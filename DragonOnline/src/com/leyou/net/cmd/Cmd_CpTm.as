package com.leyou.net.cmd {
	import com.ace.enum.WindowEnum;
	import com.ace.manager.UIManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.manager.LastTimeImageManager;
	import com.leyou.net.NetGate;

	public class Cmd_CpTm {

		/**
		 *副本信息
cptm
上行: cptm|I
下行：cptm|{"mk":"I", cplist:[[cpid,cc,mc],...]}
  cpid -- 副本Id
		  cc   -- 剩余进入次数
		  mc   -- 总进入次数

		 * @param o
		 *
		 */
		public static function sm_TeamCopy_I(o:Object):void {

			UIManager.getInstance().teamCopyWnd.updateTeamCopy(o);
		}

		public static function cmTeamCopyOpen():void {
			NetGate.getInstance().send(CmdEnum.CM_TEAM_COPY_I);
		}

		/**
		 * 我的队伍信息
上行: cptm|M
下行：cptm|{"mk":"M", team:[[name,vocation,gender,level,zdl,ready],...]}
 team  -- 队伍信息 （第一个是队长）
		   name -- 玩家名字
			 vocation --职业
			 gender  -- 性别
			 level   -- 等级
			 zdl     -- 玩家战斗力
			 ready   -- 是否已准备 （0未准备, 1已准备）
		 * @param o
		 *
		 */
		public static function sm_TeamCopy_M(o:Object):void {
			if (!UIManager.getInstance().isCreate(WindowEnum.DUNGEON_TEAM))
				UIManager.getInstance().creatWindow(WindowEnum.DUNGEON_TEAM);
			
			UIManager.getInstance().teamCopyWnd.updateTeamCopyMy(o);
		}

		public static function cmTeamCopyMy():void {
			NetGate.getInstance().send(CmdEnum.CM_TEAM_COPY_M);
		}

		/**
		 *副本队伍列表
上行: cptm|Tcpid
下行：cptm|{"mk":"T",team:[[lname,people,mzdl,tst],...]}
  lname -- 队伍队长名字
		  people -- 队伍人数
		  mzdl   -- 战斗力需求
		  tst   -- 进入是否需要密码（0不需要 ，1需要）
		 * @param o
		 *
		 */
		public static function sm_TeamCopy_T(o:Object):void {
			UIManager.getInstance().teamCopyWnd.updateTeamCopyList(o);
		}

		public static function cmTeamCopyTeam(cpid:int):void {
			NetGate.getInstance().send(CmdEnum.CM_TEAM_COPY_T + cpid);
		}

		/**
		 *创建副本队伍
上行: cptm|Ccpid,zdl,auto,password
   cpid -- 副本Id
			 mzdl -- 战斗力需求
		   auto -- 是否自动开始（0手动， 1自动）
		   password  -- 密码默认为空
		 * @param cpid
		 *
		 */
		public static function cmTeamCopyCreate(cpid:int, zdl:int, auto:int, password:String):void {
			NetGate.getInstance().send(CmdEnum.CM_TEAM_COPY_C + cpid + "," + zdl + "," + auto + "," + password);
		}

		/**
		 *队伍准备
上行: cptm|Zready
	  ready --是否已准备 （0未准备, 1已准备）
		   * @param cpid
		 *
		 */
		public static function cmTeamCopyPrepare(cpid:int):void {
			NetGate.getInstance().send(CmdEnum.CM_TEAM_COPY_Z + cpid);
		}

		/**
		 *队伍加入
上行: cptm|Jlname
	 lname -- 队长的名字
		  * @param cpid
		 *
		 */
		public static function cmTeamCopyAdd(name:String, pwd:String=""):void {
			NetGate.getInstance().send(CmdEnum.CM_TEAM_COPY_J + name + "," + pwd);
		}

		/**
		 *退出队伍
上行: cptm|Q
	 * @param cpid
		  *
		 */
		public static function cmTeamCopyQuit():void {
			NetGate.getInstance().send(CmdEnum.CM_TEAM_COPY_Q);
		}

		/**
		 *踢出队员
上行: cptm|kname
	 name -- 队员名字
		  * @param cpid
		 *
		 */
		public static function cmTeamCopyTeamKill(name:String):void {
			NetGate.getInstance().send(CmdEnum.CM_TEAM_COPY_K + name);
		}

		public static function cmTeamCopyTeamAutoAdd(auto:int):void {
			NetGate.getInstance().send(CmdEnum.CM_TEAM_COPY_A + auto);
		}

		public static function sm_TeamCopy_E(o:Object):void {
			if (!o.hasOwnProperty("sec") || !o.hasOwnProperty("cpid"))
				return;

//			LastTimeImageManager.getInstance().showPanel(o.sec);
			
			UIManager.getInstance().teamCopyWnd.teamStart.showPanel(o.sec,o.cpid);
		}

		/**
		 *--------------------------------------------------------------
倒计时开始进入副本
上行: cptm|E
下行：cptm|{"mk":"E", "sec":num}
		sec -- 进入副本倒计时秒数
		 * @param auto
		 *
		 */
		public static function cmTeamCopyTeamEnter():void {
			NetGate.getInstance().send(CmdEnum.CM_TEAM_COPY_E);
		}

		/**
		 *离开副本
上行:cptm|L
	 *
		  */
		public static function cmTeamCopyTeamExit():void {
			NetGate.getInstance().send(CmdEnum.CM_TEAM_COPY_L);
		}

		/**
		 *副本追踪
下行:cptm|{"mk":"S", "rt":remainTime, "m":[{"mid":id, "cc":currentCount, "mc":maxCount}...]}
		  rt -- 副本剩余时间
			  m  -- 怪物列表
				mid -- 怪物id
				cc  -- 已击杀数量
				mc  -- 最大数量
		 * @param o
		 *
		 */
		public static function sm_TeamCopy_S(o:Object):void {
			if (!UIManager.getInstance().isCreate(WindowEnum.DUNGEON_TEAM_TRACK))
				UIManager.getInstance().creatWindow(WindowEnum.DUNGEON_TEAM_TRACK);
			
			UIManager.getInstance().teamCopyTrackWnd.showPanel(o)
		}
		
		/**
		 * <pre>
		 *--------------------------------------------------------------
组队副本奖励信息
下行:cptm|{"mk":"G", cpid:num , jlitem:[item1,item2,...], jllist:[[name,vocation,gender,[roll1,roll2,roll3,roll4,...],[jlindex1,...],... ]  }
            cpid -- 副本id
            jlitem -- 团队奖励道具列表
               item1 -- 道具id      
            
            jllist -- 奖励结果信息
              name -- 玩家名字
              vocation -- 职业
              gender  -- 性别
              [rooll1,...]  -- 点数列表
              [jlindex1,...]  -- 最终获得的奖励索引 
			  * 
			  * 
			  * 
			  * --------------------------------------------------------------
组队副本奖励信息
下行:cptm|{"mk":"G", cpid:num , jlitem:[[item1,num1,jname1,],...], jllist:[[name,vocation,gender,[roll1,roll2,...],... ]  }
            cpid -- 副本id
            jlitem -- 团队奖励道具列表
               item1 -- 道具id      
               num   -- 道具数量
               jname -- 最终归属玩家
            jllist -- 奖励结果信息
              name -- 玩家名字
              vocation -- 职业
              gender  -- 性别
              [rooll1,...]  -- 点数列表
			  * </pre>
		 * @param o
		 * 
		 */		
		public static function sm_TeamCopy_G(o:Object):void {
			if (!UIManager.getInstance().isCreate(WindowEnum.DUNGEON_TEAM_REWARD))
				UIManager.getInstance().creatWindow(WindowEnum.DUNGEON_TEAM_REWARD);
			
			
			UIManager.getInstance().teamCopyRewardWnd.showPanel(o)
		}

		public static function cmTeamCopyTeamFind():void {
			NetGate.getInstance().send(CmdEnum.CM_TEAM_COPY_F);
		}
		
	}
}

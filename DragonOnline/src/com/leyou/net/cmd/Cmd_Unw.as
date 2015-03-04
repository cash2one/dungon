package com.leyou.net.cmd {
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.manager.SOLManager;
	import com.ace.manager.UIManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;


	/**
	 *--行会状态（0空闲 1战争中 2等级不足）


--------------------------------------------------------------------------------
行会战争状态信息
下行:unw|{"mk":"S", st:num, stime:num, un:[unionid,uname,ukill],dun:[dunionid,duname,dukill],my:[kill,gx]}
		  st -- 行会战争状态 (0准备中，1进行中)
		  un -- 我方行会信息
		  dun -- 敌方行会信息
		  my  -- 自己信息
			 kill -- 击杀数量
			 gx   -- 获得贡献



--------------------------------------------------------------------------------
行会战争排行信息
上行:unw|Runionid,begin,end
下行:unw|{"mk":"R", rlist:[[rak,name,kill,jlgx],
陈亮(陈亮) 09-02 18:06:10
行会战争

unw


--------------------------------------------------------------------------------
请求行会战争信息
上行:unw|I


--------------------------------------------------------------------------------
行会战争列表信息
下行:unw|{"mk":"L","list":[{unionid,uname,level,zpeople,zforce,ust],...]}
		list  -- 行会列表信息
			  unionid--行会id
			  uname  --行会名字
			  level  --行会等级
			  zpeople --总行会人数
			  zforce --总战斗力
			  ust
...]}
		  rak  -- 排名
		  name -- 玩家名字
		  kill -- 击杀数量
		  jlgx -- 奖励贡献
	 * @author Administrator
	 *
	 */
	public class Cmd_Unw {



		public function Cmd_Unw() {

		}


		/**
		 *--------------------------------------------------------------------------------
行会战争状态信息
下行:unw|{"mk":"S", st:num, stime:num, un:[unionid,uname,ukill],dun:[dunionid,duname,dukill],my:[kill,gx]}
st -- 行会战争状态 (0准备中，1进行中)
un -- 我方行会信息
	  dun -- 敌方行会信息
			my  -- 自己信息
			 kill -- 击杀数量
			 gx   -- 获得贡献

		 * @param o
		 *
		 */
		public static function sm_Guild_pk_S(o:Object):void {

			if (!o.hasOwnProperty("my"))
				return;

			if (!UIManager.getInstance().isCreate(WindowEnum.GUILD_WAR_WIN))
				UIManager.getInstance().creatWindow(WindowEnum.GUILD_WAR_WIN);

			UIManager.getInstance().guildWarWin.updateInfo(o);

			if (UIManager.getInstance().isCreate(WindowEnum.GUILD))
				UIManager.getInstance().guildWnd.updateGuildPk(o);
		}

		/**
		 *--------------------------------------------------------------------------------
行会战争列表信息
下行:unw|{"mk":"L","list":[{unionid,uname,level,zpeople,zforce,ust],...]}
list  -- 行会列表信息
unionid--行会id
		  uname  --行会名字
			  level  --行会等级
			  zpeople --总行会人数
			  zforce --总战斗力
			  ust    --行会状态（0空闲 1战争中 2等级不足）


		 * @param o
		 *
		 */
		public static function sm_Guild_pk_L(o:Object):void {
//			trace(o)
			if (!o.hasOwnProperty("list"))
				return;

			UIManager.getInstance().guildWnd.updateGuildPk(o);
		}

		/**
		 *--------------------------------------------------------------------------------
请求行会战争信息
上行:unw|I

*
*/
		public static function cm_GuildPkInit():void {
			NetGate.getInstance().send(CmdEnum.CM_GUILD_PK_I);
		}

		public static function sm_Guild_pk_R(o:Object):void {
			if (!o.hasOwnProperty("uid"))
				return;

			UIManager.getInstance().guildWnd.updateGuildPk(o);
		}

		/**
		 *--------------------------------------------------------------------------------
行会战争排行信息
上行:unw|Runionid,begin,end
下行:unw|{"mk":"R", rlist:[[rak,name,kill,jlgx],...]}
rak  -- 排名
name -- 玩家名字
	  kill -- 击杀数量
			jlgx -- 奖励贡献

		 * @param uid
		 * @param bindex
		 * @param eindex
		 *
		 */
		public static function cm_GuildPkPage(uid:String, bindex:int, eindex:int):void {
			NetGate.getInstance().send(CmdEnum.CM_GUILD_PK_R + uid + "," + bindex + "," + eindex);
		}

		/**
		 *--------------------------------------------------------------------------------
行会宣战
上行:unw|Wunionid
-- 行会id
   *
		   */
		public static function cm_GuildPkStart(uid:String):void {
			NetGate.getInstance().send(CmdEnum.CM_GUILD_PK_W + uid);
		}

		/**
		 *--------------------------------------------------------------------------------
战争敌对行会名字
下行:unw|{"mk":"D", duname:str,ust:num}
	 -- 敌对行会名字
		  -- ust (1在行会战争状态 0不在行会战争状态)
		 *
		 */
		public static function sm_Guild_pk_D(o:Object):void {
			MyInfoManager.getInstance().guildArr=[o.duname, (o.ust == 1)];
			UIManager.getInstance().gameScene.refreshLivingUI();
		}
 
		
		/**
		 * --------------------------------------------------------------------------------
		查询自己的排名
		上行:unw|M
		 * @param o
		 * 
		 */			
		public static function cm_GuildPkMe():void {
			NetGate.getInstance().send(CmdEnum.CM_GUILD_PK_M);
		}

	}



}

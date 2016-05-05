package com.leyou.net.cmd {

	import com.ace.enum.WindowEnum;
	import com.ace.manager.UIManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Arena {


		public static function sm_Arena_I(o:Object):void {
			if (!UIManager.getInstance().isCreate(WindowEnum.ARENA))
				UIManager.getInstance().creatWindow(WindowEnum.ARENA);

			UIManager.getInstance().arenaWnd.updateInfo(o);
		}

		/**
		 *--------------------------------------------------------------------------
竞技场个人信息
上行:jjc|I
下行:jjc|{"mk":"I", "jxlevel":num,"score":num,"jrank":num,"sfight":num,"avoidt":num,"buyf":num}
-- jxlevel  军衔等级 (1-10)
		-- score    军衔积分
		   -- jrank    排名
		   -- sfight   剩余挑战次数
		   -- avoidt   免战剩余时间秒
		   -- buyf     购买挑战价格
		   -- jlst     奖励状态 （0未领取 1已领取）

		 *
		 */
		public static function cm_ArenaInit():void {
			NetGate.getInstance().send(CmdEnum.CM_JJC_I);
		}

		public static function sm_Arena_R(o:Object):void {
			if (!UIManager.getInstance().isCreate(WindowEnum.ARENALIST))
				UIManager.getInstance().creatWindow(WindowEnum.ARENALIST);

			UIManager.getInstance().arenaListWnd.updateInfo(o);
		}

		/**
		 * 挑战记录
上行:jjc|Rlast
-- last 最后几条记录

下行:jjc|{"mk":"R", "rlist":[[ftime,fresult,fscore,fname,frev]...]}
-- ftime     战斗时间戳秒
-- fresult   战斗结果 (1胜利 0失败 )
  -- fscore    积分
		  -- fname     战斗对象名称
		  -- frev      是否可复仇(0可复仇，1不可复仇)
		 *
		 */
		public static function cm_ArenaRecord(last:int):void {
			NetGate.getInstance().send(CmdEnum.CM_JJC_R + last);
		}

		public static function sm_Arena_L(o:Object):void {

			UIManager.getInstance().arenaWnd.updatePkList(o);
		}

		/**
		 *挑战列表
上行:jjc|L
下行:jjc|{"mk":"L", "retz":num,"tzlist":[[name,level,school,gender,zdl,jxlevel,gscore,jstate,avt]...]}
-- retz    刷新剩余时间

-- name    名字
	 -- level   等级
			-- school  职业
		   -- gender  性别
		   -- zdl     战斗力
		   -- jxlevel 军衔等级
		   -- gscore  胜利可获得积分
		   -- avt     玩家avt形象字符串
		   -- jstate  挑战状态 (0未挑战, 1挑战胜利 ,2挑战失败)

		 *
		 */
		public static function cm_ArenaList():void {
			NetGate.getInstance().send(CmdEnum.CM_JJC_L);
		}


		/**
		 *复仇玩家
上行:jjc|Cftime
-- ftime     R协议记录的战斗时间戳秒

*
*/
		public static function cm_ArenaRevenge(time:String):void {
			NetGate.getInstance().send(CmdEnum.CM_JJC_C + time);
		}

		/**
		 *购买挑战次数
上行:jjc|Z
下行:jjc|{"mk":"I"....

*
*/
		public static function cm_ArenaBuyPkCount(type:int):void {
			NetGate.getInstance().send(CmdEnum.CM_JJC_Z + type);
		}

		/**
		 *--------------------------------------------------------------------------
购买免战次数
上行:jjc|Anum
下行:jjc|{"mk":"I".....
*
*/
		public static function cm_ArenaBuyFreeCount(num:int, type:int):void {
			NetGate.getInstance().send(CmdEnum.CM_JJC_A + num + "," + type);
		}


		/**
		 *--------------------------------------------------------------------------
立即刷新
上行:jjc|F
下行:jjc|{"mk":"L".....

*
*/
		public static function cm_ArenaRefresh(type:int):void {
			NetGate.getInstance().send(CmdEnum.CM_JJC_F + type);
		}

		/**
		 *竞技场退出
上行:jjc|Q
*
   */
		public static function cm_ArenaQuit():void {
			NetGate.getInstance().send(CmdEnum.CM_JJC_Q);
		}

		/**
		 *领取奖励
上行:jjc|W
*/
		public static function cm_ArenaReward():void {
			NetGate.getInstance().send(CmdEnum.CM_JJC_W);
		}

		/**
		 * --------------------------------------------------------------------------
挑战人物
上行:jjc|Tindex
-- index 挑战列表索引

*
*/
		public static function cm_ArenaPkPlayer(i:int):void {
			NetGate.getInstance().send(CmdEnum.CM_JJC_T + i);
		}

		/**
		 *  --------------------------------------------------------------------------
挑战奖励
下行:jjc{"mk":"J","fresult":num,"money":num,"exp":num,"energy":num,"fscore":num}
-- fresult   战斗结果 (1胜利 0失败 )
  -- money     金币
		  -- exp       经验
		  -- energy    魂力
		  -- fscore    积分(失败为负)
		 *
		 */
		public static function sm_Arena_J(o:Object):void {
			if (!UIManager.getInstance().isCreate(WindowEnum.ARENAFINISH))
				UIManager.getInstance().creatWindow(WindowEnum.ARENAFINISH);

			UIManager.getInstance().arenaFinishWnd.showPanel(o);
		}

		/**
		 *--------------------------------------------------------------------------
挑战任务追踪
下行:jjc{"mk":"K","sfight":num,"zfight":num}
-- sfight  剩余次数
  -- zfight  总次数
		 */
		public static function sm_Arena_K(o:Object):void {
			if (!UIManager.getInstance().isCreate(WindowEnum.ARENA) || !UIManager.getInstance().arenaWnd.visible)
				UIManager.getInstance().taskTrack.updateArena(o);
		}

		/**
		 *--------------------------------------------------------------------------
关闭竞技场面板
下行：jjc|{"mk":"X"}
*/
		public static function sm_Arena_X(o:Object):void {
			if (UIManager.getInstance().isCreate(WindowEnum.ARENA))
				UIManager.getInstance().arenaWnd.hide();

			UIManager.getInstance().hideWindow(WindowEnum.ARENALIST);
			UIManager.getInstance().hideWindow(WindowEnum.ARENAAWARD);
			UIManager.getInstance().hideWindow(WindowEnum.ARENAMESSAGE);

		}

		/**
		 *--------------------------------------------------------------------------------
-- 挑战前3
上行:jjc|Bindex 
		 * @param i
		 * 
		 */		
		public static function cm_ArenaPkTop3(i:int):void {
			NetGate.getInstance().send(CmdEnum.CM_JJC_B + i);
		}

		/**
		 *--------------------------------------------------------------------------------
-- 前3列表
上行:jjc|A
下行:jjc|{"mk":"A", "tzlist13":[ [name,level,school,gender,zdl,jxlevel,gscore,jstate,avt]...]} 
		 * 
		 */		
		public static function cm_ArenaTop3List():void {
			NetGate.getInstance().send(CmdEnum.CM_JJC_A);
		}

		public static function sm_Arena_A(o:Object):void {
			if(!o.hasOwnProperty("tzlist13"))
				return ;
			
			UIManager.getInstance().arenaWnd.updatechalList(o);
		}


	}
}

package com.leyou.net.cmd {


	import com.ace.enum.WindowEnum;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.greensock.TweenLite;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;
	import com.leyou.ui.dungeonTeam.childs.TeamCopyGrid;
	import com.leyou.ui.guild.GuildWnd;

	public class Cmd_Ucp {


		public static function sm_GuildCp_I(o:Object):void {
			if (!o.hasOwnProperty("cl"))
				return;

//			UIManager.getInstance().guildWnd.updateGuildCopy(o);
			
			if (!UIManager.getInstance().isCreate(WindowEnum.DUNGEON_TEAM))
				UIManager.getInstance().creatWindow(WindowEnum.DUNGEON_TEAM);
			
			UIManager.getInstance().teamCopyWnd.updateGuildCopy(o);
		}

		/**
		 * --------------------------------------------------------------------------------
行会副本信息
上行：ucp|I
下行：ucp|{"mk":"I",  "cl":[{"cid":copyid, "st":status, "funame":uname},...]
--  cl:[...] 副本列表
--  cid:副本id
--  st:副本状态 (0未解锁 1已解锁 2未通关 3已通关,4 未开启)
	 --  funame 首通行会名字
			 *
		 */
		public static function cm_GuildCpInit():void {
			NetGate.getInstance().send(CmdEnum.CM_GUILD_COPY_I);
		}

		/**
		 *离开副本
上行:ucp|L
 *
	   */
		public static function cm_GuildCpQuit():void {
			NetGate.getInstance().send(CmdEnum.CM_GUILD_COPY_L);
		}

		/**
		 *进入副本
上行:ucp|Ecopyid
 * @param cid
	   *
			*/
		public static function cm_GuildCpEnter(cid:int):void {
			NetGate.getInstance().send(CmdEnum.CM_GUILD_COPY_E + cid);
		}

		/**
		 *--------------------------------------------------------------------------------
副本追踪
下行:ucp|{"mk":"T", "mlist":[{"mid":id, "cc":currentCount, "mc":maxCount}...],"knum":num,"bg":num}
-- mlist 怪物列表
	   -- mid 怪物id
			  -- cc 当前已击杀数量
		   -- mc 总数量
		-- knum 个人击杀数量
		-- bg   个人获得帮贡

		 * @param o
		 *
		 */
		public static function sm_GuildCp_T(o:Object):void {
			if (!o.hasOwnProperty("mlist"))
				return;

			if (!UIManager.getInstance().isCreate(WindowEnum.GUILD_COPY_TRACK))
				UIManager.getInstance().creatWindow(WindowEnum.GUILD_COPY_TRACK);

			UIManager.getInstance().guildCopyTrack.show();
			UIManager.getInstance().guildCopyTrack.updateInfo(o);
		}

		/**
		 * --------------------------------------------------------------------------------
首次击杀奖励
下行:ucp|{"mk":"R", "cid":copyid}
	 * @param o
		  *
		 */
		public static function sm_GuildCp_R(o:Object):void {
			if (!o.hasOwnProperty("cid"))
				return;

			if (!UIManager.getInstance().isCreate(WindowEnum.BOSSCOPY_REWARD))
				UIManager.getInstance().creatWindow(WindowEnum.BOSSCOPY_REWARD);

			UIManager.getInstance().bossCopyReward.updateInfo(o);
		}

		/**
		 *--------------------------------------------------------------------------------
打开行会副本界面
下行:ucp|{"mk":"O"}
	 * @param o
		  *
		 */
		public static function sm_GuildCp_O(o:Object):void {
			 
			if (!UIManager.getInstance().isCreate(WindowEnum.DUNGEON_TEAM))
				UIManager.getInstance().creatWindow(WindowEnum.DUNGEON_TEAM);

			if (UIManager.getInstance().teamCopyWnd.viewCopyOn()) {
				cm_GuildCpInit();
				UILayoutManager.getInstance().show_II(WindowEnum.DUNGEON_TEAM);
				TweenLite.delayedCall(0.5, UIManager.getInstance().teamCopyWnd.setTabIndex, [1]);
			}
			
//			if (UIManager.getInstance().teamCopyWnd.viewCopyOn()) {
//				cm_GuildCpInit();
//				UILayoutManager.getInstance().show_II(WindowEnum.DUNGEON_TEAM);
//				TweenLite.delayedCall(0.5, UIManager.getInstance().guildWnd.setTabIndex, [3]);
//			}

		}

	}
}

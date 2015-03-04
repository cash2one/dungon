package com.leyou.net.cmd {
	import com.ace.enum.WindowEnum;
	import com.ace.manager.UIManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Blt {

		/**
		 * 上行：wbox|I
		 */
		public static function cmBltEnter():void {
			NetGate.getInstance().send(CmdEnum.CM_BLT_I);
		}

		/**
		 *离开龙穴探宝地图
		 上行：wbox|L
		 *
		 */
		public static function cmBltExit():void {
			NetGate.getInstance().send(CmdEnum.CM_BLT_L);
		}

		/**
		 *--------------------------------------------------------------------------------
		 -- 龙穴探宝

		下行: blt|{"mk":"I", "nlist":{"npcid":npc_num,,}"stime":stime}
           nlist  -- 怪物列表
               npcid  -- npcid
               npc_num -- npc 数量
           stime  -- 剩余时间

		 * @param o
		 *
		 */
		public static function sm_Blt_I(o:Object):void {
			if (!UIManager.getInstance().isCreate(WindowEnum.DUNGEON_BLT_TRACK))
				UIManager.getInstance().creatWindow(WindowEnum.DUNGEON_BLT_TRACK);

			UIManager.getInstance().bltTrack.showPanel(o);
		}


	}
}

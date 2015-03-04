package com.leyou.net.cmd {
	import com.ace.enum.WindowEnum;
	import com.ace.manager.UIManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Wbox {


		public function Cmd_Wbox() {

		}

		/**
		 * 上行：wbox|I
		 */		
		public static function cmWboxEnter():void {
			NetGate.getInstance().send(CmdEnum.CM_WBOX_I);
		}
		
		/**
		 *离开龙穴探宝地图
			上行：wbox|L 
		 * 
		 */		
		public static function cmWboxExit():void {
			NetGate.getInstance().send(CmdEnum.CM_WBOX_L);
		}

		/**
		 *--------------------------------------------------------------------------------
-- 龙穴探宝

wbox

采集信息
下行: wbox|{"mk":"I", "open":num, "energy":num, "qhs":num, "ele":num, "wing":num}
           open   -- 开始个数
           energy -- 已获得魂力
           qhs    -- 强化石
           ele    -- 元素之心
           wing   -- 奥杜之羽  
		 * @param o
		 * 
		 */		
		public static function sm_Wbox_I(o:Object):void {
			if(!UIManager.getInstance().isCreate(WindowEnum.DUNGEONTB_TRACK))
				UIManager.getInstance().creatWindow(WindowEnum.DUNGEONTB_TRACK);
			
			UIManager.getInstance().tbTrack.showPanel(o);
		}

	}
}

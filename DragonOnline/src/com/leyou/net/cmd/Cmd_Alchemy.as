package com.leyou.net.cmd {
	import com.ace.manager.UIManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Alchemy {

		public static function sm_lj_H(o:Object):void {
			trace(o)
			UIManager.getInstance().gemLvWnd.updateInfo(o);
		}

		/**
		 * 炼金
炼金合成
上行:lj|Hhid,htype,hnum
hid -- 合成配方id
	htype -- 合成类型 （0普通 1道具 2元宝）
		hnum  -- 合成数量


下行:lj|{"mk":"H","hid":num,"htype":num, "hnum":num, "success":num, "lose":num}
 * @param name
	   *
			*/
		public static function cmljNow(hid:int, htype:int, hnum:int):void {
			NetGate.getInstance().send(CmdEnum.CM_LJ_H + hid + "," + htype + "," + hnum);
		}



	}
}

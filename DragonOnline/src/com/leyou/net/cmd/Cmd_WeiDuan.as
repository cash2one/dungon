package com.leyou.net.cmd {
	import com.ace.manager.UIManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_WeiDuan {
		public static function cm_dljl_I(isWeiDuan:Boolean):void {
			NetGate.getInstance().send(CmdEnum.CM_DLJL_I + int(isWeiDuan));
		}

		// 下行: dljl|{"mk":"I", "st":num}
		public static function sm_dljl_I(obj:Object):void {
			if (UIManager.getInstance().clientWnd)
				UIManager.getInstance().clientWnd.sm_xxx(obj.st,obj.jst);
		}

		public static function cm_dljl_J():void {
			NetGate.getInstance().send(CmdEnum.CM_DLJL_J);
		}
	}
}

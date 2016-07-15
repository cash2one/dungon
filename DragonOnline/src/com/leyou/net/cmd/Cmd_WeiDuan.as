package com.leyou.net.cmd {
	import com.ace.config.Core;
	import com.ace.enum.PlatformEnum;
	import com.ace.enum.UIEnum;
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
				UIManager.getInstance().clientWnd.sm_xxx(obj.st, obj.jst);


			if (UIEnum.PLAT_FORM_ID == PlatformEnum.ID_360_OPEN || UIEnum.PLAT_FORM_ID == PlatformEnum.ID_KWAN || Core.isTencent) {
				UIManager.getInstance().rightTopWnd.deactive("v0");
			} else {
				UIManager.getInstance().rightTopWnd.active("v0");
				UIManager.getInstance().rightTopWnd.getWidget("v0").setEffect(!obj.st);
			}
		}

		public static function cm_dljl_J():void {
			NetGate.getInstance().send(CmdEnum.CM_DLJL_J);
		}
	}
}

package com.leyou.net.cmd {
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_ELEP {
		public static function cm_ELEP_I():void {
			NetGate.getInstance().send(CmdEnum.CM_ELEP_I);
		}

		public static function sm_ELEP_I(obj:Object):void {
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.ELEMENT, CmdEnum.SM_ELEP_I);
			DataManager.getInstance().elementData.loadData_I(obj);
			UIManager.getInstance().elementWnd.updateInfo();
			if (UIManager.getInstance().isCreate(WindowEnum.ELEMENT_UPGRADE) && UIManager.getInstance().elementUpgradeWnd.visible) {
				UIManager.getInstance().elementUpgradeWnd.updateInfo();
			}
		}

		public static function cm_ELEP_U(etype:int, ctype:int, btype:int=0):void {
			NetGate.getInstance().send(CmdEnum.CM_ELEP_U + etype + "," + ctype + "," + btype);
		}

		public static function sm_ELEP_U(obj:Object):void {
			UIManager.getInstance().elementUpgradeWnd.popUpText(obj.aexp);
		}

		public static function cm_ELEP_S(etype:int, ctype:int, btype:int=0):void {
			NetGate.getInstance().send(CmdEnum.CM_ELEP_S + etype + "," + ctype + "," + btype);
		}

		public static function cm_ELEP_A(type:int):void {
			NetGate.getInstance().send(CmdEnum.CM_ELEP_A + type);
		}

		public static function sm_ELEP_A(obj:Object):void {
			UIManager.getInstance().elementSwitchWnd.updateCombatPower(obj);
		}
	}
}

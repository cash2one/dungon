package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Active
	{
		public static function sm_HYD_I(obj:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.ACTIVE, CmdEnum.SM_HYD_I);
			UIManager.getInstance().activeWnd.updateInfo(obj);
		}
		
		public static function cm_HYD_I():void{
			NetGate.getInstance().send(CmdEnum.CM_HYD_I);
		}
		
		public static function sm_HYD_J(obj:Object):void{
			UIManager.getInstance().activeWnd.updateRewardLevel(obj);
		}
		
		public static function cm_HYD_J(hl:int):void{
			NetGate.getInstance().send(CmdEnum.CM_HYD_J + hl);
		}
		
		public static function sm_HYD_Z(obj:Object):void{
			UIManager.getInstance().activeWnd.flyItem();
		}
	}
}
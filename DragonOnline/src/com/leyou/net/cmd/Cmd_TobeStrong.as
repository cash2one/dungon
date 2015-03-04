package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_TobeStrong
	{
		public static function sm_RISE_I(obj:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.TOBE_STRONG, CmdEnum.SM_RISE_I);
			DataManager.getInstance().tobeStrongData.loadData_I(obj);
			if(UIManager.getInstance().isCreate(WindowEnum.TOBE_STRONG)){
				UIManager.getInstance().tobeStrong.updateInfo();
			}
			if(UIManager.getInstance().isCreate(WindowEnum.DIE)){
				UIManager.getInstance().dieWnd.updateInfo();
			}
		}
		
		public static function cm_RISE_I():void{
			NetGate.getInstance().send(CmdEnum.CM_RISE_I);
		}
	}
}
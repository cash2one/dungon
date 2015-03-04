package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_CLI
	{
		public static function sm_CLI_I(obj:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.INTEGRAL, CmdEnum.SM_CLI_I);
			DataManager.getInstance().integralData.loadDat_I(obj);
			if(UIManager.getInstance().isCreate(WindowEnum.INTEGRAL)){
				UIManager.getInstance().integralWnd.updateInfo();
			}
		}
		
		public static function cm_CLI_I():void{
			NetGate.getInstance().send(CmdEnum.CM_CLI_I);
		}
		
		public static function sm_CLI_B(obj:Object):void{
		}
		
		public static function cm_CLI_B(itemId:int, num:int):void{
			NetGate.getInstance().send(CmdEnum.CM_CLI_B+itemId+","+num);
		}
	}
}
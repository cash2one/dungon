package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_PM
	{
		public static function sm_PM_I(obj:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.VENDUE, CmdEnum.SM_PM_I);
			DataManager.getInstance().vendueData.loadData_I(obj);
			if(UIManager.getInstance().isCreate(WindowEnum.VENDUE)){
				UIManager.getInstance().vendueWnd.updateCurrentPage();
			}
		}
		
		public static function cm_PM_I():void{
			NetGate.getInstance().send(CmdEnum.CM_PM_I);
		}
		
		public static function sm_PM_F(obj:Object):void{
			DataManager.getInstance().vendueData.loadData_F(obj);
			UIManager.getInstance().vendueWnd.updateNextPage();
		}
		
		public static function cm_PM_F():void{
			NetGate.getInstance().send(CmdEnum.CM_PM_F);
		}
		
		public static function sm_PM_L(obj:Object):void{
			DataManager.getInstance().vendueData.loadData_L(obj);
			UIManager.getInstance().vendueWnd.updateHistoryPage();
		}
		
		public static function cm_PM_L():void{
			NetGate.getInstance().send(CmdEnum.CM_PM_L);
		}
		
		public static function cm_PM_P(price:int):void{
			NetGate.getInstance().send(CmdEnum.CM_PM_P+price);
		}
	}
}
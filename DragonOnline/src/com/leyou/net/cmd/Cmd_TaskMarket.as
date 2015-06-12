package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_TaskMarket
	{
		public static function sm_TaskMarket_I(obj:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.TASK_MARKET, CmdEnum.SM_YD_I);
			DataManager.getInstance().missionMarketData.loadData_I(obj);
			if(UIManager.getInstance().missionMarketWnd){
				UIManager.getInstance().missionMarketWnd.updateView();
			}
		}
		
		public static function cm_TaskMarket_I():void{
			NetGate.getInstance().send(CmdEnum.CM_YD_I);
		}
		
		public static function sm_TaskMarket_L(obj:Object):void{
			DataManager.getInstance().missionMarketData.loadData_L(obj);
			UIManager.getInstance().missionMarketWnd.updateView();
		}
		
		public static function cm_TaskMarket_L(type:int):void{
			NetGate.getInstance().send(CmdEnum.CM_YD_L+type);
		}
		
		public static function sm_TaskMarket_J(obj:Object):void{
			UIManager.getInstance().missionMarketWnd.flyItem(obj.ytype);
		}
		
		public static function cm_TaskMarket_J(type:int):void{
			NetGate.getInstance().send(CmdEnum.CM_YD_J+type);
		}

		public static function sm_TaskMarket_T(obj:Object):void{
			UIManager.getInstance().missionMarketWnd.flyTaskItem(obj.ytask);
		}
		
		public static function cm_TaskMarket_T(type:int, id:int):void{
			NetGate.getInstance().send(CmdEnum.CM_YD_T+type+","+id);
		}
	}
}
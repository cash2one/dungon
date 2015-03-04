package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Seven
	{
		public static function sm_SEVD_D(obj:Object):void{
			// todo:播放获得物品动画
			UIManager.getInstance().sevenDay.flyDayItem();
		}
		
		public static function cm_SEVD_D():void{
			NetGate.getInstance().send(CmdEnum.CM_SEVD_D);
		}
		
		public static function sm_SEVD_I(obj:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.SEVENDAY, CmdEnum.SM_SEVD_I);
			DataManager.getInstance().sevenDayData.loadData_I(obj);
			UIManager.getInstance().sevenDay.updateInfo();
		}
		
		public static function cm_SEVD_I(day:int):void{
			NetGate.getInstance().send(CmdEnum.CM_SEVD_I+day);
		}
		
		public static function sm_SEVD_R(obj:Object):void{
			// todo:播放获得物品动画
			UIManager.getInstance().sevenDay.flyTaskItem(obj.tid);
		}
		
		public static function cm_SEVD_R(id:int):void{
			NetGate.getInstance().send(CmdEnum.CM_SEVD_R+id);
		}
		
		public static function sm_SEVD_T(obj:Object):void{
			if(obj.cd > 0 && obj.cd < 8){
				DataManager.getInstance().sevenDayData.loadData_T(obj);
				UIManager.getInstance().rightTopWnd.active("sevenDBtn");
				var rt:int = DataManager.getInstance().sevenDayData.remianT();
				UIManager.getInstance().rightTopWnd.setTime("sevenDBtn", rt)
			}
		}
	}
}
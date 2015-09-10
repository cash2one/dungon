package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_HCCZ
	{
		public static function sm_HCCZ_I(obj:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.COMBINE_RECHARGE, CmdEnum.SM_HCCZ_I);
			DataManager.getInstance().combineData.loadData_I(obj);
			if(DataManager.getInstance().combineData.act){
				UIManager.getInstance().rightTopWnd.active("combineBtn");
			}else{
				UIManager.getInstance().rightTopWnd.deactive("combineBtn");
				return;
			}
			if(UIManager.getInstance().isCreate(WindowEnum.COMBINE_RECHARGE)){
				UIManager.getInstance().combineRechargeWnd.updateInfo();
			}
		}
		
		public static function cm_HCCZ_I():void{
			NetGate.getInstance().send(CmdEnum.CM_HCCZ_I);
		}
		
		public static function sm_HCCZ_C(obj:Object):void{
			UIManager.getInstance().abidePayBoxWnd.flyItem();
		}
		
		public static function cm_HCCZ_C(ctype:int, ttype:int):void{
			NetGate.getInstance().send(CmdEnum.CM_HCCZ_C+ctype+","+ttype);
		}
	}
}
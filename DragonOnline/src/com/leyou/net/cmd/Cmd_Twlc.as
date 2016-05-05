package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Twlc
	{
		public static function sm_LXTW_I(obj:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.TAIWAN_LC, CmdEnum.SM_LXTW_I);
			DataManager.getInstance().twlcData.loadData_I(obj);
			if(DataManager.getInstance().twlcData.act){
				UIManager.getInstance().rightTopWnd.active("taiwanBtn");
			}else{
				UIManager.getInstance().rightTopWnd.deactive("taiwanBtn");
				return;
			}
			if(UIManager.getInstance().isCreate(WindowEnum.TAIWAN_LC)){
				UIManager.getInstance().taiwanLcWnd.chanageToTaiwanEdition();
				UIManager.getInstance().taiwanLcWnd.updateInfoTW();
			}
		}
		
		public static function cm_LXTW_I():void{
			NetGate.getInstance().send(CmdEnum.CM_LXTW_I);
		}
		
		public static function sm_LXTW_C(obj:Object):void{
			UIManager.getInstance().abidePayBoxWnd.flyItem();
		}
		
		public static function cm_LXTW_C(ctype:int, ttype:int):void{
			NetGate.getInstance().send(CmdEnum.CM_LXTW_C+ctype+","+ttype);
		}
	}
}
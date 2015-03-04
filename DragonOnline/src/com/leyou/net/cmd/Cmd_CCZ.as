package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_CCZ
	{
		public static function sm_CCZ_I(obj:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.ABIDE_PAY, CmdEnum.SM_CCZ_I);
			DataManager.getInstance().abidePayData.loadData_I(obj);
			 if(DataManager.getInstance().abidePayData.act){
				 UIManager.getInstance().rightTopWnd.active("abidePayBtn");
			 }else{
				 UIManager.getInstance().rightTopWnd.deactive("abidePayBtn");
				 return;
			 }
			if(UIManager.getInstance().isCreate(WindowEnum.ABIDE_PAY)){
				UIManager.getInstance().abidePayWnd.updateInfo();
			}
		}
		
		public static function cm_CCZ_I():void{
			NetGate.getInstance().send(CmdEnum.CM_CCZ_I);
		}
		
		public static function sm_CCZ_L(obj:Object):void{
			UIManager.getInstance().abidePayWnd.flyItemByType(obj.ctype);
		}
		
		public static function cm_CCZ_L(ctype:int):void{
			NetGate.getInstance().send(CmdEnum.CM_CCZ_L+ctype);
		}
		
		public static function sm_CCZ_C(obj:Object):void{
			UIManager.getInstance().abidePayBoxWnd.flyItem();
		}
		
		public static function cm_CCZ_C(ctype:int, ttype:int):void{
			NetGate.getInstance().send(CmdEnum.CM_CCZ_C+ctype+","+ttype);
		}
	}
}
package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_FCZ
	{
		public static function sm_FCZ_I(obj:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.FIRST_RETURN, CmdEnum.SM_FCZ_I);
			UILayoutManager.getInstance().show(WindowEnum.FIRST_RETURN);
			UIManager.getInstance().payFirst.updateInfo(obj);
		}
		
		public static function cm_FCZ_I():void{
			NetGate.getInstance().send(CmdEnum.CM_FCZ_I);
		}
		
		public static function sm_FCZ_J(obj:Object):void{
			UIManager.getInstance().payFirst.flyItem();
		}
		
		public static function cm_FCZ_J():void{
			NetGate.getInstance().send(CmdEnum.CM_FCZ_J);
		}
		
		public static function sm_FCZ_A(obj:Object):void{
			if(0 == obj.ast){
				UIManager.getInstance().rightTopWnd.deactive("firstReturnBtn");
				UIManager.getInstance().hideWindow(WindowEnum.FIRST_RETURN);
			}else {
				UIManager.getInstance().rightTopWnd.active("firstReturnBtn");
				UIManager.getInstance().rightTopWnd.setEffect("firstReturnBtn", true);
				UIManager.getInstance().rightTopWnd.setTime("firstReturnBtn", obj.stime);
			}
		}
	}
}
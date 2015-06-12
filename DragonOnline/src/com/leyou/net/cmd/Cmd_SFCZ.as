package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.manager.UIManager;
	import com.leyou.ui.sfirstPay.SuperFirstPayWnd;

	public class Cmd_SFCZ
	{
		public static function sm_SFCZ_A(obj:Object):void{
			if(0 == obj.ast){
				UIManager.getInstance().rightTopWnd.deactive("superReturnBtn");
				UIManager.getInstance().hideWindow(WindowEnum.SUPER_FIRST_RETURN);
			}else {
				UIManager.getInstance().rightTopWnd.active("superReturnBtn");
				UIManager.getInstance().rightTopWnd.setEffect("superReturnBtn", true);
				UIManager.getInstance().rightTopWnd.setTime("superReturnBtn", obj.stime);
				(UIManager.getInstance().creatWindow(WindowEnum.SUPER_FIRST_RETURN) as SuperFirstPayWnd).updateInfo(obj);
			}
		}
	}
}
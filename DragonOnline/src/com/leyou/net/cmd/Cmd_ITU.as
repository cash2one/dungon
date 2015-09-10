package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;

	public class Cmd_ITU
	{
		
		public static function sm_OTU_L(obj:Object):void{
			UILayoutManager.getInstance().show(WindowEnum.PRO_LUCKDRAW);
			UIManager.getInstance().proLuckDrawWnd.updateInfo(obj);
		}
	}
}
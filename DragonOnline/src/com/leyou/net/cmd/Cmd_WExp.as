package com.leyou.net.cmd
{
	import com.ace.manager.UIManager;

	public class Cmd_WExp
	{
		public static function sm_WEXP_I(obj:Object):void{
			UIManager.getInstance().roleHeadWnd.activeIcon("worldExpImg", (obj.add > 0), [int(obj.add)]);
		}
	}
}
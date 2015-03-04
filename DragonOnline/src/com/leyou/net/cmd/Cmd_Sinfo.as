package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.UIManager;
	import com.leyou.data.sinfo.ServerData;
	import com.leyou.ui.tools.RightTopWnd;

	public class Cmd_Sinfo
	{
		public static function sm_Sinfo_I(obj:Object):void{
			var data:ServerData = DataManager.getInstance().serverData;
			data.loadData_I(obj);
			switchToStatus();
		}
		
		public static function switchToStatus():void{
			var data:ServerData = DataManager.getInstance().serverData;
			var bar:RightTopWnd = UIManager.getInstance().rightTopWnd;
			if(1 == data.status){ // 新服
				bar.updateWidgetUrl("areaCelebrate", "ui/mainUI/main_btn_xqqd.png");
				bar.updateWidgetUrl("firstReturnBtn", "ui/mainUI/main_button_kffz.png");
			}else if(2 == data.status){ // 合服
				bar.updateWidgetUrl("areaCelebrate", "ui/mainUI/main_btn_hfyl.png");
				bar.updateWidgetUrl("firstReturnBtn", "ui/mainUI/main_button_kffz_he.png");
			}
		}
	}
}
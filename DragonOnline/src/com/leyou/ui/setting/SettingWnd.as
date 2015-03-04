package com.leyou.ui.setting {
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;

	public class SettingWnd extends AutoWindow {

		public function SettingWnd() {
			super(LibManager.getInstance().getXML("config/ui/SettingWnd.xml"));
		}

	}
}
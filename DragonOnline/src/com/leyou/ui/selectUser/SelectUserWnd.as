package com.leyou.ui.selectUser {
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;

	public class SelectUserWnd extends AutoSprite {

		public function SelectUserWnd() {
			super(LibManager.getInstance().getXML("config/ui/SelectUserWnd.xml"));
		}

	}
}
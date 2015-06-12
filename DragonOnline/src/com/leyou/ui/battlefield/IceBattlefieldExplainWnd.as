package com.leyou.ui.battlefield
{
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	
	import flash.events.MouseEvent;
	
	public class IceBattlefieldExplainWnd extends AutoWindow
	{
		public var closeBtn:ImgButton;
		
		public function IceBattlefieldExplainWnd(){
			super(LibManager.getInstance().getXML("config/ui/iceBattle/warSyExplain.xml"));
			init();
		}
		
		private function init():void{
			hideBg();
			clsBtn.visible = false;
			closeBtn = getUIbyID("closeBtn") as ImgButton;
			closeBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			hide();
		}
	}
}
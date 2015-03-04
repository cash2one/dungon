package com.leyou.ui.qqVip.children
{
	import com.ace.enum.WindowEnum;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	
	import flash.events.MouseEvent;
	
	public class QQVipPrivilegePage extends AutoSprite
	{
		private var dayGiftBtn:ImgButton;
		
		private var lvGiftBtn:ImgButton;
		
		private var marketBtn:ImgButton;
		
		private var newUserBtn:ImgButton;
		
		public function QQVipPrivilegePage(){
			super(LibManager.getInstance().getXML("config/ui/qqVip/qqVipSection.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			dayGiftBtn = getUIbyID("dayGiftBtn") as ImgButton;
			lvGiftBtn = getUIbyID("lvGiftBtn") as ImgButton;
			marketBtn = getUIbyID("marketBtn") as ImgButton;
			newUserBtn = getUIbyID("newUserBtn") as ImgButton;
			
			dayGiftBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			lvGiftBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			marketBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			newUserBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "dayGiftBtn":
					UIManager.getInstance().qqVipWnd.turnToTab(2);
					break;
				case "lvGiftBtn":
					UIManager.getInstance().qqVipWnd.turnToTab(3);
					break;
				case "marketBtn":
					UIOpenBufferManager.getInstance().open(WindowEnum.MARKET);
					UIManager.getInstance().marketWnd.turnToTab(0);
					break;
				case "newUserBtn":
					UIManager.getInstance().qqVipWnd.turnToTab(1);
					break;
			}
		}
	}
}
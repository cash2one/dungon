package com.leyou.ui.cityBattle
{
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	
	import flash.events.MouseEvent;
	
	public class CityBattleExplain extends AutoWindow
	{
		private var closeBtn:ImgButton;
		
		public function CityBattleExplain(){
			super(LibManager.getInstance().getXML("config/ui/cityBattle/warCityExplain.xml"));
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
package com.leyou.ui.guildBattle
{
	import com.ace.enum.UIEnum;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	
	import flash.events.MouseEvent;
	
	public class GuildBattleExplainWnd extends AutoWindow
	{
		private var closeBtn:ImgButton;
		
		public function GuildBattleExplainWnd(){
			super(LibManager.getInstance().getXML("config/ui/guildBattle/warGuildExplain.xml"));
			init();
		}
		
		private function init():void{
			closeBtn = getUIbyID("closeBtn") as ImgButton;
			closeBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			hideBg();
			clsBtn.visible = false;
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			hide();
		}
		
		public function resize():void{
			x = (UIEnum.WIDTH - width) >> 1;
			y = (UIEnum.HEIGHT - height) >> 1;
		}
	}
}
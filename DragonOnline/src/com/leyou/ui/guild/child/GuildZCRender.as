package com.leyou.ui.guild.child {

	import com.ace.enum.FontEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.ShopUtil;

	import flash.events.MouseEvent;

	public class GuildZCRender extends AutoSprite {

		private var iconImg:Image;
		private var iconImg0:Image;
		private var iconImg1:Image;
		private var nameLbl:Label;
		private var valueLbl:Label;
		private var bgLbl:Label;
		private var bybLbl:Label;

		public function GuildZCRender() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildZCRender.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.iconImg=this.getUIbyID("iconImg") as Image;
			this.iconImg0=this.getUIbyID("iconImg0") as Image;
			this.iconImg1=this.getUIbyID("iconImg1") as Image;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.valueLbl=this.getUIbyID("valueLbl") as Label;
			this.bgLbl=this.getUIbyID("bgLbl") as Label;
			this.bybLbl=this.getUIbyID("bybLbl") as Label;

		}

		public function updateInfo(o:Array, rate:int):void {

			this.nameLbl.text="" + o[0];
			
			if (MyInfoManager.getInstance().name == o[0])
				this.nameLbl.setTextFormat(FontEnum.getTextFormat("Green12"));
			else
				this.nameLbl.setTextFormat(FontEnum.getTextFormat("DefaultFont"));

			this.valueLbl.text="" + o[1];

			this.bgLbl.text="" + ShopUtil.getCurrencyString(o[1] * rate);
			this.bybLbl.text="" + ShopUtil.getCurrencyString(o[1] * rate);

		}

		override public function get height():Number {
			return 23;
		}


	}
}

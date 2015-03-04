package com.leyou.ui.guild.child {

	import com.ace.enum.FontEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.FilterUtil;

	public class GuildWar2Render extends AutoSprite {

		private var topLbl:Label;
		private var nameLbl:Label;
		private var pkLbl:Label;
		private var bgLbl:Label;

		private var _type:int=0;

		public function GuildWar2Render(type:int=0) {
			super(LibManager.getInstance().getXML("config/ui/guild/guildWar2Render.xml"));

			this._type=type;
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.topLbl=this.getUIbyID("topLbl") as Label;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.pkLbl=this.getUIbyID("pkLbl") as Label;
			this.bgLbl=this.getUIbyID("bgLbl") as Label;

		}

		/**
		 *[rak,name,kill,jlgx]
		 * @param o
		 *
		 */
		public function updateInfo(o:Object):void {

			this.topLbl.text=o[0] + "";
			this.nameLbl.text=o[1] + "";
			this.pkLbl.text=o[2] + "";
			this.bgLbl.text=o[3] + "";
			
			if (this._type == 1) {
				this.topLbl.setTextFormat(FontEnum.getTextFormat("Red12Center"));
				this.nameLbl.setTextFormat(FontEnum.getTextFormat("Red12Center"));
				this.pkLbl.setTextFormat(FontEnum.getTextFormat("Red12Center"));
				this.bgLbl.setTextFormat(FontEnum.getTextFormat("Red12Center"));
			}

			if (MyInfoManager.getInstance().name == o[1]) {
				this.nameLbl.setTextFormat(FontEnum.getTextFormat("Yellow12Center"));
			} else {
				if (this._type == 1)
					this.nameLbl.setTextFormat(FontEnum.getTextFormat("Red12Center"));
				else
					this.nameLbl.setTextFormat(FontEnum.getTextFormat("Green12center"));
			}

//			this.filters=[];
//			
//			if (o[4] == 0) { 
//				this.filters=[FilterUtil.enablefilter];
//			}

		}

		override public function get height():Number {
			return 24;
		}
	}
}

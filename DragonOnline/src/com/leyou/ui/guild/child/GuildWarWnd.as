package com.leyou.ui.guild.child {

	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;

	public class GuildWarWnd extends AutoSprite {

		private var descLbl:Label;

		private var warReady:GuildWarReady;
		private var warUnReady:GuildWarUnready;

		public function GuildWarWnd() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildWarWnd.xml"));
			this.init();
			this.mouseChildren=true;
//			this.mouseEnabled=true;
		}

		private function init():void {
			this.descLbl=this.getUIbyID("descLbl") as Label;
			this.descLbl.htmlText=TableManager.getInstance().getSystemNotice(3061).content + "";

			this.warReady=new GuildWarReady();
			this.warUnReady=new GuildWarUnready();

			this.warReady.y=106;
			this.warReady.x=-2;
			
			this.warUnReady.x=1;
			this.warUnReady.y=106;
			
			this.x=-15;
			this.y=2;
		}

		public function updateInfo(o:Object):void {

			if (o.hasOwnProperty("st")) {

				if (this.warUnReady.parent == this)
					this.removeChild(this.warUnReady)

				this.addChild(this.warReady);
				this.warReady.updateInfo(o);

			} else {

				if (this.warReady.parent == this)
					this.removeChild(this.warReady);

				this.addChild(this.warUnReady);
				this.warUnReady.updateInfo(o);
			}

		}




	}
}

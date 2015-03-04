package com.leyou.ui.guild.child {
	import com.ace.ui.auto.AutoSprite;

	public class GuildWar extends AutoSprite {

		private var warWnd:GuildWarWnd;
		private var war2Wnd:GuildWar2;

		private var pking:Boolean=false;

		public function GuildWar() {
			super(new XML());
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {

			this.war2Wnd=new GuildWar2();
			this.warWnd=new GuildWarWnd();

			this.addChild(this.warWnd);
		}

		public function updateInfo(o:Object):void {

			if (o.mk == "R") {
				this.war2Wnd.updateListInfo(o);
				this.pking=true;
			} else if (o.mk == "L" || (o.mk == "S" && o.st == 0)) {

				if (this.warWnd.parent == null) {
					this.removeChild(this.war2Wnd);
					this.addChild(this.warWnd);
				}

				this.warWnd.updateInfo(o);
				this.pking=false;
			} else {

				if (this.war2Wnd.parent == null) {
					this.removeChild(this.warWnd);
					this.addChild(this.war2Wnd);
				}

				this.war2Wnd.updateInfo(o);
				this.pking=true;
			}

		}

		public function get pkstate():Boolean {
			return this.pking;
		}

	}
}

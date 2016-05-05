package com.leyou.ui.guild.child {

	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;

	public class GuildListBar extends AutoSprite {

		private var itemBg:Image;

		private var nameLbl:Label;
		private var lvLbl:Label;
		private var numLbl:Label;
		private var figthLbl:Label;
		private var sortLbl:Label;

		private var state:int=-1;
		
		public function GuildListBar() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildListBar.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.itemBg=this.getUIbyID("itemBg") as Image;

			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.numLbl=this.getUIbyID("numLbl") as Label;
			this.figthLbl=this.getUIbyID("figthLbl") as Label;
			this.sortLbl=this.getUIbyID("sortLbl") as Label;

		}

		/**
		 * @param info
		 */
		public function updateInfo(info:Array):void {

			this.nameLbl.text="" + info[1];
			this.lvLbl.text="" + info[2];
			this.numLbl.text="" + info[3];
			this.figthLbl.text="" + info[5];
			this.sortLbl.text="" + info[8];

		}
		
		public function getName():String{
			return this.nameLbl.text;
		}

		public function sethight(i:int=-1):void {
			if (this.state == -1)
				this.state=i;

			if (i == -1) {
				this.itemBg.updateBmp("ui/guild/list_bg_" + this.state + ".jpg");
			} else
				this.itemBg.updateBmp("ui/guild/list_bg_" + i + ".jpg");
		}



	}
}

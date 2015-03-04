package com.leyou.ui.guild.child {

	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.FilterUtil;
	import com.leyou.utils.GuildUtil;
	import com.leyou.utils.PlayerUtil;

	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;

	public class GuildMemberBar extends AutoSprite {

		private var nameLbl:Label;
		private var proLbl:Label;
		private var officeLbl:Label;
		private var descLbl:Label;
		private var donateLbl:Label;
		private var contributLbl:Label;
		private var lvLbl:Label;

		private var memImg:Image;

		private var state:int=-1;

		public function GuildMemberBar() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildMemberBar.xml"));
			this.init();
			this.mouseEnabled=true;
		}

		private function init():void {

			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.proLbl=this.getUIbyID("proLbl") as Label;
			this.officeLbl=this.getUIbyID("officeLbl") as Label;
			this.descLbl=this.getUIbyID("descLbl") as Label;
			this.donateLbl=this.getUIbyID("donateLbl") as Label;
			this.contributLbl=this.getUIbyID("contributLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;

			this.memImg=this.getUIbyID("memImg") as Image;
		}

		/**
		 * @param i 0,1,2
		 */
		public function setBgState(i:int=-1):void {
			if (this.state == -1)
				this.state=i;

			if (i == -1) {
				this.memImg.updateBmp("ui/guild/member_bg_" + this.state + ".jpg");
			} else
				this.memImg.updateBmp("ui/guild/member_bg_" + i + ".jpg");
		}

		public function updateInfo(info:Object):void {

			this.nameLbl.text="" + info[0];
			this.proLbl.text="" + PlayerUtil.getPlayerRaceByIdx(info[2]);
			this.officeLbl.text="" + GuildUtil.getOfficeNameByIndex(info[5]);
			
			this.descLbl.text="" + info[6];
			
			this.donateLbl.text="" + info[3];
			this.contributLbl.text="" + info[4];
			this.lvLbl.text="" + info[1];

			if (info[7] == 1) {
				this.filters=[];
			} else {
				this.filters=[FilterUtil.enablefilter];
			}
		}


	}
}

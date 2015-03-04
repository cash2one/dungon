package com.leyou.ui.team.child {

	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.PlayerUtil;

	public class TeamAddPlayerRender extends AutoSprite {

		private var playNameLbl:Label;
		private var proLbl:Label;
		private var lvLbl:Label;
		private var attLbl:Label;
		private var bossLbl:Label;

		private var lightBg:Image;

		public function TeamAddPlayerRender() {
			super(LibManager.getInstance().getXML("config/ui/team/TeamAddPlayerRender.xml"));
			this.init();
			this.mouseEnabled=true;
		}

		private function init():void {

			this.playNameLbl=this.getUIbyID("playNameLbl") as Label;
			this.proLbl=this.getUIbyID("proLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.attLbl=this.getUIbyID("attLbl") as Label;
			this.bossLbl=this.getUIbyID("bossLbl") as Label;
			this.lightBg=this.getUIbyID("lightBg") as Image;

		}

		public function updateInfo(o:Array):void {
			this.playNameLbl.text="" + o[0];
			this.proLbl.text="" + PlayerUtil.getPlayerRaceByIdx(o[1]);
			this.lvLbl.text="" + o[2];
			this.attLbl.text="" + o[3];
		}

		public function setlight(v:Boolean):void {
			if (v)
				this.lightBg.updateBmp("ui/team/team_list_bg_3.png");
			else
				this.lightBg.updateBmp("ui/team/team_list_bg_1.png");
		}

		public function playeName():String {
			return this.playNameLbl.text;
		}

		public function playNameTxt(v:String):void {
			this.playNameLbl.text=v;
		}

		public function proTxt(v:String):void {
			this.proLbl.text=v;
		}

		public function lvTxt(v:String):void {
			this.lvLbl.text=v;
		}

		public function attTxt(v:String):void {
			this.attLbl.text=v;
		}

		public function bossTxt(v:String):void {
			this.bossLbl.text=v;
		}

	}
}

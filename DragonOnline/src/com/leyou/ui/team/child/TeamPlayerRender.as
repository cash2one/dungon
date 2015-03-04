package com.leyou.ui.team.child {
	import com.ace.config.Core;
	import com.ace.game.scene.player.big.BigAvatar;
	import com.ace.gameData.player.child.FeatureInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.PnfUtil;
	import com.leyou.utils.FilterUtil;
	import com.leyou.utils.PlayerUtil;

	import flash.display.Shape;
	import flash.events.MouseEvent;

	public class TeamPlayerRender extends AutoSprite {

		private var bg:Image;

		private var iconImg:Image;
		private var bossImg:Image;
		private var unLineImg:Image;
		private var lvLbl:Label;
		private var playNameLbl:Label;
		private var proLbl:Label;
		private var attLbl:Label;
		private var mapLbl:Label;

		private var bigAvatar:BigAvatar;
		private var feachInfo:FeatureInfo;

		private var pro:int=-1;

		public function TeamPlayerRender() {
			super(LibManager.getInstance().getXML("config/ui/team/TeamPlayerRender.xml"));
			this.init();
			this.mouseEnabled=true;
//			this.mouseChildren=true;
		}

		private function init():void {

//			this.iconImg=this.getUIbyID("iconImg") as Image;
			this.bossImg=this.getUIbyID("bossImg") as Image;
			this.unLineImg=this.getUIbyID("unLineImg") as Image;

			this.playNameLbl=this.getUIbyID("playNameLbl") as Label;
			this.proLbl=this.getUIbyID("proLbl") as Label;
			this.attLbl=this.getUIbyID("attLbl") as Label;
			this.mapLbl=this.getUIbyID("mapLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;

			this.bg=new Image("ui/team/team_mate_select.png");
			this.addChild(this.bg);

			this.bg.setWH(185, 370);
			this.bg.visible=false;

			this.boosImgVisible(false);
			this.unLineImgVisible(false);

			var sp:Shape=new Shape();
			sp.graphics.beginFill(0x000000);
			sp.graphics.drawRect(0, 0, 183, 370);
			sp.graphics.endFill();
			sp.alpha=0;

			this.addChildAt(sp, 0);

			this.feachInfo=new FeatureInfo();

			this.bigAvatar=new BigAvatar();
			this.bigAvatar.x=80;
			this.bigAvatar.y=300;

			this.bigAvatar.mouseChildren=this.bigAvatar.mouseEnabled=false;
			UIManager.getInstance().teamWnd.addChild(this.bigAvatar);

		}

		public function removeAvatar():void {
			this.boosImgVisible(false);
			UIManager.getInstance().teamWnd.removeChild(this.bigAvatar);
		}

		public function showAvatar(u:Array):void {

			var avtArr:Array=u[6].split(",");

			this.feachInfo.mount=avtArr[4];

			if (this.feachInfo.mount == 0) {

				this.feachInfo.weapon=PnfUtil.realAvtId(avtArr[1], false, u[7]);
				this.feachInfo.suit=PnfUtil.realAvtId(avtArr[2], false, u[7]);
				this.feachInfo.wing=PnfUtil.realWingId(avtArr[3], false, u[7], u[1]);

			} else {

				this.feachInfo.mountWeapon=PnfUtil.realAvtId(avtArr[1], true, u[7]);
				this.feachInfo.mountSuit=PnfUtil.realAvtId(avtArr[2], true, u[7]);
				this.feachInfo.mountWing=PnfUtil.realWingId(avtArr[3], true, u[7], u[1]);
				this.feachInfo.autoNormalInfo(true, u[1], u[7]);

			}

			this.pro=u[1];
			this.bigAvatar.showII(this.feachInfo, false, this.pro);
			this.bigAvatar.mouseChildren=this.bigAvatar.mouseEnabled=false;
		}

		public function updateBigAvatar(finfo:FeatureInfo):void {
			this.bigAvatar.showII(finfo, false, this.pro);
			this.bigAvatar.mouseChildren=this.bigAvatar.mouseEnabled=false;
		}

		public function setHigit(v:Boolean):void {
			this.bg.visible=false;
//
			if (v) {
				this.bigAvatar.onOver();
			} else {
				this.bigAvatar.cancelOver();
			}

		}

		public function updateInfo(o:Array, i:int):void {

			this.playNameLbl.text="" + o[0];
			this.proLbl.text="" + PlayerUtil.getPlayerRaceByIdx(o[1]);
			this.lvLbl.text="" + o[2];
			this.attLbl.text="" + o[3];

			this.mapLbl.text="" + o[4];

//			if (o[5] == 1)
//				this.unLineImg.visible=true;
//			else
//				this.unLineImg.visible=false;

			this.showAvatar(o);
			this.bigAvatar.x=this.x + 80;
			this.bigAvatar.y=this.y + 300;

		}

		public function playNameTxt(v:String):void {
			this.playNameLbl.text=v;
		}

		public function playName():String {
			return this.playNameLbl.text;
		}

		public function proTxt(v:String):void {
			this.proLbl.text=v;
		}

		public function attTxt(v:String):void {
			this.attLbl.text=v;
		}

		public function mapTxt(v:String):void {
			this.mapLbl.text=v;
		}

		public function boosImgVisible(v:Boolean):void {
			this.bossImg.visible=v;
		}

		public function setboosImgTop():void {

			this.bossImg.x=this.x + this.bossImg.x;
			this.bossImg.y=50; //this.y + this.bossImg.y;

			UIManager.getInstance().teamWnd.addChild(this.bossImg);
		}

		public function unLineImgVisible(v:Boolean):void {
			this.unLineImg.visible=v;
		}

		public function updateIcon(v:String):void {
//			this.iconImg.updateBmp("");
		}

	}
}

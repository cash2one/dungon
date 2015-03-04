package com.ace.game.scene.ui.head {
	import com.ace.ICommon.ILivingHead;
	import com.ace.enum.UIEnum;
	import com.ace.gameData.player.LivingInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.component.ProgressImage;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;

	public class BossHead extends AutoSprite implements ILivingHead {
//		private var hpImg:Image;

		private var nameLbl:Label;

//		private var titleLbl:Label;

		private var hpLbl:Label;

//		private var lvLbl:Label;

		private var hpProgressImg:ProgressImage;

		private var info:LivingInfo;
		
		private var elementImg:Image;

		public function BossHead() {
			super(LibManager.getInstance().getXML("config/ui/BossHeadWnd.xml"));
			init();
		}

		protected function init():void {
			nameLbl=getUIbyID("nameLbl") as Label;
//			titleLbl=getUIbyID("titleLbl") as Label;
			hpLbl=getUIbyID("hpLbl") as Label;
//			lvLbl=getUIbyID("lvLbl") as Label;
			elementImg = getUIbyID("elementImg") as Image;
			if (null == hpProgressImg) {
				hpProgressImg=new ProgressImage();
				hpProgressImg.updateBmp("ui/mainUI/boss_hp.png");
				addChildAt(hpProgressImg, 2);
				hpProgressImg.x=48.5;
				hpProgressImg.y=35;
			}
		}

		public function updataHP($info:LivingInfo):void {
			this.info=$info;
			this.hpProgressImg.rollToProgress(info.baseInfo.hp / info.baseInfo.maxHp);
			this.hpLbl.text=info.baseInfo.hp + "/" + info.baseInfo.maxHp;
		}

		public function updataUI($info:LivingInfo):void {
			this.info=$info;
//			this.nameLbl.text=info.name;
//			this.lvLbl.text="（" + info.level + "级）";
//			this.titleLbl.text=TableManager.getInstance().getLivingInfo(info.tId).titleName;
			this.hpLbl.text=info.baseInfo.hp + "/" + info.baseInfo.maxHp;
			this.hpProgressImg.setProgress(info.baseInfo.hp / info.baseInfo.maxHp);
			this.nameLbl.text="LV" + info.level + "." + info.name;
			elementImg.visible = true;
			switch(info.baseInfo.yuanS){
				case 0:
					elementImg.visible = false;
					break;
				//0无元素 1金 2木 3水 4火 5土
				case 1:
					elementImg.updateBmp("ui/name/el_gold.png");
					break;
				case 2:
					elementImg.updateBmp("ui/name/el_wood.png");
					break;
				case 3:
					elementImg.updateBmp("ui/name/el_water.png");
					break;
				case 4:
					elementImg.updateBmp("ui/name/el_fire.png");
					break;
				case 5:
					elementImg.updateBmp("ui/name/el_dirt.png");
					break;
				default:
					trace("error")
					break;
			}
		}

		public function onResize($w:Number=0, $h:Number=0):void {
			x = (UIEnum.WIDTH - 586) * 0.5;
			y = 0;

		}
		
		public override function die():void{
			
		}
	}
}

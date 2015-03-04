/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-11-9 下午5:02:15
 */
package com.ace.game.scene.ui.head {
	import com.ace.enum.FilterEnum;
	import com.ace.enum.UIEnum;
	import com.ace.gameData.player.LivingInfo;
	import com.ace.ui.component.ProgressImage;
	import com.ace.ui.auto.AutoSpriteII;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;

	/**
	 * 怪物头像
	 * @author ace
	 *
	 */
	public class MonsterHead extends AutoSpriteII {

		private var nameLbl:Label;
//		private var lvLbl:Label;
//		private var titleLbl:Label;
		private var hpLbl:Label;
//		private var hpImg:Image;
		private var info:LivingInfo;
		private var hpProgressImg:ProgressImage;
		
		private var elementImg:Image;

		public function MonsterHead() {
			super("config/ui/scene/MonsterHeadWnd.xml");
		}

		override protected function init():void {
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
//			this.lvLbl=this.getUIbyID("lvLbl") as Label;
//			this.titleLbl=this.getUIbyID("titleLbl") as Label;
			this.hpLbl=this.getUIbyID("hpLbl") as Label;
//			this.hpImg=this.getUIbyID("hpImg") as Image;
			elementImg = getUIbyID("elementImg") as Image;

			if (null == hpProgressImg) {
				hpProgressImg=new ProgressImage();
				hpProgressImg.updateBmp("ui/mainUI/main_monster_hp.png");
				addChildAt(hpProgressImg, 1);
				hpProgressImg.x=16;
				hpProgressImg.y=25;
			}
			this.nameLbl.filters=/*this.lvLbl.filters=this.titleLbl.filters=*/this.hpLbl.filters=[FilterEnum.hei_miaobian];
			super.init();
			if (info)
				this.updataUI(this.info);

		}

		public function updataHP($info:LivingInfo):void {
			this.info=$info;
			if (!this.isInit)
				return;
			this.hpLbl.text=info.baseInfo.hp + "/" + info.baseInfo.maxHp;
			this.hpProgressImg.rollToProgress(info.baseInfo.hp / info.baseInfo.maxHp);
		}

		public function updataUI($info:LivingInfo):void {
			this.info=$info;
			if (!this.isInit)
				return;
			this.nameLbl.text="LV" + info.level + "." + info.name;
//			this.lvLbl.text="（" + info.level + "级）";
//			this.titleLbl.text=TableManager.getInstance().getLivingInfo(info.tId).titleName;
			this.hpLbl.text=info.baseInfo.hp + "/" + info.baseInfo.maxHp;
			this.hpProgressImg.setProgress(info.baseInfo.hp / info.baseInfo.maxHp);
			
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
			this.x=500;
			this.y=28;
		}
	}
}
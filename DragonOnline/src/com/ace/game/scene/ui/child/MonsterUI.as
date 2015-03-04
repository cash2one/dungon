/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-11-20 下午2:19:16
 */
package com.ace.game.scene.ui.child {
	import com.ace.ICommon.ILivingUI;
	import com.ace.enum.FilterEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.game.core.SceneCore;
	import com.ace.game.proxy.SceneProxy;
	import com.ace.game.scene.player.part.LivingBase;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.player.LivingInfo;
	import com.ace.ui.auto.AutoSpriteII;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.component.ProgressImage;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	
	import flash.events.MouseEvent;

	/**
	 * 场景上怪物头像ui
	 * @author ace
	 *
	 */
	public class MonsterUI extends AutoSpriteII implements ILivingUI {

		private var titleNameLbl:Label; //称号
		private var nameLbl:Label; //玩家名称
//		private var blodImg:Image;
		private var elementImg:Image;
		private var hasClick:Boolean=false;
		private var hpProgressImg:ProgressImage;

		public function MonsterUI() {
			super("config/ui/scene/titleMonWnd.xml");
		}

		override protected function init():void {
			titleNameLbl=getUIbyID("titleNameLbl") as Label;
			nameLbl=getUIbyID("nameLbl") as Label;
//			blodImg=getUIbyID("blodImg") as Image;
			elementImg=getUIbyID("elementImg") as Image;
			if (null == hpProgressImg) {
				hpProgressImg=new ProgressImage();
				hpProgressImg.updateBmp("ui/other/HP_Red_mini.png");
				addChild(hpProgressImg);
				hpProgressImg.x=70;
				hpProgressImg.y=42;
			}
			titleNameLbl.filters=nameLbl.filters=[FilterEnum.hei_miaobian];

			cacheAsBitmap=true;
		}

		/**更新：根据race不同，显示不同的样式*/
		public function updata(info:LivingInfo):void {

		}

		/**调整ui的位置*/
		public function updataPs(livingBase:LivingBase):void {
			x=livingBase.x - 94;
			y=livingBase.y - 2 * livingBase.bInfo.radius - 45;
		}

		/**显示玩家名称*/
		public function showName(info:*):void {
			nameLbl.text=info.name + "[lv" + info.level + "]";
//			nameLbl.text=info.name + "[" + info.id + "][lv" + info.level + "]";
			titleNameLbl.visible = false;
			if (info.tileNames.length > 0) {
				for each(var ti:String in info.tileNames){
					if((null != ti) && ("" != ti)){
						titleNameLbl.visible=true;
						titleNameLbl.text=ti;
						break;
					}
				}
			}
			if (info.race == PlayerEnum.RACE_MONSTER && info.tId != 0)
				nameLbl.color=getMonsterColor(info);


			if (info.race == PlayerEnum.RACE_ESCORT)
				addLoginBtn();
			switch (info.baseInfo.yuanS) {
				case 0:
					elementImg.visible=false;
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
			elementImg.x=nameLbl.x + nameLbl.width;

			this.updataHp(info);
//			showTitles(info);
//			hpProgressImg.setProgress(info.baseInfo.hp / info.baseInfo.maxHp);
//			trace("showName-------------info.idTag = " + info.idTag + "  hp rate = " + (info.baseInfo.hp / info.baseInfo.maxHp))
		}

		private var loginBtn:ImgButton;

		private function addLoginBtn():void {
			if (loginBtn)
				return;
			mouseChildren=true;
			parent.mouseChildren=true;
			parent.parent.mouseChildren=true;
			parent.parent.parent.mouseChildren=true;
			parent.parent.parent.parent.mouseChildren=true;

			loginBtn=new ImgButton("ui/delivery/btn_jinr.png");
			loginBtn.x=(192 - 39) / 2;
			loginBtn.y=-42 - 2;
			addChild(loginBtn);

			loginBtn.addEventFn(MouseEvent.CLICK, onCLick);
		}

		private function onCLick(evt:MouseEvent):void {
			hasClick=!hasClick;
			if (hasClick) {
				loginBtn.updataBmd("ui/delivery/btn_tuic.png");
				SceneProxy.onEscortBtnClick(true);
			} else {
				loginBtn.updataBmd("ui/delivery/btn_jinr.png");
				SceneProxy.onEscortBtnClick(false);
			}
		}


		public function showTitles(info:LivingInfo):void {
//			var tInfo:TTitle;
//			for (var i:int=1; i < info.tileNames.length; i++) {
//				if (info.tileNames[i] == "")
//					continue;
//				tInfo=TableManager.getInstance().getTitleByID(info.tileNames[i]);
//				if (tInfo == null)
//					continue;
//				if ("" == tInfo.Bottom_Pic) {
//					titleNameLbl.visible=true;
//					titleNameLbl.text=tInfo.name;
//					titleNameLbl.textColor=StringUtil.strToHex(tInfo.fontColour);
//					titleNameLbl.filters=[new GlowFilter(com.ace.utils.StringUtil.strToHex(tInfo.borderColour), 1, 1.3, 1.3, 7, 1)];
//				} else {
//					if (null == titles) {
//						titles=new Vector.<TitleRender>();
//					}
//					var tr:TitleRender=new TitleRender();
//					tr.updateInfo(tInfo);
//					titles.push(tr);
//					addChild(tr);
//				}
//			}
		}

		public function showPs(str:String):void {
		}

		/**更新血值*/
		public function updataHp(info:LivingInfo):void {
			hpProgressImg.rollToProgress(info.baseInfo.hp / info.baseInfo.maxHp);
			//			blodImg.setWH(42 * Math.random(), 4);
		}

		override public function die():void {
//			blodImg.die();
			releaseRes();
			parent.removeChild(this);
		}

		private function releaseRes():void {
			while (numChildren) {
				if (getChildAt(0) is Image) {
					Image(getChildAt(0)).die();
				}
				removeChildAt(0);
			}
		}

		static public function getMonsterColor(info:LivingInfo):int {
			if (info.level <= SceneCore.me.info.level - 10) {
				return 0XAAAAAA;
			} else {
				if (TableManager.getInstance().getLivingInfo(info.tId).isAggressive) {
					return 0XEE2211;
				} else {
					return 0XFFFFFF;
				}
			}
		}
		
		public function get livingName():String{
			return null;
		}
		
		public function switchVisible($visible:Boolean):void{
		}
	}
}

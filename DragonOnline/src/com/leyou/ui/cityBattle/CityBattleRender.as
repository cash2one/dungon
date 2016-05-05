package com.leyou.ui.cityBattle {
	import com.ace.config.Core;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.scene.player.big.BigAvatar;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.player.child.FeatureInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.PnfUtil;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.leyou.data.cityBattle.CityBattleCityData;
	import com.leyou.net.cmd.Cmd_WARC;
	import com.leyou.net.cmd.Cmd_ZC;
	import com.leyou.utils.PropUtils;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class CityBattleRender extends AutoSprite {
		
		private var guildLbl:Label;

		private var dayLbl:Label;

		private var rateLbl:Label;

		private var ydYbLbl:Label;

		private var playerLbl:Label;

		private var openTimeLbl:Label;
		
		private var iconImg:Image;

		private var enterBtn:ImgButton;

		private var distrRewardBtn:ImgButton;

		private var distrExpBtn:ImgButton;

		private var rewardBtn:NormalButton;

		private var desBtn:NormalButton;

		private var fInfo:FeatureInfo;

		private var historyBtn:NormalButton;
		
		private var changeBtn:ImgButton;
		
		private var ironWillBtn:ImgButton;
		
		private var big1:BigAvatar;
		
		private var big2:BigAvatar;
		
		private var big3:BigAvatar;
		
		private var bigs:Vector.<BigAvatar>;
		
		private var enterImg:Image;
		private var honuerBtn:NormalButton;

		public function CityBattleRender() {
			super(LibManager.getInstance().getXML("config/ui/cityBattle/warCityRender.xml"));
			init();
		}

		private function init():void {
			mouseEnabled=true;
			mouseChildren=true;
			enterImg=getUIbyID("enterImg") as Image;
			guildLbl=getUIbyID("guildLbl") as Label;
			dayLbl=getUIbyID("dayLbl") as Label;
			rateLbl=getUIbyID("rateLbl") as Label;
			ydYbLbl=getUIbyID("ydYbLbl") as Label;
			playerLbl=getUIbyID("playerLbl") as Label;
			openTimeLbl=getUIbyID("openTimeLbl") as Label;
			iconImg=getUIbyID("iconImg") as Image;
			enterBtn=getUIbyID("enterBtn") as ImgButton;
			changeBtn=getUIbyID("changeBtn") as ImgButton;
			distrRewardBtn=getUIbyID("distrRewardBtn") as ImgButton;
			rewardBtn=getUIbyID("rewardBtn") as NormalButton;
			desBtn=getUIbyID("desBtn") as NormalButton;
			distrExpBtn=getUIbyID("distrExpBtn") as ImgButton;
			historyBtn=getUIbyID("historyBtn") as NormalButton;
			honuerBtn=getUIbyID("honuerBtn") as NormalButton;
			ironWillBtn=getUIbyID("ironWillBtn") as ImgButton;
			
			enterBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			distrRewardBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			changeBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			distrExpBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			rewardBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			desBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			historyBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			distrExpBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			honuerBtn.addEventListener(MouseEvent.CLICK, onMouseClick);

			var content:String=TableManager.getInstance().getSystemNotice(6743).content;
			openTimeLbl.text=content;
			
			var spt:Sprite = new Sprite();
			spt.addChild(iconImg);
			addChild(spt);
			spt.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);

			big1 = new BigAvatar();
			big2 = new BigAvatar();
			big3 = new BigAvatar();
			addChild(big2);
			addChild(big3);
			addChild(big1);
			addChild(enterBtn);
			addChild(enterImg);
			
			bigs = new Vector.<BigAvatar>();
			bigs.push(big1);
			bigs.push(big2);
			bigs.push(big3);
			
			big1.x = 428;
			big1.y = 392;
			big2.x = 162;
			big2.y = 419;
			big3.x = 690;
			big3.y = 419;
			
			content = TableManager.getInstance().getSystemNotice(10149).content;
			distrRewardBtn.setToolTip(content);
			content = TableManager.getInstance().getSystemNotice(10150).content;
			distrExpBtn.setToolTip(content);
			content = TableManager.getInstance().getSystemNotice(10151).content;
			changeBtn.setToolTip(content);
			content = TableManager.getInstance().getSystemNotice(10152).content;
			ironWillBtn.setToolTip(content);
			
			fInfo = new FeatureInfo();
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			var content:String = TableManager.getInstance().getSystemNotice(10153).content;
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
		}
		
		private function getWeek(value:int):String {
			switch (value) {
				case 1:
					return PropUtils.getStringById(1659);
				case 2:
					return PropUtils.getStringById(1660);
				case 3:
					return PropUtils.getStringById(1661);
				case 4:
					return PropUtils.getStringById(1662);
				case 5:
					return PropUtils.getStringById(1663);
				case 6:
					return PropUtils.getStringById(1664);
				case 7:
					return PropUtils.getStringById(1665);
			}
			return null;
		}

//		protected function onLblClick(event:MouseEvent):void {
//			switch (event.target.name) {
//				case "adjustLbl":
//					UILayoutManager.getInstance().open(WindowEnum.CITY_BATTLE_TAX);
//					break;
//				case "provideLbl":
//					if (DataManager.getInstance().cityBattleData.cityData.cess <= 0) {
//						var content:String=TableManager.getInstance().getSystemNotice(6748).content;
//						PopupManager.showAlert(content, null, false, "citybattle.cess");
//					} else {
//						Cmd_WARC.cm_WARC_S();
//					}
//					break;
//			}
//		}

		protected function onMouseClick(event:MouseEvent):void {
			switch (event.target.name) {
				case "honuerBtn":
					UILayoutManager.getInstance().open_II(WindowEnum.MYSTORE);
					TweenMax.delayedCall(.6, function():void {
						UIManager.getInstance().myStore.setTabIndex(1)
					});
					break;
				case "enterBtn":
					Cmd_WARC.cm_WARC_E();
					break;
//				case "getBtn":
//					Cmd_WARC.cm_WARC_D();
//					break;
//				case "changeBtn":
//					UILayoutManager.getInstance().open(WindowEnum.CITY_BATTLE_ANNOUNCE);
//					break;
				case "challengeBtn":
					UILayoutManager.getInstance().open(WindowEnum.CITY_BATTLE_CHALLENGE);
					break;
				case "rewardBtn":
					UILayoutManager.getInstance().open(WindowEnum.CITY_BATTLE_REWARD);
					break;
				case "desBtn":
					UILayoutManager.getInstance().open(WindowEnum.CITY_BATTLE_EXPLAIN);
					break;
//				case "mysteryBtn":
//					UILayoutManager.getInstance().open_II(WindowEnum.MYSTORE);
//					TweenMax.delayedCall(.6, function():void {
//						UIManager.getInstance().myStore.setTabIndex(1)
//					});
//					break;
				case "historyBtn":
					UIManager.getInstance().showWindow(WindowEnum.WAR_LOG);
					Cmd_ZC.cm_ZC_H(2);
					break;
				case "changeBtn":
					UILayoutManager.getInstance().open(WindowEnum.CITY_BATTLE_TAX);
					break;
				case "distrRewardBtn":
					Cmd_WARC.cm_WARC_M(0);
					break;
				case "distrExpBtn":
					Cmd_WARC.cm_WARC_S();
					break;
			}
		}

		public function updateInfo():void {
			var data:CityBattleCityData=DataManager.getInstance().cityBattleData.cityData;
			var isOwner:Boolean=(data.palyerName == Core.me.info.name);
			distrRewardBtn.visible = isOwner;
			distrExpBtn.visible = isOwner;
			changeBtn.visible = isOwner;
			ironWillBtn.visible = isOwner;
//			getBtn.visible=isOwner;
//			changeBtn.visible=isOwner;
			dayLbl.text=data.holdDay + "";
			rateLbl.text=int(data.cess / 100) + "%";
//			ydGoldLbl.text=data.yesterMoney + "";
			ydYbLbl.text=data.yesterYB + "";
//			mGoldLbl.text=data.hostMoney + "";
//			big.visible = data.hasOwner;
//			role.visible=data.hasOwner;
//			playerLbl.visible=data.hasOwner;
//			role.update(98000);
			if (data.hasOwner) {
//				challengeBtn.visible=(Core.me.info.guildName != data.guildName);
				guildLbl.text=data.guildName;
				playerLbl.text=data.palyerName;
//				if (PlayerEnum.SEX_BOY == data.gender) {
//					role.update(98000);
//				} else {
//					role.update(98001);
//				}

				var l:int = data.hostData.length;
				for(var n:int = 0; n < l; n++){
					if(data.hostData[n].length <= 0){
						continue;
					}
					var avaArr:Array = data.hostData[n][4].split(",");
					fInfo.weapon = PnfUtil.realAvtId(avaArr[1], false, data.gender);
					fInfo.suit = PnfUtil.realAvtId(avaArr[2], false, data.gender);
					fInfo.wing = PnfUtil.realWingId(avaArr[3], false, data.gender, data.school);
					bigs[n].showII(fInfo, false, data.school);
					bigs[n].showEquipEffect(avaArr[6], avaArr[5]);
					bigs[n].playAct(PlayerEnum.ACT_STAND, 4);
				}
			} else {
//				challengeBtn.visible=false;
				guildLbl.text=PropUtils.getStringById(1642);
				playerLbl.text=PropUtils.getStringById(1642);
			}
		}
	}
}

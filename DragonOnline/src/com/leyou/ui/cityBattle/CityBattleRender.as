package com.leyou.ui.cityBattle {
	import com.ace.config.Core;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.scene.player.big.BigAvatar;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.player.child.FeatureInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.lable.children.TextArea;
	import com.ace.utils.PnfUtil;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenMax;
	import com.leyou.data.cityBattle.CityBattleCityData;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_WARC;
	import com.leyou.net.cmd.Cmd_ZC;
	import com.leyou.util.DateUtil;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;

	import flash.events.MouseEvent;
	import flash.text.StyleSheet;

	public class CityBattleRender extends AutoSprite {
		private var guildLbl:Label;

		private var dayLbl:Label;

		private var rateLbl:Label;

//		private var ydGoldLbl:Label;

		private var ydYbLbl:Label;

//		private var mGoldLbl:Label;

		private var mYbLbl:Label;

		private var adjustLbl:Label;

		private var openTimeLbl:Label;

		private var nameLbl:Label;

		private var enterBtn:ImgButton;

		private var getBtn:ImgButton;

		private var changeBtn:NormalButton;

		private var challengeBtn:ImgButton;

		private var rewardBtn:NormalButton;

		private var desBtn:NormalButton;

		private var announceText:TextArea;

		private var getBgImg:Image;

//		private var big:BigAvatar;
		private var role:SwfLoader;

		private var fInfo:FeatureInfo;

		private var challengeDesLbl:Label;

		private var historyBtn:NormalButton;

		private var mysteryBtn:ImgButton;

		private var provideLbl:Label;

		private var provideELbl:Label;

		public function CityBattleRender() {
			super(LibManager.getInstance().getXML("config/ui/cityBattle/warCityRender.xml"));
			init();
		}

		private function init():void {
			mouseEnabled=true;
			mouseChildren=true;
			guildLbl=getUIbyID("guildLbl") as Label;
			dayLbl=getUIbyID("dayLbl") as Label;
			rateLbl=getUIbyID("rateLbl") as Label;
//			ydGoldLbl=getUIbyID("ydGoldLbl") as Label;
			ydYbLbl=getUIbyID("ydYbLbl") as Label;
//			mGoldLbl=getUIbyID("mGoldLbl") as Label;
			mYbLbl=getUIbyID("mYbLbl") as Label;
			adjustLbl=getUIbyID("adjustLbl") as Label;
			openTimeLbl=getUIbyID("openTimeLbl") as Label;
			enterBtn=getUIbyID("enterBtn") as ImgButton;
			changeBtn=getUIbyID("changeBtn") as NormalButton;
			challengeBtn=getUIbyID("challengeBtn") as ImgButton;
			rewardBtn=getUIbyID("rewardBtn") as NormalButton;
			desBtn=getUIbyID("desBtn") as NormalButton;
			getBtn=getUIbyID("getBtn") as ImgButton;
			nameLbl=getUIbyID("nameLbl") as Label;
			announceText=getUIbyID("announceText") as TextArea;
			getBgImg=getUIbyID("getBgImg") as Image;
			challengeDesLbl=getUIbyID("challengeDesLbl") as Label;
			historyBtn=getUIbyID("historyBtn") as NormalButton;
			mysteryBtn=getUIbyID("mysteryBtn") as ImgButton;
			provideLbl=getUIbyID("provideLbl") as Label;
			provideELbl=getUIbyID("provideELbl") as Label;
			adjustLbl.mouseEnabled=true;
			provideLbl.mouseEnabled=true;
			var value:String=adjustLbl.text;
			var style:StyleSheet=new StyleSheet();
			style.setStyle("a:hover", {color: "#ff0000"});
			adjustLbl.styleSheet=style;
			adjustLbl.htmlText=StringUtil_II.getColorStr(StringUtil_II.addEventString("adjust", value, true), "#" + adjustLbl.textColor.toString(16));
			value=provideLbl.text;
			provideLbl.styleSheet=style;
			provideLbl.htmlText=StringUtil_II.getColorStr(StringUtil_II.addEventString("provide", value, true), "#" + provideLbl.textColor.toString(16));

			enterBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			getBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			changeBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			challengeBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			rewardBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			desBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			announceText.addEventListener(MouseEvent.CLICK, onMouseClick);
			adjustLbl.addEventListener(MouseEvent.CLICK, onLblClick);
			provideLbl.addEventListener(MouseEvent.CLICK, onLblClick);
			historyBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			mysteryBtn.addEventListener(MouseEvent.CLICK, onMouseClick);

			var content:String=TableManager.getInstance().getSystemNotice(6743).content;
			openTimeLbl.text=content;
//			big = new BigAvatar();
//			big.x = 427;
//			big.y = 352;
//			fInfo = new FeatureInfo();
//			var index:int = getChildIndex(enterBtn);
//			addChildAt(big, index);

			role=new SwfLoader();
			role.x=427;
			role.y=210;
			var index:int=getChildIndex(enterBtn);
			addChildAt(role, index);

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

		protected function onLblClick(event:MouseEvent):void {
			switch (event.target.name) {
				case "adjustLbl":
					UILayoutManager.getInstance().open(WindowEnum.CITY_BATTLE_TAX);
					break;
				case "provideLbl":
					if (DataManager.getInstance().cityBattleData.cityData.cess <= 0) {
						var content:String=TableManager.getInstance().getSystemNotice(6748).content;
						PopupManager.showAlert(content, null, false, "citybattle.cess");
					} else {
						Cmd_WARC.cm_WARC_S();
					}
					break;
			}
		}

		protected function onMouseClick(event:MouseEvent):void {
			switch (event.target.name) {
				case "enterBtn":
					Cmd_WARC.cm_WARC_E();
					break;
				case "getBtn":
					Cmd_WARC.cm_WARC_D();
					break;
				case "changeBtn":
					UILayoutManager.getInstance().open(WindowEnum.CITY_BATTLE_ANNOUNCE);
					break;
				case "challengeBtn":
					UILayoutManager.getInstance().open(WindowEnum.CITY_BATTLE_CHALLENGE);
					break;
				case "rewardBtn":
					UILayoutManager.getInstance().open(WindowEnum.CITY_BATTLE_REWARD);
					break;
				case "desBtn":
					UILayoutManager.getInstance().open(WindowEnum.CITY_BATTLE_EXPLAIN);
					break;
				case "mysteryBtn":
					UILayoutManager.getInstance().open_II(WindowEnum.MYSTORE);
					TweenMax.delayedCall(.6, function():void {
						UIManager.getInstance().myStore.setTabIndex(1)
					});
					break;
				case "historyBtn":
					UIManager.getInstance().showWindow(WindowEnum.WAR_LOG);
					Cmd_ZC.cm_ZC_H(2);
					break;
			}
		}

		public function updateInfo():void {
			var data:CityBattleCityData=DataManager.getInstance().cityBattleData.cityData;
			var isOwner:Boolean=(data.palyerName == Core.me.info.name);
			adjustLbl.visible=isOwner;
			getBtn.visible=isOwner;
			changeBtn.visible=isOwner;
			getBgImg.visible=isOwner;
			provideELbl.visible=isOwner;
			provideLbl.visible=isOwner;
			dayLbl.text=data.holdDay + "";
			rateLbl.text=int(data.cess / 100) + "%";
//			ydGoldLbl.text=data.yesterMoney + "";
			ydYbLbl.text=data.yesterYB + "";
//			mGoldLbl.text=data.hostMoney + "";
			mYbLbl.text=data.hostYB + "";
//			big.visible = data.hasOwner;
			role.visible=data.hasOwner;
			announceText.setText(data.announce);
			nameLbl.visible=data.hasOwner;
			challengeDesLbl.visible=data.hasChallenge();
			if (data.hasChallenge()) {
				var content:String=TableManager.getInstance().getSystemNotice(6740).content;
				content=StringUtil.substitute(content, data.duname, DateUtil.formatDate(new Date(data.ddate * 1000), "YYYY-MM-DD HH24:MI"));
				challengeDesLbl.htmlText=content;
			}
			role.update(98000);
			if (data.hasOwner) {
				challengeBtn.visible=(Core.me.info.guildName != data.guildName);
				guildLbl.text=data.guildName;
				nameLbl.text=data.palyerName;
				if (PlayerEnum.SEX_BOY == data.gender) {
					role.update(98000);
				} else {
					role.update(98001);
				}

//				var avaArr:Array = data.avt.split(",");
//				fInfo.weapon = PnfUtil.realAvtId(avaArr[1], false, data.gender);
//				fInfo.suit = PnfUtil.realAvtId(avaArr[2], false, data.gender);
//				fInfo.wing = PnfUtil.realWingId(avaArr[3], false, data.gender, data.school);
//				big.showII(fInfo, false, data.school);
//				big.showEquipEffect(avaArr[6], avaArr[5]);
//				big.playAct(PlayerEnum.ACT_STAND, 4);
			} else {
				challengeBtn.visible=false;
				guildLbl.text=PropUtils.getStringById(1642);
			}
		}
	}
}

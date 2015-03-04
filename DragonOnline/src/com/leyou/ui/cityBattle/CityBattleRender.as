package com.leyou.ui.cityBattle
{
	import com.ace.config.Core;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.scene.player.big.BigAvatar;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.player.child.FeatureInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.lable.children.TextArea;
	import com.ace.utils.PnfUtil;
	import com.ace.utils.StringUtil;
	import com.leyou.data.cityBattle.CityBattleCityData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_WARC;
	import com.leyou.util.DateUtil;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.MouseEvent;
	import flash.text.StyleSheet;
	
	public class CityBattleRender extends AutoSprite
	{
		private var guildLbl:Label;
		
		private var dayLbl:Label;
		
		private var rateLbl:Label;
		
		private var ydGoldLbl:Label;
		
		private var ydYbLbl:Label;
		
		private var mGoldLbl:Label;
		
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
		
		private var big:BigAvatar;
		
		private var fInfo:FeatureInfo;
		
		private var challengeDesLbl:Label;
		
		public function CityBattleRender(){
			super(LibManager.getInstance().getXML("config/ui/cityBattle/warCityRender.xml"));
			init();
		}
		
		private function init():void{
			mouseEnabled = true;
			mouseChildren = true;
			guildLbl = getUIbyID("guildLbl") as Label;
			dayLbl = getUIbyID("dayLbl") as Label;
			rateLbl = getUIbyID("rateLbl") as Label;
			ydGoldLbl = getUIbyID("ydGoldLbl") as Label;
			ydYbLbl = getUIbyID("ydYbLbl") as Label;
			mGoldLbl = getUIbyID("mGoldLbl") as Label;
			mYbLbl = getUIbyID("mYbLbl") as Label;
			adjustLbl = getUIbyID("adjustLbl") as Label;
			openTimeLbl = getUIbyID("openTimeLbl") as Label;
			enterBtn = getUIbyID("enterBtn") as ImgButton;
			changeBtn = getUIbyID("changeBtn") as NormalButton;
			challengeBtn = getUIbyID("challengeBtn") as ImgButton;
			rewardBtn = getUIbyID("rewardBtn") as NormalButton;
			desBtn = getUIbyID("desBtn") as NormalButton;
			getBtn = getUIbyID("getBtn") as ImgButton;
			nameLbl = getUIbyID("nameLbl") as Label;
			announceText = getUIbyID("announceText") as TextArea;
			getBgImg = getUIbyID("getBgImg") as Image;
			challengeDesLbl = getUIbyID("challengeDesLbl") as Label;
			adjustLbl.mouseEnabled = true;
			var value:String = adjustLbl.text;
			var style:StyleSheet = new StyleSheet();
			style.setStyle("a:hover", {color:"#ff0000"});
			adjustLbl.styleSheet = style;
			adjustLbl.htmlText = StringUtil_II.getColorStr(StringUtil_II.addEventString("adjust", value, true), "#"+adjustLbl.textColor.toString(16));
			
			enterBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			getBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			changeBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			challengeBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			rewardBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			desBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			announceText.addEventListener(MouseEvent.CLICK, onMouseClick);
			adjustLbl.addEventListener(MouseEvent.CLICK, onLblClick);
			
			var content:String = TableManager.getInstance().getSystemNotice(6743).content;
			openTimeLbl.text = content;
			big = new BigAvatar();
			big.x = 427;
			big.y = 352;
			fInfo = new FeatureInfo();
			var index:int = getChildIndex(enterBtn);
			addChildAt(big, index);
		}
		
		private function getWeek(value:int):String{
			switch(value){
				case 1:
					return "一";
				case 2:
					return "二";
				case 3:
					return "三";
				case 4:
					return "四";
				case 5:
					return "五";
				case 6:
					return "六";
				case 7:
					return "日";
			}
			return null;
		}
		
		protected function onLblClick(event:MouseEvent):void{
			UILayoutManager.getInstance().open(WindowEnum.CITY_BATTLE_TAX);
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			switch(event.target.name){
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
			}
		}
		
		public function updateInfo():void{
			var data:CityBattleCityData = DataManager.getInstance().cityBattleData.cityData;
			var isOwner:Boolean = (data.palyerName == Core.me.info.name);
			adjustLbl.visible = isOwner;
			getBtn.visible = isOwner;
			changeBtn.visible = isOwner;
			getBgImg.visible = isOwner;
			dayLbl.text = data.holdDay+"";
			rateLbl.text = int(data.cess/100)+"%";
			ydGoldLbl.text = data.yesterMoney+"";
			ydYbLbl.text = data.yesterYB+"";
			mGoldLbl.text = data.hostMoney+"";
			mYbLbl.text = data.hostYB+"";
			big.visible = data.hasOwner;
			announceText.setText(data.announce);
			nameLbl.visible = data.hasOwner;
			challengeDesLbl.visible = data.hasChallenge();
			if(data.hasChallenge()){
				var content:String = TableManager.getInstance().getSystemNotice(6740).content;
				content = StringUtil.substitute(content, data.duname, DateUtil.formatDate(new Date(data.ddate*1000), "YYYY-MM-DD HH24:MI"));
				challengeDesLbl.htmlText = content;
			}
			if(data.hasOwner){
				challengeBtn.visible = (Core.me.info.guildName != data.guildName);
				guildLbl.text = data.guildName;
				nameLbl.text = data.palyerName;
				var avaArr:Array = data.avt.split(",");
				fInfo.weapon = PnfUtil.realAvtId(avaArr[1], false, data.gender);
				fInfo.suit = PnfUtil.realAvtId(avaArr[2], false, data.gender);
				fInfo.wing = PnfUtil.realWingId(avaArr[3], false, data.gender, data.school);
				big.showII(fInfo, false, data.school);
				big.showEquipEffect(avaArr[6], avaArr[5]);
				big.playAct(PlayerEnum.ACT_STAND, 4);
			}else{
				challengeBtn.visible = false;
				guildLbl.text = "虚位以待";
			}
		}
	}
}
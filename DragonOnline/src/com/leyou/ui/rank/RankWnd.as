package com.leyou.ui.rank {
	import com.ace.enum.PlayerEnum;
	import com.ace.game.scene.player.big.BigAvatar;
	import com.ace.game.scene.ui.child.TitleRender;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.player.child.FeatureInfo;
	import com.ace.gameData.table.TTitle;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.TabButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.PnfUtil;
	import com.leyou.net.cmd.Cmd_Rank;
	import com.leyou.ui.rank.child.RankConsumeRender;
	import com.leyou.ui.rank.child.RankHeroRender;
	import com.leyou.ui.rank.child.RankListRender;
	import com.leyou.ui.rank.child.RankLockRender;

	import flash.events.MouseEvent;

	public class RankWnd extends AutoWindow {

		private var zdlBtn:TabButton;

		private var zbBtn:TabButton;

		private var zqBtn:TabButton;

		private var cbBtn:TabButton;

		private var jxBtn:TabButton;

		private var lvBtn:TabButton;

		private var cfBtn:TabButton; //xxxxxxxxxxxxxxx

		private var heroBtn:TabButton;

		private var spendBtn:TabButton; //xxxxxxxxxxxxx

//		private var timeLbl:Label;

		private var applaudBtn:ImgButton;

		private var disdainBtn:ImgButton;

		private var applaudLbl:Label;

		private var disdainLbl:Label;

		private var zdlRankPage:RankListRender;

		private var zbRankPage:RankListRender;

		private var zqRankPage:RankListRender;

		private var cbRankPage:RankListRender;

		private var jxRankPage:RankListRender;

		private var currentPage:Object;

		private var lvRankPage:RankListRender;

		private var cfRankPage:RankListRender;


		private var ysBtn:TabButton;
		private var xzBtn:TabButton;
		private var ysRankPage:RankListRender; //元素
		private var xzRankPage:RankListRender; //星座

		private var heroRankePage:RankHeroRender;

		private var consumeRankPage:RankConsumeRender;

		private var lockPage:RankLockRender;

		protected var playerMovie:BigAvatar;

		protected var rideMovie:BigAvatar;

		private var fInfo:FeatureInfo;

		public var playerName:String;

		private var countLbl:Label;

		private var effectMovie:SwfLoader;

		private var movieBgImg:Image;

		private var titleRender:TitleRender;

		public function RankWnd() {
			super(LibManager.getInstance().getXML("config/ui/rankWnd.xml"));
			init();
		}

//		(1总战斗力 2坐骑 3翅膀 4装备 5军衔 6等级 7财富)
		private function init():void {
			titleRender=new TitleRender();
			titleRender.x=574;
			titleRender.y=70;
			pane.addChild(titleRender);
			lockPage=new RankLockRender();
			lockPage.x=134;
			lockPage.y=64;
			zdlBtn=getUIbyID("zdlBtn") as TabButton;
			zbBtn=getUIbyID("zbBtn") as TabButton;
			zqBtn=getUIbyID("zqBtn") as TabButton;
			cbBtn=getUIbyID("cbBtn") as TabButton;
			jxBtn=getUIbyID("jxBtn") as TabButton;
			lvBtn=getUIbyID("lvBtn") as TabButton;
			cfBtn=getUIbyID("cfBtn") as TabButton;
			heroBtn=getUIbyID("heroBtn") as TabButton;
			spendBtn=getUIbyID("spendBtn") as TabButton;
			ysBtn=getUIbyID("ysBtn") as TabButton;
			xzBtn=getUIbyID("xzBtn") as TabButton;
			applaudBtn=getUIbyID("applaudBtn") as ImgButton;
			disdainBtn=getUIbyID("disdainBtn") as ImgButton;
			applaudLbl=getUIbyID("applaudLbl") as Label;
			disdainLbl=getUIbyID("disdainLbl") as Label;
			movieBgImg=getUIbyID("movieBgImg") as Image;

//			this.cfBtn.visible=this.spendBtn.visible=false;

			countLbl=getUIbyID("countLbl") as Label;
//			timeLbl=getUIbyID("timeLbl") as Label;
			rideMovie=new BigAvatar();
			pane.addChild(rideMovie);
			playerMovie=new BigAvatar();
			playerMovie.x=665;
			playerMovie.y=460;
			pane.addChild(playerMovie);
			effectMovie=new SwfLoader();
			effectMovie.x=665;
			effectMovie.y=415;
			pane.addChild(effectMovie);

			zdlRankPage=new RankListRender(1);
			zdlRankPage.visible=false;
			pane.addChild(zdlRankPage);
			zbRankPage=new RankListRender(4);
			zbRankPage.visible=false;
			pane.addChild(zbRankPage);
			zqRankPage=new RankListRender(2);
			zqRankPage.visible=false;
			pane.addChild(zqRankPage);
			cbRankPage=new RankListRender(3);
			cbRankPage.visible=false;
			pane.addChild(cbRankPage);
			jxRankPage=new RankListRender(5);
			jxRankPage.visible=false;
			pane.addChild(jxRankPage);
			lvRankPage=new RankListRender(6);
			lvRankPage.visible=false;
			pane.addChild(lvRankPage);
			cfRankPage=new RankListRender(7);
			cfRankPage.visible=false;
			pane.addChild(cfRankPage);

			ysRankPage=new RankListRender(9);
			ysRankPage.visible=false;
			pane.addChild(ysRankPage);

			xzRankPage=new RankListRender(10);
			xzRankPage.visible=false;
			pane.addChild(xzRankPage);


			heroRankePage=new RankHeroRender();
			heroRankePage.visible=false;
			pane.addChild(heroRankePage);
			consumeRankPage=new RankConsumeRender();
			consumeRankPage.visible=false;
			pane.addChild(consumeRankPage);

//			zdlRankPage.initByType();
//			zbRankPage.initByType();
//			zqRankPage.initByType();
//			cbRankPage.initByType();
//			jxRankPage.initByType();
//			lvRankPage.initByType();
//			cfRankPage.initByType();



			ysBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			xzBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			lvBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			cfBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			zdlBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			zbBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			zqBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			cbBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			jxBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			heroBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			applaudBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			disdainBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			spendBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			heroBtn.turnOn();
			switchToHeroRank();
		}

		public function selectPageByType(type:int):void {
			var sPage:RankListRender;
			switch (type) {
				case 9:
					sPage=ysRankPage;
					ysBtn.turnOn();
					break;
				case 10:
					sPage=xzRankPage;
					xzBtn.turnOn();
					break;
				case 1:
					sPage=zdlRankPage;
					zdlBtn.turnOn();
					break;
				case 2:
					sPage=zbRankPage;
					zbBtn.turnOn();
					break;
				case 3:
					sPage=zqRankPage;
					zqBtn.turnOn();
					break;
				case 4:
					sPage=cbRankPage;
					cbBtn.turnOn();
					break;
				case 5:
					sPage=jxRankPage;
					jxBtn.turnOn();
					break;
				case 6:
					sPage=lvRankPage;
					lvBtn.turnOn();
					break;
				case 7:
					sPage=cfRankPage;
					cfBtn.turnOn();
					break;
				case 8:
					switchToSpendRank();
					return;
				case 100:
					switchToHeroRank();
					return;
			}
			selectPage(sPage);
		}

		public override function get width():Number {
			return bg.width;
		}

		public override function get height():Number {
			return 544;
		}

		public function palyerInfo(obj:Object):void {
			var myCount:int=obj.mysc;
			countLbl.visible=true;
			countLbl.text=obj.mysc;
			var pn:String=obj.name;
			applaudLbl.text=obj.like;
			disdainLbl.text=obj.dislike;
			applaudBtn.setActive(myCount > 0, 1, true);
			disdainBtn.setActive(myCount > 0, 1, true);
		}

		public function showAvatar(avaStr:String, sex:int, pro:int, titleId:int=0):void {
			if (null == avaStr) {
				titleRender.visible=false;
				rideMovie.visible=false;
				playerMovie.visible=false;
				countLbl.visible=false;
				applaudLbl.text="0";
				disdainLbl.text="0";
				applaudBtn.setActive(false, 1, true);
				disdainBtn.setActive(false, 1, true);
				return;
			}
			if (titleId > 0) {
				titleRender.visible=true;
				var titleInfo:TTitle=TableManager.getInstance().getTitleByID(titleId);
				titleRender.updateInfo(titleInfo);
			} else {
				titleRender.visible=false;
			}
			if (null == fInfo) {
				fInfo=new FeatureInfo();
			}
			fInfo.clear();
//			var avaArr:Array=avaStr.split(",");
//			fInfo.weapon=PnfUtil.realAvtId(avaArr[1], false, sex);
//			fInfo.suit=PnfUtil.realAvtId(avaArr[2], false, sex);
//			fInfo.wing=PnfUtil.realWingId(avaArr[3], false, sex, pro);
//			big.show(fInfo, false, pro);
//			big.showEquipEffect(avaArr[5], avaArr[4])

			var avaArr:Array=avaStr.split(",");
//			if(1 == avaArr.length){
//				var bigAvaId:int = PnfUtil.realBigAvtId(avaArr[0]);
//				big.show([bigAvaId]);
//				big.playAct(PlayerEnum.ACT_STAND, 3);
//				return;
//			}
			if (avaArr.length <= 1) {
				playerMovie.visible=false;
				fInfo.suit=avaArr[0];
				rideMovie.show(fInfo);
				rideMovie.x=playerMovie.x;
				rideMovie.y=playerMovie.y;
			} else {
				rideMovie.x=playerMovie.x + 82;
				rideMovie.y=playerMovie.y - 31;
				playerMovie.visible=true;
				fInfo.weapon=PnfUtil.realAvtId(avaArr[1], false, sex);
				fInfo.suit=PnfUtil.realAvtId(avaArr[2], false, sex);
				fInfo.wing=PnfUtil.realWingId(avaArr[3], false, sex, pro);
				playerMovie.showII(fInfo, true, pro);
				playerMovie.showEquipEffect(avaArr[6], avaArr[5]);
				fInfo.clear();
				fInfo.suit=avaArr[4];
				rideMovie.show(fInfo);
			}
			playerMovie.playAct(PlayerEnum.ACT_STAND, 4);
			rideMovie.playAct(PlayerEnum.ACT_STAND, 4);
		}

		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
			if (currentPage is RankConsumeRender) {
				currentPage.requestInfo();
			}
//			addEventListener(Event.ENTER_FRAME, updateTime);
		}

//		public override function hide():void {
//			super.hide();
//			if (hasEventListener(Event.ENTER_FRAME)) {
//				removeEventListener(Event.ENTER_FRAME, updateTime);
//			}
//		}

//		protected function updateTime(event:Event):void {
//			var date:Date=new Date();
//			var rh:int=23 - date.hours;
//			var rm:int=60 - date.minutes;
//			var rs:int=60 - date.seconds;
//			timeLbl.text=StringUtil_II.lpad(rh + "", 2, "0") + ":" + StringUtil_II.lpad(rm + "", 2, "0") + ":" + StringUtil_II.lpad(rs + "", 2, "0");
//		}

		protected function onBtnClick(event:MouseEvent):void {
			var sPage:RankListRender;
			switch (event.target.name) {
				case "ysBtn":
					sPage=ysRankPage;
					break;
				case "xzBtn":
					sPage=xzRankPage;
					break;
				case "zdlBtn":
					sPage=zdlRankPage;
					break;
				case "zbBtn":
					sPage=zbRankPage;
					break;
				case "zqBtn":
					sPage=zqRankPage;
					break;
				case "cbBtn":
					sPage=cbRankPage;
					break;
				case "jxBtn":
					sPage=jxRankPage;
					break;
				case "lvBtn":
					sPage=lvRankPage;
					break;
				case "cfBtn":
					sPage=cfRankPage;
					break;
				case "heroBtn":
					switchToHeroRank();
					return;
				case "spendBtn":
					switchToSpendRank();
					return;
				case "applaudBtn":
					if ((null != playerName) && ("" != playerName)) {
						Cmd_Rank.cm_RAK_A(1, playerName);
					}
					return;
				case "disdainBtn":
					if ((null != playerName) && ("" != playerName)) {
						Cmd_Rank.cm_RAK_A(2, playerName);
					}
					return;
			}
			selectPage(sPage);
		}

		private function switchToSpendRank():void {
			spendBtn.turnOn();
			titleRender.visible=true;
			playerMovie.visible=true;
			rideMovie.visible=true;
			movieBgImg.visible=true;
			if (currentPage != consumeRankPage) {

				playerMovie.visible=false;
				if (contains(lockPage)) {
					removeChild(lockPage);
				}

				if (null == currentPage) {
					currentPage=consumeRankPage;
				} else if (currentPage.visible) {
					currentPage.visible=false;
					if (currentPage.hasOwnProperty("removeSwitchTimer")) {
						currentPage.removeSwitchTimer();
					}
					currentPage=consumeRankPage;
				}
				currentPage.visible=true;
				currentPage.x=132;
				currentPage.y=64;
				currentPage.requestInfo();
			}
		}

		private function switchToHeroRank():void {
			titleRender.visible=false;
			playerMovie.visible=false;
			rideMovie.visible=false;
			movieBgImg.visible=false;
			if (currentPage != heroRankePage) {

				playerMovie.visible=false;
				if (contains(lockPage)) {
					removeChild(lockPage);
				}

				if (null == currentPage) {
					currentPage=heroRankePage;
				} else if (currentPage.visible) {
					currentPage.visible=false;
					if (currentPage.hasOwnProperty("removeSwitchTimer")) {
						currentPage.removeSwitchTimer();
					}
					currentPage=heroRankePage;
				}
				currentPage.visible=true;
				currentPage.x=132;
				currentPage.y=64;
				currentPage.requestInfo();
			}
		}

		protected function selectPage(page:RankListRender):void {
			titleRender.visible=false;
			playerMovie.visible=true;
			rideMovie.visible=true;
			movieBgImg.visible=true;
			if (currentPage == heroRankePage) {
				currentPage.visible=false;
				currentPage=null;
			}
			if (currentPage != page) {
				if (null == currentPage) {
					currentPage=page;
				} else if (currentPage.visible) {
					currentPage.visible=false;
					if (currentPage.hasOwnProperty("removeSwitchTimer")) {
						currentPage.removeSwitchTimer();
					}
					currentPage=page;
				}
				currentPage.addSwitchTimer();
				currentPage.visible=true;
				currentPage.x=132;
				currentPage.y=64;
				currentPage.requestInfo(1);
			}
		}

		public function updateConsumeInfo(obj:Object):void {
			consumeRankPage.updateInfo(obj);
		}

		public function updateHeroInfo(obj:Object):void {
			heroRankePage.updateInfo(obj);
		}

		public function updateInfo(obj:Object):void {
			if (currentPage.type != obj.rtype) {
				return;
			}
			currentPage.isLock=("" == obj.openname)
			if (currentPage.isLock) {
				lockPage.updateInfo(currentPage.type);
				addChild(lockPage);
				//currentPage.visible=false;
				playerMovie.visible=false;
			} else {
				playerMovie.visible=true;
				if (contains(lockPage)) {
					removeChild(lockPage);
				}
				currentPage.loadRankList(obj);
					//currentPage.visible=true;
			}
		}
	}
}

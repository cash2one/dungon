package com.leyou.ui.luckDraw {
	import com.ace.ICommon.IMenu;
	import com.ace.config.Core;
	import com.ace.enum.GameFileEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.MenuManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.TimeManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.menu.data.MenuInfo;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.leyou.data.luckDraw.LuckDrawData;
	import com.leyou.data.luckDraw.LuckDrawLogInfo;
	import com.leyou.data.luckDraw.LuckDrawRewardInfo;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.enum.ChatEnum;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Friend;
	import com.leyou.net.cmd.Cmd_Guild;
	import com.leyou.net.cmd.Cmd_LDW;
	import com.leyou.net.cmd.Cmd_Tm;
	import com.leyou.ui.market.child.MarketGrid;
	import com.leyou.util.DateUtil;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.StyleSheet;
	import flash.utils.getTimer;

	public class LuckDrawWnd extends AutoWindow implements IMenu {
		private static const MAX_REWARD_COUNT:int=10;

		private var pRemainLbl:Label;

		private var pCountLbl:Label;

//		private var yb1ProLbl:Label;

		private var yb2Pro1Lbl:Label;
		
		private var yb2Pro2Lbl:Label;

		private var yb1Lbl:Label;

		private var yb2Lbl:Label;

		private var timeLbl:Label;

		//		private var proNameLbl:Label;

		private var pLotteryBtn:ImgButton;

		private var ybLotteryBtn:ImgButton;

		private var ybLottery10Btn:ImgButton;

		private var storeBtn:ImgButton;

		//		private var lLogTab:TabBar;

		private var logPanel:ScrollPane;

		private var selfPanel:ScrollPane;

		private var currentIdx:int;

		private var grids:Vector.<MarketGrid>;
		private var loopOrder:Vector.<int>;

		private var selectImg:Image;
		private var tloopCount:int;
		private var cloopCount:int;

		private var speed:int;

		private var tick:uint;
		private var totalCount:int;

		private var span:int=0;

		private var logText:Vector.<Label>;

		private var style:StyleSheet;

		private var tips:TipsInfo;

		private var menuArr:Vector.<MenuInfo>;

		private var playerName:String;

		private var isLoop:Boolean;

		private var flyQueue:Vector.<Image>;

		private var freeImgPool:Vector.<Image>;

		private var updateTick:Array;

		private var selfLogText:Vector.<Label>;

		private var evtInfo:MouseEventInfo;

		private var ybImg:Image;

		private var yb2Img:Image;

		private var tipInfo:TipsInfo;

		private var propImg:Image;

		private var btnEffect:SwfLoader;
		
		private var pRemainCLbl:Label;
		
		private var desLbl:Label;
		
		private var gotoLbl:Label;
		
		private var valueLbl:Label;
		
		private var moneyImg:Image;
		private var jlInfo:MouseEventInfo;

		public function LuckDrawWnd() {
			super(LibManager.getInstance().getXML("config/ui/luckDraw/luckDrawWnd.xml"));
			init();
		}

		private function init():void {
			// 1--个人 2--全服
			hideBg();
			clsBtn.y+=22;
			style=new StyleSheet();
			style.setStyle("a:hover", {color: "#ff0000"});
			tips=new TipsInfo();
			tips.isShowPrice=false;
			logText=new Vector.<Label>();
			selfLogText=new Vector.<Label>();
			grids=new Vector.<MarketGrid>();
			flyQueue=new Vector.<Image>();
			freeImgPool=new Vector.<Image>();
			loopOrder=new Vector.<int>();
			loopOrder.push(0, 1, 2, 3, 4, 5, 7, 13, 12, 11, 10, 9, 8, 6);
			pRemainLbl=getUIbyID("pRemainLbl") as Label;
			pCountLbl=getUIbyID("pCountLbl") as Label;
			pRemainCLbl = getUIbyID("pRemainCLbl") as Label;
			//			proNameLbl = getUIbyID("proNameLbl") as Label;
//			yb1ProLbl = getUIbyID("yb1ProLbl") as Label;
			yb2Pro1Lbl=getUIbyID("yb2Pro1Lbl") as Label;
			yb1Lbl=getUIbyID("yb1Lbl") as Label;
			yb2Pro2Lbl=getUIbyID("yb2Pro2Lbl") as Label;
			yb2Lbl=getUIbyID("yb2Lbl") as Label;
			timeLbl=getUIbyID("timeLbl") as Label;
			pLotteryBtn=getUIbyID("pLotteryBtn") as ImgButton;
			ybLotteryBtn=getUIbyID("ybLotteryBtn") as ImgButton;
			ybLottery10Btn=getUIbyID("ybLottery10Btn") as ImgButton;
			storeBtn=getUIbyID("storeBtn") as ImgButton;
			//			lLogTab = getUIbyID("lLogTab") as TabBar;
			logPanel=getUIbyID("logPanel") as ScrollPane;
			selfPanel=getUIbyID("selfLogPanel") as ScrollPane;
			propImg=getUIbyID("propImg") as Image;
			desLbl=getUIbyID("desLbl") as Label;
			gotoLbl=getUIbyID("gotoLbl") as Label;
			valueLbl=getUIbyID("valueLbl") as Label;
			moneyImg=getUIbyID("moneyImg") as Image;
			desLbl.htmlText = TableManager.getInstance().getSystemNotice(6110).content;
			gotoLbl.mouseEnabled = true;
			gotoLbl.addEventListener(MouseEvent.CLICK, onBtnClick);
			pLotteryBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			ybLotteryBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			ybLottery10Btn.addEventListener(MouseEvent.CLICK, onBtnClick);
			storeBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			//			lLogTab.addEventListener(TabbarModel.changeTurnOnIndex, onTabChange);
			//			lLogTab.turnToTab(0);
			selectImg=new Image("ui/luckDraw/icon_fz1.png");
			selectImg.visible=false;
			addChild(selectImg);
			var row:int=3;
			var col:int=6;
			var count:int=0;
			for (var i:int=0; i < row; i++) {
				for (var j:int=0; j < col; j++) {
					if ((0 == j) || ((col - 1) == j) || (0 == i) || ((row - 1) == i)) {
						var grid:MarketGrid=new MarketGrid();
						grids[count++]=grid;
						grid.x=121 + j * 113;
						grid.y=93 + i * 98;
						grid.isShowPrice=false;
						addChild(grid);
					}
				}
			}
			selectImg.x=grids[0].x;
			selectImg.y=grids[0].y;
			var info:TItemInfo=TableManager.getInstance().getItemInfo(ConfigEnum.Luck_draw1);
			//			proNameLbl.text = info.name;
			var info1:TItemInfo=TableManager.getInstance().getItemInfo(ConfigEnum.Luck_draw3);
//			yb1ProLbl.text = info1.name;
			yb2Pro1Lbl.text=info1.name + "x10";
//			yb2Pro2Lbl.text=info1.name + "x1";
			yb1Lbl.text=ConfigEnum.Luck_draw4 + "";
			yb2Lbl.text=ConfigEnum.Luck_draw13 + "";
			updateTick=ConfigEnum.Luck_draw10.split("|");
			ybImg=getUIbyID("ybImg") as Image;
			yb2Img=getUIbyID("yb2Img") as Image;
			propImg=getUIbyID("propImg") as Image;
			evtInfo=new MouseEventInfo();
			evtInfo.onMouseMove=onMouseMove;
			MouseManagerII.getInstance().addEvents(ybImg, evtInfo);
			MouseManagerII.getInstance().addEvents(yb2Img, evtInfo);
			MouseManagerII.getInstance().addEvents(propImg, evtInfo);
			jlInfo=new MouseEventInfo();
			jlInfo.onMouseMove=onTipsMouseOver;
			jlInfo.onMouseOut=onTipsMouseOut;
			
			MouseManagerII.getInstance().addEvents(moneyImg, jlInfo);
			tipInfo=new TipsInfo();
			tipInfo.isShowPrice=false;
			//			proNameLbl.mouseEnabled = true;
//			yb1ProLbl.mouseEnabled = true;
			yb2Pro1Lbl.mouseEnabled=true;
			//			proNameLbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
//			yb1ProLbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			yb2Pro1Lbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);

			var itemInfo:TItemInfo=TableManager.getInstance().getItemInfo(ConfigEnum.Luck_draw1);
			var iconUrl:String=GameFileEnum.URL_ITEM_ICO + itemInfo.icon + ".png";
			propImg.updateBmp(iconUrl);

			btnEffect=new SwfLoader();
			btnEffect.update(99900);
			btnEffect.x=697;
			btnEffect.y=535;
			addChild(btnEffect);
			removeEffect();

			if (Core.isSF) {
				ybImg.updateBmp("ui/backpack/yuanbaoIco_bound.png");
			}
			
			var style:StyleSheet=new StyleSheet();
			style.setStyle("body", {leading: 0.5});
			style.setStyle("a:hover", {color: "#ff0000"});
			gotoLbl.styleSheet=style;
			gotoLbl.htmlText=StringUtil_II.addEventString(gotoLbl.text, gotoLbl.text, true);
		}
		
		private function onTipsMouseOver(e:DisplayObject):void {
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9609).content, new Point(this.stage.mouseX, this.stage.mouseY));
		}
		
		private function onTipsMouseOut(e:DisplayObject):void {
			ToolTipManager.getInstance().hide();
		}
		
		public function updateItemNum():void {
			valueLbl.text = "" + UIManager.getInstance().backpackWnd.jl;
		}
		
		public override function get height():Number {
			return 562;
		}

		private function addEffect():void {
			btnEffect.visible=true;
		}

		private function removeEffect():void {
			btnEffect.visible=false;
		}

		protected function onMouseOver(event:MouseEvent):void {
			switch (event.target.name) {
				case "proNameLbl":
					tipInfo.itemid=ConfigEnum.Luck_draw1;
					break;
				case "yb1ProLbl":
				case "yb2Pro1Lbl":
					tipInfo.itemid=ConfigEnum.Luck_draw3;
					break;
					//					tipInfo.itemid = ConfigEnum.Luck_draw3;
					//					break;
			}
			ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, tipInfo, new Point(stage.mouseX, stage.mouseY));
		}

		private function onMouseMove(target:Image):void {
			switch (target.name) {
				case "ybImg":
				case "yb2Img":
					var content:String=TableManager.getInstance().getSystemNotice(9559).content;
					ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
					break;
				case "propImg":
					tipInfo.itemid=ConfigEnum.Luck_draw1;
					ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, tipInfo, new Point(stage.mouseX, stage.mouseY));
					break;
			}
		}

		//		protected function onTabChange(event:Event):void{
		//			if (currentIdx == lLogTab.turnOnIndex){
		//				return;
		//			}
		//			currentIdx = lLogTab.turnOnIndex;
		//			var type:int = (0 == currentIdx) ? 2 : 1;
		//			Cmd_LDW.cm_LDW_H(type);
		//		}

		protected function loop(count:int=1, index:int=0):void {
			if (!TimeManager.getInstance().hasITick(onLoopChange)) {
				speed=40;
				isLoop=true;
				cloopCount=0;
				tick=getTimer();
				totalCount=count * 14 + index + 1;
				TimeManager.getInstance().addITick(30, onLoopChange);
			}
		}

		private function onLoopChange():void {
			var interval:int=getTimer() - tick;
			if (interval >= speed) {
				tick=getTimer();
				var cindex:int=cloopCount % grids.length;
				var gi:int=loopOrder[cindex];
				cloopCount++;
				if (totalCount <= cloopCount + 10) {
					speed+=30;
				}
				if ((totalCount <= cloopCount) && TimeManager.getInstance().hasITick(onLoopChange)) {
					isLoop=false;
					receiveReward();
					TimeManager.getInstance().removeITick(onLoopChange);
				}
				selectImg.x=grids[gi].x;
				selectImg.y=grids[gi].y;
			}
		}

		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
//			Cmd_LDW.cm_LDW_I();
//			Cmd_LDW.cm_LDW_H(1);
//			Cmd_LDW.cm_LDW_H(2);
			Cmd_LDW.cm_LDW_B();
			GuideManager.getInstance().removeGuide(97);
			if (!TimeManager.getInstance().hasITick(updateTime)) {
				TimeManager.getInstance().addITick(1000, updateTime);
			}
			updateItemNum();
		}

		private function updateTime():void {
			var date:Date=new Date();
			var utick1:int=updateTick[0];
			var utick2:int=updateTick[1];
			if (utick1 > utick2) {
				var tmp:int=utick1;
				utick1=utick2;
				utick2=tmp;
			}
			var hours:int;
			var minutes:int;
			var seconds:int;
			if (date.hours > utick1) {
				hours=utick2 - date.hours;
				minutes=59 - date.minutes;
				seconds=59 - date.seconds;
			}
			if (date.hours > utick2) {
				hours=23 - date.hours + utick1;
				minutes=59 - date.minutes;
				seconds=59 - date.seconds;
			}
			var time:uint=hours * (1000 * 60 * 60) + minutes * (1000 * 60) + seconds * 1000;
			timeLbl.text=DateUtil.formatTime(time, 2);
		}

		public override function hide():void {
			super.hide();
			GuideManager.getInstance().removeGuide(98);
			if (TimeManager.getInstance().hasITick(updateTime)) {
				TimeManager.getInstance().removeITick(updateTime);
			}
		}

		protected function onBtnClick(event:MouseEvent):void {
			var content:String;
			switch (event.target.name) {
				case "pLotteryBtn":
					if (!isLoop) {
						Cmd_LDW.cm_LDW_D(1);
						GuideManager.getInstance().removeGuide(98);
					}
					break;
				case "gotoLbl":
					UILayoutManager.getInstance().show_II(WindowEnum.MYSTORE);
					
					TweenLite.delayedCall(0.3, function():void {
						UIManager.getInstance().myStore.setTabIndex(2);
					});
					break;
				case "ybLotteryBtn":
					if (!isLoop) {
						var cid:int=(Core.isSF ? 6108 : 6104);
						content=TableManager.getInstance().getSystemNotice(cid).content;
						content=StringUtil.substitute(content, ConfigEnum.Luck_draw4);
						PopupManager.showConfirm(content, lottery1, null, false, "luckDraw.lottery1");
					}
					break;
				case "ybLottery10Btn":
					if (!isLoop) {
						content=TableManager.getInstance().getSystemNotice(6105).content;
						content=StringUtil.substitute(content, ConfigEnum.Luck_draw13);
						PopupManager.showConfirm(content, lottery10, null, false, "luckDraw.lottery1");
					}
					break;
				case "storeBtn":
					UILayoutManager.getInstance().open(WindowEnum.LUCKDRAW, WindowEnum.LUCKDRAW_STORE);
					break;
			}
		}

		private function lottery1():void {
			Cmd_LDW.cm_LDW_D(2);
		}

		private function lottery10():void {
			Cmd_LDW.cm_LDW_D(3);
		}

		private function getTextItem(type:int, index:int):Label {
			var lts:Vector.<Label>=(1 == type) ? selfLogText : logText;
			if (index >= lts.length) {
				lts.length=index + 1;
			}
			var logLbl:Label=lts[index];
			if (null == logLbl) {
				logLbl=new Label();
				logLbl.mouseEnabled=true;
				logLbl.styleSheet=style;
				lts[index]=logLbl;
			}
			return logLbl;
		}

		private function updateLogPanel(type:int, length:int):void {
			var panel:ScrollPane=(1 == type) ? selfPanel : logPanel;
			var lts:Vector.<Label>=(1 == type) ? selfLogText : logText;
			var sumH:int;
			for (var n:int=0; n < length; n++) {
				var tl:Label=lts[n];
				panel.addToPane(tl);
				tl.y=sumH;
				sumH+= /*tl.height*/20;
			}
			var c:int=lts.length;
			for (var m:int=length; m < c; m++) {
				var rtl:Label=lts[m];
				rtl.text="";
				if (panel.contains(rtl)) {
					panel.delFromPane(rtl);
				}
			}
		}

		public function receiveReward():void {
			startFly();
			Cmd_LDW.cm_LDW_J();
			Cmd_LDW.cm_LDW_H(1);
			//			Cmd_LDW.cm_LDW_H(2);
		}

		public function startLuckDraw():void {
			var list:Array=DataManager.getInstance().luckdrawData.ownList;
			var pos:int=list[0] - 1;
			var gi:int=loopOrder[pos];
			pushFly(grids[gi]);
			if (list.length > 1) {
				selectImg.visible=false;
				selectImg.x=grids[gi].x;
				selectImg.y=grids[gi].y;
				var l:int=list.length;
				for (var n:int=1; n < l; n++) {
					pos=list[n] - 1;
					gi=loopOrder[pos];
					pushFly(grids[gi]);
				}
				receiveReward();
			} else {
				loop(2, pos);
				selectImg.visible=true;
			}
		}

		private function pushFly(grid:MarketGrid):void {
			var icon:Image=freeImgPool.pop();
			if (null == icon) {
				icon=new Image();
			}
			icon.bitmapData=grid.itemBmp;
			icon.x=grid.x;
			icon.y=grid.y;
			flyQueue.push(icon);
		}

		private function startFly():void {
			if (!TimeManager.getInstance().hasITick(checkFlyQueue)) {
				TimeManager.getInstance().addITick(100, checkFlyQueue);
			}
		}

		private function checkFlyQueue():void {
			var icon:Image=flyQueue.shift();
			if (null == icon) {
				if (TimeManager.getInstance().hasITick(checkFlyQueue)) {
					TimeManager.getInstance().removeITick(checkFlyQueue);
				}
				return;
			}
			addChild(icon);
			var iconW:int=icon.bitmapData.width;
			var iconH:int=icon.bitmapData.height;
			var beginX:int=icon.x + icon.width * 0.5;
			var beginY:int=icon.y + icon.height * 0.5;
			var endX:int=storeBtn.x + (storeBtn.width - iconW) * 0.5;
			var endY:int=storeBtn.y + (storeBtn.height - iconH) * 0.5;
			TweenMax.to(icon, 1.5, {bezierThrough: [{x: beginX, y: beginY}, {x: endX, y: endY}], width: iconW * 0.8, height: iconH * 0.8, ease: Expo.easeIn(1, 10, 1, 1), onComplete: complete, onCompleteParams: [icon]});
		}

		private function complete(icon:Image):void {
			if (contains(icon)) {
				removeChild(icon);
			}
			freeImgPool.push(icon);
		}

		public function updateInfo_H():void {
			var data:LuckDrawData=DataManager.getInstance().luckdrawData;
			var l:int=data.logLength(1);
			for (var n:int=0; n < l; n++) {
				var logText:Label=getTextItem(1, n);
				var info:LuckDrawLogInfo=data.getLog(1, n);
				logText.htmlText=generateLog(info);
				logText.addEventListener(TextEvent.LINK, onLinkClick);
			}
			updateLogPanel(1, l);
			l=data.logLength(2);
			for (var m:int=0; m < l; m++) {
				var lt:Label=getTextItem(2, m);
				var linfo:LuckDrawLogInfo=data.getLog(2, m);
				lt.htmlText=generateLog(linfo);
				lt.addEventListener(TextEvent.LINK, onLinkClick);
			}
			updateLogPanel(2, l);
		}

		public function onMenuClick(idx:int):void {
			switch (idx) {
				case ChatEnum.ADD_FRIEND: //添加好友
					Cmd_Friend.cm_FriendMsg_A(1, playerName);
					break;
				case ChatEnum.ADD_GUILD: //邀请入帮
					Cmd_Guild.cm_GuildInvite(playerName);
					break;
				case ChatEnum.ADD_TEAM: //邀请入队
					Cmd_Tm.cm_teamInvite(playerName);
					break;
				case ChatEnum.PRIVATE_CHAT: //私聊
					UIManager.getInstance().chatWnd.privateChat(playerName);
					break;
				case ChatEnum.CHECK_STATUS: //查看信息
					UIManager.getInstance().otherPlayerWnd.showPanel(playerName);
					break;
			}
		}

		protected function onLinkClick(event:TextEvent):void {
			var arr:Array=event.text.split("|");
			switch (arr[0]) {
				case "item":
					tips.itemid=arr[1];
					var info:TEquipInfo=TableManager.getInstance().getEquipInfo(tips.itemid);
					if ((null != info) && (10 == info.classid)) {
						ToolTipManager.getInstance().show(TipEnum.TYPE_GEM_OTHER, tips, new Point(stage.mouseX, stage.mouseY));
						return;
					}
					ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, tips, new Point(stage.mouseX, stage.mouseY));
					break;
				case "player":
					playerName=arr[1];
					if (null == menuArr) {
						menuArr=new Vector.<MenuInfo>();
						menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.PRIVATE_CHAT], ChatEnum.PRIVATE_CHAT));
						menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.CHECK_STATUS], ChatEnum.CHECK_STATUS));
						menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_FRIEND], ChatEnum.ADD_FRIEND));
						menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_TEAM], ChatEnum.ADD_TEAM));
						menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_GUILD], ChatEnum.ADD_GUILD));
					}
					MenuManager.getInstance().show(menuArr, this);
					break;
			}
		}

		public function updateInfo_I():void {
			var data:LuckDrawData=DataManager.getInstance().luckdrawData;
//			pRemainLbl.text=PropUtils.getStringById(1779) + data.remainCount + "/" + data.maxCount;
			pRemainCLbl.text = data.remainCount+"";
			if(data.remainCount > 0){
				pRemainCLbl.textColor = 0xff00;
			}else{
				pRemainCLbl.textColor = 0xff0000;
			}
			pCountLbl.text=data.costCount + "";
			var l:int=loopOrder.length;
			for (var n:int=0; n < l; n++) {
				var index:int=loopOrder[n];
				var rInfo:LuckDrawRewardInfo=data.getReward(n);
				grids[index].updataInfo({count: rInfo.count, itemId: rInfo.itemid});
			}
			updateTime();
		}

		public function updateInfoEffect():void {
			var data:LuckDrawData=DataManager.getInstance().luckdrawData;
			if (data.storeLength() > 0) {
				addEffect();
			} else {
				removeEffect();
			}
		}

		public function generateLog(info:LuckDrawLogInfo):String {
			var itemInfo:Object=TableManager.getInstance().getItemInfo(info.itemid);
			if (null == itemInfo) {
				itemInfo=TableManager.getInstance().getEquipInfo(info.itemid);
			}
			var qulity:uint=uint(itemInfo.quality);
			var itemName:String=itemInfo.name + "x" + info.itemNum;
			var color:String="#" + ItemUtil.getColorByQuality(qulity).toString(16).replace("0x");
			var str:String="";
			if (1 == info.type) {
				str="<font color='#FFC000'>{1}</font>" + PropUtils.getStringById(1780) + "<font color='{2}'><u><a href='event:{3}|{4}'>{5}</a></u></font>";
				str=StringUtil.substitute(str, info.dtime, color, "item", info.itemid, itemName);
			} else if (2 == info.type) {
				str="<font color='#00ff00'><u><a href='event:{1}|{2}'>{3}</a></u></font>"+PropUtils.getStringById(1781)+"<font color='{4}'><u><a href='event:{5}|{6}'>{7}</a></u></font>";
				str=StringUtil.substitute(str, "player", info.name, info.name, color, "item", info.itemid, itemName);
			}
			return str;
		}
	}
}

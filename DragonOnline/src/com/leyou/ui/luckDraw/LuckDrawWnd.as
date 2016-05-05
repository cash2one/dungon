package com.leyou.ui.luckDraw {
	import com.ace.ICommon.IMenu;
	import com.ace.config.Core;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.GuideArrowDirectManager;
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
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.ace.utils.StringUtil;
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
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PayUtil;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.StyleSheet;
	import flash.utils.getTimer;

	public class LuckDrawWnd extends AutoWindow implements IMenu {
		
		private static const MAX_REWARD_COUNT:int=10;

		private var costLbl:Label;

		private var item1Lbl:Label;

		private var cost10Lbl:Label;
		
		private var item2Lbl:Label;

		private var cost50Lbl:Label;

		private var item3Lbl:Label;

		private var lotteryBtn:ImgButton;

		private var lottery10Btn:ImgButton;

		private var lottery50Btn:ImgButton;

		private var storeBtn:ImgButton;
		
		private var chargeBtn:ImgButton;

		private var logPanel:ScrollPane;

		private var selfPanel:ScrollPane;
		
		private var luckDrawBar:TabBar;
		
		private var iconImg:Image;
		
		private var yb1Img:Image;
		
		private var yb2Img:Image;
		
		private var yb3Img:Image;

		private var currentIdx:int;

		private var grids:Vector.<MarketGrid>;
		private var loopOrder:Vector.<int>;

		private var selectImg:Image;
		private var tloopCount:int;
		private var cloopCount:int;

		private var speed:int;

		private var tick:uint;
		private var totalCount:int;

		private var span:int = 0;

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

//		private var ybImg:Image;
//
//		private var yb2Img:Image;

		private var tipInfo:TipsInfo;

//		private var propImg:Image;

//		private var btnEffect:SwfLoader;
//		
//		private var pRemainCLbl:Label;
//		
//		private var desLbl:Label;
//		
//		private var gotoLbl:Label;
//		
//		private var valueLbl:Label;
//		
//		private var moneyImg:Image;
		
		private var ybLbl:Label;
		
		private var jlInfo:MouseEventInfo;
		
		private var costItems:Vector.<int>;

		public function LuckDrawWnd() {
			super(LibManager.getInstance().getXML("config/ui/luckDraw/luckDrawWnd.xml"));
			init();
		}

		private function init():void {
			// 1--个人 2--全服
			costItems = new Vector.<int>(6);
			style = new StyleSheet();
			style.setStyle("a:hover", {color: "#ff0000"});
			tips = new TipsInfo();
			tips.isShowPrice = false;
			logText = new Vector.<Label>();
			selfLogText = new Vector.<Label>();
			grids = new Vector.<MarketGrid>();
			flyQueue = new Vector.<Image>();
			freeImgPool = new Vector.<Image>();
			loopOrder = new Vector.<int>();
			loopOrder.push(0, 1, 2, 3, 4, 6, 8, 13, 12, 11, 10, 9, 7, 5);
			tipInfo = new TipsInfo();
			tipInfo.isShowPrice = false;
			selectImg = new Image("ui/luckDraw/icon_fz1.png");
			selectImg.visible = false;
			pane.addChild(selectImg);
			
			costLbl = getUIbyID("costLbl") as Label;
			cost10Lbl = getUIbyID("cost10Lbl") as Label;
			cost50Lbl = getUIbyID("cost50Lbl") as Label;
			item1Lbl = getUIbyID("item1Lbl") as Label;
			item2Lbl = getUIbyID("item2Lbl") as Label;
			item3Lbl = getUIbyID("item3Lbl") as Label;
			iconImg = getUIbyID("iconImg") as Image;
			yb1Img = getUIbyID("yb1Img") as Image;
			yb2Img = getUIbyID("yb2Img") as Image;
			yb3Img = getUIbyID("yb3Img") as Image;
			ybLbl = getUIbyID("ybLbl") as Label;
			lotteryBtn = getUIbyID("lotteryBtn") as ImgButton;
			lottery10Btn = getUIbyID("lottery10Btn") as ImgButton;
			lottery50Btn = getUIbyID("lottery50Btn") as ImgButton;
			storeBtn = getUIbyID("storeBtn") as ImgButton;
			chargeBtn = getUIbyID("chargeBtn") as ImgButton;
			logPanel = getUIbyID("logPanel") as ScrollPane;
			selfPanel = getUIbyID("selfLogPanel") as ScrollPane;
			luckDrawBar = getUIbyID("luckDrawBar") as TabBar;
			lotteryBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			lottery10Btn.addEventListener(MouseEvent.CLICK, onBtnClick);
			lottery50Btn.addEventListener(MouseEvent.CLICK, onBtnClick);
			storeBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			chargeBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			luckDrawBar.addEventListener(TabbarModel.changeTurnOnIndex, onTabIndex);
			
			// 奖池
			var row:int = 4;
			var col:int = 5;
			var count:int = 0;
			for (var i:int = 0; i < row; i++) {
				for (var j:int = 0; j < col; j++) {
					if ((0 == j) || ((col - 1) == j) || (0 == i) || ((row - 1) == i)) {
						var grid:MarketGrid = new MarketGrid();
						grids[count++] = grid;
						grid.x = 28 + j * 104;
						grid.y = 120 + i * 87;
						grid.isShowPrice = false;
						pane.addChild(grid);
					}
				}
			}
			selectImg.x = grids[0].x;
			selectImg.y = grids[0].y;
			
			// 道具TIPS
			evtInfo = new MouseEventInfo();
			evtInfo.onMouseMove = onMouseMove;
			MouseManagerII.getInstance().addEvents(iconImg, evtInfo);
			MouseManagerII.getInstance().addEvents(yb1Img, evtInfo);
			MouseManagerII.getInstance().addEvents(yb2Img, evtInfo);
			MouseManagerII.getInstance().addEvents(yb3Img, evtInfo);
			
			// 文本TIPS
			item1Lbl.mouseEnabled = true;
			item2Lbl.mouseEnabled = true;
			item3Lbl.mouseEnabled = true;
			item1Lbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			item2Lbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			item3Lbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			
			luckDrawBar.turnToTab(0);
			storeBtn.width = 118;
			storeBtn.scaleY = 40/45;
			chargeBtn.width = 118;
			chargeBtn.scaleY = 40/45;
		}
		
		protected function onTabIndex(event:Event):void{
			switch(luckDrawBar.turnOnIndex){
				case 0:
					Cmd_LDW.cm_LDW_I(1);
					switchToOrdinary();
					DataManager.getInstance().luckdrawData.currentPage = 1;
					break;
				case 1:
					Cmd_LDW.cm_LDW_I(2);
					switchToVip();
					DataManager.getInstance().luckdrawData.currentPage = 2;
					break;
			}
		}
		
		protected function switchToOrdinary():void{
			var xml:XML = LibManager.getInstance().getXML("config/table/Luck_Poll.xml");
			var xmlList:XMLList = xml.children();
			var xml1:XML = xmlList[0];
			var xml2:XML = xmlList[1];
			var xml3:XML = xmlList[2];
			costLbl.text = xml1.@IB;
			item1Lbl.styleSheet = style;
			var itemInfo:TItemInfo = TableManager.getInstance().getItemInfo(xml1.@itemId);
			costItems[0] = itemInfo.id;
			item1Lbl.htmlText = StringUtil_II.addEventString(itemInfo.id+"", itemInfo.name+"x"+xml1.@itemNum, true);
			cost10Lbl.text = xml2.@IB;
			item2Lbl.styleSheet = style;
			itemInfo = TableManager.getInstance().getItemInfo(xml2.@itemPId);
			costItems[1] = itemInfo.id;
			item2Lbl.htmlText = StringUtil_II.addEventString(itemInfo.id+"", itemInfo.name+"x"+xml2.@itemPNum, true);
			cost50Lbl.text = xml3.@IB;
			item3Lbl.styleSheet = style;
			itemInfo = TableManager.getInstance().getItemInfo(xml3.@itemPId);
			costItems[2] = itemInfo.id;
			item3Lbl.htmlText = StringUtil_II.addEventString(itemInfo.id+"", itemInfo.name+"x"+xml3.@itemPNum, true);
		}
		
		protected function switchToVip():void{
			var xml:XML = LibManager.getInstance().getXML("config/table/Luck_Poll.xml");
			var xmlList:XMLList = xml.children();
			var xml1:XML = xmlList[3];
			var xml2:XML = xmlList[4];
			var xml3:XML = xmlList[5];
			costLbl.text = xml1.@IB;
			item1Lbl.styleSheet = style;
			var itemInfo:TItemInfo = TableManager.getInstance().getItemInfo(xml1.@itemId);
			costItems[3] = itemInfo.id;
			item1Lbl.htmlText = StringUtil_II.addEventString(itemInfo.id+"", itemInfo.name+"x"+xml1.@itemNum, true);
			cost10Lbl.text = xml2.@IB;
			item2Lbl.styleSheet = style;
			itemInfo = TableManager.getInstance().getItemInfo(xml2.@itemPId);
			costItems[4] = itemInfo.id;
			item2Lbl.htmlText = StringUtil_II.addEventString(itemInfo.id+"", itemInfo.name+"x"+xml2.@itemPNum, true);
			cost50Lbl.text = xml3.@IB;
			item3Lbl.styleSheet = style;
			itemInfo = TableManager.getInstance().getItemInfo(xml3.@itemPId);
			costItems[5] = itemInfo.id;
			item3Lbl.htmlText = StringUtil_II.addEventString(itemInfo.id+"", itemInfo.name+"x"+xml3.@itemPNum, true);
		}
		
		private function addEffect():void {
//			btnEffect.visible=true;
		}

		private function removeEffect():void {
//			btnEffect.visible=false;
		}
		
		protected function onMouseOver(event:MouseEvent):void {
			switch (event.target.name) {
				case "item1Lbl":
					tipInfo.itemid = (0 == luckDrawBar.turnOnIndex) ? costItems[0] : costItems[3];
					break;
				case "item2Lbl":
					tipInfo.itemid = (0 == luckDrawBar.turnOnIndex) ? costItems[1] : costItems[4];
					break;
				case "item3Lbl":
					tipInfo.itemid = (0 == luckDrawBar.turnOnIndex) ? costItems[2] : costItems[5];
					break;
			}
			ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, tipInfo, new Point(stage.mouseX, stage.mouseY));
		}

		private function onMouseMove(target:Image):void {
			switch (target.name) {
				case "iconImg":
				case "yb1Img":
				case "yb2Img":
				case "yb3Img":
					var content:String=TableManager.getInstance().getSystemNotice(9559).content;
					ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
					break;
				case "propImg":
					tipInfo.itemid=ConfigEnum.Luck_draw1;
					ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, tipInfo, new Point(stage.mouseX, stage.mouseY));
					break;
			}
		}

		protected function loop(count:int=1, index:int=0):void {
			if (!TimeManager.getInstance().hasITick(onLoopChange)) {
				speed=40;
				isLoop=true;
				cloopCount=0;
				tick=getTimer();
				totalCount=count * 14 + loopOrder.indexOf(index)+1;
				TimeManager.getInstance().addITick(30, onLoopChange);
			}
		}

		private function onLoopChange():void {
			var interval:int=getTimer() - tick;
			if (interval >= speed) {
				tick=getTimer();
				var cindex:int = cloopCount % grids.length;
				var gi:int = loopOrder[cindex];
				cloopCount++;
				if (totalCount <= cloopCount + 10) {
					speed += 30;
				}
				if ((totalCount <= cloopCount) && TimeManager.getInstance().hasITick(onLoopChange)) {
					isLoop = false;
					receiveReward();
					TimeManager.getInstance().removeITick(onLoopChange);
				}
				selectImg.x = grids[gi].x;
				selectImg.y = grids[gi].y;
			}
		}

		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
//			Cmd_LDW.cm_LDW_I();
//			Cmd_LDW.cm_LDW_H(1);
//			Cmd_LDW.cm_LDW_H(2);
			Cmd_LDW.cm_LDW_B();
			GuideManager.getInstance().removeGuide(97);
//			if (!TimeManager.getInstance().hasITick(updateTime)) {
//				TimeManager.getInstance().addITick(1000, updateTime);
//			}
//			updateItemNum();
			UILayoutManager.getInstance().open(WindowEnum.LUCKDRAW, WindowEnum.LUCKDRAW_STORE);
		}

//		private function updateTime():void {
//			var date:Date=new Date();
//			var utick1:int=updateTick[0];
//			var utick2:int=updateTick[1];
//			if (utick1 > utick2) {
//				var tmp:int=utick1;
//				utick1=utick2;
//				utick2=tmp;
//			}
//			var hours:int;
//			var minutes:int;
//			var seconds:int;
//			if (date.hours > utick1) {
//				hours=utick2 - date.hours;
//				minutes=59 - date.minutes;
//				seconds=59 - date.seconds;
//			}
//			if (date.hours > utick2) {
//				hours=23 - date.hours + utick1;
//				minutes=59 - date.minutes;
//				seconds=59 - date.seconds;
//			}
//			var time:uint=hours * (1000 * 60 * 60) + minutes * (1000 * 60) + seconds * 1000;
//			timeLbl.text=DateUtil.formatTime(time, 2);
//		}

//		public override function hide():void {
//			super.hide();
//			GuideManager.getInstance().removeGuide(98);
//			if (TimeManager.getInstance().hasITick(updateTime)) {
//				TimeManager.getInstance().removeITick(updateTime);
//			}
//		}

		protected function onBtnClick(event:MouseEvent):void {
			var xml:XML = LibManager.getInstance().getXML("config/table/Luck_Poll.xml");
			var xmlList:XMLList = xml.children();
			var content:String;
			switch (event.target.name) {
//				case "gotoLbl":
//					UILayoutManager.getInstance().show_II(WindowEnum.MYSTORE);
//					
//					TweenLite.delayedCall(0.3, function():void {
//						UIManager.getInstance().myStore.setTabIndex(2);
//					});
//					break;
				case "lotteryBtn":
					if (!isLoop) {
						if(0 == luckDrawBar.turnOnIndex){
							Cmd_LDW.cm_LDW_D(1);
						}else{
							Cmd_LDW.cm_LDW_D(4);
						}
						GuideManager.getInstance().removeGuide(98);
					}
					
					GuideArrowDirectManager.getInstance().delArrow(WindowEnum.LUCKDRAW+"");
					break;
				case "lottery10Btn":
					if (!isLoop) {
						lottery10();
//						var cid:int = (Core.isSF ? 6108 : 6104);
//						content = TableManager.getInstance().getSystemNotice(cid).content;
//						content = StringUtil.substitute(content, ConfigEnum.Luck_draw4);
//						PopupManager.showConfirm(content, lottery10, null, false, "luckDraw.lottery1");
					}
					break;
				case "lottery50Btn":
					if (!isLoop) {
						lottery50();
//						content = TableManager.getInstance().getSystemNotice(6105).content;
//						content = StringUtil.substitute(content, ConfigEnum.Luck_draw13);
//						PopupManager.showConfirm(content, lottery50, null, false, "luckDraw.lottery1");
					}
					break;
				case "storeBtn":
					UILayoutManager.getInstance().open(WindowEnum.LUCKDRAW, WindowEnum.LUCKDRAW_STORE);
					break;
				case "chargeBtn":
					PayUtil.openPayUrl();
					break;
			}
		}

		private function lottery10():void {
			if(0 == luckDrawBar.turnOnIndex){
				Cmd_LDW.cm_LDW_D(2);
			}else{
				Cmd_LDW.cm_LDW_D(5);
			}
		}

		private function lottery50():void {
			if(0 == luckDrawBar.turnOnIndex){
				Cmd_LDW.cm_LDW_D(3);
			}else{
				Cmd_LDW.cm_LDW_D(6);
			}
		}
		
		public function setTabIndex(i:int):void{
			luckDrawBar.turnToTab(i);
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
		
		public override function get height():Number{
			return 544;
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
			var gi:int=pos/*loopOrder[pos]*/;
			pushFly(grids[gi]);
			if (list.length > 1) {
				selectImg.visible=false;
				selectImg.x=grids[gi].x;
				selectImg.y=grids[gi].y;
				var l:int=list.length;
				for (var n:int=1; n < l; n++) {
					pos=list[n] - 1;
					gi=pos/*loopOrder[pos]*/;
					pushFly(grids[gi]);
				}
				receiveReward();
			} else {
				loop(2, pos);
				selectImg.visible=true;
			}
		}

		private function pushFly(grid:MarketGrid):void {
			var icon:Image = freeImgPool.pop();
			if (null == icon) {
				icon=new Image();
			}
			icon.bitmapData = grid.itemBmp;
			icon.x = grid.x;
			icon.y = grid.y;
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
				var logText:Label = getTextItem(1, n);
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
			var data:LuckDrawData = DataManager.getInstance().luckdrawData;
			// 圆周循序
//			var l:int = loopOrder.length;
//			for (var n:int = 0; n < l; n++) {
//				var index:int = loopOrder[n];
//				var rInfo:LuckDrawRewardInfo = data.getReward(n);
//				grids[index].updataInfo({count: rInfo.count, itemId: rInfo.itemid});
//			}
			ybLbl.text = data.lyb+"";
			// 阵列循序
			var l:int = grids.length;
			for (var n:int = 0; n < l; n++) {
				var rInfo:LuckDrawRewardInfo = data.getReward(n);
				grids[n].updataInfo({count: rInfo.count, itemId: rInfo.itemid});
			}
		}

		public function updateInfoEffect():void {
			var data:LuckDrawData = DataManager.getInstance().luckdrawData;
			if (data.storeLength() > 0) {
				addEffect();
			} else {
				removeEffect();
			}
		}
		
		public function updateYb():void{
			ybLbl.text = DataManager.getInstance().luckdrawData.lyb+"";
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
			var place:String = (1 == info.costType) ? PropUtils.getStringById(2340) : PropUtils.getStringById(2339);
			if (1 == info.type) {
				str="<font color='#FFC000'>{1}</font>" +  place + PropUtils.getStringById(1780) + "<font color='{2}'><u><a href='event:{3}|{4}'>{5}</a></u></font>";
				str=StringUtil.substitute(str, info.dtime, color, "item", info.itemid, itemName);
			} else if (2 == info.type) {
				str="<font color='#00ff00'><u><a href='event:{1}|{2}'>{3}</a></u></font>" + place + PropUtils.getStringById(1781)+"<font color='{4}'><u><a href='event:{5}|{6}'>{7}</a></u></font>";
				str=StringUtil.substitute(str, "player", info.name, info.name, color, "item", info.itemid, itemName);
			}
			return str;
		}
		
		override public function hide():void{
			super.hide();
			GuideManager.getInstance().removeGuide(98);
		}
		
	}
}

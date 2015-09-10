package com.leyou.ui.laba {
	import com.ace.ICommon.IMenu;
	import com.ace.enum.TipEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TLaba;
	import com.ace.manager.LibManager;
	import com.ace.manager.MenuManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.menu.data.MenuInfo;
	import com.ace.ui.roll.MultilineRoll;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.enum.ChatEnum;
	import com.leyou.net.cmd.Cmd_Duel;
	import com.leyou.net.cmd.Cmd_Friend;
	import com.leyou.net.cmd.Cmd_Guild;
	import com.leyou.net.cmd.Cmd_Laba;
	import com.leyou.net.cmd.Cmd_Tm;

	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	public class LabaWnd extends AutoWindow implements IMenu {

		private var rightImg:Image;
		private var leftImg:Image;

		private var bgImgArr:Array=[];

		private var ybBtn:ImgButton;
		private var itemBtn:ImgButton;
		private var ruleBtn:ImgButton;

		private var logList:ScrollPane;

		private var logArr:Array=[];

		private var time:Number=1;

		private var currenttime:Number=1;

		private var timer:Timer;

		private var imgArr:Vector.<Image>;

		private var mlRollArr:Vector.<MultilineRoll>;

		private var delay:int=3000;
		private var startTime:int=0;

		private var spaceTime:int=200;
		private var startspaceTime:int=0;

		private var currentStarIndex:int=0;

		private var cnum:int=0;
		private var snum:int=0;

		private var tsnum:int=0;

		private var menuName:String;
		private var tipsinfo:TipsInfo;

		private var dataobj:Object;

		private var rotationState:Boolean=false;

		public function LabaWnd() {
			super(LibManager.getInstance().getXML("config/ui/laba/labaWnd.xml"));
			this.init();
			this.hideBg();
			this.mouseChildren=true;
			//			this.mouseEnabled=true;
		}

		private function init():void {

			for (var i:int=0; i < 10; i++)
				this.bgImgArr.push(this.getUIbyID("bg" + i + "Img") as Image);

			this.rightImg=this.getUIbyID("rightImg") as Image;
			this.leftImg=this.getUIbyID("leftImg") as Image;

			this.ybBtn=this.getUIbyID("ybBtn") as ImgButton;
			this.itemBtn=this.getUIbyID("itemBtn") as ImgButton;
			this.ruleBtn=this.getUIbyID("ruleBtn") as ImgButton;

			this.logList=this.getUIbyID("logList") as ScrollPane;

			this.ybBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.itemBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.ruleBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.mlRollArr=new Vector.<MultilineRoll>();

			this.timer=new Timer(20);
			this.timer.addEventListener(TimerEvent.TIMER, onTimer);

			this.imgInit();

			this.addChild(this.rightImg);
			this.addChild(this.leftImg);

			this.tipsinfo=new TipsInfo();
		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "ybBtn":
					Cmd_Laba.cmGamble(1)
					break;
				case "itemBtn":
					Cmd_Laba.cmGamble(2)
					break;
				case "ruleBtn":
					if (!UIManager.getInstance().isCreate(WindowEnum.LABA_DESC))
						UIManager.getInstance().creatWindow(WindowEnum.LABA_DESC);

					if (UIManager.getInstance().labaDescWnd.visible)
						UIManager.getInstance().labaDescWnd.hide();
					else {
						UIManager.getInstance().labaDescWnd.show(true, UIEnum.WND_LAYER_NORMAL, true);
						UILayoutManager.getInstance().composingWnd(WindowEnum.LABA_DESC);
					}
					break;
			}

		}

		public function onTimer(e:TimerEvent):void {

			var dtime:int=getTimer();
			if (dtime - this.startTime < this.delay / 2) {
				this.spaceTime-=2;
			} else {
				this.spaceTime+=2;
			}

			if (this.spaceTime > 200)
				this.spaceTime=200;

			if (dtime - this.startspaceTime > this.spaceTime) {
				this.startspaceTime=dtime;
				this.currentStarIndex++;
			}

			var i:int=0; 
			if (this.spaceTime == 200) {
 
				for (i=0; i < 10; i++) {
					if (i % 2 == this.currentStarIndex % 2)
						this.bgImgArr[i].visible=true;
					else
						this.bgImgArr[i].visible=false;
				}

			} else {

				var pos:int=this.currentStarIndex % 10;

				for (i=0; i < 10; i++) {
					if (i != pos)
						this.bgImgArr[i].visible=false;
				}

				this.bgImgArr[pos].visible=true;
			}

			var mat:Matrix=new Matrix();
			mat.translate(-11, -22);

			if (this.rotationState)
				mat.rotate(Math.random() * -45 * Math.PI / 180);
			else
				mat.rotate(0);

			mat.translate(11, 22);

			var p:Point=mat.deltaTransformPoint(new Point(-11, -22));

			mat.tx=14 + p.x + 11;
			mat.ty=175.5 + p.y + 22;

			this.leftImg.transform.matrix=mat;

			mat=new Matrix();
			mat.translate(-37, -22);

			if (this.rotationState)
				mat.rotate(Math.random() * 45 * Math.PI / 180);
			else
				mat.rotate(0);

			mat.translate(37, 22);

			p=mat.deltaTransformPoint(new Point(-37, -22));

			mat.tx=231 + p.x + 37;
			mat.ty=175.5 + p.y + 22;

			this.rightImg.transform.matrix=mat;

		}

		public function startLaba():void {




		}

		public function startStarEffect():void {

			
			this.spaceTime=200;
			this.timer.start();
		}


		public function updateInfo(o:Object):void {

//			trace(o)

			this.ybBtn.setActive(false, 0.6, true);
			this.itemBtn.setActive(false, 0.6, true);

			this.dataobj=o;
			
			this.startTime=getTimer();

			TweenLite.delayedCall(0.1, this.mlRollArr[0].setup, [delay])
			TweenLite.delayedCall(0.3, this.mlRollArr[1].setup, [delay])
			TweenLite.delayedCall(0.6, this.mlRollArr[2].setup, [delay])

			TweenLite.delayedCall(2, onComplete);

			this.rotationState=true;
		}

		private function onComplete():void {
//			this.dataobj.jlid

			this.ybBtn.setActive(true, 1, true);
			this.itemBtn.setActive(true, 1, true);

			if (this.dataobj.jlid != 1) {

				var msp:int=this.tsnum - this.snum;

				TweenLite.delayedCall(0.1, this.mlRollArr[0].endRoll, [this.dataobj.jlid - msp - 1])
				TweenLite.delayedCall(0.3, this.mlRollArr[1].endRoll, [this.dataobj.jlid - msp - 1])
				TweenLite.delayedCall(0.6, this.mlRollArr[2].endRoll, [this.dataobj.jlid - msp - 1]);

			} else {

				var r:int=Math.random() * (this.imgArr.length - 1);
				var rArr:Array=[r];
				while (rArr.length < 3) {

					r=Math.random() * (this.imgArr.length - 1);
					if (rArr.indexOf(r) == -1)
						rArr.push(r);
				}

				TweenLite.delayedCall(0.1, this.mlRollArr[0].endRoll, [rArr[0]]);
				TweenLite.delayedCall(0.3, this.mlRollArr[1].endRoll, [rArr[1]])
				TweenLite.delayedCall(0.6, this.mlRollArr[2].endRoll, [rArr[2]])

			}


			TweenLite.delayedCall(1, lastFlyBag)

			Cmd_Laba.cmAccpet();
			Cmd_Laba.cmHistory();
		}

		private function lastFlyBag():void {

			this.rotationState=false;

			if (this.visible) {
				var itemArr:Array=[];
				var itemPointArr:Array=[];
				var itemSizeArr:Array=[];

				itemArr.push(TableManager.getInstance().getLabaById(this.dataobj.jlid).itemId);
				itemPointArr.push(this.mlRollArr[1].parent.localToGlobal(new Point(this.mlRollArr[1].x, this.mlRollArr[1].y + 60)));
				itemSizeArr.push([60, 60]);

				FlyManager.getInstance().flyBags(itemArr, itemPointArr, itemSizeArr);
			}

		}

		/**
		 *上行：laba|H
下行: laba|{"mk":"H", "hlist":[ [dtime,name,itemid,num],...]}
hlist  -- 记录信息列表
dtime -- 抽奖时间
name  -- 抽奖人名字
itemid -- 中奖道具
num    -- 道具数量
* @param o
*
*/
		public function updateHistoryInfo(o:Object):void {

			var lb:Label;

			for each (lb in this.logArr) {
				this.logList.delFromPane(lb);
			}

			this.logArr.length=0;

			var hlist:Array=o.hlist;
			var itemname:String;

			for (var i:int=0; i < hlist.length; i++) {
				lb=new Label();
				this.logList.addToPane(lb);
				this.logArr.push(lb);

				if (hlist[i][2] > 10000)
					itemname=TableManager.getInstance().getItemInfo(hlist[i][2]).name;
				else
					itemname=TableManager.getInstance().getEquipInfo(hlist[i][2]).name;

				lb.htmlText=StringUtil.substitute(TableManager.getInstance().getSystemNotice(10085).content, ["<font color='#00ff00'><u><a href='event:name--" + hlist[i][1] + "'>" + hlist[i][1] + "</a></u></font>", hlist[i][3], "<font color='#cc54ea'><u><a href='event:itemName--" + hlist[i][2] + "'>" + itemname + "</a></u></font>"]);
				lb.addEventListener(TextEvent.LINK, onLink);
				lb.mouseEnabled=true;

				lb.y=i * 20;
			}


		}

		private function onLink(e:TextEvent):void {

			var nArr:Array=e.text.split("--")

			this.menuName=nArr[1];

			if (nArr[0] == "name") {

				var menuArr:Vector.<MenuInfo>=new Vector.<MenuInfo>();
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.PRIVATE_CHAT], ChatEnum.PRIVATE_CHAT));
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.CHECK_STATUS], ChatEnum.CHECK_STATUS));
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_FRIEND], ChatEnum.ADD_FRIEND));
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_TEAM], ChatEnum.ADD_TEAM));
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU[ChatEnum.ADD_GUILD], ChatEnum.ADD_GUILD));
				menuArr.push(new MenuInfo(ChatEnum.CLICK_MENU_II[10], ChatEnum.DUEL));

				MenuManager.getInstance().show(menuArr, this);

			} else if (nArr[0] == "itemName") {

				this.tipsinfo.itemid=nArr[1];

				ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, tipsinfo, new Point(this.stage.mouseX + this.width, this.stage.mouseY + this.height));


			}


		}

		public function onMenuClick(idx:int):void {
			switch (idx) {
				case ChatEnum.ADD_FRIEND: //添加好友
					Cmd_Friend.cm_FriendMsg_A(1, this.menuName);
					break;
				case ChatEnum.ADD_GUILD: //邀请入帮
					Cmd_Guild.cm_GuildInvite(this.menuName);
					break;
				case ChatEnum.ADD_TEAM: //邀请入队
					Cmd_Tm.cm_teamInvite(this.menuName);
					break;
				case ChatEnum.PRIVATE_CHAT: //私聊
					UIManager.getInstance().chatWnd.privateChat(this.menuName);
					break;
				case ChatEnum.CHECK_STATUS: //查看信息
					UIManager.getInstance().otherPlayerWnd.showPanel(this.menuName);
					break;
				case ChatEnum.DUEL:
					Cmd_Duel.cm_DUEL_T(this.menuName);
					break;
			}
		}


		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);

			Cmd_Laba.cmHistory();
//			this.startTime=getTimer();
			this.startStarEffect();
		}

		override public function get height():Number {
			return 492;
		}

		override public function get width():Number {
			return 296;
		}

		public function imgInit():void {

			this.imgArr=new Vector.<Image>;

			var obj:Object=TableManager.getInstance().getLabaAll();

			var info:TLaba;

			for each (info in obj) {

				this.tsnum++;

				if (info.image == "-1")
					continue;

				this.cnum++;
			}

			for each (info in obj) {
				if (info.image == "-1")
					continue;

				this.imgArr.push(new Image("ico/items/" + info.image, loadUI));

			}

		}

		private function loadUI(e:Image):void {

			snum++;

			if (snum < cnum)
				return;

			var ibd:Vector.<BitmapData>=new Vector.<BitmapData>();
			for (var i:int=0; i < this.imgArr.length; i++)
				ibd.push(this.imgArr[i].bitmapData);

			var mlRoll:MultilineRoll;
			for (i=0; i < 3; i++) {
				mlRoll=new MultilineRoll(ibd, 3);
				this.addChild(mlRoll);
				this.mlRollArr.push(mlRoll);

				mlRoll.x=46 + i * 70;
				mlRoll.y=109;
			}


			this.addChild(this.rightImg);
			this.addChild(this.leftImg);

		}

		override public function onWndMouseMove($x:Number, $y:Number):void {
			super.onWndMouseMove($x, $y);

			var _w:Number=296;

			if (UIManager.getInstance().isCreate(WindowEnum.LABA_DESC) && UIManager.getInstance().labaDescWnd.visible) {

				if (this.x + _w + 3 + UIManager.getInstance().labaDescWnd.width > UIEnum.WIDTH)
					this.x=UIEnum.WIDTH - UIManager.getInstance().labaDescWnd.width - 3 - _w;

				UIManager.getInstance().labaDescWnd.x=this.x + _w;
				UIManager.getInstance().labaDescWnd.y=this.y + 80
			}
		}

		override public function onWndMouseDown():void {
			super.onWndMouseDown();

			if (UIManager.getInstance().isCreate(WindowEnum.LABA_DESC) && UIManager.getInstance().labaDescWnd.visible) {
				UIManager.getInstance().labaDescWnd.setToTop();
			}
		}

		override public function hide():void {
			super.hide();

			UIManager.getInstance().hideWindow(WindowEnum.LABA_DESC);

		}

		public function reSize():void {

			this.x=(UIEnum.WIDTH - this.width) / 2;
			this.y=(UIEnum.HEIGHT - this.height) / 2;

			var _w:Number=296;

			if (UIManager.getInstance().isCreate(WindowEnum.LABA_DESC) && UIManager.getInstance().labaDescWnd.visible) {

				if (this.x + _w + 3 + UIManager.getInstance().labaDescWnd.width > UIEnum.WIDTH)
					this.x=UIEnum.WIDTH - UIManager.getInstance().labaDescWnd.width - 3 - _w;
				else
					this.x=(UIEnum.WIDTH - _w - 3 - UIManager.getInstance().labaDescWnd.width) / 2;

				UIManager.getInstance().labaDescWnd.x=this.x + _w;
				UIManager.getInstance().labaDescWnd.y=this.y + 80
			}
		}

	}
}

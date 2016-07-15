package com.leyou.ui.guild.child {

	import com.ace.ICommon.IMenu;
	import com.ace.delayCall.DelayCallManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.MenuManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.menu.data.MenuInfo;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.ui.window.children.SimpleWindow;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ChatEnum;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.GuildEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Duel;
	import com.leyou.net.cmd.Cmd_Friend;
	import com.leyou.net.cmd.Cmd_Guild;
	import com.leyou.net.cmd.Cmd_Tm;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.system.System;

	public class GuildMember extends AutoSprite implements IMenu {

		private var namesortBtn:ImgLabelButton;
		private var lvsortBtn:ImgLabelButton;
		private var prosortBtn:ImgLabelButton;
		private var contribut1sortBtn:ImgLabelButton;
		private var contribut2sortBtn:ImgLabelButton;
		private var officesortBtn:ImgLabelButton;
		private var lastTimesortBtn:ImgLabelButton;

		private var itemList:ScrollPane;

		private var impeachBtn:NormalButton;
		private var addMemBtn:NormalButton;
		private var exitBtn:NormalButton;
		private var priceBtn:NormalButton;
		private var onlineCb:CheckBox;
		private var autoAccCb:CheckBox;

		private var arrowImg:Vector.<Image>;
		private var memberVec:Vector.<GuildMemberBar>;

		private var selectIndex:int=-1;
		private var begIndex:int=0;

		private var datalist:Array=[];

		private var BtnState:Array=[false, false, false, false, false, false, false];
		private var BtnIndex:int=-1;

		private var wnd:SimpleWindow;

		private var useArr:Array=[];

		public function GuildMember() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildMember.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.namesortBtn=this.getUIbyID("namesortBtn") as ImgLabelButton;
			this.lvsortBtn=this.getUIbyID("lvsortBtn") as ImgLabelButton;
			this.prosortBtn=this.getUIbyID("prosortBtn") as ImgLabelButton;
			this.contribut1sortBtn=this.getUIbyID("contribut1sortBtn") as ImgLabelButton;
			this.contribut2sortBtn=this.getUIbyID("contribut2sortBtn") as ImgLabelButton;
			this.officesortBtn=this.getUIbyID("officesortBtn") as ImgLabelButton;
			this.lastTimesortBtn=this.getUIbyID("lastTimesortBtn") as ImgLabelButton;

			this.itemList=this.getUIbyID("itemList") as ScrollPane;

			this.impeachBtn=this.getUIbyID("impeachBtn") as NormalButton;
			this.addMemBtn=this.getUIbyID("addMemBtn") as NormalButton;
			this.exitBtn=this.getUIbyID("exitBtn") as NormalButton;
			this.priceBtn=this.getUIbyID("priceBtn") as NormalButton;
			this.onlineCb=this.getUIbyID("onlineCb") as CheckBox;
			this.autoAccCb=this.getUIbyID("autoAccCb") as CheckBox;
			this.onlineCb.turnOn();

			this.itemList.addEventListener(MouseEvent.CLICK, onItemClick);
			this.itemList.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.itemList.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.itemList.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);

			this.impeachBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.addMemBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.exitBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.onlineCb.addEventListener(MouseEvent.CLICK, onClick);
			this.priceBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.autoAccCb.addEventListener(MouseEvent.CLICK, onClick);

			this.namesortBtn.addEventListener(MouseEvent.CLICK, onSortClick);
			this.lvsortBtn.addEventListener(MouseEvent.CLICK, onSortClick);
			this.prosortBtn.addEventListener(MouseEvent.CLICK, onSortClick);
			this.contribut1sortBtn.addEventListener(MouseEvent.CLICK, onSortClick);
			this.contribut2sortBtn.addEventListener(MouseEvent.CLICK, onSortClick);
			this.officesortBtn.addEventListener(MouseEvent.CLICK, onSortClick);
			this.lastTimesortBtn.addEventListener(MouseEvent.CLICK, onSortClick);

			this.memberVec=new Vector.<GuildMemberBar>();
			this.arrowImg=new Vector.<Image>();

			this.arrowImg.push(this.getUIbyID("arrowName") as Image);
			this.arrowImg.push(this.getUIbyID("arrowLv") as Image);
			this.arrowImg.push(this.getUIbyID("arrowPro") as Image);
			this.arrowImg.push(this.getUIbyID("arrowDon") as Image);
			this.arrowImg.push(this.getUIbyID("arrowCon") as Image);
			this.arrowImg.push(this.getUIbyID("arrowJob") as Image);
			this.arrowImg.push(this.getUIbyID("arrowLastTime") as Image);

			this.impeachBtn.setToolTip(StringUtil.substitute(TableManager.getInstance().getSystemNotice(10197).content,[ConfigEnum.union42,ConfigEnum.union41,ConfigEnum.union43]))
			
			this.y+=5;
			this.x=-14;
		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "addMemBtn":

//					if (wnd == null)
//						wnd=PopupManager.showConfirmInput("请输入要添加玩家名字:", function(str:String):void {
//							if (str != "")
//								Cmd_Guild.cm_GuildInvite(str);
//						}, function():void {
//							wnd=null;
//						}, false);

					Cmd_Guild.cm_GuildSearch();
					break;
				case "exitBtn":

					var sid:int=3052;

					if (UIManager.getInstance().guildWnd.WarPking && UIManager.getInstance().guildWnd.guildMemNum == 1)
						sid=3074;
					else if (UIManager.getInstance().guildWnd.guildMemNum == 1)
						sid=3073;
					else if (UIManager.getInstance().guildWnd.guildMemNum > 1) {
//						sid=3033;
						wnd=PopupManager.showConfirm(TableManager.getInstance().getSystemNotice(3084).content, function():void {
							Cmd_Guild.cm_GuildQuit();
						}, null, false, "guildQuit");
						return;
					}

					wnd=PopupManager.showConfirm(TableManager.getInstance().getSystemNotice(sid).content, function():void {
						Cmd_Guild.cm_GuildQuit();
					}, null, false, "guildQuit");

					break;
				case "onlineCb":
					this.onLineMem();
					break;
				case "priceBtn":
					UIManager.getInstance().guildWnd.guildPowManager.show();
					break;
				case "autoAccCb":
					Cmd_Guild.cm_GuildApplySet(this.autoAccCb.isOn ? 1 : 0);
					break;
				case "impeachBtn":
					Cmd_Guild.cm_GuildImpeachBoss();
					break;
			}

		}

		private function onWheel(e:MouseEvent):void {

			if (e.delta > 0) {

				this.begIndex-=12;

				if (this.begIndex < 0)
					this.begIndex=0;

//				Cmd_Guild.cm_GuildMemList(this.begIndex + 1, this.begIndex + 12);

			} else {

				if (this.datalist.length == 12)
					this.begIndex+=12;

//				Cmd_Guild.cm_GuildMemList(this.begIndex + 1, this.begIndex + 12);
			}
		}

		public function updateMemList():void {
			Cmd_Guild.cm_GuildMemList(this.begIndex + 1, this.begIndex + 12);
		}

		public function deleteMember(o:Object):void {

			var i:int=this.getDataByName(o.expel);
			if (i == -1)
				return;

			this.datalist.splice(i, 1);
		}


		/**
		 * 是否在线
		 */
		private function onLineMem():void {

			var tmp:Array=this.datalist.filter(function(item:Object, i:int, arr:Array):Boolean {
				if (item[7])
					return true;

				return false;
			});

			if (!this.onlineCb.isOn)
				this.updateList(tmp.sortOn("" + (BtnIndex), (BtnState[BtnIndex] ? (Array.DESCENDING | Array.NUMERIC) : (Array.CASEINSENSITIVE | Array.NUMERIC))));
			else {
				this.updateList(this.datalist.sortOn("" + (BtnIndex), (BtnState[BtnIndex] ? (Array.DESCENDING | Array.NUMERIC) : (Array.CASEINSENSITIVE | Array.NUMERIC))));
			}

		}

		/**
		 * 排序
		 * @param e
		 *
		 */
		private function onSortClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "namesortBtn":
					BtnIndex=0;
					break;
				case "lvsortBtn":
					BtnIndex=1;
					break;
				case "prosortBtn":
					BtnIndex=2;
					break;
				case "contribut1sortBtn":
					BtnIndex=3;
					break;
				case "contribut2sortBtn":
					BtnIndex=4;
					break;
				case "officesortBtn":
					BtnIndex=5;
					break;
				case "lastTimesortBtn":
					BtnIndex=6;
					break;
			}

			BtnState[BtnIndex]=!BtnState[BtnIndex];
			this.onLineMem();

			this.namesortBtn.turnOff();
			this.lvsortBtn.turnOff();
			this.prosortBtn.turnOff();
			this.contribut1sortBtn.turnOff();
			this.contribut2sortBtn.turnOff();
			this.officesortBtn.turnOff();
			this.lastTimesortBtn.turnOff();

			ImgLabelButton(e.target).turnOn(false);

			if (BtnState[BtnIndex])
				this.arrowImg[BtnIndex].updateBmp("ui/guild/icon_arrows_d.png");
			else
				this.arrowImg[BtnIndex].updateBmp("ui/guild/icon_arrows_u.png");
		}

		public function onMenuClick(i:int):void {

			switch (i) {
				case 1:
					UIManager.getInstance().chatWnd.privateChat(this.useArr[this.selectIndex][0]);
					break;
				case 2:
					UIManager.getInstance().otherPlayerWnd.showPanel(this.useArr[this.selectIndex][0]);
					break;
				case 3:
					Cmd_Tm.cm_teamInvite(this.useArr[this.selectIndex][0]);
					break;
				case 4:
					Cmd_Friend.cm_FriendMsg_A(1, this.useArr[this.selectIndex][0]);
					break;
				case 5:
					Cmd_Friend.cm_FriendMsg_A(3, this.useArr[this.selectIndex][0]);
					break;
				case 6:
					UIManager.getInstance().guildWnd.guildMemMessage.showPanel(this.useArr[this.selectIndex]);
					break;
				case 7:
					wnd=PopupManager.showConfirm(StringUtil.substitute(TableManager.getInstance().getSystemNotice(3080).content, this.useArr[this.selectIndex][0]), function():void {
						Cmd_Guild.cm_GuildAbdicate(useArr[selectIndex][0])
					}, null, false, "confirmCR");
					break;
				case 8:
					Cmd_Guild.cm_GuildKill(this.useArr[this.selectIndex][0]);
					break;
				case 9:
					System.setClipboard(this.useArr[this.selectIndex][0]);
					break;
				case 10:
					NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(9961));
					break;
				case 11:
					Cmd_Duel.cm_DUEL_T(this.useArr[this.selectIndex][0]);
					break;
				case 12:
					UIManager.getInstance().roleWnd.startMarry(this.useArr[this.selectIndex][0]);
					break;
			}

		}

		private function onItemClick(e:MouseEvent):void {

			if (e.target is GuildMemberBar) {

				if (selectIndex != -1 && this.memberVec.length > this.selectIndex)
					this.memberVec[this.selectIndex].setBgState();

				selectIndex=this.memberVec.indexOf(e.target as GuildMemberBar);

				GuildMemberBar(e.target).setBgState(2);

//				trace(UIManager.getInstance().guildWnd.memberJob , UIManager.getInstance().guildWnd.memberJob)
//				if (UIManager.getInstance().guildWnd.memberPrice[GuildEnum.ADMINI_PRICE_MANAGER] != 1)
//					return;

//				发起私聊，查看状态，邀请组队，加为加友，拉黑名单，职务变更，禅让会长，踢出行会，复制名字，举报玩家 


				var menuVec:Vector.<MenuInfo>=new Vector.<MenuInfo>();

				menuVec.push(new MenuInfo(PropUtils.getStringById(1728), 1));
				menuVec.push(new MenuInfo(PropUtils.getStringById(1729), 2));
				menuVec.push(new MenuInfo(PropUtils.getStringById(1730), 3));
				menuVec.push(new MenuInfo(PropUtils.getStringById(1711), 4));


				if (UIManager.getInstance().guildWnd.memberPrice[GuildEnum.ADMINI_PRICE_MANAGER] == 1)
					menuVec.push(new MenuInfo(PropUtils.getStringById(1731), 6));

				menuVec.push(new MenuInfo(PropUtils.getStringById(1726), 9));
				menuVec.push(new MenuInfo(PropUtils.getStringById(1732), 11));

				if (UIManager.getInstance().guildWnd.memberPrice[GuildEnum.ADMINI_PRICE_MANAGER] == 1)
					menuVec.push(new MenuInfo(PropUtils.getStringById(1733), 7));

				menuVec.push(new MenuInfo(PropUtils.getStringById(1734), 5));
				menuVec.push(new MenuInfo(PropUtils.getStringById(1735), 10));

				if (UIManager.getInstance().guildWnd.memberPrice[GuildEnum.ADMINI_PRICE_KILL_PEOPLE] == 1)
					menuVec.push(new MenuInfo(PropUtils.getStringById(1736), 8));

				menuVec.push(new MenuInfo(PropUtils.getStringById(2242), 12));

				var p:Point=new Point(e.stageX - 30, e.stageY);
				MenuManager.getInstance().show(menuVec, this, p);

			}

			e.stopImmediatePropagation();
		}

		private function onMouseOut(e:MouseEvent):void {
			if (e.target is GuildMemberBar) {
				if (selectIndex != this.memberVec.indexOf(e.target as GuildMemberBar))
					GuildMemberBar(e.target).setBgState();
			}
		}

		private function onMouseOver(e:MouseEvent):void {
			if (e.target is GuildMemberBar) {
				GuildMemberBar(e.target).setBgState(2);
			}
		}

		private function updateList(a:Array):void {

			this.useArr=a;

			var bar:GuildMemberBar;

			for each (bar in this.memberVec) {
				this.itemList.delFromPane(bar);
			}

			this.memberVec.length=0;

			for (var i:int=0; i < a.length; i++) {

				bar=new GuildMemberBar();

				if (this.memberVec.length % 2)
					bar.setBgState(0);
				else
					bar.setBgState(1);

				bar.updateInfo(a[i]);
				bar.y=this.memberVec.length * (30);

				this.itemList.addToPane(bar);
				this.memberVec.push(bar);
			}

			var p:Number=this.itemList.scrollBar_Y.progress;
			this.itemList.scrollTo(0);
			this.itemList.updateUI();
//			DelayCallManager.getInstance().add(this, this.itemList.updateUI, "updateUI", 4);
			DelayCallManager.getInstance().add(this, this.itemList.scrollTo, "updateUI", 4, p);
//			this.itemList.scrollTo(p);

		}

		public function updateInfo(o:Object):void {

			var i:int;
			if (o.hasOwnProperty("info")) {

				if (this.datalist == null)
					return;

				i=this.getDataByName(o.info[0]);
				if (i > -1) {
					this.datalist[i]=o.info;
				}

				if (BtnIndex == -1) {
					BtnIndex=1;
					BtnState[BtnIndex]=true
				}
				this.onLineMem();
			} else {

//				if (o.mlist.length == 1 && o.mlist[0][0] != MyInfoManager.getInstance().name) {
//
//					if (this.datalist == null)
//						return;
//
//					i=this.datalist.indexOf(o.mlist[0]);
//					if (i == -1 && this.datalist.length < 12) {
//						this.datalist.push(o.mlist[0]);
//					} else {
//						for(var j:int=0;j<o.mlist.length;j++)
//							if()
//						this.datalist=o.mlist;
//					}

//				} else
//				this.datalist.length=0;

				var _i:int=0;
				for (var j:int=0; j < o.mlist.length; j++) {

					_i=getDataByName(o.mlist[j][0])

					if (_i == -1)
						this.datalist.push(o.mlist[j]);
					else if (_i > -1)
						this.datalist[_i]=o.mlist[j];

				}

				if (BtnIndex == -1) {
					BtnIndex=1;
					BtnState[BtnIndex]=true
				}
				this.onLineMem();

			}

			this.updatePrice();

		}

		/**
		 *更新权限
		 */
		public function updatePrice():void {

			if (UIManager.getInstance().guildWnd.memberJob == GuildEnum.ADMINI_1) {
//				this.exitBtn.visible=false;
				this.priceBtn.visible=true;
				this.autoAccCb.visible=true;
				this.impeachBtn.visible=false;
			} else {
//				this.exitBtn.visible=true;
				this.priceBtn.visible=false;
				this.autoAccCb.visible=false;
				this.impeachBtn.visible=true;
			}

//			var mo:Object=UIManager.getInstance().guildWnd.memberPrice;

			//判断权限,和活跃度
			if (UIManager.getInstance().guildWnd.memberPrice[GuildEnum.ADMINI_PRICE_GET_PEOPLE] == 1 && UIManager.getInstance().guildWnd.guildLiveness)
				this.addMemBtn.visible=true;
			else
				this.addMemBtn.visible=false;
		}

		public function setAutoAccCb(u:int):void {
			if (u == 1)
				this.autoAccCb.turnOn();
			else
				this.autoAccCb.turnOff();
		}

		private function getDataByName(n:String):int {

			for (var i:int=0; i < this.datalist.length; i++) {
				if (this.datalist[i][0] == n)
					return i;
			}

			return -1;
		}

		public function clearData():void {
			this.datalist.length=0;
			this.hideWnd();

			var bar:GuildMemberBar;

			for each (bar in this.memberVec) {
				if (bar.parent != null)
					this.itemList.delFromPane(bar);
			}

			this.memberVec.length=0;

			this.itemList.scrollTo(0);
			this.itemList.updateUI();
			//			DelayCallManager.getInstance().add(this, this.itemList.updateUI, "updateUI", 4);
			DelayCallManager.getInstance().add(this, this.itemList.scrollTo, "updateUI", 4, 0);

			UIManager.getInstance().guildWnd.guildMemMessage.hide();
			UIManager.getInstance().guildWnd.guildPowManager.hide();
		}

		public function hideWnd():void {
			if (wnd != null) {
				wnd.hide();
				wnd=null;
			}
		}

	}
}

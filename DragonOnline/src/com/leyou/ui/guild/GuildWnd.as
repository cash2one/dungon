package com.leyou.ui.guild {

	import com.ace.enum.TipEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.TweenManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.tabbar.children.TabBar;
	import com.greensock.TweenLite;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.GuildEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Guild;
	import com.leyou.net.cmd.Cmd_Ucp;
	import com.leyou.net.cmd.Cmd_Unw;
	import com.leyou.net.cmd.Cmd_unb;
	import com.leyou.ui.guild.child.GuildAddWnd;
	import com.leyou.ui.guild.child.GuildCreat;
	import com.leyou.ui.guild.child.GuildDungeon;
	import com.leyou.ui.guild.child.GuildList;
	import com.leyou.ui.guild.child.GuildMain;
	import com.leyou.ui.guild.child.GuildMemMessager;
	import com.leyou.ui.guild.child.GuildMember;
	import com.leyou.ui.guild.child.GuildPowManager;
	import com.leyou.ui.guild.child.GuildSci;
	import com.leyou.ui.guild.child.GuildShop;
	import com.leyou.ui.guild.child.GuildSkill;
	import com.leyou.ui.guild.child.GuildWar;
	import com.leyou.ui.guild.child.GuildZC;
	import com.leyou.utils.PropUtils;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class GuildWnd extends AutoWindow {

		private var memNumLbl:Label;
		private var currentonlineLbl:Label;
		private var contributeLbl:Label;

		private var memNumTxt:Label;
		private var currOnLineTxt:Label;
		private var contributeTxt:Label;

		private var autoAccCb:CheckBox;

		private var guildTabbar:TabBar;

		private var mainBtn:ImgButton;
		private var memBtn:ImgButton;
		private var kjBtn:ImgButton;
		private var shopBtn:ImgButton;
		private var listBtn:ImgButton;

		private var guildMain:GuildMain;
		private var guildMember:GuildMember;
		private var guildShop:GuildShop;

		private var guildCreat:GuildCreat;
		private var guildList:GuildList;
		private var guildSkill:GuildSkill;
		private var guildSci:GuildSci;
		private var guildCopy:GuildDungeon;
		private var guildPk:GuildWar;
		private var guildZc:GuildZC;

		public var guildMemMessage:GuildMemMessager;
		public var guildPowManager:GuildPowManager;

		public var guildInviteWnd:GuildInviteWnd;
		public var guildAddWnd:GuildAddWnd;
		public var guildDonateMessage:GuildDonateMessage;
		public var bgIcon:Image;

		public var firstOpen:Boolean=true;

		public var guildMemNum:int=0;

		/**
		 *帮会id
		 */
		public var guildId:String="";

		/**
		 * 帮贡
		 */
		public var guildContribute:int=0;

		/**
		 *帮会等级
		 */
		public var guildLv:int=0;

		/**
		 *个人职位
		 */
		public var memberJob:int=0;

		/**
		 *工会名字
		 */
		public var guildName:String;

		/**
		 *活跃度
		 */
		public var guildLiveness:Boolean=false;

		/**
		 * 已捐赠金币
		 */
		public var guildDonateMoney:int=0;

		/**
		 *sr -- 收人 (0,1)
tr -- 踢人 (0,1)
sj -- 升级 (0,1)
xz -- 宣战 (0,1)
gl -- 管理 (0,1)
*/
		public var memberPrice:Object={};

		/**
		 *是否争霸
		 */
		public var guildWarc:int=0;

		public var guildSciData:Array=[];

		private var ischeckUset:int=0;


		private var changeTabIndex:int=0;
		private var changeTabName:String;


		public function GuildWnd() {
			super(LibManager.getInstance().getXML("config/ui/guildWnd.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.memNumLbl=this.getUIbyID("memNumLbl") as Label;
			this.currentonlineLbl=this.getUIbyID("currentonlineLbl") as Label;
			this.contributeLbl=this.getUIbyID("contributeLbl") as Label;
			this.memNumTxt=this.getUIbyID("memNumTxt") as Label;
			this.currOnLineTxt=this.getUIbyID("currOnLineTxt") as Label;
			this.contributeTxt=this.getUIbyID("contributeTxt") as Label;
			this.bgIcon=this.getUIbyID("bgIcon") as Image;

//			this.autoAccCb=this.getUIbyID("autoAccCb") as CheckBox;
//			this.guildTabbar=this.getUIbyID("guildTabbar") as TabBar;

			this.mainBtn=this.getUIbyID("mainBtn") as ImgButton;
			this.memBtn=this.getUIbyID("memBtn") as ImgButton;
			this.kjBtn=this.getUIbyID("kjBtn") as ImgButton;
			this.shopBtn=this.getUIbyID("shopBtn") as ImgButton;
			this.listBtn=this.getUIbyID("listBtn") as ImgButton;

			this.mainBtn.addEventListener(MouseEvent.CLICK, onItemClick);
			this.memBtn.addEventListener(MouseEvent.CLICK, onItemClick);
			this.kjBtn.addEventListener(MouseEvent.CLICK, onItemClick);
			this.shopBtn.addEventListener(MouseEvent.CLICK, onItemClick);
			this.listBtn.addEventListener(MouseEvent.CLICK, onItemClick);

//			this.autoAccCb.addEventListener(MouseEvent.CLICK, onClick);
//			this.guildTabbar.addEventListener(TabbarModel.changeTurnOnIndex, onChangeIndex);

//			this.autoAccCb.setActive(false);

			this.guildMain=new GuildMain();
			this.addChild(this.guildMain);
			this.guildMain.x=5;
			this.guildMain.y=60;

			this.guildMember=new GuildMember();
			this.addChild(this.guildMember);
			this.guildMember.x=5;
			this.guildMember.y=60;

			this.guildShop=new GuildShop();
			this.addChild(this.guildShop);
			this.guildShop.x=5;
			this.guildShop.y=60;

			this.guildCreat=new GuildCreat();
//			this.addChild(this.guildCreat);
//			this.guildCreat.x=60;
//			this.guildCreat.y=60;

			this.guildList=new GuildList();
			this.addChild(this.guildList);
			this.guildList.x=5;
			this.guildList.y=60;

			this.guildSci=new GuildSci();
			this.addChild(this.guildSci);
			this.guildSci.x=5;
			this.guildSci.y=60;

			this.guildCopy=new GuildDungeon();
//			this.addChild(this.guildCopy);

			this.guildPk=new GuildWar();
			this.addChild(this.guildPk);
			this.guildPk.x=60;
			this.guildPk.y=60;

			this.guildZc=new GuildZC();
			this.addChild(this.guildZc);
			this.guildZc.x=60;
			this.guildZc.y=60;

			this.guildMain.visible=true;
			this.guildMember.visible=false;
			this.guildSci.visible=false;
			this.guildShop.visible=false;
			this.guildList.visible=false;
			this.guildZc.visible=false;
			this.guildPk.visible=false;
			this.guildCreat.visible=false;

//			this.guildTabbar.addToTab(this.guildMain, 0);
//			this.guildTabbar.addToTab(this.guildMember, 1);
//			this.guildTabbar.addToTab(this.guildSci, 2);
//			this.guildTabbar.addToTab(this.guildCopy, 3);
//			this.guildTabbar.addToTab(this.guildPk, 4);
//			this.guildTabbar.addToTab(this.guildShop, 5);
//			this.guildTabbar.addToTab(this.guildZc, 6);
//			this.guildTabbar.addToTab(this.guildList, 7);
//			this.guildTabbar.addToTab(this.guildCreat, 8);


			this.guildMemMessage=new GuildMemMessager();
			this.guildPowManager=new GuildPowManager();
			this.guildInviteWnd=new GuildInviteWnd();
			this.guildDonateMessage=new GuildDonateMessage();
			this.guildAddWnd=new GuildAddWnd();

//			this.guildTabbar.turnToTab(0);

			this.addChild(this.mainBtn);
			this.addChild(this.memBtn);
			this.addChild(this.kjBtn);
			this.addChild(this.shopBtn);
			this.addChild(this.listBtn);

			this.addChild(this.getUIbyID("m1Img") as Image);
			this.addChild(this.getUIbyID("m2Img") as Image);
			this.addChild(this.getUIbyID("m3Img") as Image);
			this.addChild(this.getUIbyID("m4Img") as Image);
			this.addChild(this.getUIbyID("m5Img") as Image);

			this.addChild(this.memNumLbl);
			this.addChild(this.currentonlineLbl);
			this.addChild(this.contributeLbl);
			this.addChild(this.currOnLineTxt);
			this.addChild(this.memNumTxt);
			this.addChild(this.contributeTxt);
			this.addChild(this.bgIcon);

			var einfo:MouseEventInfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.bgIcon, einfo);
		}

		private function onTipsMouseOver(e:DisplayObject):void {
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9557).content, new Point(this.stage.mouseX, this.stage.mouseY));
		}

		private function onTipsMouseOut(e:DisplayObject):void {
			ToolTipManager.getInstance().hide();
		}

		private function onItemClick(e:MouseEvent):void {

			this.mainBtn.turnOff();
			this.memBtn.turnOff();
			this.kjBtn.turnOff();
			this.shopBtn.turnOff();
			this.listBtn.turnOff();

			switch (e.target.name) {
				case "mainBtn":
					this.guildMain.visible=true;
					this.guildMember.visible=false;
					this.guildSci.visible=false;
					this.guildShop.visible=false;
					this.guildList.visible=false;

					this.mainBtn.turnOn();

					Cmd_Guild.cm_GuildInfo();
					this.guildAddWnd.hide();
					UIManager.getInstance().buyWnd.hide();
					break;
				case "memBtn":
					this.guildMain.visible=false;
					this.guildMember.visible=true;
					this.guildSci.visible=false;
					this.guildShop.visible=false;
					this.guildList.visible=false;

					this.memBtn.turnOn();

//					Cmd_Guild.cm_GuildMemList(1, this.guildMemNum);
					Cmd_Guild.cm_GuildMemList(1, 1000);
					this.guildDonateMessage.hide();
					UIManager.getInstance().buyWnd.hide();
					break;
				case "kjBtn":
					this.guildMain.visible=false;
					this.guildMember.visible=false;
					this.guildSci.visible=true;
					this.guildShop.visible=false;
					this.guildList.visible=false;

					this.kjBtn.turnOn();
					Cmd_unb.cmGuildBlessInit();
//					this.updateGuildSci(null);
//					Cmd_Guild.cm_GuildSkill();
					this.guildDonateMessage.hide();
					this.guildAddWnd.hide();
					UIManager.getInstance().buyWnd.hide();
					break;
				case 3:
					Cmd_Ucp.cm_GuildCpInit();
					this.guildDonateMessage.hide();
					this.guildAddWnd.hide();
					UIManager.getInstance().buyWnd.hide();
					break;
				case 4:
					Cmd_Unw.cm_GuildPkInit();
					this.guildAddWnd.hide();
					break;
				case "shopBtn":

					this.guildMain.visible=false;
					this.guildMember.visible=false;
					this.guildSci.visible=false;
					this.guildShop.visible=true;
					this.guildList.visible=false;

					this.shopBtn.turnOn();

					this.guildShop.updateData();
					this.guildAddWnd.hide();
					break;
				case 6:
					this.guildDonateMessage.hide();
					this.guildAddWnd.hide();
					UIManager.getInstance().buyWnd.hide();
					Cmd_Guild.cm_GuildZCInit();
					break;
				case "listBtn":

					this.guildMain.visible=false;
					this.guildMember.visible=false;
					this.guildSci.visible=false;
					this.guildShop.visible=false;
					this.guildList.visible=true;

					this.listBtn.turnOn();

					Cmd_Guild.cm_GuildList(1, 12);
					this.guildDonateMessage.hide();
					this.guildAddWnd.hide();
					UIManager.getInstance().buyWnd.hide();
					break;
				case 8:
					this.guildDonateMessage.hide();
					this.guildAddWnd.hide();
					UIManager.getInstance().buyWnd.hide();
					break;

			}

			this.changeTabName=e.target.name;
			//			this.guildSkill.clearData();
			this.guildMember.clearData();
			this.guildList.clearData();

		}

		/**
		 * 更新副本
		 * @param o
		 *
		 */
		public function updateGuildCopy(o:Object):void {
			this.guildCopy.updateInfo(o);
		}

		public function updateGuildPk(o:Object):void {
			this.guildPk.updateInfo(o);
		}

		public function updateGuildZc(o:Object):void {
			this.guildZc.updateInfo(o);
		}

		/**
		 * 设置列表页邀请状态
		 * @param yset
		 *
		 */
		public function setGuildListInviteState(yset:int):void {
			if (yset == 1) {
				this.guildList.getAutoAccCb().turnOn();
			} else {
				this.guildList.getAutoAccCb().turnOff();
			}
		}

		/**
		 * 行会pk状态
		 * @return
		 *
		 */
		public function get WarPking():Boolean {
			return this.guildPk.pkstate;
		}

		public function setTabIndex(i:int):void {
			if (this.guildName != "" && this.guildName != null) {
				this.changeTabIndex=i;
//				this.guildTabbar.turnToTab(i);
			}
		}

		/**
		 *自动入会
		 * @param e
		 *
		 */
//		private function onClick(e:MouseEvent):void {
//			if (UIManager.getInstance().guildWnd.memberJob == GuildEnum.ADMINI_1)
//				Cmd_Guild.cm_GuildApplySet(this.autoAccCb.isOn ? 1 : 0);
//			else
//				Cmd_Guild.cm_GuildInviteSet(this.autoAccCb.isOn ? 1 : 0);
//		}

		public function viewCopyOn():Boolean {
			return this.guildCopy.isOn;
		}

		private function onChangeIndex(e:Event):void {

			switch (this.guildTabbar.turnOnIndex) {
				case 0:
					Cmd_Guild.cm_GuildInfo();
					this.guildAddWnd.hide();
					UIManager.getInstance().buyWnd.hide();
					break;
				case 1:
					Cmd_Guild.cm_GuildMemList(1, this.guildMemNum);
					this.guildDonateMessage.hide();
					UIManager.getInstance().buyWnd.hide();
					break;
				case 2:
					Cmd_unb.cmGuildBlessInit();
//					this.updateGuildSci(null);
//					Cmd_Guild.cm_GuildSkill();
					this.guildDonateMessage.hide();
					this.guildAddWnd.hide();
					UIManager.getInstance().buyWnd.hide();
					break;
				case 3:
					Cmd_Ucp.cm_GuildCpInit();
					this.guildDonateMessage.hide();
					this.guildAddWnd.hide();
					UIManager.getInstance().buyWnd.hide();
					break;
				case 4:
					Cmd_Unw.cm_GuildPkInit();
					this.guildAddWnd.hide();
					break;
				case 5:
					this.guildShop.updateData();
					this.guildAddWnd.hide();
					break;
				case 6:
					this.guildDonateMessage.hide();
					this.guildAddWnd.hide();
					UIManager.getInstance().buyWnd.hide();
					Cmd_Guild.cm_GuildZCInit();
					break;
				case 7:
					Cmd_Guild.cm_GuildList(1, 12);
					this.guildDonateMessage.hide();
					this.guildAddWnd.hide();
					UIManager.getInstance().buyWnd.hide();
					break;
				case 8:
					this.guildDonateMessage.hide();
					this.guildAddWnd.hide();
					UIManager.getInstance().buyWnd.hide();
					break;

			}

//			this.guildSkill.clearData();
			this.guildMember.clearData();
			this.guildList.clearData();
		}

		public function getTabIndex():int {
			return this.guildTabbar.turnOnIndex;
		}

		public function getTabName():String {
			return this.changeTabName;
		}

		/**
		 *重刷会员列表
		 */
		public function requestMemList(o:Object):void {
			this.guildMember.deleteMember(o);
			this.guildMember.updateMemList();
		}

		/**
		 * @param o
		 */
		public function updateMain(o:Object):void {

//			this.guildTabbar.setTabVisible(0, true);
//			this.guildTabbar.setTabVisible(1, true);

//			this.guildTabbar.setTabVisible(3, false);
//			this.guildTabbar.setTabVisible(4, false);
//			this.guildTabbar.setTabVisible(5, true);
//			this.guildTabbar.setTabVisible(6, false);
//			this.guildTabbar.setTabVisible(7, true);
//			this.guildTabbar.setTabVisible(8, false);

			this.memBtn.setActive(true, 1, true);
			this.shopBtn.setActive(true, 1, true);
			this.mainBtn.setActive(true, 1, true);

//			this.mainBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			//callback
//			if (!this.visible)
//				super.show();

			if (this.firstOpen || this.guildId == "") {
//				this.guildTabbar.turnToTab(this.changeTabIndex);
				this.memBtn.turnOff();
				this.kjBtn.turnOff();
				this.shopBtn.turnOff();
				this.listBtn.turnOff();

//				this.mainBtn.turnOn();
				this.mainBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				this.firstOpen=false;
			}


			if (o.hasOwnProperty("unionid"))
				this.guildId=o.unionid;

			if (o.hasOwnProperty("online"))
				this.currentonlineLbl.text="" + o.online;

			if (o.hasOwnProperty("level"))
				this.guildLv=o.level;

			if (o.hasOwnProperty("people") || o.hasOwnProperty("zpeople")) {
				this.guildMemNum=o.people;
				this.memNumLbl.text="" + o.people + "/" + o.zpeople;
			}

			if (o.hasOwnProperty("bg")) {
				this.contributeLbl.text="" + o.bg;
				this.guildContribute=o.bg;
			}

			if (o.hasOwnProperty("warc")) {
				this.guildWarc=o.warc;
			} else
				this.guildWarc=0;

			if (o.hasOwnProperty("uset")) {
				this.ischeckUset=o.uset;
				this.guildMember.setAutoAccCb(o.uset);
			}

			this.guildList.getAutoAccCb().visible=false;
			this.guildList.setBtnVisible(false);

			if (o.hasOwnProperty("dmoney")) {
				this.guildDonateMoney=o.dmoney;
				this.guildDonateMessage.updateLastMoney();
			}

//			if (this.guildTabbar.turnOnIndex == 0 && o.mk == "I")
//				Cmd_Guild.cm_GuildNotice(o.unionid, 1);

			this.guildMain.updateInfo(o);

			this.memNumTxt.text=PropUtils.getStringById(1760);
			this.currOnLineTxt.text=PropUtils.getStringById(1761);
			this.contributeTxt.text=PropUtils.getStringById(1762);
			this.bgIcon.visible=true;

			if (this.guildLv >= ConfigEnum.Union_Bless1)
				this.kjBtn.setActive(true, 1, true);

			MyInfoManager.getInstance().isGuild=true;

			if (!this.visible)
				TweenLite.delayedCall(.5, UIManager.getInstance().showPanelCallback, [WindowEnum.GUILD]);
		}

		/**
		 * 活动
		 * @param info
		 *
		 */
		public function updateMainActive(info:Object):void {
			this.guildMain.updateActive(info);
		}

		/**
		 * 更新skill
		 * @param o
		 *
		 */
		public function updateSkill(o:Object):void {
			this.guildSkill.updateInfo(o);
		}

		/**
		 * 自己的信息
		 * @param o
		 *
		 */
		public function updateMemInfo(o:Object):void {

			if (o.info[0] == MyInfoManager.getInstance().name) {
//				this.contributeLbl.text="" + o.info[9];
//				this.guildContribute=o.info[9];
				this.memberJob=o.info[5];

				Cmd_Guild.cm_GuildAuth(this.memberJob);
			} else
				this.updateMemberList(o);
		}

		/**
		 * 获取个人权限
		 * @param o
		 *
		 */
		public function updateSelfPrice(o:Object):void {

			this.memberPrice=o;

			if (this.memberJob == GuildEnum.ADMINI_1) {
//				this.autoAccCb.text="自动同意入会申请";
			} else {
//				this.autoAccCb.text=PropUtils.getStringById(1764);

				this.guildList.getAutoAccCb().visible=false;
//				this.guildList.getAutoAccCb().setActive((o[4] == 1 ? true : false));

				if (this.ischeckUset == 1)
					this.guildList.getAutoAccCb().turnOn();
				else
					this.guildList.getAutoAccCb().turnOff();
			}

//			if (this.memberPrice[GuildEnum.ADMINI_PRICE_MANAGER] == 1) {
//
//			} else {
//
//			}

			this.guildMain.updatePriceState();
			this.guildMember.updatePrice();
		}

		/**
		 *更新会员数据
		 * @param o
		 *
		 */
		public function updateMemberList(o:Object):void {
			this.guildMember.updateInfo(o);
		}

		public function updateGuildList(o:Array):void {
			UIManager.getInstance().showPanelCallback(WindowEnum.GUILD);
			this.guildList.updateData(o);
		}

		/**
		 * @param txt
		 */
		public function updateGuildListNotice(txt:String):void {
			this.guildList.descTxt(txt.substr(0, 250));
		}

		/**
		 *
		 * @param o
		 *
		 */
		public function updateGuildSci(o:Object):void {

//			var od:Object={num: 1, blist: [[1, 1, 1, 86400],, [6, 2, 1, 86400],[], [11, 3, 1, 86400]]}

			this.guildSciData=o.blist;
			this.guildSci.updateInfo(o);
		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);

			GuideManager.getInstance().removeGuide(41);

			GuideManager.getInstance().removeGuide(100);
			GuideManager.getInstance().removeGuide(101);
			GuideManager.getInstance().removeGuide(102);
			GuideManager.getInstance().removeGuide(103);

//			this.guildTabbar.setTabVisible(3, false);
//			this.guildTabbar.setTabVisible(4, false);
//			this.guildTabbar.setTabVisible(6, false);

		}

//		override public function set visible(value:Boolean):void {
//			super.visible=value;

//			if (!value && this.guildTabbar == null)
//				return;

//			if (this.firstOpen) {
//				this.resetWnd();
//
//				Cmd_Guild.cm_GuildMemInfo(MyInfoManager.getInstance().name);
//				Cmd_Guild.cm_GuildInfo();
//
//			}

//		}

		override public function sendOpenPanelProtocol(... parameters):void {
			this.dataModel=parameters;
			this.resetWnd();

			this.changeTabIndex=0;

			Cmd_Guild.cm_GuildMemInfo(MyInfoManager.getInstance().name);
			Cmd_Guild.cm_GuildInfo();
		}

		public function resetWnd():void {

			if (this.guildName == null || this.guildName == "") {

//				this.guildTabbar.setTabVisible(0, false);
//				this.guildTabbar.setTabVisible(1, false);
//				this.guildTabbar.setTabVisible(2, false);
//				this.guildTabbar.setTabVisible(3, false);
//				this.guildTabbar.setTabVisible(4, false);
//				this.guildTabbar.setTabVisible(5, false);
//				this.guildTabbar.setTabVisible(6, false);
//				this.guildTabbar.setTabVisible(7, true);
//				this.guildTabbar.setTabVisible(8, true);

				this.memBtn.turnOff();
				this.kjBtn.turnOff();
				this.shopBtn.turnOff();
				this.mainBtn.turnOff();

				this.memBtn.setActive(false, 0.6, true);
				this.kjBtn.setActive(false, 0.6, true);
				this.shopBtn.setActive(false, 0.6, true);
				this.mainBtn.setActive(false, 0.6, true);

//				this.listBtn.turnOn();
				this.listBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
//				this.guildCreat.visible=false;

				this.firstOpen=false;
				Cmd_Guild.cm_GuildList(1, 12);
//				this.guildTabbar.turnToTab(7);
			}

//			this.guildTabbar.setTabVisible(3, false);
//			this.guildTabbar.setTabVisible(4, false);
//			this.guildTabbar.setTabVisible(6, false);

//			this.autoAccCb.visible=false;

			this.currentonlineLbl.text="";
			this.memNumLbl.text="";

			this.guildMain.turrOn();

			this.memNumTxt.text="";
			this.currOnLineTxt.text="";
			this.contributeTxt.text="";
			this.bgIcon.visible=false;
		}

		public function showCreate():void {
			this.guildCreat.show();
		}

		public function clearData():void {
			this.currentonlineLbl.text="";
			this.memNumLbl.text="";
			this.contributeLbl.text="";

			this.memNumTxt.text="";
			this.currOnLineTxt.text="";
			this.contributeTxt.text="";

			this.guildList.getAutoAccCb().visible=true;
			this.guildList.setBtnVisible(true);
		}

		public function resize():void {
			this.x=UIEnum.WIDTH - this.width >> 1;
			this.y=UIEnum.HEIGHT - this.height >> 1;
		}

		override public function get width():Number {
			return 932;
		}

		override public function get height():Number {
			return 544;
		}

		override public function hide():void {
			super.hide();

			this.firstOpen=true;
			this.guildInviteWnd.hide();
			this.guildMemMessage.hide();
			this.guildPowManager.hide();
			this.guildDonateMessage.hide();
			this.guildAddWnd.hide();
			this.guildCreat.hide();
			this.guildMember.clearData();

//			this.guildSkill.clearData();

			this.changeTabIndex=0;

			PopupManager.closeConfirm("guildwarpk");

			PopupManager.closeConfirm("guildSciDel");
			PopupManager.closeConfirm("guildSciGet");
			PopupManager.closeConfirm("guildSciUpgrade");
			PopupManager.closeConfirm("guildSciBuild");

			TweenManager.getInstance().lightingCompnent(UIManager.getInstance().toolsWnd.guildBtn);
		}


	}
}

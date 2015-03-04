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
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.greensock.TweenLite;
	import com.leyou.enum.GuildEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Guild;
	import com.leyou.net.cmd.Cmd_Ucp;
	import com.leyou.net.cmd.Cmd_Unw;
	import com.leyou.ui.guild.child.GuildAddWnd;
	import com.leyou.ui.guild.child.GuildCreat;
	import com.leyou.ui.guild.child.GuildDungeon;
	import com.leyou.ui.guild.child.GuildList;
	import com.leyou.ui.guild.child.GuildMain;
	import com.leyou.ui.guild.child.GuildMemMessager;
	import com.leyou.ui.guild.child.GuildMember;
	import com.leyou.ui.guild.child.GuildPowManager;
	import com.leyou.ui.guild.child.GuildShop;
	import com.leyou.ui.guild.child.GuildSkill;
	import com.leyou.ui.guild.child.GuildWar;
	import com.leyou.ui.guild.child.GuildZC;

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

		private var guildMain:GuildMain;
		private var guildMember:GuildMember;
		private var guildShop:GuildShop;

		private var guildCreat:GuildCreat;
		private var guildList:GuildList;
		private var guildSkill:GuildSkill;
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
		 *sr -- 收人 (0,1)
tr -- 踢人 (0,1)
sj -- 升级 (0,1)
xz -- 宣战 (0,1)
gl -- 管理 (0,1)
*/
		public var memberPrice:Object={};

		private var ischeckUset:int=0;

		private var changeTabIndex:int=0;

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

			this.autoAccCb=this.getUIbyID("autoAccCb") as CheckBox;
			this.guildTabbar=this.getUIbyID("guildTabbar") as TabBar;

			this.autoAccCb.addEventListener(MouseEvent.CLICK, onClick);
			this.guildTabbar.addEventListener(TabbarModel.changeTurnOnIndex, onChangeIndex);

			this.autoAccCb.setActive(false);

			this.guildMain=new GuildMain();
			this.guildMember=new GuildMember();
			this.guildShop=new GuildShop();
			this.guildCreat=new GuildCreat();
			this.guildList=new GuildList();
			this.guildSkill=new GuildSkill();
			this.guildCopy=new GuildDungeon();
			this.guildPk=new GuildWar();
			this.guildZc=new GuildZC();

			this.guildTabbar.addToTab(this.guildMain, 0);
			this.guildTabbar.addToTab(this.guildMember, 1);
			this.guildTabbar.addToTab(this.guildSkill, 2);
			this.guildTabbar.addToTab(this.guildCopy, 3);
			this.guildTabbar.addToTab(this.guildPk, 4);
			this.guildTabbar.addToTab(this.guildShop, 5);
			this.guildTabbar.addToTab(this.guildZc, 6);
			this.guildTabbar.addToTab(this.guildList, 7);
			this.guildTabbar.addToTab(this.guildCreat, 8);

			this.guildMemMessage=new GuildMemMessager();
			this.guildPowManager=new GuildPowManager();
			this.guildInviteWnd=new GuildInviteWnd();
			this.guildDonateMessage=new GuildDonateMessage();
			this.guildAddWnd=new GuildAddWnd();

//			this.guildTabbar.turnToTab(0);

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
				this.guildTabbar.turnToTab(i);
			}
		}

		/**
		 *自动入会
		 * @param e
		 *
		 */
		private function onClick(e:MouseEvent):void {
			if (this.memberJob == GuildEnum.ADMINI_1)
				Cmd_Guild.cm_GuildApplySet(this.autoAccCb.isOn ? 1 : 0);
			else
				Cmd_Guild.cm_GuildInviteSet(this.autoAccCb.isOn ? 1 : 0);
		}

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
					Cmd_Guild.cm_GuildSkill();
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

			this.guildSkill.clearData();
			this.guildMember.clearData();
			this.guildList.clearData();
		}

		public function getTabIndex():int {
			return this.guildTabbar.turnOnIndex;
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

			this.guildTabbar.setTabVisible(0, true);
			this.guildTabbar.setTabVisible(1, true);
			this.guildTabbar.setTabVisible(2, true);
//			this.guildTabbar.setTabVisible(3, true);
//			this.guildTabbar.setTabVisible(4, true);
			this.guildTabbar.setTabVisible(5, true);
			this.guildTabbar.setTabVisible(6, true);
			this.guildTabbar.setTabVisible(7, true);
			this.guildTabbar.setTabVisible(8, false);

			//callback
//			if (!this.visible)
//				super.show();

			if (this.firstOpen || this.guildId == "") {
				this.guildTabbar.turnToTab(this.changeTabIndex);

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

			if (o.hasOwnProperty("uset")) {
				this.ischeckUset=o.uset;
				if (o.uset == 1)
					this.autoAccCb.turnOn();
				else
					this.autoAccCb.turnOff();

				this.autoAccCb.visible=true;
			}

			if (this.guildTabbar.turnOnIndex == 0 && o.mk == "I")
				Cmd_Guild.cm_GuildNotice(o.unionid, 1);

			this.guildMain.updateInfo(o);

			this.memNumTxt.text="成员数：";
			this.currOnLineTxt.text="当前在线：";
			this.contributeTxt.text="行会贡献：";
			this.bgIcon.visible=true;

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
			} else
				this.autoAccCb.text="自动同意入会邀请";

			this.autoAccCb.setActive((o[4] == 1 ? true : false));

			if (this.ischeckUset == 1)
				this.autoAccCb.turnOn();
			else
				this.autoAccCb.turnOff();

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

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);

			GuideManager.getInstance().removeGuide(41);

			GuideManager.getInstance().removeGuide(100);
			GuideManager.getInstance().removeGuide(101);
			GuideManager.getInstance().removeGuide(102);
			GuideManager.getInstance().removeGuide(103);

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

				this.guildTabbar.setTabVisible(0, false);
				this.guildTabbar.setTabVisible(1, false);
				this.guildTabbar.setTabVisible(2, false);
				this.guildTabbar.setTabVisible(3, false);
				this.guildTabbar.setTabVisible(4, false);
				this.guildTabbar.setTabVisible(5, false);
				this.guildTabbar.setTabVisible(6, false);
				this.guildTabbar.setTabVisible(7, true);
				this.guildTabbar.setTabVisible(8, true);

//				this.firstOpen=false;
				this.guildTabbar.turnToTab(7);
			}

			this.autoAccCb.visible=false;

			this.currentonlineLbl.text="";
			this.memNumLbl.text="";

			this.guildMain.turrOn();

			this.memNumTxt.text="";
			this.currOnLineTxt.text="";
			this.contributeTxt.text="";
			this.bgIcon.visible=false;
		}


		public function clearData():void {
			this.currentonlineLbl.text="";
			this.memNumLbl.text="";
			this.contributeLbl.text="";

			this.memNumTxt.text="";
			this.currOnLineTxt.text="";
			this.contributeTxt.text="";
		}

		public function resize():void {
			this.x=UIEnum.WIDTH - this.width >> 1;
			this.y=UIEnum.HEIGHT - this.height >> 1;
		}

		override public function get width():Number {
			return 644;
		}

		override public function get height():Number {
			return 522;
		}

		override public function hide():void {
			super.hide();

			this.firstOpen=true;
			this.guildInviteWnd.hide();
			this.guildMemMessage.hide();
			this.guildPowManager.hide();
			this.guildDonateMessage.hide();
			this.guildAddWnd.hide();
			this.guildMember.clearData();

			this.guildSkill.clearData();

			this.changeTabIndex=0;

			PopupManager.closeConfirm("guildwarpk");
			TweenManager.getInstance().lightingCompnent(UIManager.getInstance().toolsWnd.guildBtn);
		}


	}
}

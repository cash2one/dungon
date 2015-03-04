package com.leyou.ui.guild.child {

	import com.ace.ICommon.IMenu;
	import com.ace.ICommon.ITip;
	import com.ace.enum.CursorEnum;
	import com.ace.enum.FontEnum;
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.CursorManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.MenuManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.menu.data.MenuInfo;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.GuildEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Guild;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.system.System;

	public class GuildMain extends AutoSprite implements IMenu {

		private var mainTabber:TabBar;

		private var progressSc:ScaleBitmap;
		private var progressLbl:Label;

		private var nameLbl:Label;
		private var lvLbl:Label;
		private var numLbl:Label;
		private var bossLbl:Label;
		private var topLbl:Label;
		private var saveCostLbl:Label;
		private var upgradeCostLbl:Label;

		private var saveCostTxt:Label;
		private var upgradeCostTxt:Label;

		private var pkBossLbl:Label;
		private var pkDelBtn:ImgButton;

		private var contributeBtn:NormalButton;
		private var upgradeBtn:NormalButton;

		private var mainActive:MainActive;
		private var mainManifesto:MainManifesto;
		private var mainNotice:MainNotic;

		public function GuildMain() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildMain.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.progressLbl=this.getUIbyID("progressLbl") as Label;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.numLbl=this.getUIbyID("numLbl") as Label;
			this.bossLbl=this.getUIbyID("bossLbl") as Label;
			this.topLbl=this.getUIbyID("topLbl") as Label;
			this.saveCostLbl=this.getUIbyID("saveCostLbl") as Label;
			this.saveCostTxt=this.getUIbyID("saveCostTxt") as Label;
			this.upgradeCostLbl=this.getUIbyID("upgradeCostLbl") as Label;
			this.upgradeCostTxt=this.getUIbyID("upgradeCostTxt") as Label;
			this.pkBossLbl=this.getUIbyID("pkBossLbl") as Label;
			this.mainTabber=this.getUIbyID("mainTabber") as TabBar;

			this.progressSc=this.getUIbyID("progressSc") as ScaleBitmap;

			this.contributeBtn=this.getUIbyID("contributeBtn") as NormalButton;
			this.upgradeBtn=this.getUIbyID("upgradeBtn") as NormalButton;

			this.contributeBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.upgradeBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.nameLbl.addEventListener(MouseEvent.CLICK, onClick);
			this.bossLbl.addEventListener(MouseEvent.CLICK, onClick);
			
			this.nameLbl.styleSheet=FontEnum.DEFAULT_LINK_STYLE;
			this.bossLbl.styleSheet=FontEnum.DEFAULT_LINK_STYLE;
			
			this.nameLbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.bossLbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);

			this.nameLbl.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.bossLbl.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			this.nameLbl.mouseEnabled=true;
			this.bossLbl.mouseEnabled=true;

			this.mainActive=new MainActive();
			this.mainManifesto=new MainManifesto();
			this.mainNotice=new MainNotic();

			this.mainTabber.addToTab(this.mainNotice, 0);
			this.mainTabber.addToTab(this.mainActive, 1);
			this.mainTabber.addToTab(this.mainManifesto, 2);

			this.mainTabber.addEventListener(TabbarModel.changeTurnOnIndex, onChangeIndex);

			this.saveCostTxt.setToolTip(TableManager.getInstance().getSystemNotice(3048).content);
			this.upgradeCostTxt.setToolTip(TableManager.getInstance().getSystemNotice(3049).content);

			var spr:Sprite=new Sprite();
			spr.graphics.beginFill(0x000000);
			spr.graphics.drawRect(0, 0, this.progressSc.width, this.progressSc.height);
			spr.graphics.endFill();

			this.addChild(spr);

			spr.x=this.progressSc.x;
			spr.y=this.progressSc.y;

			spr.alpha=0;

			spr.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			spr.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			this.y+=5;
			this.x=-14;
		}

		private function onMouseOut(e:MouseEvent):void {
			CursorManager.getInstance().resetGameCursor();
			ToolTipManager.getInstance().hide();
		}

		private function onMouseOver(e:MouseEvent):void {
			CursorManager.getInstance().updataCursor(CursorEnum.CURSOR_HAND);
		}

		private function onMouseMove(e:MouseEvent):void {
			var r:Array=this.progressLbl.text.split("/");
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(3047).content, [r[0], r[1], int(int(r[0]) / int(r[1]) * 100) + "%"]), new Point(e.stageX, e.stageY));
		}

		private function onChangeIndex(e:Event):void {

			switch (this.mainTabber.turnOnIndex) {
				case 0:
					Cmd_Guild.cm_GuildNotice(UIManager.getInstance().guildWnd.guildId, 1);
					break
				case 1:
					Cmd_Guild.cm_GuildActive(100);
					break
				case 2:
					Cmd_Guild.cm_GuildNotice(UIManager.getInstance().guildWnd.guildId, 2);
					break
			}
		}

		public function turrOn():void {
			this.mainTabber.turnToTab(0);
		}

		private function onClick(e:MouseEvent):void {

			var menuVec:Vector.<MenuInfo>;
			var p:Point;
			switch (e.target.name) {
				case "contributeBtn":
					UIManager.getInstance().guildWnd.guildDonateMessage.show();
					break;
				case "upgradeBtn":
					Cmd_Guild.cm_GuildUpgrade();
					break;
				case "nameLbl":
					menuVec=new Vector.<MenuInfo>();
					menuVec.push(new MenuInfo("复制名字", 1));

					p=new Point(e.stageX - 30, e.stageY);
					MenuManager.getInstance().show(menuVec, this, p);
					break;
				case "bossLbl":
					menuVec=new Vector.<MenuInfo>();
					menuVec.push(new MenuInfo("复制名字", 2));

					p=new Point(e.stageX - 30, e.stageY);
					MenuManager.getInstance().show(menuVec, this, p);
					break;
			}

			e.stopImmediatePropagation();
		}

		public function onMenuClick(i:int):void {

			switch (i) {
				case 1:
					System.setClipboard(this.nameLbl.text);
					break;
				case 2:
					System.setClipboard(this.bossLbl.text);
					break;
			}
		}

		public function clearAllData():void {


		}


		public function updatePriceState():void {

			if (UIManager.getInstance().guildWnd.memberPrice[GuildEnum.ADMINI_PRICE_MANAGER] == 1) {
				this.mainNotice.setEidtBtnState(true);
				this.mainManifesto.setEidtBtnState(true);
			} else {
				this.mainNotice.setEidtBtnState(false);
				this.mainManifesto.setEidtBtnState(false);
			}

			if (UIManager.getInstance().guildWnd.memberPrice[GuildEnum.ADMINI_PRICE_UPGRADE] == 1) {
				this.upgradeBtn.setActive(true, 1, true);
			} else {
				this.upgradeBtn.setActive(false, 0.6, true);
			}

		}


		/**
		 * 活动
		 * @param info
		 *
		 */
		public function updateActive(info:Object):void {
			this.mainActive.updateData(info.log as Array);
		}

		/**
		 *更新基础数据
		 * @param o
		 *
		 */
		private function updateData(o:Object):void {

			if (o.hasOwnProperty("uname")) {
				this.nameLbl.htmlText="<u><a href='event:--'>" + o.uname + "</a></u>";
				UIManager.getInstance().guildWnd.guildName=o.uname + "";
			}

			if (o.hasOwnProperty("level"))
				this.lvLbl.text="" + o.level;

			if (o.hasOwnProperty("people"))
				this.numLbl.text="" + o.people;

			if (o.hasOwnProperty("lname"))
				this.bossLbl.htmlText="<u><a href='event:--'>" + o.lname + "</a></u>";

			if (o.hasOwnProperty("rank"))
				this.topLbl.text="" + o.rank;

			if (o.hasOwnProperty("duname"))
				this.pkBossLbl.text="" + o.duname;

			if (o.hasOwnProperty("vnum") && o.hasOwnProperty("xnum")) {
				this.progressLbl.text="" + o.vnum + "/" + o.xnum;
				this.progressSc.scaleX=(int(o.vnum) / int(o.xnum) > 1 ? 1 : int(o.vnum) / int(o.xnum));
			}

			if (o.hasOwnProperty("mnum"))
				this.saveCostLbl.text="" + o.mnum;

			UIManager.getInstance().guildWnd.guildLiveness=this.upgradeBtn.visible=(int(o.vnum) >= int(o.mnum));

			if (UIManager.getInstance().guildWnd.memberPrice[GuildEnum.ADMINI_PRICE_UPGRADE] == 1) {
				this.upgradeBtn.visible=true;
			} else {
				this.upgradeBtn.visible=false;
			}

			if (o.hasOwnProperty("lnum")) {
				if (o.lnum == -1) {
					this.upgradeCostLbl.text="无";
				} else
					this.upgradeCostLbl.text="" + o.lnum;
			}
		}

		/**
		 * 数据分发
		 * @param o
		 *
		 */
		public function updateInfo(o:Object):void {

			if (o.mk == "I") {
				this.updateData(o);
			} else if (o.mk == "N") {

				if (o.ntype == 1) {
					this.mainNotice.updateInfo(o);
				} else if (o.ntype == 2) {
					this.mainManifesto.updateInfo(o);
				}

			}

		}


	}
}

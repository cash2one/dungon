package com.leyou.ui.guild.child {


	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TUnion_Bless;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.TipsEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.manager.TimerManager;
	import com.leyou.net.cmd.Cmd_unb;
	import com.leyou.ui.tips.GuildSciTips;
	import com.leyou.utils.FilterUtil;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.TimeUtil;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class GuildSciRender extends AutoSprite {

		private var nameLbl:Label;
		private var addUpgradeBtn:ImgButton;
		private var upgradeLbl:Label;
		private var deleteBtn:ImgButton;
		private var getBtn:ImgButton;
		private var upgradeBtn:ImgButton;
		private var bgImg:Image;

		private var upgradeSc1:ScaleBitmap;
		private var upgradeSc2:ScaleBitmap;

		private var localIndex:int=0;
		private var blessid:int=0;

		private var localTime:int=0;
		private var lastTime:int=0;

		private var freeCount:int=0;

		private var guildSciBuyWnd:GuildSciMessage;
		private var tinfo:TUnion_Bless;

		private var strString:String;

		private var buildEffect:SwfLoader;

		public function GuildSciRender() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildSciRender.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.addUpgradeBtn=this.getUIbyID("addUpgradeBtn") as ImgButton;
			this.upgradeLbl=this.getUIbyID("upgradeLbl") as Label;
			this.deleteBtn=this.getUIbyID("deleteBtn") as ImgButton;
			this.getBtn=this.getUIbyID("getBtn") as ImgButton;
			this.upgradeBtn=this.getUIbyID("upgradeBtn") as ImgButton;
			this.bgImg=this.getUIbyID("bgImg") as Image;

			this.upgradeSc1=this.getUIbyID("upgradeSc1") as ScaleBitmap;
			this.upgradeSc2=this.getUIbyID("upgradeSc2") as ScaleBitmap;

			this.addUpgradeBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.deleteBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.getBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.upgradeBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			this.guildSciBuyWnd=new GuildSciMessage();
			LayerManager.getInstance().windowLayer.addChild(this.guildSciBuyWnd);
			this.guildSciBuyWnd.hide();

			this.deleteBtn.visible=false;
			this.getBtn.visible=false;
			this.upgradeBtn.visible=false;

			this.buildEffect=new SwfLoader(27069);
			this.addChildAt(this.buildEffect, 1);

			this.buildEffect.visible=false;

			this.deleteBtn.setToolTip(TableManager.getInstance().getSystemNotice(10045).content);
			this.getBtn.setToolTip(TableManager.getInstance().getSystemNotice(10044).content);
			this.upgradeBtn.setToolTip(TableManager.getInstance().getSystemNotice(10043).content);

		}

		private function onMouseOver(e:MouseEvent):void {

			if (this.lastTime == 0) {
				this.getBtn.visible=true;
				this.upgradeBtn.visible=true;
				this.deleteBtn.visible=true;
			}

			this.bgImg.filters=[FilterUtil.showBorder(0xffff00)];

			if (!(e.target is ImgButton))
				ToolTipManager.getInstance().show(TipEnum.TYPE_GUILD_BLESS, this.blessid, new Point(e.stageX, e.stageY));
		}

		private function onMouseOut(e:MouseEvent):void {
			this.deleteBtn.visible=false;
			this.getBtn.visible=false;
			this.upgradeBtn.visible=false;

			this.bgImg.filters=[];
			ToolTipManager.getInstance().hide();
		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "addUpgradeBtn":
					this.guildSciBuyWnd.showPanel(this.localIndex, this.lastTime);
					break;
				case "deleteBtn":
					PopupManager.showConfirm(StringUtil.substitute(TableManager.getInstance().getSystemNotice(23213).content, [tinfo.build_Name]), function():void {
						Cmd_unb.cmGuildBlessDeleteBuild(localIndex);
					}, null, false, "guildSciDel");
					break;
				case "getBtn":

					var Buff_Spend:int=tinfo.Buff_Spend;
					if (this.freeCount > 0) {
						Buff_Spend=0;
					}

					PopupManager.showConfirm(StringUtil.substitute(TableManager.getInstance().getSystemNotice(23216).content, [Buff_Spend, TableManager.getInstance().getBuffInfo(tinfo.build_Buff).name]), function():void {
						Cmd_unb.cmGuildBlessBuyBuff(localIndex);
					}, null, false, "guildSciGet");
					break;
				case "upgradeBtn":

					var bid:int=0;
					if (tinfo.build_Lv < 5) {
						bid=tinfo.ID + 1;
					}

					var info:TUnion_Bless=TableManager.getInstance().getGuildblessByID(bid);

					PopupManager.showConfirm(StringUtil.substitute(TableManager.getInstance().getSystemNotice(23212).content, [info.build_Name, info.Upgrade_at]), function():void {
						Cmd_unb.cmGuildBlessUpgrade(localIndex);
					}, null, false, "guildSciUpgrade");
					break;
			}

		}


		public function updateInfo(o:Object, i:int, c:int):void {

			this.localIndex=i + 1;
			this.freeCount=c;

			if (o[0] == 0) {
				tinfo=TableManager.getInstance().getGuildblessByType(o[1]);
				strString=PropUtils.getStringById(2191)
			} else {
				tinfo=TableManager.getInstance().getGuildblessByID(o[0]);
				strString=PropUtils.getStringById(2189)
			}

			if (o[3] > 0) {
				if (tinfo.build_Lv < 5) {
					if (o[0] == 0)
						this.blessid=tinfo.ID;
					else
						this.blessid=tinfo.ID + 1;
				}

			} else {
				this.blessid=o[0];
			}

			if (tinfo == null)
				return;

			this.bgImg.updateBmp("ui/guild/" + tinfo.build_Pic);
			this.nameLbl.text="" + tinfo.build_Name;
			this.localTime=int(o[3]);

			if (this.localTime > 0) {
				this.upgradeLbl.visible=true;
				this.upgradeSc1.visible=true;
				this.upgradeSc2.visible=true;
				this.addUpgradeBtn.visible=true;

				this.buildEffect.visible=true;
			} else {
				this.upgradeLbl.visible=false;
				this.upgradeSc1.visible=false;
				this.upgradeSc2.visible=false;
				this.addUpgradeBtn.visible=false;

				this.buildEffect.visible=false;
			}

			if ((tinfo.build_Lv < 5))
				this.upgradeBtn.setActive(true, 1, true);
			else
				this.upgradeBtn.setActive(false, 0.6, true);

			this.upgradeLbl.text=StringUtil.substitute(strString, [TimeUtil.getIntToTime(this.localTime)]);
			this.lastTime=this.localTime;

			TimerManager.getInstance().remove(exeTime);

			if (this.localTime > 0)
				TimerManager.getInstance().add(exeTime);
		}

		private function exeTime(i:int):void {
			if (this.localTime - i > 0) {
				this.lastTime=this.localTime - i;
				this.upgradeLbl.text=StringUtil.substitute(strString, [TimeUtil.getIntToTime(this.localTime - i)]);
			} else {
				TimerManager.getInstance().remove(exeTime);
				this.lastTime=0;
				this.upgradeLbl.visible=false;
				this.upgradeSc1.visible=false;
				this.upgradeSc2.visible=false;
				this.addUpgradeBtn.visible=false;

				Cmd_unb.cmGuildBlessInit();
			}

		}

	}
}

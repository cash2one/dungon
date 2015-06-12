package com.leyou.ui.skill.childs {

	import com.ace.config.Core;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TUnion_attribute;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.notice.NoticeManager;
	import com.leyou.net.cmd.Cmd_Guild;
	import com.leyou.ui.guild.child.GuildSkill;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class PassiveSkill extends AutoSprite {

		private var iconImg:Image;
		private var upgradeBtn:ImgButton;
		private var moneyLbl:Label;
		private var bgLbl:Label;
		private var effSwf:SwfLoader;
		private var succeffSwf:SwfLoader;
		private var nameLbl:Label;
		private var lvLbl:Label;

		private var moneyIco:Image;
		private var bgIco:Image;

		private var itemRender:Vector.<PassiveSkillRender>;
		private var infoData:Array=[];

		private var currentAtt:int=-1;
		private var upgrade:Boolean=false;

		public function PassiveSkill() {
			super(LibManager.getInstance().getXML("config/ui/skill/passiveSkill.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.iconImg=this.getUIbyID("iconImg") as Image;
			this.upgradeBtn=this.getUIbyID("upgradeBtn") as ImgButton;
			this.moneyLbl=this.getUIbyID("moneyLbl") as Label;
			this.bgLbl=this.getUIbyID("bgLbl") as Label;

			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;

			this.moneyIco=this.getUIbyID("moneyIco") as Image;
			this.bgIco=this.getUIbyID("bgIco") as Image;

			this.effSwf=this.getUIbyID("effSwf") as SwfLoader;

			this.effSwf.update(99913);
			this.effSwf.visible=false;

			this.succeffSwf=this.getUIbyID("succeffSwf") as SwfLoader;

			this.succeffSwf.update(99906);
			this.succeffSwf.visible=false;

			this.upgradeBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.itemRender=new Vector.<PassiveSkillRender>();

			var einfo:MouseEventInfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.iconImg, einfo);

			this.x=-21;
			this.y=2;

			einfo=new MouseEventInfo();
			einfo.onMouseMove=onTips1MouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.moneyIco, einfo);

			einfo=new MouseEventInfo();
			einfo.onMouseMove=onTips1MouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.bgIco, einfo);
		}

		private function onTips1MouseOver(e:DisplayObject):void {
			if (e == this.bgIco)
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9557).content, new Point(this.stage.mouseX, this.stage.mouseY));
			else if (e == this.moneyIco)
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9555).content, new Point(this.stage.mouseX, this.stage.mouseY));

		}

		private function onTipsMouseOver(e:DisplayObject):void {
			if (this.currentAtt != -1)
				ToolTipManager.getInstance().show(TipEnum.TYPE_GUILD_SKILL, this.itemRender[this.currentAtt].infoData, new Point(this.stage.mouseX, this.stage.mouseY));
		}

		private function onTipsMouseOut(e:DisplayObject):void {
			ToolTipManager.getInstance().hide();
		}

		private function onClick(e:MouseEvent):void {
			if (this.currentAtt == -1 || this.itemRender[this.currentAtt] == null)
				return;

			var info:TUnion_attribute=TableManager.getInstance().getguildAttributeNextInfo(this.itemRender[this.currentAtt].att, this.itemRender[this.currentAtt].lv);
			if (info == null || Core.me.info.level < info.uLv) {
				NoticeManager.getInstance().broadcastById(3056);
				return;
			}

			Cmd_Guild.cm_GuildSkill(this.itemRender[this.currentAtt].att);
		}

		private function onItemClick(e:MouseEvent):void {

			var render:PassiveSkillRender;
			for each (render in this.itemRender) {
				render.state=false;
			}

			render=e.currentTarget as PassiveSkillRender;
			var index:int=this.itemRender.indexOf(render);

			var info:TUnion_attribute;

			if (index == this.currentAtt) {

				this.currentAtt=-1;
				this.moneyLbl.text="";
				this.bgLbl.text="";
				this.nameLbl.text="";
				this.lvLbl.text="";
				this.iconImg.fillEmptyBmd();
				this.effSwf.visible=false;

			} else {

				render.state=true;
				this.effSwf.visible=true;
				this.currentAtt=index;

				info=TableManager.getInstance().getguildAttributeNextInfo(render.att, render.lv);

				if (info == null) {

					this.moneyLbl.text=render.money + "";
					this.bgLbl.text=render.bg + "";
					this.nameLbl.text=render.skillname + "";
					this.lvLbl.text="Lv:" + render.lv + "";
					this.iconImg.updateBmp("ico/skills/" + render.ico + ".png");

				} else {

					this.moneyLbl.text=info.uMoney + "";
					this.bgLbl.text=info.uEnergy + "";
					this.nameLbl.text=info.name + "";
					this.lvLbl.text="Lv:" + info.lv + "";
					this.iconImg.updateBmp("ico/skills/" + info.ico + ".png");

				}

			}
		}

		public function updateInfo(o:Object):void {

			var render:PassiveSkillRender;
			for each (render in this.itemRender) {
				this.removeChild(render);
			}

			if (this.itemRender.length > 0) {

				if (this.succeffSwf.isLoaded) {

					if (this.infoData != null && (this.infoData.indexOf(o.jlist[0]) == -1 || this.infoData.indexOf(o.jlist[1]) == -1 || this.infoData.indexOf(o.jlist[2]) == -1 || this.infoData.indexOf(o.jlist[3]) == -1 || this.infoData.indexOf(o.jlist[4]) == -1)) {

						this.upgrade=false;
						this.succeffSwf.visible=true;

						this.succeffSwf.playAct(PlayerEnum.ACT_STAND, -1, false, function():void {
							succeffSwf.visible=false;
						});
					}
				}

			}

			this.itemRender.length=0;

			if (o.hasOwnProperty("jlist")) {

				this.infoData=o.jlist;
				var info:TUnion_attribute;

				for (var i:int=0; i < o.jlist.length; i++) {
					render=new PassiveSkillRender();

					//					if (o.jlist[i] == 0)
					//						render.updateInfor(this.defaultArr[i]);
					//					else
					render.updateInfo(o.jlist[i]);

					render.y=313;
					render.x=50 + 158 * i;

					render.addEventListener(MouseEvent.CLICK, onItemClick);

					if (this.currentAtt == i) {
						render.state=true;

						info=TableManager.getInstance().getguildAttributeNextInfo(render.att, render.lv);

						if (info != null) {
							this.moneyLbl.text=info.uMoney + "";
							this.bgLbl.text=info.uEnergy + "";
							 
							this.nameLbl.text=info.name + "";
							this.lvLbl.text="Lv:" + info.lv + "";
						}

					}

					this.addChild(render);
					this.itemRender.push(render);
				}

				if (this.currentAtt == -1) {
					this.itemRender[this.itemRender.length - 1].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
			}

		}

		public function clearData():void {

			this.currentAtt=-1;
			this.moneyLbl.text="";
			this.bgLbl.text="";
			this.iconImg.fillEmptyBmd()
			this.effSwf.visible=false;
			this.succeffSwf.visible=false;

			this.nameLbl.text="";
			this.lvLbl.text="";
		}

	}
}

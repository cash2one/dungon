package com.leyou.ui.skill.childs {

	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TSkillInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.GuideArrowDirectManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.leyou.data.playerSkill.TipSkillInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Skill;
	import com.leyou.utils.FilterUtil;
	import com.leyou.utils.PropUtils;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class SkillBar extends AutoSprite {

		private var nameLbl:Label;
		private var lvLbl:Label;

		private var fuwenImg1:Image;
		public var fuwenImg2:Image;
		private var fuwenImg3:Image;
		private var fuwenImg4:Image;

		private var fwLbl1:Label;
		private var fwLbl2:Label;
		private var fwLbl3:Label;
		private var fwLbl4:Label;
		private var desLbl:Label;

		private var bgImg:Image;
		private var upgradeBtn:NormalButton;
		private var succeffSwf:SwfLoader;

		private var moneyIco:Image;
		private var hunIco:Image;
		private var moneyLbl:Label;
		private var hunLbl:Label;

		private var grid:SkillGrid;

		private var state:Boolean=false;

		private var skillid:int=0;
		private var curLv:int=0;

		private var twen:TweenMax;

		private var runeindex:int=0;

		private var money:int=0;
		private var hun:int=0;


		public function SkillBar(iscancel:Boolean=false) {
			super(LibManager.getInstance().getXML("config/ui/skill/skillBar.xml"), iscancel);
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.fuwenImg1=this.getUIbyID("fuwenImg1") as Image;
			this.fuwenImg2=this.getUIbyID("fuwenImg2") as Image;
			this.fuwenImg3=this.getUIbyID("fuwenImg3") as Image;
			this.fuwenImg4=this.getUIbyID("fuwenImg4") as Image;

			this.fwLbl1=this.getUIbyID("fwLbl1") as Label;
			this.fwLbl2=this.getUIbyID("fwLbl2") as Label;
			this.fwLbl3=this.getUIbyID("fwLbl3") as Label;
			this.fwLbl4=this.getUIbyID("fwLbl4") as Label;

			this.desLbl=this.getUIbyID("desLbl") as Label;

			this.moneyIco=this.getUIbyID("moneyIco") as Image;
			this.hunIco=this.getUIbyID("hunIco") as Image;
			this.moneyLbl=this.getUIbyID("moneyLbl") as Label;
			this.hunLbl=this.getUIbyID("hunLbl") as Label;

			this.bgImg=this.getUIbyID("bgImg") as Image;
			this.succeffSwf=this.getUIbyID("succeffSwf") as SwfLoader;
			succeffSwf.visible=false;

			this.upgradeBtn=this.getUIbyID("upgradeBtn") as NormalButton;

			this.grid=new SkillGrid();
			this.addChild(this.grid);

			this.grid.x=3;
			this.grid.y=3;

			this.addChild(this.succeffSwf);
//			this.grid.mouseChildren=false;
//			this.grid.mouseEnabled=false;

			var spr:Sprite;
			for (var i:int=0; i < 4; i++) {
				spr=new Sprite();
				this.addChild(spr);

				spr.graphics.clear();
				spr.graphics.beginFill(0x000000);
				spr.graphics.drawRect(0, 0, 60, 60);
				spr.graphics.endFill();

				if (i == 1)
					spr.x=533;
				else if (i > 1) {
					spr.x=533 + (i - 1) * 70;
				} else {
					spr.x=430;
				}

				spr.y=3;

				spr.name="tips" + i;
				spr.alpha=0;

				spr.addEventListener(MouseEvent.CLICK, onMouseClick);
				spr.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				spr.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			}

			this.upgradeBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.upgradeBtn.mouseChildren=this.upgradeBtn.mouseEnabled=true;

			var einfo:MouseEventInfo;

			einfo=new MouseEventInfo();
			einfo.onMouseMove=onTips1MouseOver;
			einfo.onMouseOut=onTips1MouseOut;

			MouseManagerII.getInstance().addEvents(this.hunIco, einfo);

			einfo=new MouseEventInfo();
			einfo.onMouseMove=onTips1MouseOver;
			einfo.onMouseOut=onTips1MouseOut;

			MouseManagerII.getInstance().addEvents(this.moneyIco, einfo);

		}

		public function onTips1MouseOver(e:DisplayObject):void {

			if (e == this.hunIco) {
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, PropUtils.getStringById(29) + (this.hun == 0 ? "" : ":" + hun), this.parent.localToGlobal(new Point(this.x, this.y)));
			} else
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, PropUtils.getStringById(32) + (this.money == 0 ? "" : ":" + this.money), this.parent.localToGlobal(new Point(this.x, this.y)));

		}

		public function onTips1MouseOut(e:DisplayObject):void {
			ToolTipManager.getInstance().hide();
		}

		public function onMouseClick(e:MouseEvent):void {

//			trace(e, "click")

			var skills:Array=MyInfoManager.getInstance().skilldata.skillItems[this.skillid];
			if (skills[0] == 0)
				return;

			var skill:Array=TableManager.getInstance().getSkillArr(MyInfoManager.getInstance().skilldata.skillItems[this.skillid][1]);
			skill.sortOn("id", Array.CASEINSENSITIVE | Array.NUMERIC);

			var runindex:int=int(e.target.name.charAt(e.target.name.length - 1))

			var sk:TSkillInfo=skill[runindex];

			if (skills[2] < sk.autoLv)
				return;

			var acid:int=skills.indexOf(2, 3) - 2;
			if (acid < 0 && skills.length == 7 && (skills[6]).split("_")[1] == 2) {
				acid=(skills[6]).split("_")[0];
			}

			acid=acid < 0 ? 0 : acid;

			if (int(e.target.name.charAt(e.target.name.length - 1)) != acid) {

				var str:String="";
				if (acid == 0) {

//							str="确认将<font color='#00ff00'><u>" + sk.name + "</u></font>的符文切换为<font color='#00ff00'><u>" + sk.runeName + "</u></font>?，本次切换不消耗道具。";
					str=StringUtil.substitute(TableManager.getInstance().getSystemNotice(2121).content, [sk.name, sk.runeName]);

				} else {

//							str="切换符文需要消耗道具<font color='#00ff00'><u><a href='event:" + ConfigEnum.skillItem + "'>技能符石</a></u></font>，是否确定这样做？";
					str=StringUtil.substitute(TableManager.getInstance().getSystemNotice(2120).content, [ConfigEnum.skill3]);

				}

				PopupManager.showConfirm(str, function():void {
//							if (acid == 0) {

					Cmd_Skill.cm_sklChange(skillid, runindex);

//					UIManager.getInstance().skillWnd.setChangeRune();

					//							} else {

					//								if (!UIManager.getInstance().quickBuyWnd.isAutoBuy(ConfigEnum.skillItem, ConfigEnum.skillbindItem)) {
					//									UILayoutManager.getInstance().show(WindowEnum.SKILL, WindowEnum.QUICK_BUY, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y + 40);
					//									UIManager.getInstance().quickBuyWnd.pushItem(ConfigEnum.skillItem, ConfigEnum.skillbindItem);
					//								} else {
					//
					//									if (selectIndex != -1) {
					//										Cmd_Skill.cm_sklChange(index, selectIndex, (UIManager.getInstance().quickBuyWnd.getCost(ConfigEnum.skillItem, ConfigEnum.skillbindItem) == 0 ? 2 : 1));
					//									}
					//
					//								}

					//							}
				}, null, false, "changeRune", PropUtils.getStringById(1866));
			}


		}

		public function onMouseOver(e:MouseEvent):void {
//			trace(e, "over")

			var runindex:int=int(e.target.name.charAt(e.target.name.length - 1));
			if (runindex == 0)
				return;


			var skill:Array=TableManager.getInstance().getSkillArr(MyInfoManager.getInstance().skilldata.skillItems[this.skillid][1]);
			skill.sortOn("id", Array.CASEINSENSITIVE | Array.NUMERIC);

			var sk:TSkillInfo=skill[runindex];

			var tipInfo:TipSkillInfo=new TipSkillInfo();
			tipInfo.skillInfo=sk;
			tipInfo.hasRune=false;
			tipInfo.level=sk.autoLv;
			tipInfo.skillLv=MyInfoManager.getInstance().skilldata.skillItems[this.skillid][2];
			tipInfo.level=MyInfoManager.getInstance().skilldata.skillItems[this.skillid][2];
			tipInfo.runde=MyInfoManager.getInstance().skilldata.skillItems[this.skillid].indexOf(2, 3) - 2;

			ToolTipManager.getInstance().show(TipEnum.TYPE_RUNE, tipInfo, new Point(this.stage.mouseX + 15, this.stage.mouseY + 15));


		}

		public function onMouseOut(e:MouseEvent):void {
//			trace(e, "out")

		}


		public function onClick(e:MouseEvent):void {

			GuideArrowDirectManager.getInstance().delArrow(WindowEnum.SKILL + "");
			Cmd_Skill.cm_sklUpgrade(this.skillid);
		}

		/**
		 * @param arr
		 */
		public function updateInfo(arr:Array):void {



			this.skillid=MyInfoManager.getInstance().skilldata.skillItems.indexOf(arr);

			var skill:Array=TableManager.getInstance().getSkillArr(arr[1]);
			skill.sortOn("id", Array.CASEINSENSITIVE | Array.NUMERIC);

			this.nameLbl.text="" + skill[0].name;
			this.desLbl.text="" + skill[0].autoLv + PropUtils.getStringById(2300);

			if (arr[0] == 1) {
				this.desLbl.visible=false;
				this.lvLbl.visible=true;
				this.lvLbl.text="LV:" + arr[2]; //skill[0].autoLv;

				if (this.curLv != 0 && this.curLv != arr[2]) {
					this.succeffSwf.visible=true;

					this.succeffSwf.playAct(PlayerEnum.ACT_STAND, -1, false, function():void {
						succeffSwf.visible=false;
					});
				}

				this.curLv=arr[2];

			} else {
				this.lvLbl.text="LV:0";
				this.lvLbl.visible=false;
				this.desLbl.visible=true;
			}

//			this.fuwenImg1.updateBmp("ico/skills/" + skill[6].runeIcon + ".png");
			this.fuwenImg2.updateBmp("ico/skills/" + skill[1].runeIcon + ".png");
			this.fuwenImg3.updateBmp("ico/skills/" + skill[2].runeIcon + ".png");
			this.fuwenImg4.updateBmp("ico/skills/" + skill[3].runeIcon + ".png");

			this.money=TableManager.getInstance().getSkillLvInfo(int(arr[2])).money;
			this.hun=TableManager.getInstance().getSkillLvInfo(int(arr[2])).energy;

			this.moneyLbl.text="" + this.money;
			this.hunLbl.text="" + this.hun;

			for (var i:int=3; i < arr.length; i++) {

//				if (arr[i] == 2)
//					this["fwLbl" + (i - 1)].text="已使用";
//
//				if (arr[i] == 1)
//					this["fwLbl" + (i - 1)].text="未激活";
//
//				if (arr[i] == 0)
//					this["fwLbl" + (i - 1)].text="未获得";

				this["fwLbl" + (i - 1)].text="";


				if (arr[i] == 0)
					this["fuwenImg" + (i - 1)].filters=[FilterUtil.enablefilter];
				else
					this["fuwenImg" + (i - 1)].filters=[];

			}

//			if (arr[0] == 1) {
//				if (arr.indexOf(2, 3) == -1)
//					this.fwLbl1.text="已使用";
//				else
//					this.fwLbl1.text="未激活";
//			} else
//				this.fwLbl1.text="未获得";

			this.fwLbl1.text="";
			this.fuwenImg1.filters=[];

			this.grid.updataInfo(skill[0]);
			this.grid.setSize(60, 60);
			this.grid.skillIndex=skillid;

			if (arr.indexOf(2, 3) != -1) {

				if (this.runeindex == arr.indexOf(2, 3))
					return;

				this.runeindex=arr.indexOf(2, 3)

				if (twen != null) {
					twen.pause();
					twen.kill();

					twen=null;
				}

				twen=TweenMax.to(this["fuwenImg" + (arr.indexOf(2, 3) - 1)], 2, {glowFilter: {color: 0xfa9611, alpha: 1, blurX: 12, blurY: 12, strength: 2}, yoyo: true, repeat: -1});
			} else {

				if (this.runeindex == 1)
					return;

				if (twen != null) {
					twen.pause();
					twen.kill();

					twen=null;
				}

				if (arr[0] == 1) {
					twen=TweenMax.to(this.fuwenImg1, 2, {glowFilter: {color: 0xfa9611, alpha: 1, blurX: 12, blurY: 12, strength: 2}, yoyo: true, repeat: -1});
					this.runeindex=1;
				}

			}

//			else if (arr.length == 7 && String(arr[6]).indexOf("2") != -1)
//				this.fuwenImg1.updateBmp("ico/skills/" + skill[6].runeIcon + ".png");
//			else
//				this.fuwenImg1.updateBmp("ui/skill/icon_fu_0.png");


		}

		public function setAutoMagicEffect(v:Boolean):void {
			this.grid.setMagicEffect(v);
		}

		/**
		 * @param v
		 */
		public function set hight(v:Boolean):void {

			if (this.state)
				return;

			if (v)
				this.bgImg.updateBmp("ui/skill/skill_information_over.jpg");
			else
				this.bgImg.updateBmp("ui/skill/skill_information_out.jpg");
		}

		/**
		 *
		 * @param v
		 *
		 */
		public function set enable(v:Boolean):void {

//			this.mouseChildren=this.mouseEnabled=!v;
			this.upgradeBtn.mouseChildren=this.upgradeBtn.mouseEnabled=!v;

			this.state=v;

			if (v) {
				this.filters=[FilterUtil.enablefilter];
			} else {
				this.filters=[];
			}
		}

		public function dispAutoEvent():void {
			this.upgradeBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}

	}
}

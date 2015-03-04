package com.leyou.ui.role.child.children {

	import com.ace.config.Core;
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.player.PlayerBasicInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.role.RoleInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.utils.PlayerUtil;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class PropertyNum extends AutoSprite {

		private var phyAttLbl:Label;
		private var phyDefLbl:Label;
		private var magAttLbl:Label;
		private var magDefLbl:Label;
		private var critLvLbl:Label;
		private var hpLbl:Label;
		private var soulLbl:Label;
		private var mpLbl:Label;
		private var toughLvLbl:Label;
		private var dodgeLvLbl:Label;
		private var killLvLbl:Label;
		private var goldLvLbl:Label;
		private var waterLvLbl:Label;
		private var fireLvLbl:Label;
		private var soilLvLbl:Label;
		private var woodLvLbl:Label;
		private var guardLvLbl:Label;
		private var pkLbl:Label;
		private var hitLvLbl:Label;
		private var raceLbl:Label;
		private var lvLbl:Label;
		private var txt24:Label;
		private var guildNameLbl:Label;

		private var soulImgbg:Image;
		private var hpImg:Image;
		private var soulImg:Image;
		private var mpImg:Image;
		private var elementImg:Image;
		private var eleSwf:SwfLoader;

		private var currentElement:int=0;

		private var propArrKey:Array=[4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 16, 22, 23, 24];
		private var propArrLbL:Array=[];

		private var w:Number;
		private var h:Number;

		private var otherplay:Boolean=false;

		public function PropertyNum(otherPlay:Boolean=false) {
			super(LibManager.getInstance().getXML("config/ui/role/PropertyNum.xml"));
			this.otherplay=otherPlay;
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {
			this.phyAttLbl=this.getUIbyID("phyAttLbl") as Label;
			this.phyDefLbl=this.getUIbyID("phyDefLbl") as Label;
			this.magAttLbl=this.getUIbyID("magAttLbl") as Label;
			this.magDefLbl=this.getUIbyID("magDefLbl") as Label;
			this.critLvLbl=this.getUIbyID("critLvLbl") as Label;
			this.hpLbl=this.getUIbyID("hpLbl") as Label;
			this.soulLbl=this.getUIbyID("soulLbl") as Label;
			this.mpLbl=this.getUIbyID("mpLbl") as Label;
			this.toughLvLbl=this.getUIbyID("toughLvLbl") as Label;
			this.dodgeLvLbl=this.getUIbyID("dodgeLvLbl") as Label;
			this.killLvLbl=this.getUIbyID("killLvLbl") as Label;
			this.goldLvLbl=this.getUIbyID("goldLvLbl") as Label;
			this.waterLvLbl=this.getUIbyID("waterLvLbl") as Label;
			this.fireLvLbl=this.getUIbyID("fireLvLbl") as Label;
			this.soilLvLbl=this.getUIbyID("soilLvLbl") as Label;
			this.woodLvLbl=this.getUIbyID("woodLvLbl") as Label;
			this.guardLvLbl=this.getUIbyID("guardLvLbl") as Label;
			this.pkLbl=this.getUIbyID("pkLbl") as Label;
			this.hitLvLbl=this.getUIbyID("hitLvLbl") as Label;
			this.txt24=this.getUIbyID("txt24") as Label;
			this.raceLbl=this.getUIbyID("raceLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.guildNameLbl=this.getUIbyID("guildNameLbl") as Label;

			this.soulImgbg=this.getUIbyID("soulImgbg") as Image;
			this.hpImg=this.getUIbyID("hpImg") as Image;
//			this.soulImg=this.getUIbyID("soulImg") as Image;
			this.mpImg=this.getUIbyID("mpImg") as Image;
			this.elementImg=this.getUIbyID("elementImg") as Image;
			this.eleSwf=this.getUIbyID("eleSwf") as SwfLoader;

//			var einfo1:MouseEventInfo=new MouseEventInfo();
//			einfo1.onMouseMove=onjinMouseOver;
//			einfo1.onMouseOut=onjinMouseOut;
//
//			MouseManagerII.getInstance().addEvents(this.elementImg, einfo1);

			var eleSpr:Sprite=new Sprite();
			eleSpr.graphics.beginFill(0x000000);
			eleSpr.graphics.drawRect(0, 0, 180, 120);
			eleSpr.graphics.endFill();

			this.addChild(eleSpr);

			eleSpr.y=330;
			eleSpr.x=5;

			eleSpr.alpha=0;

			if (!this.otherplay)
				eleSpr.addEventListener(MouseEvent.CLICK, onClick);
			
			eleSpr.addEventListener(MouseEvent.MOUSE_MOVE, onMouseOver);
			eleSpr.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			var hpSpr:Sprite=new Sprite();
			hpSpr.graphics.beginFill(0x000000);
			hpSpr.graphics.drawRect(0, 0, 122, 21);
			hpSpr.graphics.endFill();
			hpSpr.name="hpspr";
			this.addChild(hpSpr);

			hpSpr.y=this.hpImg.y;
			hpSpr.x=this.hpImg.x;

			hpSpr.alpha=0;

//			hpSpr.addEventListener(MouseEvent.CLICK, onClick);
			hpSpr.addEventListener(MouseEvent.MOUSE_MOVE, onMouseTipOver);
			hpSpr.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			var mpSpr:Sprite=new Sprite();
			mpSpr.graphics.beginFill(0x000000);
			mpSpr.graphics.drawRect(0, 0, 122, 21);
			mpSpr.graphics.endFill();
			mpSpr.name="mpspr";
			this.addChild(mpSpr);

			mpSpr.y=this.mpImg.y;
			mpSpr.x=this.mpImg.x;

			mpSpr.alpha=0;

//			mpSpr.addEventListener(MouseEvent.CLICK, onClick);
			mpSpr.addEventListener(MouseEvent.MOUSE_MOVE, onMouseTipOver);
			mpSpr.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			for (var i:int=0; i < this.propArrKey.length; i++) {
				this.propArrLbL[this.propArrKey[i]]=this.getUIbyID("txt" + this.propArrKey[i]) as Label;
			}

			var lb:Label;
			var key:String;
			for (key in this.propArrLbL) {
				lb=this.propArrLbL[key];
				if (lb != null) {
					lb.setToolTip(TableManager.getInstance().getSystemNotice(9500 + int(key)).content);
				}
			}

			this.w=121; //this.hpImg.width;
			this.h=16; //this.hpImg.height;
		}

		private function onMouseTipOver(e:MouseEvent):void {
			if (e.target.name == "hpspr") {
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(9522).content, [Core.me.info.baseInfo.hp, Core.me.info.baseInfo.maxHp, int(Core.me.info.baseInfo.hp / Core.me.info.baseInfo.maxHp * 100) + "%"]), new Point(e.stageX, e.stageY));
			} else if (e.target.name == "mpspr") {
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(9523).content, [Core.me.info.baseInfo.mp, Core.me.info.baseInfo.maxMp, int(Core.me.info.baseInfo.mp / Core.me.info.baseInfo.maxMp * 100) + "%", ConfigEnum.manaRevive]), new Point(e.stageX, e.stageY));
			}

		}

		public function updateInfo(info:RoleInfo):void {
			this.phyAttLbl.text=info.phAtt + "";
			this.phyDefLbl.text=info.phDef + "";
			this.magAttLbl.text=info.magicAtt + "";
			this.magDefLbl.text=info.magicDef + "";
			this.critLvLbl.text=info.crit + "";
			this.hpLbl.text=info.hp + "/" + info.mHp;
//			this.soulLbl.text=info.soul + "/" + info.mSoul;
			this.mpLbl.text=info.mp + "/" + info.mMp;
			this.toughLvLbl.text=info.tenacity + "";
			this.dodgeLvLbl.text=info.dodge + "";
			this.killLvLbl.text=info.slay + "";

			if (info.guildName == "")
				this.guildNameLbl.text="无";
			else
				this.guildNameLbl.text=info.guildName + "";

//			if (Core.me != null && Core.me.info != null)
//				this.soulImgbg.visible=this.soulImg.visible=this.txt24.visible=this.soulLbl.visible=(ConfigEnum.WingOpenLv <= Core.me.info.level);

//			this.soulImgbg.visible=this.soulImg.visible=this.txt24.visible=this.soulLbl.visible=false;

			this.propArrLbL[22].setToolTip(StringUtil.substitute(TableManager.getInstance().getSystemNotice(9522).content, [info.hp, info.mHp, int(info.hp / info.mHp * 100) + "%"]));
			this.propArrLbL[23].setToolTip(StringUtil.substitute(TableManager.getInstance().getSystemNotice(9523).content, [info.mp, info.mMp, int(info.mp / info.mMp * 100) + "%", ConfigEnum.manaRevive]));

//			if (info.currentElement == 1)
//				this.goldLvLbl.text="等级" + info.elementArr[0] + "(守护中)";
//			else
//				this.goldLvLbl.text="等级" + info.elementArr[0];
//
//			if (info.currentElement == 2)
//				this.woodLvLbl.text="等级" + info.elementArr[1] + "(守护中)";
//			else
//				this.woodLvLbl.text="等级" + info.elementArr[1];
//
//			if (info.currentElement == 3)
//				this.waterLvLbl.text="等级" + info.elementArr[2] + "(守护中)";
//			else
//				this.waterLvLbl.text="等级" + info.elementArr[2];
//
//			if (info.currentElement == 4)
//				this.fireLvLbl.text="等级" + info.elementArr[3] + "(守护中)";
//			else
//				this.fireLvLbl.text="等级" + info.elementArr[3];
//
//			if (info.currentElement == 5)
//				this.soilLvLbl.text="等级" + info.elementArr[4] + "(守护中)";
//			else
//				this.soilLvLbl.text="等级" + info.elementArr[4];

			this.currentElement=info.currentElement;

			switch (info.currentElement) {
				case 0:
					if (Core.me != null && Core.me.info != null && ConfigEnum.ElementOpenLv <= Core.me.info.level) {
						this.elementImg.bitmapData=null;
						this.eleSwf.stop();
					}
					break;
				case 1:
					this.elementImg.visible=false;
//					this.elementImg.updateBmp("ui/element/element_gold_over.png");
					this.eleSwf.update(99925);
					break;
				case 2:
					this.elementImg.visible=false;
//					this.elementImg.updateBmp("ui/element/element_wood_over.png");
					this.eleSwf.update(99924);
					break;
				case 3:
					this.elementImg.visible=false;
//					this.elementImg.updateBmp("ui/element/element_water_over.png");
					this.eleSwf.update(99922);
					break;
				case 4:
					this.elementImg.visible=false;
//					this.elementImg.updateBmp("ui/element/element_fire_over.png");
					this.eleSwf.update(99921);
					break;
				case 5:
					this.elementImg.visible=false;
//					this.elementImg.updateBmp("ui/element/element_dirt_over.png");
					this.eleSwf.update(99923);
					break;
			}

			this.eleSwf.scaleX=this.eleSwf.scaleY=.6;

			this.elementImg.setWH(47 * 0.6, 47 * 0.6);
			this.guardLvLbl.text=info.guaid + "";
			this.pkLbl.text=info.pk + "";
			this.hitLvLbl.text=info.hit + "";
			this.raceLbl.text=PlayerUtil.getPlayerRaceByIdx(info.race);
			this.lvLbl.text=info.lv + "";

			var ww:Number=info.hp / info.mHp;

			ww=this.getWW(ww);
			this.hpImg.scaleX=ww;

//			ww=this.getWW(info.soul / info.mSoul);
//			this.soulImg.scaleX=ww;

			ww=this.getWW(info.mp / info.mMp);
			this.mpImg.scaleX=ww;

		}

		public function updateHpAndMpAndSoul():void {
			this.hpLbl.text=Core.me.info.baseInfo.hp + "/" + Core.me.info.baseInfo.maxHp;
//			this.soulLbl.text=Core.me.info.baseInfo.jingL + "/" + Core.me.info.baseInfo.maxJingL;
			this.mpLbl.text=Core.me.info.baseInfo.mp + "/" + Core.me.info.baseInfo.maxMp;

			var info:PlayerBasicInfo=Core.me.info.baseInfo;

			var ww:Number=info.hp / info.maxHp;

			ww=this.getWW(ww);
			this.hpImg.scaleX=ww;

//			ww=this.getWW(info.jingL / info.maxJingL);
//			this.soulImg.scaleX=ww;

			ww=this.getWW(info.mp / info.maxMp);
			this.mpImg.scaleX=ww;

		}

		private function onClick(e:MouseEvent):void {
			if (ConfigEnum.ElementOpenLv <= Core.me.info.level)
				UIManager.getInstance().roleWnd.setTabIndex(3);
		}

		private function onMouseOver(e:MouseEvent):void {
			if (ConfigEnum.ElementOpenLv <= Core.me.info.level) {

				if (this.currentElement == 0)
					ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(1015).content, [ConfigEnum.ElementOpenLv]), new Point(this.stage.mouseX, this.stage.mouseY));
				else {
					if (UIManager.getInstance().roleWnd.elementInfo != null && UIManager.getInstance().roleWnd.elementInfo.elements.length > this.currentElement - 1)
						ToolTipManager.getInstance().show(TipEnum.TYPE_ELEMENTS, UIManager.getInstance().roleWnd.elementInfo.elements[this.currentElement - 1], new Point(this.stage.mouseX, this.stage.mouseY));
				}

			} else {
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(1014).content, [ConfigEnum.ElementOpenLv]), new Point(this.stage.mouseX, this.stage.mouseY));
			}
		}

		private function onMouseOut(e:MouseEvent):void {
			ToolTipManager.getInstance().hide();
		}

		private function getWW(ww:Number):Number {
			if (ww > 1)
				ww=1;

			if (ww < 0)
				ww=0;

			return ww;
		}
	}
}

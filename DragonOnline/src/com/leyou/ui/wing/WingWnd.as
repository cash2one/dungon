package com.leyou.ui.wing {

	import com.ace.enum.WindowEnum;
	import com.ace.game.scene.ui.effect.StarChangeEffect;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Wig;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class WingWnd extends AutoSprite {

		private var wingUpBtn:NormalButton;
		private var wingTradeBtn:NormalButton;
		public var wingNameImg:Image;
		private var jieImg:Image;
		private var rightImgBtn:ImgButton;
		private var leftImgBtn:ImgButton;
		private var showBtn:ImgButton;

		private var fightKeyLbl:Label;
		private var fightAddkeyLbl:Label;
		private var phAttLbl:Label;
		private var phAttAddLbl:Label;
		private var magicAttAddLbl:Label;
		private var phDefAddLbl:Label;
		private var magicDefAddLbl:Label;
		private var hpAddLbl:Label;
		private var mpAddLbl:Label;
		private var critLvAddLbl:Label;
		private var toughLvAddLbl:Label;
		private var hitLvAddLbl:Label;
		private var dodgeLvAddLbl:Label;
		private var killLvAddLbl:Label;
		private var guaidLvAddLbl:Label;
		private var reikiUpAddLbl:Label;
		private var reiliBackAddLbl:Label;
		private var reikiUpLbl:Label;
		private var magicAttLbl:Label;
		private var phDefLbl:Label;
		private var magicDefLbl:Label;
		private var hpLbl:Label;
		private var mpLbl:Label;
		private var critLvLbl:Label;
		private var toughLvLbl:Label;
		private var hitLvLbl:Label;
		private var dodgeLvLbl:Label;
		private var killLvLbl:Label;
		private var guaidLvLbl:Label;
		private var reikiBackLbl:Label;
		private var arrowImg:Image;
		private var arrow1Img:Image;
		private var wingImg:Image;

//		private var fightBD:Bitmap;
		private var rollPower:RollNumWidget;

		private var gridVec:Vector.<WingGrid>;

		private var lv:int=0;
		private var wlv:int=0;
		private var st:int=0;
		private var swfIndex:int=1;

		private var pageCount:int=10;

		private var viewList:Array=[];
		private var viewAddList:Array=[];

		private var infoXml:XML;
		private var effectBg:SwfLoader;

		private var starEffect:StarChangeEffect;

		private var otherPlay:Boolean=false;
		//3
		private var propArrKey:Array=[4, 5, 8, 9, 10, 11, 12, 13, 1, 2, 24];

		public function WingWnd(otherPlayer:Boolean=false) {
			super(LibManager.getInstance().getXML("config/ui/wing/wingWnd.xml"));
			this.otherPlay=otherPlayer;
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {

			this.wingUpBtn=this.getUIbyID("wingUpBtn") as NormalButton;
			this.wingTradeBtn=this.getUIbyID("wingTradeBtn") as NormalButton;
			this.wingNameImg=this.getUIbyID("wingNameImg") as Image;
			this.jieImg=this.getUIbyID("jieImg") as Image;
			this.rightImgBtn=this.getUIbyID("rightImgBtn") as ImgButton;
			this.leftImgBtn=this.getUIbyID("leftImgBtn") as ImgButton;
			this.showBtn=this.getUIbyID("showBtn") as ImgButton;

			this.fightKeyLbl=this.getUIbyID("fightKeyLbl") as Label;
			this.fightAddkeyLbl=this.getUIbyID("fightAddkeyLbl") as Label;
			this.phAttLbl=this.getUIbyID("phAttLbl") as Label;
			this.phAttAddLbl=this.getUIbyID("phAttAddLbl") as Label;
			this.magicAttAddLbl=this.getUIbyID("magicAttAddLbl") as Label;
			this.phDefAddLbl=this.getUIbyID("phDefAddLbl") as Label;
			this.magicDefAddLbl=this.getUIbyID("magicDefAddLbl") as Label;
			this.hpAddLbl=this.getUIbyID("hpAddLbl") as Label;
			this.mpAddLbl=this.getUIbyID("mpAddLbl") as Label;
			this.toughLvAddLbl=this.getUIbyID("toughLvAddLbl") as Label;
			this.critLvAddLbl=this.getUIbyID("critLvAddLbl") as Label;
			this.hitLvAddLbl=this.getUIbyID("hitLvAddLbl") as Label;
			this.dodgeLvAddLbl=this.getUIbyID("dodgeLvAddLbl") as Label;
			this.killLvAddLbl=this.getUIbyID("killLvAddLbl") as Label;
			this.guaidLvAddLbl=this.getUIbyID("guaidLvAddLbl") as Label;
			this.reikiUpAddLbl=this.getUIbyID("reikiUpAddLbl") as Label;
			this.reiliBackAddLbl=this.getUIbyID("reiliBackAddLbl") as Label;
			this.magicAttLbl=this.getUIbyID("magicAttLbl") as Label;
			this.phDefLbl=this.getUIbyID("phDefLbl") as Label;
			this.magicDefLbl=this.getUIbyID("magicDefLbl") as Label;
			this.hpLbl=this.getUIbyID("hpLbl") as Label;
			this.mpLbl=this.getUIbyID("mpLbl") as Label;
			this.critLvLbl=this.getUIbyID("critLvLbl") as Label;
			this.toughLvLbl=this.getUIbyID("toughLvLbl") as Label;
			this.hitLvLbl=this.getUIbyID("hitLvLbl") as Label;
			this.dodgeLvLbl=this.getUIbyID("dodgeLvLbl") as Label;
			this.killLvLbl=this.getUIbyID("killLvLbl") as Label;
			this.guaidLvLbl=this.getUIbyID("guaidLvLbl") as Label;
			this.reikiUpLbl=this.getUIbyID("reikiUpLbl") as Label;
			this.arrowImg=this.getUIbyID("arrowImg") as Image;
			this.arrow1Img=this.getUIbyID("arrow1Img") as Image;
			this.wingImg=this.getUIbyID("wingImg") as Image;

			this.rollPower=new RollNumWidget();
			this.rollPower.loadSource("ui/num/{num}_zdl.png");
			this.addChild(this.rollPower);
			this.rollPower.x=this.fightKeyLbl.x;
			this.rollPower.y=this.fightKeyLbl.y + 10;

//			this.rollPower.visibleOfBg=false;
			this.rollPower.alignCenter();

			if (!otherPlay) {
				this.wingUpBtn.addEventListener(MouseEvent.CLICK, this.onBtnClick);
				this.wingUpBtn.addEventListener(MouseEvent.ROLL_OVER, this.onRollClick);
				this.wingUpBtn.addEventListener(MouseEvent.ROLL_OUT, this.onRollClick);
				this.rightImgBtn.addEventListener(MouseEvent.CLICK, this.onBtnClick);
				this.leftImgBtn.addEventListener(MouseEvent.CLICK, this.onBtnClick);
				this.showBtn.addEventListener(MouseEvent.CLICK, this.onBtnClick);
				this.wingTradeBtn.addEventListener(MouseEvent.CLICK, this.onBtnClick);
			} else {
				this.wingTradeBtn.visible=false;
				this.wingUpBtn.visible=false;
				this.rightImgBtn.visible=false;
				this.leftImgBtn.visible=false;
				this.showBtn.visible=false;
				this.arrowImg.visible=false;
				this.arrow1Img.visible=false;
				this.wingImg.visible=false;
			}

			this.viewList[PropUtils.getIndexByStr("物理攻击")]=this.phAttLbl;
			this.viewList[PropUtils.getIndexByStr("物理防御")]=this.phDefLbl;
//			this.viewList[PropUtils.getIndexByStr("法术攻击")]=this.magicAttLbl;
//			this.viewList[PropUtils.getIndexByStr("法术防御")]=this.magicDefLbl;
			this.viewList[PropUtils.getIndexByStr("生命上限")]=this.hpLbl;
			this.viewList[PropUtils.getIndexByStr("法力上限")]=this.mpLbl;
			this.viewList[PropUtils.getIndexByStr("暴击等级")]=this.critLvLbl;
			this.viewList[PropUtils.getIndexByStr("命中等级")]=this.hitLvLbl;
			this.viewList[PropUtils.getIndexByStr("闪避等级")]=this.dodgeLvLbl;
			this.viewList[PropUtils.getIndexByStr("韧性等级")]=this.toughLvLbl;
			this.viewList[PropUtils.getIndexByStr("守护等级")]=this.guaidLvLbl;
			this.viewList[PropUtils.getIndexByStr("精力上限")]=this.reikiUpLbl;
			this.viewList[PropUtils.getIndexByStr("必杀等级")]=this.killLvLbl;

			this.viewAddList[PropUtils.getIndexByStr("物理攻击")]=this.phAttAddLbl;
			this.viewAddList[PropUtils.getIndexByStr("物理防御")]=this.phDefAddLbl;
//			this.viewAddList[PropUtils.getIndexByStr("法术攻击")]=this.magicAttAddLbl;
//			this.viewAddList[PropUtils.getIndexByStr("法术防御")]=this.magicDefAddLbl;
			this.viewAddList[PropUtils.getIndexByStr("生命上限")]=this.hpAddLbl;
			this.viewAddList[PropUtils.getIndexByStr("法力上限")]=this.mpAddLbl;
			this.viewAddList[PropUtils.getIndexByStr("暴击等级")]=this.critLvAddLbl;
			this.viewAddList[PropUtils.getIndexByStr("命中等级")]=this.hitLvAddLbl;
			this.viewAddList[PropUtils.getIndexByStr("闪避等级")]=this.dodgeLvAddLbl;
			this.viewAddList[PropUtils.getIndexByStr("韧性等级")]=this.toughLvAddLbl;
			this.viewAddList[PropUtils.getIndexByStr("守护等级")]=this.guaidLvAddLbl;
			this.viewAddList[PropUtils.getIndexByStr("精力上限")]=this.reikiUpAddLbl;
			this.viewAddList[PropUtils.getIndexByStr("必杀等级")]=this.killLvAddLbl;

			this.reikiUpLbl.visible=this.reikiUpAddLbl.visible=false;

			infoXml=LibManager.getInstance().getXML("config/table/Wing_Base.xml");

//			var xml:XML=LibManager.getInstance().getXML("config/table/Wing_Enhance.xml");
//			this.gridVec=new Vector.<WingGrid>();

			var i:int=0;
//			var grid:WingGrid;
//			for (var i:int=0; i < 6; i++) {
//
//				grid=new WingGrid(i);
//
//				grid.goldNum=xml.data[i].@PO_Pay;
//				grid.openLv=xml.data[i].@PO_Level;
//
//				this.addChild(grid);
//				this.gridVec.push(grid);
//
//				grid.x=4 + i * 44;
//				grid.y=332;
//			}

			var lb:Label;
			for (i=0; i < this.propArrKey.length; i++) {
				lb=this.getUIbyID("txt" + this.propArrKey[i]) as Label;
				if (lb != null) {
					if (this.propArrKey[i] == 2) {
						lb.setToolTip(StringUtil.substitute(TableManager.getInstance().getSystemNotice(9500 + int(this.propArrKey[i])).content, [ConfigEnum.manaRevive]));
					} else
						lb.setToolTip(TableManager.getInstance().getSystemNotice(9500 + int(this.propArrKey[i])).content);
				}
			}

			this.getUIbyID("txt3").visible=false;
			this.setPropAddVisible(false);
			this.wingUpBtn.setToolTip(TableManager.getInstance().getSystemNotice(1210).content);

			this.starEffect=new StarChangeEffect(10, true, 200);
			this.addChild(this.starEffect);
			this.starEffect.x=-50;
			this.starEffect.y=4;

			this.scrollRect=new Rectangle(0, 0, this.width, this.height);

			this.y=3;
			this.x=4;
		}


		public function updateInfo(info:Object):void {

//			if (ConfigEnum.WingOpenLv > Core.me.info.level)
//				return;

			if (info.lv == "0")
				throw Error("坐骑等级不能等于0")

			if (info.hasOwnProperty("lv")) {

				this.st=info.see;
				var j:int=this.swfIndex=this.lv=info.lv;

				this.pageCount=j;
				this.updateEffect(info.lv);

//				if (--j < 1)
//					this.leftImgBtn.visible=false;
//
//				j=swfIndex;
//				if (++j > this.pageCount)
//					this.rightImgBtn.visible=false;
			}

			var xml:XML=infoXml.data[int(info.wlv) - 1];
			var xml2:XML=infoXml.data[(int(info.wlv) < 100 ? int(info.wlv) : 99)];

			var twRate:int=0;

			if (info.flyl != 0)
				twRate=TableManager.getInstance().getWingTradeByID(info.flyl).rate;

			for (var i:int=1; i <= 10; i++) {
				if (int(xml.attribute("W_AttID" + i)) == 3)
					continue;

				if ([1, 4, 5, 6, 7].indexOf(int(xml.attribute("W_AttID" + i))) > -1)
					this.viewList[int(xml.attribute("W_AttID" + i)) - 1].text="" + int(int(xml.attribute("W_AttNum" + i)) + Math.floor(int(xml.attribute("W_AttNum" + i)) * (twRate / 100)));
				else
					this.viewList[int(xml.attribute("W_AttID" + i)) - 1].text=xml.attribute("W_AttNum" + i);

				if (info.lv < 10) {
					this.viewAddList[int(xml.attribute("W_AttID" + i)) - 1].text="+" + (int(xml2.attribute("W_AttNum" + i)) - int(xml.attribute("W_AttNum" + i)));
				}
			}

			if (info.hasOwnProperty("zdl")) {

				if (this.rollPower.number != info.zdl) {

					if (this.otherPlay)
						this.rollPower.setNum(info.zdl);
					else
						this.rollPower.rollToNum(info.zdl);

					this.rollPower.x=317 - this.rollPower.width >> 1;
				}
			}

			if (info.hasOwnProperty("st")) {

				MyInfoManager.getInstance().wingData=info;

//				var key:String;
//				for (key in info.st) {
//					if (info.st[key].s == 0) {
//
//					} else if (info.st[key].s == 1) {
//						this.gridVec[int(key) - 1].updataInfo(null);
//					} else if (info.st[key].s > 1) {
//						this.gridVec[int(key) - 1].updataInfo(info.st[key].s);
//						this.gridVec[int(key) - 1].tips=info.st[key].t;
//					}
//
//					if (otherPlay)
//						this.gridVec[int(key) - 1].canMove=false;
//				}
			}

			if (info.hasOwnProperty("wlv"))
				this.starEffect.setStarPos(info.wlv % 10 - 1);

			if (this.otherPlay) {
				this.leftImgBtn.visible=false;
				return;
			}


			this.wlv=info.wlv;

			if (info.wlv >= 100) {
				this.wingUpBtn.setActive(false, .6, true);
				this.wingUpBtn.setToolTip(TableManager.getInstance().getSystemNotice(1213).content);
				this.arrowImg.visible=false;
				UIManager.getInstance().wingLvUpWnd.hide();

				this.starEffect.setStarPos(9);
			} else {
				this.wingUpBtn.setActive(true, 1, true);
				this.wingUpBtn.setToolTip(TableManager.getInstance().getSystemNotice(1210).content);
				this.arrowImg.visible=true;
				UIManager.getInstance().wingLvUpWnd.update(xml, info);
			}


			if (this.lv >= ConfigEnum.wing17) {

				this.wingTradeBtn.setActive(true, 1, true);

				this.wingTradeBtn.setToolTip(TableManager.getInstance().getSystemNotice(1224).content);

				this.arrow1Img.visible=true;

				UIManager.getInstance().wingTradeWnd.updateInfo(info);

			} else {

				this.wingTradeBtn.setActive(false, .6, true);
				this.wingTradeBtn.setToolTip(StringUtil.substitute(TableManager.getInstance().getSystemNotice(1217).content, [ConfigEnum.wing17]));
				this.arrow1Img.visible=false;
			}
		}

		/**
		 * 开启某一格子
		 * @param o
		 */
		public function updateGrid(o:Object):void {
//			if (o.rs == 1) {
//				this.gridVec[int(o.id) - 1].updataInfo(null);
//			} else if (o.rs > 1) {
//				this.gridVec[int(o.id) - 1].updataInfo(o.rs);
//			}
		}

		/**
		 * @param o
		 */
		public function updateGridList(o:Object):void {
			if (o.hasOwnProperty("st")) {
				MyInfoManager.getInstance().wingData=o;

				var key:String;
//				for (key in o.st) {
//					if (o.st[key].s == 0) {
//
//					} else if (o.st[key].s == 1) {
//						this.gridVec[int(key) - 1].updataInfo(null);
//					} else if (o.st[key].s > 1) {
//						this.gridVec[int(key) - 1].updataInfo(o.st[key].s);
//						this.gridVec[int(key) - 1].tips=o.st[key].t;
//					}
//				}
			}
		}

		public function setPropAddVisible(v:Boolean):void {
			for (var i:int=0; i < this.viewAddList.length; i++) {
				if (this.viewAddList[i] != null)
					this.viewAddList[i].visible=v;
			}
		}

		public function get Lv():int {
			return this.lv;
		}

		public function get wLv():int {
			return this.wlv;
		}

		private function onRollClick(e:MouseEvent):void {
			if (e.type == MouseEvent.ROLL_OUT) {
				this.setPropAddVisible(false);
			} else {
				this.setPropAddVisible(true);
			}
		}

		private function updateEffect(i:int):void {
			this.jieImg.updateBmp("ui/horse/horse_lv" + i + ".png");
			var p:Point;

			if (this.wingNameImg.parent != UIManager.getInstance().roleWnd) {

				p=UIManager.getInstance().roleWnd.globalToLocal(this.wingNameImg.parent.localToGlobal(new Point(this.wingNameImg.x, this.wingNameImg.y)));
				UIManager.getInstance().roleWnd.addChild(this.wingNameImg);

				this.wingNameImg.x=p.x;
				this.wingNameImg.y=p.y;
			}


			if (this.otherPlay && this.wingNameImg.parent != UIManager.getInstance().otherPlayerWnd) {
				p=UIManager.getInstance().otherPlayerWnd.globalToLocal(this.wingNameImg.parent.localToGlobal(new Point(this.wingNameImg.x, this.wingNameImg.y)));
				UIManager.getInstance().otherPlayerWnd.addChild(this.wingNameImg);

				this.wingNameImg.x=p.x;
				this.wingNameImg.y=p.y;
			}

			this.wingNameImg.updateBmp("ui/wing/wing_lv" + i + "_name.png");

			if (this.otherPlay) {
				UIManager.getInstance().otherPlayerWnd.updateWingAvatar(this.st);
			} else if (UIManager.getInstance().roleWnd != null) {
				UIManager.getInstance().roleWnd.updateWingAvatar(this.st);
			}

//			if (--i < 1)
				this.leftImgBtn.visible=false;
//			else
//				this.leftImgBtn.visible=true;

//			i=swfIndex;
//			if (++i > this.pageCount)
				this.rightImgBtn.visible=false;
//			else
//				this.rightImgBtn.visible=true;

			if (swfIndex == this.lv) {
				if (swfIndex == this.lv && this.st > 0) {
//					this.wingImg.updateBmp("ui/character/font_yc.png");
					this.wingImg.updateBmp("ui/character/font_sy.png");
				} else
//					this.wingImg.updateBmp("ui/character/font_xs.png");
					this.wingImg.updateBmp("ui/character/font_sy.png");
			}

			if ((swfIndex) > this.lv) {
				this.showBtn.setActive(false, .6, true);
			} else
				this.showBtn.setActive(true, 1, true);

		}

		private function onBtnClick(evt:MouseEvent):void {

			if (evt.target.name == "wingUpBtn") {

//				UIManager.getInstance().wingLvUpWnd.open();
				UIManager.getInstance().mountLvUpwnd.hide();
				UIManager.getInstance().mountTradeWnd.hide();
				UIManager.getInstance().wingTradeWnd.hide();
				UIManager.getInstance().hideWindow(WindowEnum.QUICK_BUY);

				if (UIManager.getInstance().wingLvUpWnd.isShow) {
					UIManager.getInstance().wingLvUpWnd.hide();
				} else
					UILayoutManager.getInstance().show(WindowEnum.ROLE, WindowEnum.WINGLVUP); //, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y);


			} else if (evt.target.name == "rightImgBtn") {

				swfIndex++;

				if (swfIndex > this.pageCount) {
					swfIndex=this.pageCount;
				} else {

					if (swfIndex == this.pageCount)
						this.starEffect.setStarPos(this.wlv % 10 - 1);
					else {
						this.rightImgBtn.visible=true;
						this.starEffect.setStarPos(9);
					}
				}

				this.leftImgBtn.visible=true;

				this.updateEffect(swfIndex);
			} else if (evt.target.name == "leftImgBtn") {
				swfIndex--;

				if (swfIndex < 1) {
					swfIndex=1;
					if (swfIndex == this.pageCount)
						this.starEffect.setStarPos(this.wlv % 10 - 1);
				} else {
					this.leftImgBtn.visible=true;
					this.starEffect.setStarPos(9);
				}

				this.rightImgBtn.visible=true;

				this.updateEffect(swfIndex);
			} else if (evt.target.name == "showBtn") {
//				swfIndex=this.lv;
				
				UILayoutManager.getInstance().show(WindowEnum.SHIYI);
				TweenLite.delayedCall(0.6, UIManager.getInstance().shiyeWnd.setTabIndex, [3]);
				
//				this.updateEffect(this.lv);
//				Cmd_Wig.cm_WigShow();
			} else if (evt.target.name == "wingTradeBtn") {

				UIManager.getInstance().mountLvUpwnd.hide();
				UIManager.getInstance().mountTradeWnd.hide();
				UIManager.getInstance().wingLvUpWnd.hide();
				UIManager.getInstance().hideWindow(WindowEnum.QUICK_BUY);

				if (UIManager.getInstance().wingTradeWnd.isShow) {
					UIManager.getInstance().wingTradeWnd.hide();
				} else
					UILayoutManager.getInstance().show(WindowEnum.ROLE, WindowEnum.WING_FLY); //, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y);

			}


		}

		override public function hide():void {
			super.hide();
		}

		override public function get width():Number {
			return 501;
		}

		override public function get height():Number {
			return 443;
		}

	}
}

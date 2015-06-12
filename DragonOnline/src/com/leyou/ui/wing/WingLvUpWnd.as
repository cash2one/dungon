package com.leyou.ui.wing {

	import com.ace.config.Core;
	import com.ace.enum.FontEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.scene.ui.effect.StarChangeEffect;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.SoundManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.ui.window.children.SimpleWindow;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Wig;
	import com.leyou.ui.quickBuy.QuickBuyWnd;
	import com.leyou.utils.EffectUtil;
	import com.leyou.utils.PropUtils;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	public class WingLvUpWnd extends AutoWindow {

		private var autoUpBtn:ImgLabelButton;
		private var upBtn:ImgLabelButton;
		private var itemNumLbl:Label;
		private var moneyNumLbl:Label;
		private var itemNameLbl:Label;

		private var wishLbl:Label;
		private var jieImg:Image;
		private var wingNameImg:Image;
		private var goldImg:Image;
		private var tipImg:Image;
		private var modeSwf:SwfLoader;

		private var wishProScaleBitMap:ScaleBitmap;

		private var autoTimeID:int=0;
		private var autoLv:int=0;
		private var info:Object;

		private var win:SimpleWindow;
		private var starEffect:StarChangeEffect;

		private var infoxml:XML;

		private var effectBg:SwfLoader;
		private var tipsinfo:TipsInfo;

		/**
		 *单前经验
		 */
		private var currentExp:int=-1;

		private var successEffect:SwfLoader;

		public function WingLvUpWnd() {
			super(LibManager.getInstance().getXML("config/ui/wing/wingLvUpWnd.xml"));
			this.init();
			this.hideBg();
		}

		private function init():void {

			this.autoUpBtn=this.getUIbyID("autoUpBtn") as ImgLabelButton;
			this.upBtn=this.getUIbyID("upBtn") as ImgLabelButton;

			this.itemNumLbl=this.getUIbyID("itemNumLbl") as Label;
			this.itemNameLbl=this.getUIbyID("itemNameLbl") as Label;
			this.moneyNumLbl=this.getUIbyID("moneyNumLbl") as Label;
			this.wishLbl=this.getUIbyID("wishLbl") as Label;

			this.jieImg=this.getUIbyID("jieImg") as Image;
			this.wingNameImg=this.getUIbyID("wingNameImg") as Image;
			this.goldImg=this.getUIbyID("goldImg") as Image;
			this.tipImg=this.getUIbyID("tip2Img") as Image;

			this.modeSwf=this.getUIbyID("modeSwf") as SwfLoader;

			this.wishProScaleBitMap=this.getUIbyID("wishProScaleBitMap") as ScaleBitmap;

			this.autoUpBtn.addEventListener(MouseEvent.CLICK, this.onbtnClick);
			this.upBtn.addEventListener(MouseEvent.CLICK, this.onbtnClick);
			this.itemNameLbl.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.itemNameLbl.addEventListener(MouseEvent.CLICK, onClick);
			this.itemNameLbl.mouseEnabled=true;

			this.clsBtn.y=40;

			this.tipsinfo=new TipsInfo();
			this.tipsinfo.itemid=ConfigEnum.WingItem;

			this.successEffect=new SwfLoader(99909);

			this.itemNameLbl.styleSheet=FontEnum.DEFAULT_LINK_STYLE;

			successEffect.visible=false;
			this.addChild(this.successEffect);
			this.successEffect.x=this.width / 2;
			this.successEffect.y=this.height / 2;

			this.upBtn.setToolTip(TableManager.getInstance().getSystemNotice(1210).content);
			this.autoUpBtn.setToolTip(TableManager.getInstance().getSystemNotice(1211).content);

			this.allowDrag=false;

			this.starEffect=new StarChangeEffect(10, true);
			this.addChild(this.starEffect);
			this.starEffect.x=52;
			this.starEffect.y=363.25;

//			this.effectBg=new SwfLoader();
//			this.addChildAt(this.effectBg,this.getChildIndex(this.tipImg)-1);
//			this.effectBg.parent.addChildAt(this.effectBg, 3);

//			this.effectBg.mouseChildren=this.effectBg.mouseEnabled=false;

			this.modeSwf.x=146;
			this.modeSwf.y=390;

//			this.modeSwf.opaqueBackground=0xff0000;
			this.modeSwf.mouseChildren=this.modeSwf.mouseEnabled=false;
			this.mouseEnabled=false;

//			this.wishLbl.setToolTip(TableManager.getInstance().getSystemNotice(1212).content);

			var einfo:MouseEventInfo=new MouseEventInfo();
			einfo.onMouseMove=onTipMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.tipImg, einfo);

			einfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.goldImg, einfo);
		}

		private function onTipMouseOver(e:DisplayObject):void {
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(1212).content, new Point(this.stage.mouseX, this.stage.mouseY));
		}

		private function onTipsMouseOver(e:DisplayObject):void {
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9555).content, new Point(this.stage.mouseX, this.stage.mouseY));
		}

		private function onTipsMouseOut(e:DisplayObject):void {
			ToolTipManager.getInstance().hide();
		}

		private function buyItem():Boolean {
			var arr:Array=this.itemNumLbl.text.split(" x ");

			if (MyInfoManager.getInstance().getBagItemNumByName(this.itemNameLbl.text) >= int(arr[1])) {
				return false;
			}

			if (!UIManager.getInstance().quickBuyWnd.isAutoBuy(ConfigEnum.WingItem, ConfigEnum.WingbindItem)) {
				UILayoutManager.getInstance().show(WindowEnum.ROLE, WindowEnum.QUICK_BUY, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y + 40);
				UIManager.getInstance().quickBuyWnd.pushItem(ConfigEnum.WingItem, ConfigEnum.WingbindItem, arr[1]);

				NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(1203), [PropUtils.getStringById(1610)]);
				return true;
			} else {

//				if (MyInfoManager.getInstance().getBagEmptyGridIndex(ConfigEnum.WingItem, int(arr[1])) == -1 || MyInfoManager.getInstance().getBagEmptyGridIndex(ConfigEnum.WingbindItem, int(arr[1])) == -1) {
//					NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(1610));
//					NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(1215));
//					return true;
//				}
//
//				UIManager.getInstance().quickBuyWnd.getItemNotShow(ConfigEnum.WingItem, ConfigEnum.WingbindItem, arr[1]);
			}

			return false;
		}

		private function onbtnClick(evt:MouseEvent):void {

			if (evt.target.name == "autoUpBtn") {

				if (this.autoUpBtn.text.indexOf(PropUtils.getStringById(1986)) > -1) {
					win=PopupManager.showConfirm(PropUtils.getStringById(1987), startEvo, function():void{
					trace("ffeeeeeeeeeeee");
					}, false, "wingLv");
				} else {

					clearInterval(this.autoTimeID);
					autoUpBtn.text=PropUtils.getStringById(1986);
					win=null;
					this.autoTimeID=0;
					upBtn.setActive(true, 1, true);

				}

			} else if (evt.target.name == "upBtn") {
				this.updateAutoLv();
			}

		}

		private function startEvo():void {
			autoUpBtn.text=PropUtils.getStringById(1988);
			upBtn.setActive(false, .6, true);
			autoTimeID=setInterval(updateAutoLv, 1000);
			updateAutoLv();
			autoLv=info.wlv;

		}

		public function updateAutoLv():void {

			var arr:Array=this.itemNumLbl.text.split(" x ");
			// || (MyInfoManager.getInstance().getBagItemNumByName(this.itemNameLbl.text) < int(arr[1])) 
			if (this.buyItem() || Core.me.info.level < int(infoxml.@Wing_OL) || UIManager.getInstance().backpackWnd.jb < int(this.moneyNumLbl.text)) {

				if (UIManager.getInstance().backpackWnd.jb < int(this.moneyNumLbl.text)) {
					NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(1204));
				} else if (Core.me.info.level < int(infoxml.@Wing_OL)) {
					NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(1206));
				}

				if (autoTimeID != 0) {
					NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(1205));
					clearInterval(this.autoTimeID);
					autoUpBtn.text=PropUtils.getStringById(1986);
					this.autoTimeID=0;
				}

				upBtn.setActive(true, 1, true);
				win=null;
				return;
			}

			upBtn.setActive(false, .6, true);

			if (MyInfoManager.getInstance().getBagItemNumByName(this.itemNameLbl.text) < int(arr[1]) && UIManager.getInstance().quickBuyWnd.isAutoBuy(ConfigEnum.WingItem, ConfigEnum.WingbindItem)) {
				Cmd_Wig.cm_WigUpgrade((UIManager.getInstance().quickBuyWnd.getCost(ConfigEnum.WingItem, ConfigEnum.WingbindItem) == 0 ? 2 : 1));
			} else {
				Cmd_Wig.cm_WigUpgrade();
			}
		}

		public function changeState(i:int):void {

			if (i == 0) {
				NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(1205));
				if (autoTimeID != 0) {
					clearInterval(this.autoTimeID);
					autoUpBtn.text=PropUtils.getStringById(1986);
					this.autoTimeID=0;
				}

				upBtn.setActive(true, 1, true);
			}
		}


		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
		}

		private function onClick(e:MouseEvent):void {
			var swnd:QuickBuyWnd=UIManager.getInstance().creatWindow(WindowEnum.QUICK_BUY) as QuickBuyWnd;
			swnd.pushItem(ConfigEnum.WingItem, ConfigEnum.WingbindItem);
			UILayoutManager.getInstance().show(WindowEnum.ROLE, WindowEnum.QUICK_BUY, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y + 40);
		}

		private function onMouseMove(e:MouseEvent):void {
			ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, tipsinfo, new Point(e.stageX, e.stageY));
		}

		public function update(xml:XML, o:Object):void {

			if (o != null)
				this.info=o;

			if (xml != null)
				this.infoxml=xml;

			if (o.hasOwnProperty("exp") && this.currentExp != o.exp) {

				if (int(o.exp) / int(xml.@Wish_Exp) <= 1) {
					this.wishProScaleBitMap.visible=(int(o.exp) != 0);
					this.wishProScaleBitMap.setSize(int(o.exp) / int(xml.@Wish_Exp) * 220, 12);
				} else
					this.wishProScaleBitMap.setSize(220, 12);

				this.wishLbl.text=o.exp; // + "/" + xml.@Wish_Exp;
				var diff:int=int(o.exp - this.currentExp);

				if (o.hasOwnProperty("wlv") && int(o.wlv) != this.autoLv && this.autoLv != 0 && this.autoTimeID != 0) {
					this.autoUpBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					diff=int(xml.@Wish_Exp) - int(this.currentExp);

					this.successEffect.visible=true;

//					if (successEffect.isLoaded)
					successEffect.playAct(PlayerEnum.ACT_STAND, -1, false, function():void {
						successEffect.visible=false;
					});


					SoundManager.getInstance().play(23);
				}

				if (this.autoTimeID == 0)
					upBtn.setActive(true, 1, true);

				if (this.visible) {
					var p:Point=this.localToGlobal(new Point(130, 380));
					EffectUtil.flyWordEffect("+ " + diff + " " + PropUtils.getStringById(1989), p);
				}

				this.currentExp=o.exp;
			}

			var titem:TItemInfo=TableManager.getInstance().getItemInfo(ConfigEnum.WingItem);
			this.itemNameLbl.htmlText="<font color='#00ff00'><u><a href='event:56'>" + titem.name + "</a></u></font>";
			this.itemNumLbl.htmlText=" x " + xml.@WingOL_Num;
			this.moneyNumLbl.text="" + xml.@money;

			if (o.hasOwnProperty("wlv"))
				this.starEffect.setStarPos(o.wlv % 10 - 1);

			if (o.hasOwnProperty("lv")) {

				var wlv:int=o.lv;
				if (o.wlv % 10 == 9)
					wlv=wlv + 1;

				if (o.lv == 10)
					wlv=10;

				this.jieImg.updateBmp("ui/horse/horse_lv" + (wlv) + ".png");
				this.wingNameImg.updateBmp("ui/wing/wing_lv" + (wlv) + "_name.png");

				var pnid:int=38000 + (wlv - 1);

				this.modeSwf.update(pnid);
				this.modeSwf.mouseChildren=this.modeSwf.mouseEnabled=false;
				this.autoLv=o.wlv;
			}
		}

		override public function hide():void {

			if (this.visible) {
				super.hide();
				UILayoutManager.getInstance().composingWnd(WindowEnum.ROLE);
			}

			clearInterval(this.autoTimeID);
			autoUpBtn.text=PropUtils.getStringById(1986);

			if (win != null) {
				win.hide();
				win=null;
			}

			upBtn.setActive(true, 1, true);
			this.autoTimeID=0;
		}

		public function resise():void {

//			if (this.isShow) {
//				if (UIManager.getInstance().roleWnd.isShow) {
//					UIManager.getInstance().roleWnd.setPos(3);
//					this.x=UIManager.getInstance().roleWnd.x + UIManager.getInstance().roleWnd.width;
//					this.y=UIManager.getInstance().roleWnd.y;
//				} else {
//					this.x=(UIEnum.WIDTH - this.width) / 2;
//					this.y=(UIEnum.HEIGHT - this.height) / 2;
//				}
//			}

		}

		override public function get width():Number {
			return 306
		}

		override public function get height():Number {
			return 524;
		}

	}
}

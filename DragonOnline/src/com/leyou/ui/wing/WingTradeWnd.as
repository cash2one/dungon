package com.leyou.ui.wing {

	import com.ace.config.Core;
	import com.ace.enum.FontEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TWing_Trade;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.greensock.OverwriteManager;
	import com.greensock.TweenMax;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Wig;
	import com.leyou.ui.quickBuy.QuickBuyWnd;
	import com.leyou.utils.EffectUtil;
	import com.leyou.utils.PropUtils;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	public class WingTradeWnd extends AutoWindow {

		private var ptxt:Array=[];
		private var patxtArr:Array=[]

		private var unitroll:RollNumWidget;
		private var levelroll:RollNumWidget;

		private var itemNameLbl:Label;
		private var itemNumLbl:Label;
		private var moneyNumLbl:Label;
		private var goldImg:Image;

		private var effectSwf:SwfLoader;

		private var autoUpBtn:ImgLabelButton;
		private var upBtn:ImgLabelButton;

		private var x1ImgArr:Array=[];

		private var autoTime:int=0;

		private var lv:int=0;
		private var flvv:int=0;

		private var tipInfo:TipsInfo;

		private var spr:Sprite;
		private var tipsSpr:Sprite;

		private var succEffect:SwfLoader;

		private var tipsStr:String;

		private var tweenmax:TweenMax;
		private var ulevel:int=-1;

		private var pArr:Array=[0, 3, 4];
		private var flyLv:int=0;

		public function WingTradeWnd() {
			super(LibManager.getInstance().getXML("config/ui/wing/wingTradeWnd.xml"));
			this.init();
			this.hideBg();
			this.clsBtn.y=40;
			this.allowDrag=false;
		}

		private function init():void {

			var lb:Label;
			for (var i:int=0; i < 10; i++) {

				if (i < 5) {
					this.ptxt.push(this.getUIbyID("p" + (i + 1) + "txt") as Label);
					this.patxtArr.push(this.getUIbyID("pa" + (i + 1) + "txt") as Label);
				}

				lb=this.getUIbyID("ntxt" + i) as Label;
				if (lb != null) {
					lb.setToolTip(TableManager.getInstance().getSystemNotice(9500 + i).content);
				}

				this.x1ImgArr.push(this.getUIbyID("x" + (i + 1) + "Img") as Image);
			}

			this.itemNameLbl=this.getUIbyID("itemNameLbl") as Label;
			this.itemNumLbl=this.getUIbyID("itemNumLbl") as Label;
			this.moneyNumLbl=this.getUIbyID("moneyNumLbl") as Label;
			this.goldImg=this.getUIbyID("goldImg") as Image;
			this.effectSwf=this.getUIbyID("effectSwf") as SwfLoader;

			this.autoUpBtn=this.getUIbyID("autoUpBtn") as ImgLabelButton;
			this.upBtn=this.getUIbyID("upBtn") as ImgLabelButton;

			this.autoUpBtn.setToolTip(TableManager.getInstance().getSystemNotice(1226).content);
			this.upBtn.setToolTip(StringUtil.substitute(TableManager.getInstance().getSystemNotice(1225).content, [ConfigEnum.wing15, ConfigEnum.wing16]));

			this.unitroll=new RollNumWidget();
			this.unitroll.loadSource("ui/num/{num}_zdl.png");
			this.addChild(this.unitroll);

			this.levelroll=new RollNumWidget();
			this.levelroll.loadSource("ui/num/{num}_zdl.png");
//			this.addChild(this.levelroll);

			this.itemNameLbl.styleSheet=FontEnum.DEFAULT_LINK_STYLE;

			this.itemNameLbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.itemNameLbl.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.itemNameLbl.addEventListener(MouseEvent.CLICK, onClick);
			this.itemNameLbl.mouseEnabled=true;

			this.autoUpBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.upBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.tipInfo=new TipsInfo();
			this.tipInfo.itemid=ConfigEnum.wing13;

			this.spr=new Sprite();
			this.spr.graphics.beginFill(0x00);
			this.spr.graphics.drawRect(0, 0, 90, 90);
			this.spr.graphics.endFill();

			this.addChild(this.spr);
			this.spr.alpha=0;

			this.effectSwf.mask=this.spr;

			this.spr.x=107;
			this.spr.y=286 + 90;

			this.tipsSpr=new Sprite();
			this.tipsSpr.graphics.beginFill(0x00);
			this.tipsSpr.graphics.drawRect(0, 0, 90, 90);
			this.tipsSpr.graphics.endFill();

			this.addChild(this.tipsSpr);
			this.tipsSpr.alpha=0;

			this.tipsSpr.x=107;
			this.tipsSpr.y=286;

			this.tipsSpr.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.tipsSpr.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			this.succEffect=new SwfLoader(99904);
			this.addChild(this.succEffect);

			this.succEffect.visible=false;

			this.succEffect.x=this.x1ImgArr[0].x + 5;
			this.succEffect.y=this.x1ImgArr[0].y + 5;

			var einfo:MouseEventInfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.goldImg, einfo);

		}

		private function onTipsMouseOver(e:DisplayObject):void {
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9555).content, new Point(this.stage.mouseX, this.stage.mouseY));
		}

		private function onTipsMouseOut(e:DisplayObject):void {
			ToolTipManager.getInstance().hide();
		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "autoUpBtn":

					if (autoTime == 0) {
						PopupManager.showConfirm(TableManager.getInstance().getSystemNotice(1218).content, function():void {

							autoUpBtn.text=PropUtils.getStringById(1990);
							upBtn.setActive(false, .6, true);
//							autoUpBtn.setActive(false, .6, true);
							autoTime=setInterval(updateUpgrade, 2000);
							updateUpgrade();
						}, null, false, "wingFly");
					} else {
//						autoUpBtn.text="自动飞升";
						this.clearBtnState();
					}
					break;
				case "upBtn":

					this.upBtn.setActive(false, .6, true);
					this.autoUpBtn.setActive(false, .6, true);
					this.updateUpgrade();
					break;
				case "itemNameLbl":
					var swnd:QuickBuyWnd=UIManager.getInstance().creatWindow(WindowEnum.QUICK_BUY) as QuickBuyWnd;
					swnd.pushItem(ConfigEnum.wing14, ConfigEnum.wing13);
					UILayoutManager.getInstance().show(WindowEnum.ROLE, WindowEnum.QUICK_BUY, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y + 40);
					break;
			}

		}

		private function onMouseOver(e:MouseEvent):void {
			if (e.target == this.tipsSpr)
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, this.tipsStr, new Point(e.stageX, e.stageY));
			else
				ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, this.tipInfo, new Point(e.stageX, e.stageY));
		}

		private function onMouseOut(e:MouseEvent):void {
			ToolTipManager.getInstance().hide();
		}

		public function updateInfo(o:Object):void {

			for (var i:int=0; i < pArr.length; i++) {

				this.ptxt[pArr[i]].text="";
				this.patxtArr[pArr[i]].text="";
			}

			var winfo:TWing_Trade;
			var winfo2:TWing_Trade;

			var ulv:int=0;
			var flv:int=o.flyl;
			var flyv:int=o.flyl;
			flvv=o.flyv;

			if (flv == 0) {

				this.unitroll.setNum(flv + 1);
				this.levelroll.setNum(flv);
				this.setEnbaleStar(1);

				ulv=1;

				winfo2=TableManager.getInstance().getWingTradeByID(flv + 1);

				for (i=0; i < pArr.length; i++) {
					this.ptxt[pArr[i]].text="+0%";
					this.patxtArr[pArr[i]].text="+" + winfo2.rate + "%";
				}

				flv=1;
			} else if (flv == TableManager.getInstance().getWingTradeMaxIDByID()) {

				winfo=TableManager.getInstance().getWingTradeByID(flv);
				winfo2=TableManager.getInstance().getWingTradeByID(flv);

				this.unitroll.setNum(winfo.unit);
				this.levelroll.setNum(winfo.level);

//				this.ulevel=(winfo.level == 10 ? 10 : winfo.level + 1);
				ulv=winfo2.level;

				this.setEnbaleStar(this.ulevel);

				for (i=0; i < pArr.length; i++) {
					this.ptxt[pArr[i]].text="+" + winfo.rate + "%";
					this.patxtArr[pArr[i]].text="";
				}

				this.autoUpBtn.setToolTip(TableManager.getInstance().getSystemNotice(1227).content);
				this.upBtn.setToolTip(TableManager.getInstance().getSystemNotice(1227).content);

			} else {

				winfo=TableManager.getInstance().getWingTradeByID(flv);
				winfo2=TableManager.getInstance().getWingTradeByID(flv + 1);

				this.unitroll.setNum(winfo2.unit);
				this.levelroll.setNum(winfo2.level);
				ulv=winfo2.level;

				this.setEnbaleStar(this.ulevel);

				for (i=0; i < pArr.length; i++) {
					this.ptxt[pArr[i]].text="+" + winfo.rate + "%";
					this.patxtArr[pArr[i]].text="+" + winfo2.rate + "%";
				}

				flv+=1;
			}

			this.spr.scaleY=-(flvv / winfo2.exp);
			this.tipsStr=StringUtil.substitute(TableManager.getInstance().getSystemNotice(1219).content, [flvv, winfo2.exp, int(flvv / winfo2.exp * 100) + "%"]);

			if (o.flyl != TableManager.getInstance().getWingTradeMaxIDByID()) {
				if (ulv != this.ulevel) {
					
					if (tweenmax != null) {
						tweenmax.pause();
						tweenmax.kill();
						
						this.x1ImgArr[this.ulevel - 1].alpha=1;
					}
					
					this.ulevel=ulv;
					
					this.x1ImgArr[this.ulevel - 1].alpha=1;
					tweenmax=TweenMax.to(this.x1ImgArr[this.ulevel - 1], 1.5, {alpha: 0, overwrite: OverwriteManager.ALL_IMMEDIATE, repeat: -1, yoyo: true});
				}
				
				
			}

			this.unitroll.x=140 + (30 - this.unitroll.width) / 2;
			this.unitroll.y=83;

			this.levelroll.x=169 + (30 - this.levelroll.width) / 2;
			this.levelroll.y=83;

			this.itemNameLbl.text="" + TableManager.getInstance().getItemInfo(ConfigEnum.wing13).name; // + " x <font color='#ffff00'>" + TableManager.getInstance().getWingTradeByID(flv).itemNum+"</font>";
			this.itemNumLbl.text=" x " + TableManager.getInstance().getWingTradeByID(flv).itemNum;
			this.moneyNumLbl.text="" + TableManager.getInstance().getWingTradeByID(flv).money;

			this.itemNumLbl.x=this.itemNameLbl.x + this.itemNameLbl.textWidth + 3;

			if (this.lv != flyv) {
				this.clearBtnState();

				if (flyv != TableManager.getInstance().getWingTradeMaxIDByID()) {
					this.succEffect.x=this.x1ImgArr[winfo.level - 1].x + 5;
					this.succEffect.y=this.x1ImgArr[winfo.level - 1].y + 5;

					this.succEffect.visible=true;
					this.succEffect.playAct(PlayerEnum.ACT_STAND, -1, false, function():void {
						succEffect.visible=false;
					});
				}

			} else {
				if (this.autoTime == 0) {
					this.upBtn.setActive(true, 1, true);
					this.autoUpBtn.setActive(true, 1, true);
				}
			}

			if (flyv == TableManager.getInstance().getWingTradeMaxIDByID()) {
				this.upBtn.setActive(false, 0.6, true);
				this.autoUpBtn.setActive(false, 0.6, true);
			}

			this.lv=flyv;

		}

		private function updateUpgrade():void {

			var arr:Array=this.itemNumLbl.text.split(" x ");

			if (MyInfoManager.getInstance().getBagItemNumByName(itemNameLbl.text) < int(arr[1]) && !UIManager.getInstance().quickBuyWnd.isAutoBuy(ConfigEnum.wing14, ConfigEnum.wing13)) {

				if (ConfigEnum.MarketOpenLevel <= Core.me.info.level)
					UILayoutManager.getInstance().show(WindowEnum.ROLE, WindowEnum.QUICK_BUY, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y + 40);

				UIManager.getInstance().quickBuyWnd.pushItem(ConfigEnum.wing14, ConfigEnum.wing13, int(arr[1]));

				this.clearBtnState();
//				return;
			}

//			if (UIManager.getInstance().backpackWnd.jb < int(this.itemNumLbl.text)) {
//				
//
//
//			}

//			var arr:Array=this.itemNumLbl.text.split(" x ");
			if (MyInfoManager.getInstance().getBagItemNumByName(itemNameLbl.text) < int(arr[1]) && UIManager.getInstance().quickBuyWnd.isAutoBuy(ConfigEnum.wing14, ConfigEnum.wing13)) {
				Cmd_Wig.cm_WigFly((UIManager.getInstance().quickBuyWnd.getCost(ConfigEnum.wing14, ConfigEnum.wing13) == 0 ? 2 : 1));
			} else {
				Cmd_Wig.cm_WigFly();
			}

		}


		public function onSuccess(o:Object):void {
			if (o.rst == 0) {
				this.clearBtnState();
			} else {
				if (o.flyv > 0)
					EffectUtil.flyWordEffect(StringUtil.substitute(TableManager.getInstance().getSystemNotice(1223).content, [int(o.flyv) - flvv]), this.localToGlobal(new Point(this.effectSwf.x + 10, this.effectSwf.y + 25)), "#00ff00");
			}

			this.updateInfo(o);
		}

		private function clearBtnState():void {
			clearInterval(this.autoTime);
			this.autoTime=0;
			autoUpBtn.text=PropUtils.getStringById(1991);
			this.upBtn.setActive(true, 1, true);
			this.autoUpBtn.setActive(true, 1, true);
		}

		private function setEnbaleStar(_i:int):void {

			for (var i:int=0; i < 10; i++) {
				if (i < _i)
					this.x1ImgArr[i].updateBmp("ui/tips/icon_xx.png");
				else
					this.x1ImgArr[i].updateBmp("ui/tips/icon_xxx.png");
			}
		}

		override public function hide():void {

			if (this.visible) {
				super.hide();
				UILayoutManager.getInstance().composingWnd(WindowEnum.ROLE);
			}

			clearInterval(this.autoTime);
			this.autoTime=0;

			if (this.lv != TableManager.getInstance().getWingTradeMaxIDByID()) {
				this.upBtn.setActive(true, 1, true);
				this.autoUpBtn.setActive(true, 1, true);
			}

//			this.clearBtnState();
		}

		override public function get width():Number {
			return 306;
		}

		override public function get height():Number {
			return 524;
		}
	}
}

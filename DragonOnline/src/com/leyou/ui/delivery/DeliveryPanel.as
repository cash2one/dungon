package com.leyou.ui.delivery {

	import com.ace.config.Core;
	import com.ace.enum.EventEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.EventManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Yct;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;

	import flash.events.MouseEvent;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	public class DeliveryPanel extends AutoWindow {

		private var progressImg:Image;
		private var ppImg:Image;

		private var progressLbl:Label;
		private var mapLbl:Label;
		private var ppLbl:Label;

		private var flyBtn:ImgButton;

		private var enterBtn:NormalButton;
		private var trackBtn:NormalButton;

		private var endSt:int=0;
		private var _hp:Number=0;

		public function DeliveryPanel() {
			super(LibManager.getInstance().getXML("config/ui/delivery/deliveryPanel.xml"));
			this.init();
			this.hideBg();
			this.clsBtn.visible=false;
		}

		private function init():void {

			this.progressImg=this.getUIbyID("progressImg") as Image;
			this.ppImg=this.getUIbyID("ppImg") as Image;

			this.progressLbl=this.getUIbyID("progressLbl") as Label;

			this.mapLbl=this.getUIbyID("mapLbl") as Label;
			this.ppLbl=this.getUIbyID("ppLbl") as Label;

			this.flyBtn=this.getUIbyID("flyBtn") as ImgButton;

			this.enterBtn=this.getUIbyID("enterBtn") as NormalButton;
			this.trackBtn=this.getUIbyID("trackBtn") as NormalButton;

			this.flyBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.enterBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.trackBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.flyBtn.addEventListener(MouseEvent.MOUSE_OVER, onTrOverBtn);
			this.flyBtn.doubleClickEnabled=false;

			this.ppLbl.htmlText="";
			this.ppImg.visible=false;
		}

		private function onTrOverBtn(e:MouseEvent):void {
			this.flyBtn.setToolTip(com.ace.utils.StringUtil.substitute(TableManager.getInstance().getSystemNotice(9937).content, [MyInfoManager.getInstance().VipLastTransterCount]));
		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "flyBtn":
					if (ConfigEnum.MarketOpenLevel <= Core.me.info.level) {
						var tinfo:TItemInfo=TableManager.getInstance().getItemInfo(ConfigEnum.traveItem);

						if (MyInfoManager.getInstance().VipLastTransterCount == 0 && MyInfoManager.getInstance().getBagItemNumByName(tinfo.name) <= 0) {

							if (!UIManager.getInstance().quickBuyWnd.isAutoBuy(ConfigEnum.traveItem, ConfigEnum.traveBindItem)) {
								UILayoutManager.getInstance().show(WindowEnum.ROLE, WindowEnum.QUICK_BUY, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y + 40);
								UIManager.getInstance().quickBuyWnd.pushItem(ConfigEnum.traveItem, ConfigEnum.traveBindItem);
								return;
							} else {
								UIManager.getInstance().quickBuyWnd.getItemNotShow(ConfigEnum.traveItem, ConfigEnum.traveBindItem);
							}
						}
					}

					EventManager.getInstance().dispatchEvent(EventEnum.SCENE_TRANS, true);
					Cmd_Yct.cm_DeliveryTrackCart(2);
					break;
				case "enterBtn":

					if (this.enterBtn.text.indexOf(PropUtils.getStringById(1677)) > -1) {
						Cmd_Yct.cm_DeliveryEnterCart();
					} else if (this.enterBtn.text.indexOf(PropUtils.getStringById(1678)) > -1) {
						Cmd_Yct.cm_DeliveryQuitCart()
					}

					break;
				case "trackBtn":
					Cmd_Yct.cm_DeliveryTrackCart();
					break;
			}

		}

		/**
		 * @param v,true 已进入;false,已离开;
		 */
		public function changeEnterCartState(v:Boolean):void {
			if (v) {
				this.enterBtn.text=PropUtils.getStringById(1679);
				this.flyBtn.setActive(false, .6, true);
				this.trackBtn.setActive(false, .6, true);

				UIManager.getInstance().rightTopWnd.hideBar(1);
			} else {
				this.enterBtn.text=PropUtils.getStringById(1680);

				if (endSt == 0) {
					this.flyBtn.setActive(true, 1, true);
					this.trackBtn.setActive(true, 1, true);
				}

				UIManager.getInstance().rightTopWnd.showBar(1);
			}
		}

		public function updateInfo(o:Object):void {

			if (endSt != 0)
				clearInterval(endSt);

			ppLbl.visible=false;
			ppImg.visible=false;

			endSt=0;
			enterBtn.setActive(true, 1, true);
			trackBtn.setActive(true, 1, true);
			flyBtn.setActive(true, 1, true);

			var hp:Number=Number(int(o.shp.replace("%", "")) / 100);
			this.progressLbl.text=o.shp + "";
			this.progressImg.scaleX=hp;

			this.mapLbl.text="" + o.cpos;

			if (hp < this._hp)
				this.updateDesc(TableManager.getInstance().getSystemNotice(4514).content);

			this._hp=hp;
		}

		public function updateDesc(s:String):void {
			if (s.indexOf("<") > -1) {
				this.ppLbl.htmlText=com.leyou.utils.StringUtil_II.getBreakLineStringByCharIndex(s, 52) + "";
			} else
				this.ppLbl.htmlText=com.leyou.utils.StringUtil_II.getBreakLineStringByCharIndex(s, 22) + "";

			this.ppImg.visible=true;
			this.ppLbl.visible=true;

			TweenLite.delayedCall(5, function():void {
				ppLbl.visible=false;
				ppImg.visible=false;
			});

		}

		public function updateEndDesc(s:String):void {

			this.ppLbl.htmlText=com.leyou.utils.StringUtil_II.getBreakLineStringByCharIndex(s, 52) + "";
			this.ppImg.visible=true;
			this.ppLbl.visible=true;

			this.enterBtn.setActive(false, .6, true);
			this.trackBtn.setActive(false, .6, true);
			this.flyBtn.setActive(false, .6, true);

			endSt=setInterval(endhide, 10000);
		}

		private function endhide():void {

			ppLbl.visible=false;
			ppImg.visible=false;

			enterBtn.setActive(true, 1, true);
			trackBtn.setActive(true, 1, true);
			flyBtn.setActive(true, 1, true);

			if (endSt != 0)
				clearInterval(endSt);

			endSt=0;
			closehide();
		}

		public function closehide():void {
			super.hide();
		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
			this.resize();
		}

		public function resize():void {
			this.x=UIEnum.WIDTH / 2 - this.width;
			this.y=UIEnum.HEIGHT / 2; // + 166;
		}

		override public function hide():void {


		}

	}
}

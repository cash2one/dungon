package com.leyou.ui.ttsc {

	import com.ace.config.Core;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.leyou.net.cmd.Cmd_ddsc;
	import com.leyou.ui.shop.child.ShopGrid;
	import com.leyou.utils.PayUtil;

	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class TtscWnd extends AutoWindow {

		private var topupBtn:ImgButton;
		private var bgImg:Image;

		private var gridVec:Vector.<ShopGrid>;

		private var st:int=-1;
		private var succst:int=-1;
		private var flyArr:Array=[[], [], []];


		public function TtscWnd() {
			super(LibManager.getInstance().getXML("config/ui/ttsc/ttscWnd.xml"));
			this.init();
			this.hideBg();
			this.mouseChildren=true;
//			this.mouseEnabled=true;
		}

		private function init():void {
			this.topupBtn=this.getUIbyID("topupBtn") as ImgButton;
			this.bgImg=this.getUIbyID("bgImg") as Image;

			this.clsBtn.x=640;
			this.clsBtn.y=100;

			this.topupBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.gridVec=new Vector.<ShopGrid>();
		}

		private function onClick(e:MouseEvent):void {
			if (st == 1)
				Cmd_ddsc.cm_DdscConfirm();
			else if (st == 0) {
//				navigateToURL(new URLRequest(Core.URL_PAY), "_blank");
				PayUtil.openPayUrl()
			}
		}

		/**
		 *st  -- 状态(0不可领取,1可领取,2已领取)
		 * @param o
		 *
		 */
		public function updateInfo(o:Object):void {

			UIManager.getInstance().adWnd.setStateTtsc((o.st != 0));

			if (UIManager.getInstance().isCreate(WindowEnum.MARKET)) {
				UIManager.getInstance().marketWnd.setADStateTtsc((o.st != 0));
			}

//			if (!this.visible && o.st == 2)
//				return;

			UIManager.getInstance().showPanelCallback(WindowEnum.TOPUP);

			var render:ShopGrid;
			for each (render in this.gridVec) {
				this.removeChild(render);
			}

			this.gridVec.length=0;

			var listArr:Array=o.jlist;
			if (o.st == 2)
				listArr=o.mjlist;

			var info:Object;

			for (var i:int=0; i < listArr.length; i++) {
				render=new ShopGrid();

				this.addChild(render);
				this.gridVec.push(render);

				info=TableManager.getInstance().getItemInfo(listArr[i][0]);
				if (info == null)
					info=TableManager.getInstance().getEquipInfo(listArr[i][0]);

				render.type=2;
				render.updataInfo(info);
				if (listArr[i][1] > 1)
					render.numLblTxt=listArr[i][1];

				render.x=298 + i * (82);
				render.y=211;

			}

			this.st=o.st;

			if (o.st == 0) {
				UIManager.getInstance().rightTopWnd.active("firstPayBtn");
				UIManager.getInstance().rightTopWnd.updateDDSC(false,true);
				this.topupBtn.updataBmd("ui/ttsc/btn_cdxq.jpg");

				this.topupBtn.visible=true;
				this.bgImg.updateBmp("ui/ttsc/mrsc_bg1.png");

			} else if (o.st == 2) {

				this.topupBtn.updataBmd("ui/ttsc/btn_lqjl.jpg");
				this.topupBtn.visible=false;
				UIManager.getInstance().rightTopWnd.active("firstPayBtn");
				UIManager.getInstance().rightTopWnd.updateDDSC(false,false);
				this.bgImg.updateBmp("ui/ttsc/mrsc_bg3.png");

				if (this.succst == -1 && this.visible) {

					flyArr=[[], [], []];
					for (i=0; i < this.gridVec.length; i++) {
						render=this.gridVec[i];

						flyArr[0].push(o.jlist[i][0]);
						flyArr[1].push(render.parent.localToGlobal(new Point(render.x, render.y)));
						flyArr[2].push([60, 60]);

					}

					FlyManager.getInstance().flyBags(flyArr[0], flyArr[1], flyArr[2]);
				}

				this.succst=1;

//				this.hide();
			} else {
				this.topupBtn.updataBmd("ui/ttsc/btn_lqjl.jpg");
				this.topupBtn.visible=true;
				UIManager.getInstance().rightTopWnd.active("firstPayBtn");

				UIManager.getInstance().rightTopWnd.updateDDSC(true,true);
				this.bgImg.updateBmp("ui/ttsc/mrsc_bg1.png");
			}
		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);


		}

		override public function sendOpenPanelProtocol(... parameters):void {
			this.dataModel=parameters;

			Cmd_ddsc.cm_DdscInit();

		}

		public function resise():void {
			this.x=(UIEnum.WIDTH - this.width) / 2;
			this.y=(UIEnum.HEIGHT - this.height) / 2;
		}

	}
}

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
	import com.leyou.net.cmd.Cmd_ddsc;
	import com.leyou.ui.shop.child.ShopGrid;
	import com.leyou.utils.PayUtil;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class TtscWnd extends AutoWindow {

		private var topupBtn:ImgButton;

		private var gridVec:Vector.<ShopGrid>;

		private var st:int=-1;

		public function TtscWnd() {
			super(LibManager.getInstance().getXML("config/ui/ttsc/ttscWnd.xml"));
			this.init();
			this.hideBg();
			this.mouseChildren=true;
//			this.mouseEnabled=true;
		}

		private function init():void {
			this.topupBtn=this.getUIbyID("topupBtn") as ImgButton;

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
			
			if(UIManager.getInstance().isCreate(WindowEnum.MARKET)){
				UIManager.getInstance().marketWnd.setADStateTtsc((o.st != 0));
			}
			
			if(!this.visible && o.st == 2)
				return ;
			
			UIManager.getInstance().showPanelCallback(WindowEnum.TOPUP);
			
			var render:ShopGrid;
			for each (render in this.gridVec) {
				this.removeChild(render);
			}

			this.gridVec.length=0;

			var info:Object;
			var flyArr:Array=[[], [], []];
			for (var i:int=0; i < o.jlist.length; i++) {
				render=new ShopGrid();

				this.addChild(render);
				this.gridVec.push(render);

				info=TableManager.getInstance().getItemInfo(o.jlist[i][0]);
				if (info == null)
					info=TableManager.getInstance().getEquipInfo(o.jlist[i][0]);

				render.type=2;
				render.updataInfo(info);
				render.numLblTxt=o.jlist[i][1];

				render.x=298 + i * (72);
				render.y=211;

				if (o.st == 2) {
					flyArr[0].push(info.id);
					flyArr[1].push(render.parent.localToGlobal(new Point(render.x, render.y)));
					flyArr[2].push([60, 60]);
				}

			}

			this.st=o.st;
			
			if (o.st == 0) {
				UIManager.getInstance().rightTopWnd.active("firstPayBtn");
				UIManager.getInstance().rightTopWnd.updateDDSC(false);
				this.topupBtn.updataBmd("ui/ttsc/btn_cdxq.jpg");

				this.topupBtn.setActive(true, 1, true);

			} else if (o.st == 2) {

				this.topupBtn.updataBmd("ui/ttsc/btn_lqjl.jpg");
				this.topupBtn.setActive(false, .6, true);
				UIManager.getInstance().rightTopWnd.deactive("firstPayBtn");
				UIManager.getInstance().rightTopWnd.updateDDSC(false);

				FlyManager.getInstance().flyBags(flyArr[0], flyArr[1], flyArr[2]);
				this.hide();
			} else {
				this.topupBtn.updataBmd("ui/ttsc/btn_lqjl.jpg");
				this.topupBtn.setActive(true, 1, true);
				UIManager.getInstance().rightTopWnd.active("firstPayBtn");

				UIManager.getInstance().rightTopWnd.updateDDSC(true);

			}
		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);

			
		}
		
		override public function sendOpenPanelProtocol(...parameters):void{
			this.dataModel=parameters;
			
			Cmd_ddsc.cm_DdscInit();
			
		}

		public function resise():void {
			this.x=(UIEnum.WIDTH - this.width) / 2;
			this.y=(UIEnum.HEIGHT - this.height) / 2;
		}

	}
}

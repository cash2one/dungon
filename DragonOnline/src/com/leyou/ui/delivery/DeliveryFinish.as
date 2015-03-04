package com.leyou.ui.delivery {


	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.net.cmd.Cmd_Yct;

	import flash.events.MouseEvent;

	public class DeliveryFinish extends AutoWindow {

		private var confirmBtn:NormalButton;
		private var confirmNpcBtn:NormalButton;
		private var cencelBtn:NormalButton;

		private var dropGoldLbl:Label;
		private var catHpLbl:Label;
		private var rewardGoldLbl:Label;
		private var rewardExpLbl:Label;
		private var freeCountLbl:Label;

		private var stateImg:Image;

		public function DeliveryFinish() {
			super(LibManager.getInstance().getXML("config/ui/delivery/deliveryFinish.xml"));
			this.init();
			this.hideBg();
		}

		private function init():void {
			this.confirmBtn=this.getUIbyID("confirmBtn") as NormalButton;
			this.confirmNpcBtn=this.getUIbyID("confirmNpcBtn") as NormalButton;
			this.cencelBtn=this.getUIbyID("cencelBtn") as NormalButton;

			this.dropGoldLbl=this.getUIbyID("dropGoldLbl") as Label;
			this.catHpLbl=this.getUIbyID("catHpLbl") as Label;
			this.rewardGoldLbl=this.getUIbyID("rewardGoldLbl") as Label;
			this.rewardExpLbl=this.getUIbyID("rewardExpLbl") as Label;
			this.freeCountLbl=this.getUIbyID("freeCountLbl") as Label;

			this.stateImg=this.getUIbyID("stateImg") as Image;

			this.confirmBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.confirmNpcBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.cencelBtn.addEventListener(MouseEvent.CLICK, onBtnClick);

			this.clsBtn.visible=false;
			this.allowDrag=false;
		}

		private function onBtnClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "confirmBtn":
					Cmd_Yct.cm_DeliveryContinue();
					break;
				case "confirmNpcBtn":

					break;
				case "cencelBtn":
					break;
			}

			this.hide();
		}


		public function updateInfo(o:Object):void {
			this.show();

			this.x=UIEnum.WIDTH - this.width >> 1;
			this.y=UIEnum.HEIGHT - this.height >> 1;

			this.dropGoldLbl.text="" + o.dmoney;
			this.catHpLbl.text=o.shp + "%";
			this.rewardGoldLbl.text="" + o.money;
			this.rewardExpLbl.text="" + o.exp;

			if (o.synum > 0) {
				this.confirmNpcBtn.visible=false;
				this.confirmBtn.visible=true;
				this.cencelBtn.visible=true;

				this.freeCountLbl.text="今日还剩" + o.synum + "次，是否继续护镖？";
			} else {
				this.confirmNpcBtn.visible=true;
				this.confirmBtn.visible=false;
				this.cencelBtn.visible=false;

				this.freeCountLbl.text="";
			}

			if (o.shp > 0) {
				this.stateImg.updateBmp("ui/delivery/img_ybcg.png");

			} else {
				this.stateImg.updateBmp("ui/delivery/img_ybsb.png");
			}

			UIManager.getInstance().deliveryPanel.updateEndDesc(TableManager.getInstance().getSystemNotice(4515).content);
		}

		override public function get width():Number{
			return 574;
		}

	}
}

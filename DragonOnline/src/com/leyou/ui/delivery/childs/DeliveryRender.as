package com.leyou.ui.delivery.childs {

	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.window.children.SimpleWindow;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Yct;
	import com.leyou.utils.FilterUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class DeliveryRender extends AutoSprite {

		private var expLbl:Label;
		private var goldLbl:Label;

		private var accpetBtn:ImgLabelButton;
		private var consignBtn:ImgLabelButton;

		private var changeCatImg:Image;
		private var accpetImg:Image;
		public static var prop:SimpleWindow;

		public var index:int=0;

		public function DeliveryRender() {
			super(LibManager.getInstance().getXML("config/ui/delivery/deliveryRender.xml"));
			this.init();
			this.mouseEnabled=this.mouseChildren=true;
		}

		private function init():void {

			this.expLbl=this.getUIbyID("expLbl") as Label;
			this.goldLbl=this.getUIbyID("goldLbl") as Label;
			this.accpetBtn=this.getUIbyID("accpetBtn") as ImgLabelButton;
			this.consignBtn=this.getUIbyID("consignBtn") as ImgLabelButton;

			this.changeCatImg=this.getUIbyID("changeCatImg") as Image;
			this.accpetImg=this.getUIbyID("accpetImg") as Image;

			this.accpetBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.consignBtn.addEventListener(MouseEvent.CLICK, onBtnClick);

			this.addEventListener(Event.ADDED_TO_STAGE, onAddStage);
		}

		private function onAddStage(e:Event):void {

			UIManager.getInstance().deliveryWnd.addChild(this.accpetImg);

			this.accpetImg.x=this.x + this.accpetImg.x;
			this.accpetImg.y=this.y + this.accpetImg.y;

		}

		private function onBtnClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "accpetBtn":
					if (this.index > 0)
						Cmd_Yct.cm_DeliveryStart(this.index);

					UIManager.getInstance().deliveryWnd.hide();
					break;
				case "consignBtn":

					prop=PopupManager.showConfirm(StringUtil.substitute(TableManager.getInstance().getSystemNotice(4507).content, [ConfigEnum.delivery11]), function():void {
						if (index > 0)
							Cmd_Yct.cm_DeliveryConsign(index);
					},null,false,"deliveryConsign");

					break;
			}

		}

		public function updateInfo(o:Object):void {

			this.expLbl.text=o[2] + "";
			this.goldLbl.text=o[3] + "";

			this.accpetImg.visible=(o[1] == 1 ? true : false);

			if (this.accpetImg.parent != this)
				UIManager.getInstance().deliveryWnd.setChildIndex(this.accpetImg, UIManager.getInstance().deliveryWnd.numChildren - 1);

			if (o[1] == 1) {

				this.accpetBtn.visible=(false);
				this.consignBtn.visible=(false);

				this.filters=[FilterUtil.enablefilter];

			} else {

				this.accpetBtn.visible=(true);
				this.consignBtn.visible=(true);
				this.filters=[];
			}

			switch (o[0]) {
				case 1:
					this.changeCatImg.updateBmp("ui/delivery/title_pinzhi_bai.jpg");
					break;
				case 2:
					this.changeCatImg.updateBmp("ui/delivery/title_pinzhi_lv.jpg");
					break;
				case 3:
					this.changeCatImg.updateBmp("ui/delivery/title_pinzhi_lan.jpg");
					break;
				case 4:
					this.changeCatImg.updateBmp("ui/delivery/title_pinzhi_zi.jpg");
					break;
				case 5:
					this.changeCatImg.updateBmp("ui/delivery/title_pinzhi_jin.jpg");
					break;
			}

		}


		public function setHidePopup(v:Boolean=false):void {
			if (prop != null)
				prop.hide()
		}

	}
}

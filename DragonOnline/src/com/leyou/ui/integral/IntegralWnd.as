package com.leyou.ui.integral {
	import com.ace.enum.TipEnum;
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.integral.IntegralData;
	import com.leyou.ui.integral.children.IntegralShopRender;
	import com.leyou.util.DateUtil;
	import com.leyou.utils.PayUtil;
	import com.leyou.utils.PropUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class IntegralWnd extends AutoWindow {
		private var timeLbl:Label;

		private var integralLbl:Label;

		private var ordinationLbl:Label;

		private var thresholdLbl:Label;

		private var payBtn:ImgButton;

		private var integralBtn:ImgButton;

		private var costBtn:ImgButton;

		private var integralShop:IntegralShopRender;

		private var iconImg:Image;

		public function IntegralWnd() {
			super(LibManager.getInstance().getXML("config/ui/cost/xfflWnd.xml"));
			init();
		}

		private function init():void {
			hideBg();
			timeLbl=getUIbyID("timeLbl") as Label;
			integralLbl=getUIbyID("integralLbl") as Label;
			ordinationLbl=getUIbyID("ordinationLbl") as Label;
			thresholdLbl=getUIbyID("thresholdLbl") as Label;
			payBtn=getUIbyID("payBtn") as ImgButton;
			integralBtn=getUIbyID("integralBtn") as ImgButton;
			costBtn=getUIbyID("costBtn") as ImgButton;
			iconImg=getUIbyID("iconImg") as Image;
			var spt:Sprite=new Sprite();
			spt.addChild(iconImg);
			spt.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
//			spt.x = iconImg.x;
//			spt.y = iconImg.y;
//			iconImg.x = 0;
//			iconImg.y = 0;
			addChild(spt);
			costBtn.visible=false;
			integralShop=new IntegralShopRender();
			addChild(integralShop);
			integralShop.x=172;
			integralShop.y=221;
			clsBtn.x+=4;
			clsBtn.y+=14;
			integralBtn.turnOn();
			thresholdLbl.wordWrap=true;
			thresholdLbl.multiline=true;
			thresholdLbl.htmlText=TableManager.getInstance().getSystemNotice(10003).content;
			payBtn.addEventListener(MouseEvent.CLICK, onMosueClick);
		}

		protected function onMosueClick(event:MouseEvent):void {
			PayUtil.openPayUrl();
		}

		protected function onMouseOver(event:MouseEvent):void {
			var content:String=TableManager.getInstance().getSystemNotice(10002).content;
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
		}

		public override function hide():void {
			super.hide();
			UIManager.getInstance().buyWnd.hide();
		}

		public function updateInfo():void {
			var data:IntegralData=DataManager.getInstance().integralData;
			integralLbl.text=data.integral + "";
			var begin:String=DateUtil.formatDate(new Date((data.beginT) * 1000), PropUtils.getStringById(1578));
			var end:String=DateUtil.formatDate(new Date((data.endT - 1) * 1000), PropUtils.getStringById(1578));
			if (data.act) {
				timeLbl.text=StringUtil.substitute(PropUtils.getStringById(1579), begin, end);
			} else {
				timeLbl.text=TableManager.getInstance().getSystemNotice(10005).content;
			}
		}

		public function resize():void {
			x=(UIEnum.WIDTH - width) * 0.5;
			y=(UIEnum.HEIGHT - height) * 0.5;
		}
	}
}

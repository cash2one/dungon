package com.leyou.ui.market.child {
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.utils.PayUtil;
	import com.leyou.utils.PropUtils;

	import flash.events.MouseEvent;

	public class TencentMarketItem extends AutoSprite {
		private var rebateImg:Image;

		private var nameLbl:Label;

		private var marketPriceLbl:Label;

		private var vipPriceLbl:Label;

		private var buyBtn:ImgButton;

		private var ibImg:Image;

		private var type:int;

		private var count:int;

		public function TencentMarketItem() {
			super(LibManager.getInstance().getXML("config/ui/market/marketQQItemRender.xml"));
			init();
		}

		private function init():void {
			mouseChildren=true;
			rebateImg=getUIbyID("rebateImg") as Image;
			nameLbl=getUIbyID("nameLbl") as Label;
			marketPriceLbl=getUIbyID("marketPriceLbl") as Label;
			vipPriceLbl=getUIbyID("vipPriceLbl") as Label;
			ibImg=getUIbyID("ibImg") as Image;
			buyBtn=getUIbyID("buyBtn") as ImgButton;

			buyBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
		}

		protected function onBtnClick(event:MouseEvent):void {
			PayUtil.buyIB(type);
		}

		public function updateInfo($type:int, $count:int):void {
			type=$type;
			count=$count;
			nameLbl.text=StringUtil.substitute(PropUtils.getStringById(1787), count);
			marketPriceLbl.text=count + PropUtils.getStringById(1788);
			vipPriceLbl.text=(count * ConfigEnum.qqvip2 / 10000) + PropUtils.getStringById(1788);
			var url:String=StringUtil.substitute("ui/qq/zuan{1}.jpg", type);
			ibImg.updateBmp(url);
		}
	}
}

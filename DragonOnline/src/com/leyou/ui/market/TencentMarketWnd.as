package com.leyou.ui.market
{
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_QQVip;
	import com.leyou.utils.PayUtil;
	
	import flash.events.MouseEvent;
	
	public class TencentMarketWnd extends AutoWindow
	{
		private var ib1Lbl:Label;
		
		private var ib2Lbl:Label;
		
		private var ib3Lbl:Label;
		
		private var ib4Lbl:Label;
		
		private var ib5Lbl:Label;
		
		private var buy1Btn:ImgButton;
		
		private var buy2Btn:ImgButton;
		
		private var buy3Btn:ImgButton;
		
		private var buy4Btn:ImgButton;
		
		private var buy5Btn:ImgButton;
		
		private var payVipBtn:ImgButton;
		
		public function TencentMarketWnd(){
			super(LibManager.getInstance().getXML("config/ui/market/marketQQWnd.xml"));
			init();
		}
		
		private function init():void{
			ib1Lbl = getUIbyID("ib1Lbl") as Label;
			ib2Lbl = getUIbyID("ib2Lbl") as Label;
			ib3Lbl = getUIbyID("ib3Lbl") as Label;
			ib4Lbl = getUIbyID("ib4Lbl") as Label;
			ib5Lbl = getUIbyID("ib5Lbl") as Label;
			buy1Btn = getUIbyID("buy1Btn") as ImgButton;
			buy2Btn = getUIbyID("buy2Btn") as ImgButton;
			buy3Btn = getUIbyID("buy3Btn") as ImgButton;
			buy4Btn = getUIbyID("buy4Btn") as ImgButton;
			buy5Btn = getUIbyID("buy5Btn") as ImgButton;
			payVipBtn = getUIbyID("payVipBtn") as ImgButton;
			
			buy1Btn.addEventListener(MouseEvent.CLICK, onBtnClick);
			buy2Btn.addEventListener(MouseEvent.CLICK, onBtnClick);
			buy3Btn.addEventListener(MouseEvent.CLICK, onBtnClick);
			buy4Btn.addEventListener(MouseEvent.CLICK, onBtnClick);
			buy5Btn.addEventListener(MouseEvent.CLICK, onBtnClick);
			payVipBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			
			var tarr:Array = ConfigEnum.qqvip3.split("|");
			ib1Lbl.text = tarr[0]+"钻石";
			ib2Lbl.text = tarr[1]+"钻石";
			ib3Lbl.text = tarr[2]+"钻石";
			ib4Lbl.text = tarr[3]+"钻石";
			ib5Lbl.text = tarr[4]+"钻石";
			clsBtn.x -= 6;
			clsBtn.y -= 14;
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "buy1Btn":
					PayUtil.buyIB(1);
					break;
				case "buy2Btn":
					PayUtil.buyIB(2);
					break;
				case "buy3Btn":
					PayUtil.buyIB(3);
					break;
				case "buy4Btn":
					PayUtil.buyIB(4);
					break;
				case "buy5Btn":
					PayUtil.buyIB(5);
					break;
				case "payVipBtn":
					var st:int = DataManager.getInstance().qqvipData.actSt;
					if(0 == st){
						PayUtil.payQQYellowVip(1);
					}else{
						PayUtil.openQQYellowVipUrl(1);
					}
					break;
			}
		}
	}
}
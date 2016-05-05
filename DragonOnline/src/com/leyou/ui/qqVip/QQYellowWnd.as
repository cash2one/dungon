package com.leyou.ui.qqVip
{
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.ui.market.child.MarketGrid;
	import com.leyou.utils.PayUtil;
	
	import flash.events.MouseEvent;
	
	public class QQYellowWnd extends AutoWindow
	{
		private var payYellowBtn:ImgButton;
		
		private var grid:MarketGrid;
		
		public function QQYellowWnd(){
			super(LibManager.getInstance().getXML("config/ui/qqVip/qqVipSWnd.xml"));
			init();
		}
		
		private function init():void{
			payYellowBtn = getUIbyID("payYellowBtn") as ImgButton;
			payYellowBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
//			clsBtn.x -= 6;
//			clsBtn.y -= 14;
			
			grid = new MarketGrid();
			grid.isShowPrice = false;
			addChild(grid);
			grid.x = 120;
			grid.y = 88;
			grid.updataById(ConfigEnum.qqvip4);
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			var st:int = DataManager.getInstance().qqvipData.actSt;
			switch(event.target.name){
				case "payYellowBtn":
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
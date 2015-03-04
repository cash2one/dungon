package com.leyou.ui.quickBuy.child {
	import com.ace.game.backpack.GridBase;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	
	import flash.geom.Rectangle;

	public class QuickBuyGrid extends GridBase {
		public function QuickBuyGrid() {
		}
		
		override protected function init(hasCd:Boolean=false):void {
			super.init();
			this.iconBmp.x=0;
			this.iconBmp.y=0;
			
			var bmp:ScaleBitmap=new ScaleBitmap(LibManager.getInstance().getImg("ui/backpack/bg.png"));
			bmp.scale9Grid=new Rectangle(3, 3, 20, 20);
			bmp.setSize(60,60);
			this.bgBmp.bitmapData=bmp.bitmapData;
		}
	}
}
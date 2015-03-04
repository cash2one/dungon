package com.leyou.ui.shop.child {
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;

	public class ShopRender extends AutoSprite {
		private var nameLbl:Label;
		private var moneyKindLbl:Label;
		private var priceLbl:Label;
		private var selectSBmp:ScaleBitmap;
		private var bg:ScaleBitmap;

		private var moneyIco:Image;
		
		private var grid:ShopGrid;

		public var id:int;
		
		public function ShopRender() {
			super(LibManager.getInstance().getXML("config/ui/shop/BShopRender.xml"));
			this.init();
//			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
//			this.moneyKindLbl=this.getUIbyID("moneyKindLbl") as Label;
			this.priceLbl=this.getUIbyID("priceLbl") as Label;
			this.selectSBmp=this.getUIbyID("selectSBmp") as ScaleBitmap;
			this.bg=this.getUIbyID("bg") as ScaleBitmap;
			this.moneyIco=this.getUIbyID("moneyIco") as Image;
			
			this.selectSBmp.visible=false;

			this.grid=new ShopGrid();
			this.grid.x=this.grid.y=3;
			this.addChild(this.grid);
		}

		public function updateInfo(info:Object):void {
			this.grid.updataInfo(info);
		}

		public function set selectedOr(f:Boolean):void {
			this.selectSBmp.visible=f;
			this.bg.visible=!f;
		}
		

	}
}
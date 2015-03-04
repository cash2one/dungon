package com.leyou.ui.autionSale.children
{
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.leyou.data.vendue.VendueData;
	import com.leyou.enum.ConfigEnum;
	
	public class VendueNextPage extends AutoSprite
	{
		private var items:Vector.<VendueNextPageItem>;
		
		public function VendueNextPage(){
			super(LibManager.getInstance().getXML("config/ui/vendue/vendueRender2.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			var l:int = ConfigEnum.vendue2;
			items = new Vector.<VendueNextPageItem>(l);
			for(var n:int = 0; n < l; n++){
				var item:VendueNextPageItem = items[n];
				if(null == item){
					item = new VendueNextPageItem();
					items[n] = item;
					item.x = 13;
					item.y = 105*n;
					addChild(item);
				}
			}
		}
		
		public function updateInfo(data:VendueData):void{
			var pl:int = items.length;
			var count:int = data.getNextCount();
			for(var n:int = 0; n < pl; n++){
				var item:VendueNextPageItem = items[n];
				if(n < count){
					item.visible = true;
					item.updateInfo(data.getNextItem(n));
				}else{
					item.visible = false;
				}
			}
		}
	}
}
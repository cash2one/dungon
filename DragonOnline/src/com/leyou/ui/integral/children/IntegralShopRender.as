package com.leyou.ui.integral.children
{
	import com.ace.config.Core;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TShop;
	import com.ace.ui.scrollPane.children.ScrollPane;
	
	import flash.display.Sprite;

	public class IntegralShopRender extends Sprite
	{
		private var items:Array;
		
		private var panel:ScrollPane;
		
		public function IntegralShopRender(){
			init();
		}
		
		private function init():void{
			items = [];
			panel = new ScrollPane(657, 317);
			addChild(panel);
			initTable();
		}
		
		private function initTable():void{
			var index:int;
			var shopDic:Object = TableManager.getInstance().getShopDic();
			for(var key:String in shopDic){
				var shop:TShop = shopDic[key];
				if((3 == shop.shopId) && ((Core.me.info.profession == shop.Class) || (0 == shop.Class))){
					var item:IntegralShopItem = items[index];
					if(null == item){
						item = new IntegralShopItem();
						items[index] = item;
					}
					panel.addToPane(item);
					item.x = int(index%3) * 212;
					item.y = int(index/3) * 103;
					index++;
					item.updateInfo(shop);
				}
			}
			panel.updateUI();
		}
	}
}
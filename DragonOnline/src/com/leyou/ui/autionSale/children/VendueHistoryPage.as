package com.leyou.ui.autionSale.children
{
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.data.vendue.VendueData;
	import com.leyou.data.vendue.VendueHistoryData;
	
	public class VendueHistoryPage extends AutoSprite
	{
		private var scrollPanel:ScrollPane;
		
		private var items:Vector.<VendueHistoryPageItem>;
		
		public function VendueHistoryPage(){
			super(LibManager.getInstance().getXML("config/ui/vendue/vendueRender3.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			scrollPanel = getUIbyID("scrollPanel") as ScrollPane;
			scrollPanel.updateUI();
			items = new Vector.<VendueHistoryPageItem>();
		}
		
		public function updateInfo(data:VendueData):void{
			var lc:int = data.getLogCount();
			var ic:int = items.length;
			var mc:int = (lc > ic) ? lc : ic;
			for(var n:int = 0; n < mc; n++){
				var idata:VendueHistoryData = data.getLogItem(n);
				var item:VendueHistoryPageItem = nvlItem(n);
				if(null != idata){
					item.y = n*61;
					item.updateInfo(idata);
					scrollPanel.addToPane(item);
				}else if(null != item){
					if(scrollPanel.contains(item)){
						scrollPanel.delFromPane(item);
					}
				}
			}
			scrollPanel.updateUI();
		}
		
		private function nvlItem(index:int):VendueHistoryPageItem{
			var item:VendueHistoryPageItem;
			if(index < items.length){
				item = items[index];
			}else{
				item = new VendueHistoryPageItem();
				items.push(item);
			}
			return item;
		}
	}
}
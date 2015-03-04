package com.leyou.ui.qqVip.children
{
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TQQVipLvRewardInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.data.qqvip.QQVipData;

	public class QQVipLvPage extends AutoSprite
	{
		private var scrollPanel:ScrollPane;
		
		private var items:Vector.<QQVipLvRender>;
		
		public function QQVipLvPage(){
			super(LibManager.getInstance().getXML("config/ui/qqVip/qqVipLv.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			items = new Vector.<QQVipLvRender>(7);
			scrollPanel = getUIbyID("scrollPanel") as ScrollPane;
			initTable();
		}
		
		public function initTable():void{
			for(var n:int = 10; n <= 70; n+=10){
				var index:int = n/10-1;
				var item:QQVipLvRender = items[index];
				if(null == item){
					item = new QQVipLvRender();
					items[index] = item;
				}
				scrollPanel.addToPane(item);
				item.y = 50*index;
				
				var tinfo:TQQVipLvRewardInfo = TableManager.getInstance().getQQLvInfo(n);
				item.updateTableInfo(tinfo);
			}
		}
		
		public function updateInfo():void{
			var data:QQVipData = DataManager.getInstance().qqvipData;
			var l:int = items.length;
			for(var n:int = 0; n < l; n++){
				var item:QQVipLvRender = items[n];
				item.updateStatus(data);
			}
		}
	}
}
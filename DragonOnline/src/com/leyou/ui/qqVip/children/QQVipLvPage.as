package com.leyou.ui.qqVip.children {
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TQQVipLvRewardInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.data.qqvip.QQVipData;

	public class QQVipLvPage extends AutoSprite {
		private var scrollPanel:ScrollPane;

		private var items:Vector.<QQVipLvRender>;

		public function QQVipLvPage() {
			super(LibManager.getInstance().getXML("config/ui/qqVip/qqVipLv.xml"));
			init();
		}

		private function init():void {
			mouseChildren=true;
			items=new Vector.<QQVipLvRender>();
			scrollPanel=getUIbyID("scrollPanel") as ScrollPane;
			initTable();
		}

		public function initTable():void {
			var item:QQVipLvRender;
			var index:int=0;
			for (var n:int=10; n <= 100; n+=10) {
				var tinfo:TQQVipLvRewardInfo=TableManager.getInstance().getQQLvInfo(n);
				if (tinfo == null)
					continue;

				item=new QQVipLvRender();
				items[index]=item;

				scrollPanel.addToPane(item);
				item.y=50 * index;

				item.updateTableInfo(tinfo);

				index++;
			}
		}

		public function updateInfo():void {
			var data:QQVipData=DataManager.getInstance().qqvipData;
			var l:int=items.length;
			for (var n:int=0; n < l; n++) {
				var item:QQVipLvRender=items[n];
				item.updateStatus(data);
			}
		}
	}
}

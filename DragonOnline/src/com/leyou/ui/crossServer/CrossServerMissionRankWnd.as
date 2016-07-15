package com.leyou.ui.crossServer {
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.data.crossServer.CrossServerData;
	import com.leyou.ui.crossServer.children.CrossServerMissionRankItem;

	public class CrossServerMissionRankWnd extends AutoWindow {
		private var panel:ScrollPane;

		private var itemList:Vector.<CrossServerMissionRankItem>;

		public function CrossServerMissionRankWnd() {
			super(LibManager.getInstance().getXML("config/ui/crossServer/kfdtMissionRank.xml"));
			init();
		}

		private function init():void {
			hideBg();
			panel=new ScrollPane(415, 380);
			addChild(panel);
			panel.x=18;
			panel.y=70;

			itemList=new Vector.<CrossServerMissionRankItem>();
//			clsBtn.x -= 6;
//			clsBtn.y -= 14;
		}

		public function updateInfo():void {
			for each (var citem:CrossServerMissionRankItem in itemList) {
				if ((null != citem) && panel.contains(citem)) {
					panel.delFromPane(citem);
				}
			}

			var data:CrossServerData=DataManager.getInstance().crossServerData;
			var l:int=data.taskRankList.length;
			if (itemList.length < l) {
				itemList.length=l;
			}

			for (var n:int=0; n < l; n++) {
				var item:CrossServerMissionRankItem=itemList[n];
				if (null == item) {
					item=new CrossServerMissionRankItem();
					itemList[n]=item;
				}
				item.y=60 * n;
				panel.addToPane(item);
				item.updateInfo(data.taskRankList[n]);
			}

			panel.visible=(n > 0);
		}

		public override function get width():Number {
			return 442;
		}

		public override function get height():Number {
			return 456;
		}
	}
}

package com.leyou.ui.crossServer.children {
	import com.ace.config.Core;
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCSServerRankInfo;
	import com.ace.gameData.table.TPointInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.data.crossServer.CrossServerData;
	import com.leyou.data.crossServer.children.CrossServerLvData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.ui.market.child.MarketGrid;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class CrossServerTaskCarRender extends AutoSprite {
		private var beginLbl:Label;

		private var ruleLbl:Label;

		private var rewardLbl:Label;

		private var joinBtn:ImgButton;

		private var taskPanel:ScrollPane;

		private var itemList:Vector.<CrossServerTaskCarItemRender>;

		private var grids:Vector.<MarketGrid>;

		public function CrossServerTaskCarRender() {
			super(LibManager.getInstance().getXML("config/ui/crossServer/kfdtHorseRender.xml"));
			init();
		}

		private function init():void {
			mouseEnabled=true;
			mouseChildren=true;
			beginLbl=getUIbyID("beginLbl") as Label;
			ruleLbl=getUIbyID("ruleLbl") as Label;
			rewardLbl=getUIbyID("rewardLbl") as Label;
			joinBtn=getUIbyID("joinBtn") as ImgButton;
			taskPanel=getUIbyID("taskPanel") as ScrollPane;
			itemList=new Vector.<CrossServerTaskCarItemRender>();

			grids=new Vector.<MarketGrid>(5);
			for (var n:int=0; n < 5; n++) {
				var grid:MarketGrid=grids[n];
				if (null == grid) {
					grid=new MarketGrid();
					grids[n]=grid;
				}
				addChild(grid);
				grid.x=15 + n * 80;
				grid.y=67;
			}

			joinBtn.addEventListener(MouseEvent.CLICK, onMouseClick);

			ruleLbl.mouseEnabled=true;
			ruleLbl.addEventListener(MouseEvent.MOUSE_OVER, onTips);
		}

		protected function onTips(event:MouseEvent):void {
			var content:String=TableManager.getInstance().getSystemNotice(11025).content;
			content=StringUtil_II.translate(content, ConfigEnum.multiple16, ConfigEnum.multiple7 + "%", ConfigEnum.multiple9 + "%");
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
		}

		protected function onMouseClick(event:MouseEvent):void {
			var pt:TPointInfo=TableManager.getInstance().getPointInfo(900001);
			Core.me.gotoMap(new Point(pt.tx, pt.ty), pt.sceneId, true);
		}

		public function updateInfo():void {
			var data:CrossServerData=DataManager.getInstance().crossServerData;
			if (data.myServerData.lv <= 0) {
				return;
			}
			if (data.myServerData.rank > ConfigEnum.multiple16) {
				// 无奖励
				for (var k:int=0; k < 5; k++) {
					var grid:MarketGrid=grids[k];
					grid.clear();
				}
				beginLbl.text="";
				rewardLbl.text=PropUtils.getStringById(101572);
			} else {

				var serverLv:TCSServerRankInfo=TableManager.getInstance().getCrossServerRankInfo(data.myServerData.rank);
				for (var l:int=0; l < 5; l++) {
					var g:MarketGrid=grids[l];
					g.updateInfoII(serverLv.itemList[l], serverLv.itemNumList[l]);
				}
				var cd:Date=new Date(data.currentTime());
				var timeArr:Array=serverLv.deliveryTime.split(":");
				var tickDate:Date=new Date(cd.fullYear, cd.month, cd.date, timeArr[0], timeArr[1], timeArr[2]);
				if (cd.time > tickDate.time) {
					if (data.myServerData.serverName == data.gname) {
						beginLbl.htmlText=serverLv.deliveryTime + PropUtils.getStringById(2282);
					} else {
						beginLbl.htmlText=serverLv.deliveryTime + PropUtils.getStringById(2284);
					}
				} else {
					beginLbl.htmlText=serverLv.deliveryTime + PropUtils.getStringById(2283);
				}

				rewardLbl.text=PropUtils.getStringById(2285);
			}
			// 国家列表数据
			var itemCount:int=itemList.length;
			for (var n:int=0; n < itemCount; n++) {
				var item:CrossServerTaskCarItemRender=itemList[n];
				if ((null != item) && taskPanel.contains(item)) {
					taskPanel.delFromPane(item);
				}
			}

			var serverList:Vector.<CrossServerLvData>=data.serverList;
			if (itemList.length < serverList.length) {
				itemList.length=serverList.length;
			}
			var idx:int=0;
			var sl:int=(serverList.length > ConfigEnum.multiple16) ? ConfigEnum.multiple16 : serverList.length;
			for (var m:int=0; m < sl; m++) {
				var serverData:CrossServerLvData=serverList[m];
				if (serverData.rank > 10) {
					continue;
				}
				var serverItem:CrossServerTaskCarItemRender=itemList[m];
				if (null == serverItem) {
					serverItem=new CrossServerTaskCarItemRender();
					itemList[m]=serverItem;
				}
				serverItem.updateInfo(serverData);
				taskPanel.addToPane(serverItem);
				serverItem.x=1;
				serverItem.y=idx * 42;
				idx++;
			}
			taskPanel.updateUI();
		}
	}
}

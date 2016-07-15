package com.leyou.ui.crossServer.children {
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCSLvInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.leyou.data.crossServer.CrossServerData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.ui.market.child.MarketGrid;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class CrossServerMissionReleaseRender extends AutoSprite {
		private var ruleLbl:Label;

		private var timeLbl:Label;

		private var rewardBtn:ImgButton;

		private var grids:Vector.<MarketGrid>;

		public function CrossServerMissionReleaseRender() {
			super(LibManager.getInstance().getXML("config/ui/crossServer/kfdtMissionRender1.xml"));
			init();
		}

		private function init():void {
			mouseEnabled=true;
			mouseChildren=true;
			ruleLbl=getUIbyID("ruleLbl") as Label;
			timeLbl=getUIbyID("titleLbl") as Label;
			rewardBtn=getUIbyID("rewardBtn") as ImgButton;
			ruleLbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			grids=new Vector.<MarketGrid>();
			for (var n:int=0; n < 5; n++) {
				var grid:MarketGrid=new MarketGrid();
				grid.x=146 + n * 80;
				grid.y=245;
				addChild(grid);
				grids.push(grid);
			}
			rewardBtn.addEventListener(MouseEvent.CLICK, onBtnClick);

			ruleLbl.mouseEnabled=true;
			ruleLbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}

		protected function onBtnClick(event:MouseEvent):void {
			UILayoutManager.getInstance().open(WindowEnum.CROSS_SERVER_RANK_AWARD);
		}

		protected function onMouseOver(event:MouseEvent):void {
			var content:String=TableManager.getInstance().getSystemNotice(11001).content;
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY))
		}

		public function updateInfo():void {
			var data:CrossServerData=DataManager.getInstance().crossServerData;
			if (0 != data.taskId) {
				return;
			}

			var timeArr:Array=ConfigEnum.multiple2.split("|");
			var serverDate:Date=new Date(data.stime * 1000);
			var startTick1:Date=new Date(serverDate.fullYear, serverDate.month, serverDate.date, int(timeArr[0].split(":")[0]), int(timeArr[0].split(":")[1]));
			var startTick2:Date=new Date(serverDate.fullYear, serverDate.month, serverDate.date, int(timeArr[1].split(":")[0]), int(timeArr[1].split(":")[1]));

			if (serverDate.time < startTick1.time) {
				timeLbl.text=timeArr[0];
			} else if ((serverDate.time >= startTick1.time) && (serverDate.time < startTick2.time)) {
				timeLbl.text=timeArr[1];
			} else {
				timeLbl.text=timeArr[0];
			}

			var lv:int=1;
			if (data.myServerData.lv > 0)
				lv=data.myServerData.lv;

			var serverInfo:TCSLvInfo=TableManager.getInstance().getCrossServerInfo(lv);
			var rl:int=grids.length;
			for (var n:int=0; n < rl; n++) {
				grids[n].updateInfoII(serverInfo.itemIdlist[n], serverInfo.itemNumlist[n]);
			}

		}
	}
}

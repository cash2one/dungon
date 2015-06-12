package com.leyou.ui.sevenDay.child {
	import com.ace.enum.FilterEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TSevenDayInfo;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.sevenDay.SevenDayTask;
	import com.leyou.net.cmd.Cmd_Seven;
	import com.leyou.ui.mail.child.MaillGrid;
	import com.leyou.utils.PropUtils;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class SevenDayRender extends AutoSprite {
		private var receiveBtn:NormalButton;

		private var targetLbl:Label;

		private var receivedImg:Image;

		private var progressBImg:ScaleBitmap;

		private var progressCImg:ScaleBitmap;

		private var progressLbl:Label;

		private var grids:Vector.<MaillGrid>;

		private var gridImgs:Vector.<Image>;

		private var _linkId:int;

		public function SevenDayRender() {
			super(LibManager.getInstance().getXML("config/ui/sevenDay/sevendRender.xml"));
			init();
		}

		public function get linkId():int {
			return _linkId;
		}

		private function init():void {
			mouseChildren=true;
			receiveBtn=getUIbyID("receiveBtn") as NormalButton;
			targetLbl=getUIbyID("targetLbl") as Label;
			receivedImg=getUIbyID("receivedImg") as Image;
			progressBImg=getUIbyID("progressBImg") as ScaleBitmap;
			progressCImg=getUIbyID("progressCImg") as ScaleBitmap;
			progressLbl=getUIbyID("progressLbl") as Label;
			receiveBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			gridImgs=new Vector.<Image>();
			grids=new Vector.<MaillGrid>();
			for (var n:int=0; n < 3; n++) {
				var grid:MaillGrid=new MaillGrid();
				grid.isShowPrice=false;
				grid.x=250 + n * 56;
				grid.y=14;
				addChild(grid);
				grids.push(grid);
				gridImgs.push(getUIbyID("gridImg" + (n + 1)));
			}
			addChild(receivedImg);
		}

		protected function onBtnClick(event:MouseEvent):void {
			switch (event.target.name) {
				case "receiveBtn":
					Cmd_Seven.cm_SEVD_R(linkId);
					break;
			}
		}

		public function updateInfo(task:SevenDayTask):void {
			_linkId=task.id;
			if (0 == task.receiveStatus) {
				receivedImg.visible=false;
				receiveBtn.visible=false;
				progressBImg.visible=true;
				progressCImg.visible=true;
				progressLbl.visible=true;
			} else if (1 == task.receiveStatus) {
				receivedImg.visible=false;
				receiveBtn.visible=true;
				receiveBtn.text=PropUtils.getStringById(1575);
				receiveBtn.setActive(true, 1, true);
				progressBImg.visible=false;
				progressCImg.visible=false;
				progressLbl.visible=false;
			} else if (2 == task.receiveStatus) {
				receivedImg.visible=true;
				receiveBtn.visible=true;
				receiveBtn.text=PropUtils.getStringById(1574);
				receiveBtn.setActive(false, 1, true);
				progressBImg.visible=false;
				progressCImg.visible=false;
				progressLbl.visible=false;
			}
			var ttask:TSevenDayInfo=TableManager.getInstance().getSevenDayInfo(task.id);
			targetLbl.text=ttask.taskDes;
			if ((7 == ttask.type) || (15 == ttask.type)) {
				progressLbl.text=task.progress + "/1";
				progressCImg.scaleX=task.progress;
			} else {
				progressLbl.text=task.progress + "/" + ttask.taskValue;
				progressCImg.scaleX=task.progress / ttask.taskValue
			}
			for (var n:int=0; n < 3; n++) {
				if (null != grids[n]) {
					grids[n].clear();
					grids[n].visible=false;
					grids[n].filters=(2 == task.receiveStatus) ? [FilterEnum.enable] : null;
				}
				gridImgs[n].visible=false;
			}
			var index:int=0;
			var grid:MaillGrid=grids[index];
			if (ttask.rMoney > 0) {
				grid.visible=true;
				gridImgs[index].visible=true;
				grid.updateInfo(65535, ttask.rMoney);
				index++;
			}
			if (ttask.rEnergy > 0) {
				grid=grids[index];
				grid.visible=true;
				gridImgs[index].visible=true;
				grid.updateInfo(65533, ttask.rEnergy);
				index++;
			}
			if (ttask.rExp > 0) {
				grid=grids[index];
				grid.visible=true;
				gridImgs[index].visible=true;
				grid.updateInfo(65534, ttask.rExp);
				index++;
			}
			if (ttask.rlp > 0) {
				grid=grids[index];
				grid.visible=true;
				gridImgs[index].visible=true;
				grid.updateInfo(65531, ttask.rlp);
				index++;
			}
			if (ttask.item1 > 0) {
				grid=grids[index];
				grid.visible=true;
				gridImgs[index].visible=true;
				grid.updateInfo(ttask.item1, ttask.item1Count);
				index++;
			}
			if (ttask.item2 > 0) {
				grid=grids[index];
				grid.visible=true;
				gridImgs[index].visible=true;
				grid.updateInfo(ttask.item2, ttask.item2Count);
				index++;
			}
			if (ttask.item3 > 0) {
				grid=grids[index];
				grid.visible=true;
				gridImgs[index].visible=true;
				grid.updateInfo(ttask.item3, ttask.item3Count);
				index++;
			}
			if (ttask.item4 > 0) {
				grid=grids[index];
				grid.visible=true;
				gridImgs[index].visible=true;
				grid.updateInfo(ttask.item4, ttask.item4Count);
				index++;
			}
		}

		public function flyItem():void {
			var ids:Array=[];
			var starts:Array=[];
			for each (var grid:MaillGrid in grids) {
				if (grid.visible && (0 != grid.dataId)) {
					ids.push(grid.dataId);
					starts.push(grid.localToGlobal(new Point(0, 0)));
				}
			}
			FlyManager.getInstance().flyBags(ids, starts);
		}
	}
}

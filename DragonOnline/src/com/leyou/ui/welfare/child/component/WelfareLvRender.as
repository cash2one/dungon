package com.leyou.ui.welfare.child.component {
	import com.ace.enum.FilterEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.table.TLevelGiftInfo;
	import com.ace.manager.GuideArrowDirectManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.leyou.net.cmd.Cmd_Welfare;
	import com.leyou.ui.mail.child.MaillGrid;
	import com.leyou.ui.market.child.MarketGrid;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class WelfareLvRender extends AutoSprite {
		private static const GRID_COUNT:int=6;

		private var receiveBtn:ImgButton;

		private var lvImg:Image;

		private var receivedImg:Image;

		private var grids:Vector.<MarketGrid>;

		private var receiveableImg:Image;

		private var lv:int;

		public var waitFly:Boolean;

		private var status:int;

		public function WelfareLvRender() {
			super(LibManager.getInstance().getXML("config/ui/welfare/welfareLvRender.xml"));
			init();
		}

		private function init():void {
			mouseChildren=true;
			grids=new Vector.<MarketGrid>(GRID_COUNT);
			lvImg=getUIbyID("lvImg") as Image;
			receivedImg=getUIbyID("receivedImg") as Image;
			receiveBtn=getUIbyID("receiveBtn") as ImgButton;
			receiveableImg=getUIbyID("receiveableImg") as Image;
			receiveBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
		}

		protected function onButtonClick(event:MouseEvent):void {

			GuideArrowDirectManager.getInstance().delArrow(WindowEnum.WELFARE + "");
			waitFly=true;
			Cmd_Welfare.cm_ULV_J(lv);
		}

		public function updateInfo(levelInfo:TLevelGiftInfo, re:int):void {
			status=re;
			lv=levelInfo.level;
			receivedImg.visible=(1 == re);
			var fa:Array=receivedImg.visible ? [FilterEnum.enable] : null;
			for (var n:int=0; n < GRID_COUNT; n++) {
				var grid:MarketGrid=getGrid(n);
				grid.filters=fa;
				var itemId:int=levelInfo.getItemId(n);
				if (0 != itemId) {
					grid.visible=true;
					grid.updateInfoII(levelInfo.getItemId(n), levelInfo.getItemNum(n));
				} else {
					grid.visible=false;
				}
			}
			lvImg.updateBmp("ui/welfare/lv_" + levelInfo.level + ".png");
			var av:Boolean=(0 == re);
			receiveBtn.setActive(av, 1, true);
			if (0 == re) {
				receiveableImg.updateBmp("ui/welfare/btn_lqjl.png");
				receivedImg.visible=false;
				receiveableImg.visible=true;
			} else if (1 == re) {
				receivedImg.updateBmp("ui/welfare/btn_lqjl2.png");
				receivedImg.visible=true;
				receiveableImg.visible=false;
			} else if (2 == re) {
				receivedImg.updateBmp("ui/welfare/btn_lqjl3.png");
				receivedImg.visible=true;
				receiveableImg.visible=false;
			}
		}

		public function hasReward():Boolean {
			return (0 == status);
		}

		private function getGrid(index:int):MarketGrid {
			var grid:MarketGrid=grids[index];
			if (null == grid) {
				grid=new MarketGrid();
				grid.updateBG("ui/tips/TIPS_bg_frame.jpg");
				addChild(grid);
				grid.x=183 + index * 72;
				grid.y=8;
				grids[index]=grid;
			}
			return grid;
		}

		public function flyItem():void {
			var ids:Array=[];
			var starts:Array=[];
			for each (var grid:MarketGrid in grids) {
				if (grid.visible && (0 != grid.dataId)) {
					ids.push(grid.dataId);
					starts.push(grid.localToGlobal(new Point(0, 0)));
				}
			}
			FlyManager.getInstance().flyBags(ids, starts);
		}
	}
}

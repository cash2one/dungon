package com.leyou.ui.bossCopy {
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCopyInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.leyou.ui.market.child.MarketGrid;

	import flash.events.MouseEvent;

	public class BossRewardWnd extends AutoWindow {
		private var confirmBtn:ImgButton;

		private var grids:Vector.<MarketGrid>;

		public function BossRewardWnd() {
			super(LibManager.getInstance().getXML("config/ui/dungeonBossFinish.xml"));
			init();
		}

		private function init():void {
			hideBg();
			clsBtn.visible=false;

			confirmBtn=getUIbyID("confirmBtn") as ImgButton;
			confirmBtn.addEventListener(MouseEvent.CLICK, onMouseClick);

			grids=new Vector.<MarketGrid>(4);
			for (var n:int=0; n < 4; n++) {
				var grid:MarketGrid=grids[n];
				if (null == grid) {
					grid=new MarketGrid();
					grid.x=128 + 72 * n;
					grid.y=89;
					addChild(grid);
					grids[n]=grid;

				}
			}
		}

		public function getGrid(index:int):MarketGrid {
			if (index < grids.length) {
				return grids[index];
			}
			return null;
		}

		protected function onMouseClick(event:MouseEvent):void {
			hide();
		}

		private function clear():void {
			for each (var gird:MarketGrid in grids) {
				if (null != gird) {
					gird.clear();
				}
			}
		}

		public function updateInfo(obj:Object):void {
			show();
			clear();
			var copyInfo:TCopyInfo=TableManager.getInstance().getCopyInfo(obj.cid);
			var index:int=0;
			if (copyInfo.firstEXP > 0) {
				getGrid(index).updataInfo({itemId: 65534, count: copyInfo.firstEXP});
				index++;
			}
			if (copyInfo.firstEnergy > 0) {
				getGrid(index).updataInfo({itemId: 65533, count: copyInfo.firstEnergy});
				index++;
			}
			if (copyInfo.firstMoney > 0) {
				getGrid(index).updataInfo({itemId: 65535, count: copyInfo.firstMoney});
				index++;
			}
			if (copyInfo.firstItem1 > 0) {
				getGrid(index).updataInfo({itemId: copyInfo.firstItem1, count: copyInfo.firstItemCount1});
				index++;
			}
			if (copyInfo.firstItem2 > 0) {
				getGrid(index).updataInfo({itemId: copyInfo.firstItem2, count: copyInfo.firstItemCount2});
				index++;
			}
		}
	}
}

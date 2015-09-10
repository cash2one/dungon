package com.leyou.ui.ttt.childs {
	import com.leyou.ui.task.child.MissionGrid;

	public class TttGrid extends MissionGrid {

		public function TttGrid(id:int=-1) {
			super(id);
		}

		override protected function init(hasCd:Boolean=false):void {
			super.init();
			this.setTipsPriceIsshow(false);
			this.isEmpty=true;
		}

		override public function updataInfo(info:Object):void {
			this.resetGrid();
			super.updataInfo(info);

			this.canMove=false;

		}

		public function resetGrid():void {
			this.reset();
			this.isEmpty=true;
			this.iconBmp.bitmapData=null;
		}
	}
}

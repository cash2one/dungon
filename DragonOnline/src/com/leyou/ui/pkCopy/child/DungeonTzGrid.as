package com.leyou.ui.pkCopy.child {
	import com.leyou.ui.task.child.MissionGrid;

	public class DungeonTzGrid extends MissionGrid {


		public function DungeonTzGrid(id:int=-1) {
			super(id);
		}

		override protected function init(hasCd:Boolean=false):void {
			super.init();
			this.setTipsPriceIsshow(false);
		}

		override public function updataInfo(info:Object):void{
			super.updataInfo(info);
			this.canMove=false;
		}

	}
}

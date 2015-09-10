package com.leyou.ui.laba.child {
	import com.leyou.ui.backpack.child.BackpackGrid;
	import com.leyou.ui.task.child.MissionGrid;

	public class LabaGrid extends MissionGrid {


		public function LabaGrid(id:int) {
			super(id);
		}

		override protected function init(hasCd:Boolean=false):void {
			super.init();
			this.bgBmp.bitmapData=null;
			
		}


	}
}

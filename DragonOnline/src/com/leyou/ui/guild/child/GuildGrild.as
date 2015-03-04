package com.leyou.ui.guild.child {

	import com.ace.game.backpack.GridBase;
	import com.leyou.ui.task.child.MissionGrid;

	public class GuildGrild extends MissionGrid {



		public function GuildGrild(id:int=-1) {
			super(id);
		}

		override protected function init(hasCd:Boolean=false):void {
			super.init();
			this.setTipsPriceIsshow(false);
		}





	}
}

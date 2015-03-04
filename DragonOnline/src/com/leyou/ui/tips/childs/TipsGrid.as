package com.leyou.ui.tips.childs {

	import com.ace.game.backpack.GridBase;
	import com.ace.manager.LibManager;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.ui.backpack.child.GridModel;
	
	import flash.geom.Point;

	public class TipsGrid extends GridModel {

		public var tips:TipsInfo;
		
		public function TipsGrid(id:int=-1) {
			super(id);
		}

		override protected function init(hasCd:Boolean=false):void {
			super.init();
			this.bgBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/bg.png");
			this.bgBmp.setWH(60, 60);

			this.iconBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/lock.png");
//			this.iconBmp.setWH(65, 65);

			this.iconBmp.x=60 - 55 >> 1;
			this.iconBmp.y=60 - 55 >> 1;
		}

		override public function updataInfo(info:Object):void {
			super.reset();
			super.unlocking();

			super.updataInfo(info);

			if (info.hasOwnProperty("eicon")) {
				this.iconBmp.updateBmp(info.eicon);
			} else {
				this.iconBmp.updateBmp("ico/items/" + info.icon + ".png");

				if (info.effect1 != null && info.effect1 != "0" && info.effect1!="")
					this.playeMc(int(info.effect1),new Point(-2,-2));
			}


			this.limitTimeLbl.x=60 - 25;
		}


	}
}

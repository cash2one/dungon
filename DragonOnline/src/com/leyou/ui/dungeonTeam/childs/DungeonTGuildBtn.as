package com.leyou.ui.dungeonTeam.childs {

	import com.ace.enum.FontEnum;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;

	public class DungeonTGuildBtn extends AutoSprite {

		private var iconImg:Image;
		private var stateLbl:Label;

		private var o:Object;

		public function DungeonTGuildBtn() {
			super(LibManager.getInstance().getXML("config/ui/dungeonTeam/dungeonTGuildBtn.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.iconImg=this.getUIbyID("iconImg") as Image;
			this.stateLbl=this.getUIbyID("stateLbl") as Label;
			this.stateLbl.mouseEnabled=true;
		}

		public function updateInfo(o:Object, i:int):void {
			this.o=o;

//			--  st:副本状态 (0未解锁 1已解锁 2未通关 3已通关,4 未开启)

			this.iconImg.updateBmp("ui/dungeonTeam/" + (i + 1) + ".png");

			if (o.hasOwnProperty("st")) {
				if (o.st == 0)
					this.stateLbl.defaultTextFormat=FontEnum.getTextFormat("Red12");
				else
					this.stateLbl.defaultTextFormat=FontEnum.getTextFormat("Green12");
				
				this.stateLbl.text=["未解锁", "已解锁", "未通关", "已通关", "未开启"][o.st] + "";
			} else {
				this.stateLbl.defaultTextFormat=FontEnum.getTextFormat("Red12");
				this.stateLbl.text="未解锁";
			}

		}


		public function get data():Object {
			return this.o;
		}

	}
}

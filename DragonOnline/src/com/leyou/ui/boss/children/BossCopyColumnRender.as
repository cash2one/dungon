package com.leyou.ui.boss.children {
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.leyou.data.bossCopy.BossCopyBossData;

	public class BossCopyColumnRender extends AutoSprite {
		public static const COL_COUNT:int=3;

		private var renders:Vector.<BossCopyItemRender>;

		public function BossCopyColumnRender() {
			super(LibManager.getInstance().getXML("config/ui/boss/bossPlayerLable.xml"));
			init();
		}

		private function init():void {
			mouseEnabled=true;
			mouseChildren=true;
			renders=new Vector.<BossCopyItemRender>(COL_COUNT);
			for (var n:int=0; n < COL_COUNT; n++) {
				var render:BossCopyItemRender=renders[n];
				if (null == render) {
					render=new BossCopyItemRender();
					renders[n]=render;
					addChild(render);
				}
				render.x=5;
				render.y=10 + n * 97;
			}
		}

		public function updateInfo(data:BossCopyBossData, prevData:BossCopyBossData, index:int):void {
			var render:BossCopyItemRender=renders[index];
			if (null != render) {
				render.updateInfo(data, prevData);
			}
		}

		public function getCurrentItem():BossCopyItemRender {
			var lRender:BossCopyItemRender;
			for each (var render:BossCopyItemRender in renders) {
				if (render.lock()) {
					return lRender;
				}
				lRender=render;
			}
			return lRender;
		}
	}
}

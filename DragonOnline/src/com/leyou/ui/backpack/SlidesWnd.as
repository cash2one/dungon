package com.leyou.ui.backpack {

	import com.ace.enum.UIEnum;
	import com.ace.loader.child.SwfLoader;
	import com.ace.ui.auto.AutoSprite;

	public class SlidesWnd extends AutoSprite {

		private var EffectLoader:SwfLoader;

		public function SlidesWnd() {
			super(new XML);
			this.init();
			
		}

		private function init():void {
			this.EffectLoader=new SwfLoader(99954);
			this.addChild(this.EffectLoader);
			this.EffectLoader.visible=false;
		}

		public function setEffectVisiable(v:Boolean):void {
			this.EffectLoader.visible=v;
		}

		public function reSize():void {
			this.x=UIEnum.WIDTH - this.width >> 1;
			this.y=UIEnum.HEIGHT - this.height >> 1;
		}

	}
}

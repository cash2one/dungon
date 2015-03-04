package com.leyou.manager {


	import com.ace.enum.UIEnum;
	import com.ace.manager.LayerManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.img.child.Image;

	public class LastTimeImageManager extends AutoWindow {

		private var imgUrl:Array=["ui/num/0_lz.png"];

		private static var _instance:LastTimeImageManager;

		private var type:int=0;
		private var timeImg:Image;
		private var time:int=0;

		public function LastTimeImageManager() {
			super(new XML());
			this.init();
			this.hideBg();
			this.clsBtn.visible=false;
		}

		public static function getInstance():LastTimeImageManager {
			if (_instance == null)
				_instance=new LastTimeImageManager();

			return _instance;
		}

		private function init():void {
			this.timeImg=new Image("ui/num/0_lz.png");
			this.addChild(this.timeImg);

		}

		/**
		 *
		 * @param num 时间数
		 * @param type 自定义类型
		 *
		 */
		public function showPanel(num:int, type:int=0):void {
			if (this.time > 0)
				return;

			if (this.parent == null)
				LayerManager.getInstance().windowLayer.addChild(this);

			this.time=num;
			this.type=type;

			this.show(true, UIEnum.WND_LAYER_TOP, true);

			this.reSize();

			this.timeImg.updateBmp(this.imgUrl[type].replace(/\d/g, this.time));
			TimerManager.getInstance().add(updateTime);
		}

		private function updateTime(i:int):void {

			if (this.time - i <= 0) {
				this.time=0;
				TimerManager.getInstance().remove(updateTime);
				this.hide();
			}

			this.timeImg.updateBmp(this.imgUrl[type].replace(/\d/g, this.time - i));
		}

		public function reSize():void {

			this.x=UIEnum.WIDTH - this.width >> 1;
			this.y=UIEnum.HEIGHT - this.height >> 1;

			this.timeImg.x=this.width - this.timeImg.width >> 1;
			this.timeImg.y=this.height - this.timeImg.height >> 1;

		}

	}
}

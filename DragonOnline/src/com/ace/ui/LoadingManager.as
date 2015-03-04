package com.ace.ui {

	import com.ace.enum.EventEnum;
	import com.ace.enum.UIEnum;
	import com.ace.manager.EventManager;
	import com.ace.manager.LoadingManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.greensock.TweenLite;
	import com.leyou.ui.loading.LoadingRen;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class LoadingManager extends Sprite {

		private var loadArr:Vector.<LoadingRen>;

		public function LoadingManager() {
			super();
			this.init();
		}

		private function init():void {
			this.loadArr=new Vector.<LoadingRen>();
			EventManager.getInstance().addEvent(EventEnum.LIVING_STOP_COLLECT, this.hide);
		}

		/**
		 * @param t
		 * @param callBack
		 * @param type 0,采集; 1,坐骑
		 */
		public function startProgress(t:Number, callBack:Function, type:int=0):void {

			this.resize();

			var runingIndex:int=-1;

			var i:int=0;
			var j:int=0;
			var temp:LoadingRen;

			for each (temp in this.loadArr) {

				if (!temp.running) {

					if (runingIndex == -1)
						runingIndex=i;

				} else {

					if (temp.getType() == type)
						return;

//					temp.x=120;
					TweenLite.to(temp, 1, {y: j * 40});

					j++;
				}

				i++;
			}


			if (runingIndex != -1) {

				this.loadArr[runingIndex].startProgress(t, callBack, type);
//				this.loadArr[runingIndex].x=120;
				this.loadArr[runingIndex].y=j * 40;

			} else {

				temp=new LoadingRen();
				this.addChild(temp);

//				temp.x=120;
				temp.y=j * 40;

				this.loadArr.push(temp);
				this.loadArr[j].startProgress(t, callBack, type);
			}
			
			 
		}

		/**
		 * 
		 * @param type 0,采集;
		 * 
		 */		
		public function hide(type:int=0):void {
			var temp:LoadingRen;

			for each (temp in this.loadArr) {
				if (temp.getType() == type) {
					temp.hide();
					break;
				}
			}
		}

		public function resize():void {
			this.y=UIEnum.HEIGHT - 200;
			this.x=(UIEnum.WIDTH - 269) >> 1;
		}

	}
}

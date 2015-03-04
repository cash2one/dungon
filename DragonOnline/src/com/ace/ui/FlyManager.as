package com.ace.ui {

	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Expo;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	public class FlyManager {

//		private var img:Image;
		private var stg:Stage;

		private var aidArr:Array=[];
		private var spArr:Array=[];

		private var curraid:int=0;
		private var currsp:Point;

		private static var _instance:FlyManager;

		private var _timerid:int=0;
		private var curroffset:Number=0;


		public static function getInstance():FlyManager {
			if (_instance == null)
				_instance=new FlyManager();

			return _instance;
		}

		public function FlyManager() {

		}

		public function setup(stg:Stage):void {
			this.stg=stg;
		}

		private function fly(id:int, sp:Point, ep:Point, size:Array, stype:int):void {

			var info:*=TableManager.getInstance().getItemInfo(id);

			if (info == null)
				info=TableManager.getInstance().getEquipInfo(id);

			if (info == null)
				return;

			var img:Image=new Image();
			this.stg.addChild(img);
			switch (stype) {
				case 0:
					img.updateBmp("ico/items/" + info.icon + ".png");
					break;
				case 1:  {
					if (info.dropIcon != null && info.dropIcon != "") {
						img.updateBmp("ico/items/" + info.dropIcon + ".png");
						if (info.id != "65535") {
							size[0]=100;
							size[1]=100;
						}
					} else {
						img.updateBmp("ico/items/" + info.icon + ".png");
					}
					break;
				}
			}

			img.setWH(size[0], size[1]);

			img.x=sp.x;
			img.y=sp.y;

			if (size[0] != 100) {
				ep.x=ep.x + (size[0] / 4);
				ep.y=ep.y + (size[1] / 4)
			}

			TweenMax.to(img, 2.5, {bezierThrough: [{x: sp.x + 80, y: sp.y - 30, width: size[0], height: size[1]}, {x: ep.x, y: ep.y}], width: int(size[0]) * 0.5, height: int(size[1]) * 0.5, ease: Expo.easeIn(1, 10, 1, 1), onComplete: complete, onCompleteParams: [img], delay: this.curroffset})

			this.curroffset+=.2;

			function complete(_i:Image):void {
				if (_i.parent == stg)
					stg.removeChild(_i);
			}
		}

		/**
		 * 飞入背包
		 * @param id
		 * @param p
		 *
		 */
		private function flyBag(id:int, sp:Point, size:Array, stype:int):void {
			var bagBtn:ImgButton=UIManager.getInstance().toolsWnd.getBagBtn();
			var ep:Point=(bagBtn.parent.localToGlobal(new Point(bagBtn.x, bagBtn.y)));

			this.fly(id, sp, ep, size, stype);
		}

		/**
		 * *飞入背包
		 * @param aid 数组
		 * @param startPoint 开始位置
		 * @param size 开始大小
		 * @param stype 来源类型:0,普通;1,掉落
		 *
		 */
		public function flyBags(aid:Array, startPoint:Array, size:Array=null, stype:int=0):void {

			this.curroffset=0;

			for (var i:int=0; i < aid.length; i++) {
				if (size != null && size.length > 0)
					this.flyBag(aid[i], startPoint[i], size[i], stype);
				else
					this.flyBag(aid[i], startPoint[i], [40, 40], stype);
			}
		}

	}
}

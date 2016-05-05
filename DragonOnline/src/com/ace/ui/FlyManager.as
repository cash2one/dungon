package com.ace.ui {

	import com.ace.effect.RotationBlackEffect;
	import com.ace.enum.UIEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;

	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.geom.Point;

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

		private var currentExpOrHun:int=0;
		private var expOrHunTwwen:TweenLite;

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
						} else {
							ep.x=90;
							ep.y=25;
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

			TweenMax.to(img, 1.5, {bezierThrough: [{x: sp.x + 80, y: sp.y - 30, width: size[0], height: size[1]}, {x: ep.x, y: ep.y}], width: int(size[0]) * 0.5, height: int(size[1]) * 0.5, ease: Expo.easeIn(1, 10, 1, 1), onComplete: complete, onCompleteParams: [img], delay: this.curroffset})

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

		public function flyBagsII(gridArr:Vector.<GridBase>, stype:int=0):void {
			this.curroffset=0;

			for (var i:int=0; i < gridArr.length; i++) {
				this.flyBag(gridArr[i].dataId, gridArr[i].parent.localToGlobal(new Point(gridArr[i].x, gridArr[i].y)), [gridArr[i].width, gridArr[i].height], stype);
			}
		}

		/**
		 *  删除经验与魂力
		 */
		public function flyBags_II(aid:Array, startPoint:Array, size:Array=null, stype:int=0):void {

			this.curroffset=0;

			for (var i:int=0; i < aid.length; i++) {
				if (65533 == aid[i] || 65534 == aid[i])
					continue;
				if (size != null && size.length > 0)
					this.flyBag(aid[i], startPoint[i], size[i], stype);
				else
					this.flyBag(aid[i], startPoint[i], [40, 40], stype);
			}
		}


		/**
		 *
		 * @param ptype 1:任务;2:场景;
		 * @param num 数量
		 * @param type 1:exp;2:魂力;
		 * @param sP位置
		 *
		 */
		public function flyExpOrHonour(ptype:int, num:int, type:int, sP:Point):void {

			if (num <= 100)
				return;

			if (ptype == 2 && UIManager.getInstance().taskNpcTalkWnd.taskConfirmSucc) {
				return;
			}

			this.flyExpOrHonours(type, sP);

		}

		private function flyExpOrHonours(type:int, sP:Point):void {

			var arr:Array=[];
			var url:String;
			var eP:Point;
			var eff:RotationBlackEffect;
			for (var i:int=0; i < 5; i++) {

				if (type == 1) {
					eff=new RotationBlackEffect("ui/num/point_exp.jpg");
					eP=UIManager.getInstance().toolsWnd.getExpPos();

				} else if (type == 2) {
					eff=new RotationBlackEffect("ui/num/point_energy.jpg");
					eP=UIManager.getInstance().toolsWnd.getHunPos();

				}

				this.stg.addChild(eff);

				eff.scaleX=0.7;
				eff.scaleY=0.7;

				eff.x=sP.x - 20 + Math.random() * 40;
				eff.y=sP.y - 20 + Math.random() * 40;

				var ox:int=0;
				var oy:int=sP.y + (eP.y - sP.y) / 2;

				if (sP.x < UIEnum.WIDTH / 2) {
					ox=sP.x - 30;
				} else {
					ox=sP.x + 30;
				}

				if (ox > UIEnum.WIDTH) {
					ox=UIEnum.WIDTH;
				} else if (ox < 105) {
					ox=sP.x + (eP.x - sP.x) / 3;
				}

				TweenMax.to(eff, 1, {bezierThrough: [{x: ox, y: oy}, {x: eP.x, y: eP.y}], onComplete: complete, onCompleteParams: [eff, i], delay: i * 0.1});
			}

		}


		private function complete(eff:DisplayObjectContainer, i:int):void {

			this.stg.removeChild(eff);

			if (i == 4) {
				UIManager.getInstance().toolsWnd.updatePropPoint();
			}
		}



	}
}

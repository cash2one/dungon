/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-11-25 上午11:34:06
 */
package com.ace.game.scene.ui.effect {
	import com.ace.enum.EffectEnum;
	import com.ace.game.scene.ui.SceneUIManager;
	import com.ace.game.utils.SceneUtil;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;

	import flash.geom.Point;

	public class BubbleEffect extends BubbleModel {
		private var _isFirst:Boolean;
		private var _isUsed:Boolean;
		private var _type:int;
		private var _pt:Point;
		private var fromPt:Point;
		private var toPt:Point;

		public function BubbleEffect() {
			super();
		}

		override public function free():void {
			_pt=null;
			clear();
			super.free();
		}

		override public function show(effectType:int, num:int, color:String, str:String="", ico:String="", ptArr:Array=null, showZero:Boolean=false, strFront:Boolean=true):void {
			isUsed=true;
			this.alpha=1;
			if (null != ptArr) {
				fromPt=ptArr[0];
				toPt=ptArr[1];
				_pt=SceneUtil.findPtByExLen(fromPt, toPt, 150);
//				_pt = findRandomPtByExLen(fromPt, toPt, 100);
			}
			super.show(effectType, num, color, str, ico, ptArr, showZero, strFront);
		}

		public function play(effectType:int):void {
			//			return;
			if (null == _pt) {
				// 玩家控制角色自己头顶显示
				_type=effectType;
				var tmpX:Number;
				var tmpY:Number;
				if (effectType == EffectEnum.BUBBLE_LINE) { //直线向上
					tmpX=x;
					tmpY=y - 50;
					TweenMax.to(this, 1, {x: tmpX, y: tmpY, ease: Quart.easeOut, onComplete: onPlayOver});
				}
				if (effectType == EffectEnum.BUBBLE_LEFT) { //左抛
					tmpX=x - 150;
					tmpY=y - 50;
					TweenMax.to(this, 1, {x: tmpX, y: tmpY, bezier: [{x: tmpX, y: tmpY}], /*onUpdate: onTick,*/ onComplete: onPlayOver});
				}
				if (effectType == EffectEnum.BUBBLE_RIGHT) { //右抛
					tmpX=x + 150;
					tmpY=y - 50;
					TweenMax.to(this, 1, {x: tmpX, y: tmpY, bezier: [{x: tmpX, y: tmpY}], onComplete: onPlayOver});
				}
			} else {
				// 其他玩家,或者怪物
				TweenMax.to(this, 0.7, {x: (_pt.x - width * 0.5), y: (_pt.y - height * 0.5), ease: Quart.easeOut, onComplete: onPlayOver});
				_pt=SceneUtil.findPtByExLen(fromPt, toPt, 150 + 100 - (Math.random() * 100000) % 50);
			}
		}

		private function onTick():void {
//			trace("当前坐标点：", x, y);
		}

		//动画播放完毕后调用
		private function onPlayOver():void {
			if (null == _pt) {
				var tmpX:Number;
				var tmpY:Number;
//				var k:int = 1;/*((Math.random()*1000)%1000 >= 500) ? 1 : -1;*/
				if (EffectEnum.BUBBLE_LINE == _type) { //直线
					free();
					SceneUIManager.getInstance().onBubbleEffectOver(this);
					return;
				} else if (EffectEnum.BUBBLE_LEFT == _type) { // 左抛
					tmpX=x - width - (Math.random() * 100000) % 20;
					tmpY=y - /*k**/ (Math.random() * 100000) % 80;
				} else if (EffectEnum.BUBBLE_RIGHT == _type) { //右抛
					tmpX=x + width + (Math.random() * 100000) % 20;
					tmpY=y - /*k**/ (Math.random() * 100000) % 80;
				}
			} else {
				tmpX=(_pt.x - width * 0.5);
				tmpY=(_pt.y - height * 0.5);
			}
			TweenMax.to(this, 0.5, {x: tmpX, y: tmpY, alpha: 0.3, /*delay:0.2, */ ease: Quart.easeOut, onComplete: onMoveOver});
		}

		private function onMoveOver():void {
			free();
			//可以抛事件给容器
			SceneUIManager.getInstance().onBubbleEffectOver(this);
		}
	}
}

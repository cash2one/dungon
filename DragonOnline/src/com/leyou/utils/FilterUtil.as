package com.leyou.utils {
	
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.core.TweenCore;
	
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.filters.GradientGlowFilter;

	public class FilterUtil {

		public static var enablefilter:ColorMatrixFilter=new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0]);

		public static var greenGlowFilter:GlowFilter=new GlowFilter(0x0e8671);
		public static var yellowGlowFilter:GlowFilter=new GlowFilter(0xffff00);

		public static var grayFilter:ColorMatrixFilter=new ColorMatrixFilter([0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0]);
		public static var redFilter:ColorMatrixFilter=new ColorMatrixFilter([.5, .1, .1, .1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0]);
		public static var blackStrokeFilters:Array=[new GlowFilter(0x000000, 1, 2, 2, 4)];
		public static var NotifyOutterFilter:GradientGlowFilter = new GradientGlowFilter(0,0,[0xff00ff,0xCC1FC6,0xCC1FC6],[0,1,1],[0,64,255],10,10,1,2,"outer");
		
		public function FilterUtil() {

		}

		/**
		 *
		 * @param d
		 * @param _color
		 * @param _alpha
		 * @param _blurX
		 * @param _blurY
		 * @param _strength
		 * @return
		 *
		 */
		public static function showGlowFilter(d:DisplayObject, t:Number=2, _color:uint=0x0e8671, _alpha:int=1, _blurX:int=6, _blurY:int=6, _strength:int=6):TweenCore {

			var tl:TimelineMax=new TimelineMax({repeat: -1});

			tl.active=true;

			tl.append(TweenMax.to(d, t, {glowFilter: {color: _color, alpha: _alpha, blurX: _blurX, blurY: _blurY, strength: _strength}}));
			tl.append(TweenMax.to(d, t, {glowFilter: {color: _color, alpha: _alpha, blurX: .3, blurY: .3, strength: _strength}}));

			return tl;
		}

		public static function updatePlayer(arr:Array):TweenCore {

			var tl:TimelineMax=new TimelineMax({repeat: -1});

			tl.active=true;

//			tl.appendMultiple(arr);
//			tl.insertMultiple(arr);

			for (var i:int=0; i < arr.length; i++) {
				tl.append(arr[i]);
			}
			
			return tl;
		}


		/**
		 *黑色描边
		 * @param obj
		 *
		 */
		public static function showBlackStroke(obj:DisplayObject):void {
			obj.filters=blackStrokeFilters;
		}

		/**
		 * 给定颜色描边
		 * @param color
		 * @return
		 *
		 */
		public static function showBorder(color:uint):GlowFilter {
			return new GlowFilter(color, 1, 2, 2, 4)
		}

		/**
		 * 发光
		 * @param color
		 * @return
		 *
		 */
		public static function showGlowFilterByColor(color:uint):GlowFilter {
			return new GlowFilter(color, 1, 10, 10, 4)
		}

	}
}

package com.leyou.utils
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class PixelUtil
	{
		private static var _matrix:Matrix = new Matrix();
		
		private static var _bitmap:BitmapData = new BitmapData(1, 1);
		
		public function PixelUtil()
		{
		}
		
		/**
		 * <T>测试显示对象目标点的透明度</T>
		 * 
		 * @param target 显示对象
		 * @param x      横坐标
		 * @param y      纵坐标
		 * @param threshold 阀值
		 * @return       是否满足
		 * 
		 */		
		public static function getIsHit(target:DisplayObject, x:int, y:int, threshold:uint):Boolean{
			_bitmap.setPixel32(0, 0, 0xffffff);
			_matrix.tx = -x;
			_matrix.ty = -y;
			_bitmap.draw(target, _matrix, null, null, new Rectangle(0, 0, 1, 1));
			var alpha:uint = _bitmap.getPixel32(0, 0) >> 24 & 0xFF;
			if(alpha > 10 && alpha < threshold){
				trace("-------target"+ target + "-------alpha = " + alpha + "-------threshold = " + threshold);
			}
			if(alpha > threshold){
				return true;
			}
			return false;
		}
	}
}
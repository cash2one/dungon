package com.leyou.utils {
	
	import com.ace.manager.LibManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class ColorUtil {

		public static const COLOR_GOLD:String="";

		public function ColorUtil() {
		}

		/**
		 * 血脉 color
		 * @param u
		 * @return
		 *
		 */
		public static function getBadgeColor(u:int):uint {
			if (u >= 100 && u < 200)
				return 0x69e053;
			else if (u >= 200 && u < 300)
				return 0x3fa6ed;
			else if (u >= 300 && u < 400)
				return 0xcc54ea;
			else if (u == 400)
				return 0xf6d654;

			return 0xffffff;
		}

		/**
		 * 战斗力
		 * @param s
		 * @return
		 *
		 */
		public static function getBitmapDataByInt(s:String):BitmapData {

			var bd:BitmapData=new BitmapData(s.length * 15, 21);
			var _bd:BitmapData;

			for (var i:int=0; i < s.length; i++) {
				_bd=LibManager.getInstance().getImg("ui/num/" + s.charAt(i) + "_zdl.png");
				bd.copyPixels(_bd, new Rectangle(0, 0, _bd.width, _bd.height), new Point(i * _bd.width, 0));
			}

			return bd;
		}

		/**
		 * 背包格子强化等级
		 * @param s
		 * @return
		 *
		 */
		public static function getEquipBitmapDataByInt(s:String):BitmapData {

			var bd:BitmapData=new BitmapData((s.length+1) * 10, 11,true,0x00000000);
			var _bd:BitmapData=LibManager.getInstance().getImg("ui/num/equip_plus.png");
			bd.copyPixels(_bd, new Rectangle(0, 0, _bd.width, _bd.height), new Point(2, 0));

			for (var i:int=0; i < s.length; i++) {
				_bd=LibManager.getInstance().getImg("ui/num/equip_" + s.charAt(i) + ".png");
				bd.copyPixels(_bd, new Rectangle(0, 0, _bd.width, _bd.height), new Point((i+1) * _bd.width, 0));
			}

			return bd;
		}

	}
}

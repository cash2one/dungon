package com.leyou.utils {

	public class TimeUtil {

		private static var month:Array=[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

		public function TimeUtil() {
		}

		public static function getStringToDate(s:String):Date {
			if (s == null || s == "")
				return null;

			var d:Array=s.split(" ");
			var ymd:Array=d[0].split("-");
			var hms:Array=d[1].split(":");

			var dt:Date=new Date(ymd[0], ymd[1], ymd[2], hms[0], hms[1], hms[2]);
			return dt;
		}

		/**
		 * 获取24小时后的
		 * @param d
		 * @return
		 *
		 */
		public static function getDateTo24hour(d:Date):Date {
			return new Date(d.fullYear, d.month, d.date + 1, d.hours, d.minutes, d.seconds);
		}

		/**
		 * 获取2个月之后的
		 * @param d
		 * @return
		 *
		 */
		public static function getDateTo2month(d:Date):Date {
			return new Date(d.fullYear, d.month + 2, d.date, d.hours, d.minutes, d.seconds);
		}

		/**
		 * 日期转string
		 * @param d
		 * @return
		 *
		 */
		public static function getDateToString(d:Date):String {

			var ss:String="";
			var mm:String="";
			var hh:String="";

			if (d.seconds < 10) {
				ss="0" + d.seconds;
			} else {
				ss="" + d.seconds;
			}

			if (d.minutes < 10) {
				mm="0" + d.minutes;
			} else {
				mm="" + d.minutes;
			}

			if (d.hours < 10) {
				hh="0" + d.hours;
			} else {
				hh="" + d.hours;
			}

			return d.fullYear + "-" + (d.month + 1) + "-" + d.date + " " + hh + ":" + mm + ":" + ss;
		}
		
		/**
		 * 
		 * @param d
		 * @return 
		 * 
		 */		
		public static function getTimeToString(d:Date):String {

			var ss:String="";
			var mm:String="";
			var hh:String="";

			if (d.seconds < 10) {
				ss="0" + d.seconds;
			} else {
				ss="" + d.seconds;
			}

			if (d.minutes < 10) {
				mm="0" + d.minutes;
			} else {
				mm="" + d.minutes;
			}

			if (d.hours < 10) {
				hh="0" + d.hours;
			} else {
				hh="" + d.hours;
			}

			return hh + ":" + mm + ":" + ss;
		}


		/**
		 * 时间戳转时间
		 * @param _i
		 * @return hh:mm:ss
		 *
		 */
		public static function getIntToTime(_i:int):String {
			if (_i <= 0)
				return "";

			var s:int=_i % 60;
			var m:int=_i / 60 % 60;
			var h:int=_i / 60 / 60; // % 24;

			var ss:String="";
			var mm:String="";
			var hh:String="";

			if (s < 10) {
				ss="0" + s;
			} else {
				ss="" + s;
			}

			if (m < 10) {
				mm="0" + m;
			} else {
				mm="" + m;
			}

			if (h < 10) {
				hh="0" + h;
			} else {
				hh="" + h;
			}


			if (h > 0)
				return hh + ":" + mm + ":" + ss;

			if (m > 0)
				return mm + ":" + ss;

			if (s > 0)
				return "00:" + ss;

			return "00:00";
		}

		/**
		 * 返回带日期的格式
		 * @param _i 秒
		 * @return 1天1时1分1秒
		 *
		 */
		public static function getIntToDateTime(_i:int):String {
			if (_i <= 0)
				return "";

//			var mon:int=new Date().month;

			var s:int=_i % 60;
			var m:int=_i / 60 % 60;
			var h:int=_i / 60 / 60 % 24;
			var d:int=_i / 60 / 60 / 24; // % int(month[mon]);

			if (d > 0) {
				return d + "天" + h + "时" + m + "分" + s + "秒";
			}

			if (h > 0) {
				return h + "时" + m + "分" + s + "秒";
			}

			if (m > 0) {
				return m + "分" + s + "秒";
			}

			if (s > 0) {
				return s + "秒";
			}

			return "0秒";
		}

		public static function getWeekStringByInt(i:int):String {

			switch (i) {
				case 0:
					return "周日";
				case 1:
					return "周一";
				case 2:
					return "周二";
				case 3:
					return "周三";
				case 4:
					return "周四";
				case 5:
					return "周五";
				case 6:
					return "周六";
				case 7:
					return "周日";
			}

			return "";
		}

	}
}

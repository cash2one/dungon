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


		public static function getStringToTime(s:String):Date {
			if (s == null || s == "")
				return null;

			var hms:Array=s.split(":");

			var dt:Date=new Date();
			dt.hours=hms[0];
			dt.minutes=hms[1];
			dt.seconds=hms[2];

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


		public static function getDateToString2(d:Date):String {

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

			return d.fullYear + "年" + (d.month + 1) + "月" + d.date + "日" + hh + "时" + mm + "分"; // + ss + "秒";
		}

		public static function getDateToString3(d:Date):String {

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

			return d.fullYear + "年" + (d.month + 1) + "月" + d.date + "日" + hh + ":" + mm + ":" + ss;
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
				return d + PropUtils.getStringById(1783) + h + PropUtils.getStringById(2062) + m + PropUtils.getStringById(2147) + s + PropUtils.getStringById(2146);
			}

			if (h > 0) {
				return h + PropUtils.getStringById(2062) + m + PropUtils.getStringById(2147) + s + PropUtils.getStringById(2146);
			}

			if (m > 0) {
				return m + PropUtils.getStringById(2147) + s + PropUtils.getStringById(2146);
			}

			if (s > 0) {
				return s + PropUtils.getStringById(2146);
			}

			return "0" + PropUtils.getStringById(2146);
		}

		public static function getWeekStringByInt(i:int):String {

			switch (i) {
				case 0:
					return PropUtils.getStringById(2063);
				case 1:
					return PropUtils.getStringById(2064);
				case 2:
					return PropUtils.getStringById(2065);
				case 3:
					return PropUtils.getStringById(2066);
				case 4:
					return PropUtils.getStringById(2067);
				case 5:
					return PropUtils.getStringById(2068);
				case 6:
					return PropUtils.getStringById(2069);
				case 7:
					return PropUtils.getStringById(2063);
			}

			return "";
		}

	}
}

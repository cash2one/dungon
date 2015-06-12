package com.leyou.util {
	import com.ace.utils.StringUtil;
	import com.leyou.utils.PropUtils;



	public class DateUtil {
		// 闰年每月的天数
		private static const LEAP_MONTH_DAYS_NUM:Array=[31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

		// 平年每月天数
		private static const NORMAL_MONTH_DAYS_NUM:Array=[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

		/**
		 * <T>获得一个日期数据</T>
		 */
		public static function getDate(t:Number=0):Date {
			if (0 == t) {
				return new Date();
			}
			return new Date(t);
		}

		/**
		 * <T>根据日期计算周日期</T>
		 * <P>基本思想是计算出当前天是从公元元年一月一日开始的第几天，
		 *    再利用星期的周期性来计算公元任何一天是星期几</P>
		 *
		 * @return 0为星期天,1为周一,依次类推
		 */
		public static function getWeekDay(year:int, month:int, day:int):int {
			var e:int;
			switch (month) {
				case 1:
					e=day;
					break;
				case 2:
					e=31 + day;
					break;
				case 3:
					e=59 + day;
					break;
				case 4:
					e=90 + day;
					break;
				case 5:
					e=120 + day;
					break;
				case 6:
					e=151 + day;
					break;
				case 7:
					e=181 + day;
					break;
				case 8:
					e=212 + day;
					break;
				case 9:
					e=243 + day;
					break;
				case 10:
					e=273 + day;
					break;
				case 11:
					e=304 + day;
					break;
				case 12:
					e=334 + day;
					break;
				default:
					return -1;
			}
			if (isLeapYear(year)) {
				if (month > 2) {
					e++;
				}
			}
			year--;
			var wd:int=year + int(year / 4) - int(year / 100) + int(year / 400) + e;
			return wd % 7;
		}

		/**
		 * <T>判定年份是否是闰年</T>
		 */
		public static function isLeapYear(year:int):Boolean {
			return ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);
		}

		/**
		 * <T>获得月份的天数</T>
		 *
		 */
		public static function getMonthDayCount(y:int, m:int):int {
			if (isLeapYear(y)) {
				return LEAP_MONTH_DAYS_NUM[m - 1];
			}
			return NORMAL_MONTH_DAYS_NUM[m - 1];
		}

		//============================================================
		// <T>格式化时间成指定格式。</T>
		//
		// @param date 时间
		// @param foramt 格式(YYYY-MM-DD HH：MI：SS)
		// @return 格式化后字符串
		//
		//============================================================
//		public static function parse(time:Number, format:String="HH:MI:SS", isLocal:Boolean=false):String {
//			var hour:uint = time/(1000 * 60 * 60);
//			time -= hour * 1000 * 60 * 60;
//			var minute:uint = time/(1000 * 60);
//			time -= minute * 1000 * 60;
//			var second:uint = time/1000;
//			switch(format){
//				case "HH":
//					if(!isLocal){
//						return hour + "";
//					}else{
//						return hour + "小时";
//					}
//				case "HH:MI":
//					if(!isLocal){
//						return hour + ":" + minute;
//					}else{
//						return hour + "小时" + minute + "分";
//					}
//				case "HH:MI:SS":
//					if(!isLocal){
//						return hour + ":" + minute + ":" + second;
//					}else{
//						return hour + "小时" + minute + "分钟"+second+"秒";
//					}
//				case "DD:HH:MI:SS":
//					var day:uint = hour/24;
//					hour %= 24;
//					if(!isLocal){
//						return day + ":" + hour + ":" + minute + ":" + second;
//					}else{
//						return day + "天" + hour + "时" + minute + "分"+second+"秒";
//					}
//				case "MI:SS":
//					minute = time/(60);
//					time -= minute * 60;
//					if(!isLocal){
//						return hour + ":" + minute;
//					}else{
//						return hour + "分钟" + minute + "秒";
//					}
//			}
//			return null;
//		}

		//============================================================
		// <T>格式化时间成指定格式。</T>
		//
		// @param date 日期	
		// @param foramt 格式(1 -- 对应文档中公告类时间 2 -- 对应文档中普通倒计时 3 -- 对应文档中固定格式)
		// @return 格式化后字符串
		//============================================================
		public static function formatTime(time:Number, format:int):String {
			var content:String="";
			var day:uint=time / (24 * 1000 * 60 * 60);
			if (day > 0) {
				time-=day * (24 * 1000 * 60 * 60);
			}
			var hour:uint=time / (1000 * 60 * 60);
			if (hour > 0) {
				time-=hour * 1000 * 60 * 60;
			}
			var minute:uint=time / (1000 * 60);
			if (minute > 0) {
				time-=minute * 1000 * 60;
			}
			var second:uint=time / 1000;
			switch (format) {
				case 1:
					if (minute > 0) {
						content+=minute + PropUtils.getStringById(2147);
					}
					if (second > 0) {
						content+=second + PropUtils.getStringById(2146);
					}
					break;
				case 2:
					if (day > 0) {
						content+=day + PropUtils.getStringById(1783);
					}
					if (hour > 0 || ("" != content)) {
						content+=hour + PropUtils.getStringById(2062);
					}
					if (minute > 0 || ("" != content)) {
						content+=minute + PropUtils.getStringById(2147);
					}
					if (second > 0 || ("" != content)) {
						content+=second + PropUtils.getStringById(2146);
					}
					break;
				case 3:
					if (day > 0) {
						content+=day + PropUtils.getStringById(1783);
						return content;
					}
					if (hour > 0) {
						content+=hour + PropUtils.getStringById(2062);
						return content;
					}
					if (minute > 0) {
						content+=minute + PropUtils.getStringById(2147);
						return content;
					}
					if (second > 0) {
						content+=second + PropUtils.getStringById(2146);
						return content;
					}
					break;
				default:
					throw new Error("unknow time format");
					break;
			}
			return content;
		}

		//============================================================
		// <T>格式化时间成指定格式。</T>
		//
		// @param date 日期	
		// @param foramt 格式(如YYYY-MM-DD HH：MI：SS, HH12为12小时制,HH24为24小时制)
		// @return 格式化后字符串
		//============================================================
		public static function formatDate(date:Date, format:String):String {
			format=format.replace("YYYY", date.fullYear);
			format=format.replace("YY", date.fullYear % 100);
			format=format.replace("MM", StringUtil.fillTheStr(date.month + 1, 2, "0"));
			format=format.replace("DD", StringUtil.fillTheStr(date.date, 2, "0"));
			format=format.replace("HH12", StringUtil.fillTheStr(date.hours % 12, 2, "0"));
			format=format.replace("HH24", StringUtil.fillTheStr(date.hours, 2, "0"));
			format=format.replace("MI", StringUtil.fillTheStr(date.minutes, 2, "0"));
			format=format.replace("SS", StringUtil.fillTheStr(date.seconds, 2, "0"));
			format=format.replace("MS", StringUtil.fillTheStr(date.milliseconds, 2, "0"));
			return format;
		}
	}
}

package com.leyou.data.calendar
{
	import com.leyou.util.DateUtil;

	public class MonthInfo
	{
		public var year:int;
		
		public var month:int;
		
		private var days:Vector.<DayInfo> = new Vector.<DayInfo>();
		
		private var _currentDay:DayInfo;
		
		public function MonthInfo(){
		}
		
		public function get currentDay():DayInfo{
			return _currentDay;
		}
		
		public function initByDate(y:int, m:int, d:int):void{
			year = y;
			month = m;
			days.length = DateUtil.getMonthDayCount(year, month);
			var length:int = days.length;
			for(var n:int = 0; n < length; n++){
				var day:DayInfo = days[n];
				if(null == day){
					day = new DayInfo();
					days[n] = day;
				}
				day.day = n + 1;
				day.month = month;
				day.year = year;
				day.weekDay = DateUtil.getWeekDay(year, month, day.day);
			}
			_currentDay = days[d-1];
		}

		public function initByTick(tick:Number):void{
			var date:Date = DateUtil.getDate(tick);
			year = date.fullYear;
			month = date.month+1;
			days.length = DateUtil.getMonthDayCount(year, month);
			var length:int = days.length;
			for(var n:int = 0; n < length; n++){
				var day:DayInfo = days[n];
				if(null == day){
					day = new DayInfo();
					days[n] = day;
				}
				day.day = n + 1;
				day.month = month;
				day.year = year;
				day.weekDay = DateUtil.getWeekDay(year, month, day.day);
				
				// 临时用
//				if(n < date.date){
//					day.signStatus = int(Math.random()*10000)%3;
//				}
			}
			_currentDay = days[date.date-1];
		}
		
		public function getDay(day:int):DayInfo{
			return days[day - 1];
		}
		
		public function isToday(day:DayInfo):Boolean{
			return (_currentDay == day);
		}
		
		public function get count():int{
			return days.length;
		}
	}
}
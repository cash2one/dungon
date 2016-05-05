package com.leyou.ui.welfare.child.component {
	import com.leyou.data.calendar.DayInfo;
	import com.leyou.data.calendar.MonthInfo;
	import com.leyou.enum.CalendarEnum;

	import flash.display.Sprite;

	public class CalendarRender extends Sprite {
		private var dayRenders:Vector.<CalendarDayRender>;

		private var renderContainer:Sprite;

		private var monthInfo:MonthInfo;

		private var _signCount:int;

		public function CalendarRender() {
			init();
		}

		public function get signCount():int {
			return _signCount;
		}

		private function init():void {
			monthInfo=new MonthInfo();
			dayRenders=new Vector.<CalendarDayRender>();
			dayRenders.length=6 * 7;

			renderContainer=new Sprite();
			addChild(renderContainer);
		}

		public function getMonth():int {
			return monthInfo.month;
		}

		public function getDay():int {
			if (monthInfo && monthInfo.currentDay) {
				return monthInfo.currentDay.day;
			} else {
				return -1;
			}
		}

		public function updateTimeByTick(tick:Number):void {
			_signCount=0;
			monthInfo.initByTick(tick);
			updateUI();
		}

		public function updateTimeByDate(year:int, month:int, day:int):void {
			_signCount=0;
			monthInfo.initByDate(year, month, day);
			updateUI();
		}

		public function setDayStatus(day:int, status:int):void {
			var dayInfo:DayInfo=monthInfo.getDay(day);
			dayInfo.signStatus=status;
			if (CalendarEnum.SIGN_STATUS_SIGNED == status) {
				_signCount++;
			}
		}

		public function updateUI():void {
			// 取得当月第一天是星期几
			var firstDay:DayInfo=monthInfo.getDay(1);
			for (var n:int=0; n < 6; n++) {
				for (var m:int=0; m < 7; m++) {
					var dayRender:CalendarDayRender=dayRenders[7 * n + m];
					if (null == dayRender) {
						dayRender=new CalendarDayRender();
						dayRenders[7 * n + m]=dayRender;
					}
					// 计算与周日期的差值
					var dayIndex:int=7 * n + m + 1 - firstDay.weekDay;
					dayRender.updataInfo(monthInfo, dayIndex);
					dayRender.x=m * 76;
					dayRender.y=n * 30;
					renderContainer.addChild(dayRender);
				}
			}
		}
	}
}

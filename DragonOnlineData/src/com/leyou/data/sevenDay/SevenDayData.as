package com.leyou.data.sevenDay
{
	import flash.utils.getTimer;

	public class SevenDayData
	{
		private var _currentDay:int;
		
		private var _currentDayStatus:int;
		
		private var _openT:uint;
		
		private var _currentT:uint;
		
		private var dayTasks:Object;
		
		private var tick:int;
		
		public function SevenDayData(){
			dayTasks = {};
		}
		
		public function get currentDayStatus():int{
			return _currentDayStatus;
		}

		public function get currentDay():int{
			return _currentDay;
		}

		public function loadData_I(obj:Object):void{
			_currentDayStatus = obj.dr;
			var day:int = obj.d;
			var taskInfo:SevenDayTaskData = dayTasks[day];
			if(null == taskInfo){
				taskInfo = new SevenDayTaskData();
				dayTasks[day] = taskInfo;
			}
			taskInfo.unserialize(obj);
		}
		
		public function remianT():int{
			return 7*24*60*60 - (_currentT + (getTimer() - tick)/1000 - _openT);
		}
		
		public function getDayTaskInfo(day:int):SevenDayTaskData{
			return dayTasks[day];
		}
		
		public function loadData_T(obj:Object):void{
			_currentDay = obj.cd;
			_openT = obj.utime;
			_currentT = obj.ctime;
			_openT = _openT - _openT%(24*60*60);
		}
		
	}
}
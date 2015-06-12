package com.leyou.data.celebrate
{
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.utils.PropUtils;
	
	import flash.utils.getTimer;
	

	public class AreaCelebrateData
	{
		private var _openTime:uint;
		
		private var _cTime:uint;
		
		private var tick:int;
		
		private var typeTasks:Object={};
		
		public function AreaCelebrateData(){
		}
		
		public function get currentDay():int{
			var interval:int = _cTime - _openTime;
			return Math.ceil(interval/60/60/24);
		}
		
		public function getActiveTime():String{
			var tpl:String = PropUtils.getStringById(2075);
			var openDate:Date = new Date(_openTime*1000);
			var endDate:Date = new Date((_openTime+ConfigEnum.welfare19*24*60*60)*1000);
			return StringUtil.substitute(tpl, openDate.fullYear, (openDate.month+1), openDate.date, endDate.fullYear, (endDate.month+1), endDate.date-1);
		}
		
		public function loadData_I(obj:Object):void{
			var type:int = obj.dtype;
			var taskInfo:AreaCelebrateTaskData = typeTasks[type];
			if(null == taskInfo){
				taskInfo = new AreaCelebrateTaskData();
				typeTasks[type] = taskInfo;
			}
			taskInfo.unserialize(obj);
		}
		
		public function getDayTaskInfo(type:int):AreaCelebrateTaskData{
			return typeTasks[type];
		}
		
		public function loadData_T(obj:Object):void{
			tick = getTimer();
			_cTime = obj.ctime;
			_openTime = obj.opentime;
		}
		
		public function remainT():int{
			return (ConfigEnum.welfare19*24*60*60 - (_cTime + (getTimer() - tick)/1000 - _openTime));
		}
		
		public function hasReceive(type:int):Boolean{
			var taskInfo:AreaCelebrateTaskData = typeTasks[type];
			if(null != taskInfo){
				return taskInfo.hasReceive();
			}
			return false;
		}
	}
}
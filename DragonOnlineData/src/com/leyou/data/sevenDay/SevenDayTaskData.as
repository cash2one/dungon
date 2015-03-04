package com.leyou.data.sevenDay
{
	

	public class SevenDayTaskData
	{
		private var day:int;
		
		private var taskList:Vector.<SevenDayTask> = new Vector.<SevenDayTask>();
		
		private var _unfinishCount:int;
		
		public function SevenDayTaskData(){
		}
		
		public function get unfinishCount():int{
			return _unfinishCount;
		}

		public function taskCount():int{
			return taskList.length;
		}
		
		public function getTask(index:int):SevenDayTask{
			return taskList[index];
		}
		
		public function unserialize(obj:Object):void{
			_unfinishCount = 0;
			day = obj.d;
			var dl:Array = obj.dl;
			var length:int = dl.length;
			taskList.length = length;
			for(var n:int = 0; n < length; n++){
				var taskInfo:SevenDayTask = taskList[n];
				if(null == taskInfo){
					taskInfo = new SevenDayTask();
					taskList[n] = taskInfo;
				}
				taskInfo.day = day;
				taskInfo.unserialize(dl[n]);
				if(0 == taskInfo.receiveStatus){
					_unfinishCount++;
				}
			}
			taskList.sort(compare);
			
			function compare(taskP:SevenDayTask, taskN:SevenDayTask):int{
				if(1 == taskN.receiveStatus){
					return 1;
				}
				return -1;
			}
		}
	}
}
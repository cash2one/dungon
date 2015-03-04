package com.leyou.data.celebrate
{
	public class AreaCelebrateTaskData
	{
		private var type:int;
		
		private var taskList:Vector.<AreaCelebrateTask> = new Vector.<AreaCelebrateTask>();
		
		public function AreaCelebrateTaskData(){
		}
		
		public function taskCount():int{
			return taskList.length;
		}
		
		public function getTask(index:int):AreaCelebrateTask{
			return taskList[index];
		}
		
		public function unserialize(obj:Object):void{
			var dl:Array = obj.dl;
			type = obj.dtype;
			var length:int = dl.length;
			taskList.length = length;
			for(var n:int = 0; n < length; n++){
				var taskInfo:AreaCelebrateTask = taskList[n];
				if(null == taskInfo){
					taskInfo = new AreaCelebrateTask();
					taskList[n] = taskInfo;
				}
				taskInfo.type = type;
				taskInfo.unserialize(dl[n]);
			}
			taskList.sort(compare);
			
			function compare(taskP:AreaCelebrateTask, taskN:AreaCelebrateTask):int{
				if(taskP.id > taskN.id){
					return 1;
				}else if(taskP.id == taskN.id){
					return 0;
				}
				return -1;
			}
		}
		
		public function hasReceive():Boolean{
			for each(var task:AreaCelebrateTask in taskList){
				if(null != task){
					return task.canReceive();
				}
			}
			return false;
		}
	}
}
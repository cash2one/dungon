package com.leyou.data.collectioin
{
	public class CollectionGroupTaskData
	{
		public var groupId:int;
		
		public var tasks:Vector.<CollectionTaskData> = new Vector.<CollectionTaskData>();
		
		public function CollectionGroupTaskData(){
		}
		
		public function getTask(sid:int):CollectionTaskData{
			for each(var task:CollectionTaskData in tasks){
				if((null != task) && (sid == task.id)){
					return task;
				}
			}
			return null;
		}
		
		public function unserialize(data:Array):void{
			tasks.length = data.length;
			var l:int = data.length;
			for(var n:int = 0; n < l; n++){
				var task:CollectionTaskData = tasks[n];
				if(null == task){
					task = new CollectionTaskData();
					tasks[n] = task;
				}
				task.groupId = groupId;
				task.unserialize(data[n]);
			}
		}
	}
}
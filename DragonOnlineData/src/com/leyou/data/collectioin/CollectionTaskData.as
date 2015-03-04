package com.leyou.data.collectioin
{
	public class CollectionTaskData
	{
		public var id:int;
		
		public var groupId:int;
		
		public var status:int;
		
		public var cNum:int;
		
		public function unserialize(data:Array):void{
			id = data[0];
			status = data[1];
			cNum = data[2];
		}
	}
}
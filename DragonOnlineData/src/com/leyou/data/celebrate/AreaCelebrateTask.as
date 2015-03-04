package com.leyou.data.celebrate
{
	public class AreaCelebrateTask
	{
		public var id:int;
		
		public var type:int;
		
		public var receiveStatus:int;
		
		public var progress:int;
		
		public var remainC:int;
		
		public function AreaCelebrateTask(){
		}
		
		public function unserialize(data:Array):void{
			id = data[0];
			receiveStatus = data[1];
			progress = data[2];
			remainC = data[3];
		}
		
		public function canReceive():Boolean{
			return ((1 == receiveStatus) && (remainC >= 0));
		}
	}
}
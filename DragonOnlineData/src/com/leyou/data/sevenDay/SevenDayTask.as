package com.leyou.data.sevenDay
{
	public class SevenDayTask
	{
		public var id:int;
		
		public var day:int;
		
		public var receiveStatus:int;
		
		public var progress:int;
		
		public function SevenDayTask(){
		}
		
		public function unserialize(data:Array):void{
			id = data[0];
			receiveStatus = data[1];
			progress = data[2];
		}
	}
}
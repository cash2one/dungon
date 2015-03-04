package com.leyou.data.achievement
{
	public class AchievementEraData
	{
		public var serverId:String;
		
		public var tid:int;
		
		public var name:String;
		
		public var date:String;
		
		public function dispose():void{
			name = null;
			date = null;
		}
		
		public function unserialize(data:Array):void{
			tid = data[0];
			name = data[1];
			date = data[2];
		}
	}
}
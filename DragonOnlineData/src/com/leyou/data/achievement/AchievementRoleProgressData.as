package com.leyou.data.achievement
{
	public class AchievementRoleProgressData
	{
		public var id:int;
		
		public var value:int;
		
		public function unserialize(bytes:Array):void{
			id = bytes[0];
			value = bytes[1];
		}
	}
}
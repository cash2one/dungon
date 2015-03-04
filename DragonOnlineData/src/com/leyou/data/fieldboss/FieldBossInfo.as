package com.leyou.data.fieldboss
{
	public class FieldBossInfo
	{
		public var bossId:int;
		
		public var status:int;
		
		public var killName:String;
		
		public var type:int;
		
		public function unserialize(nd:Array):void{
			bossId = nd[0];
			status = nd[1];
			killName = nd[2];
		}
	}
}
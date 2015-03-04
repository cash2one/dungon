package com.leyou.data.fieldboss
{
	public class FBRankInfo
	{
		public var rank:int;
		
		public var name:String;
		
		public var damage:int;
		
		public function unserialize(na:Array):void{
			name = na[0];
			damage = na[1];
		}
	}
}
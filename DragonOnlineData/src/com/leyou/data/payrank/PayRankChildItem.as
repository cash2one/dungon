package com.leyou.data.payrank
{
	public class PayRankChildItem
	{
		public var type:int;
		
		public var rank:int;
		
		public var name:String;
		
		public var value:int;
		
		public function PayRankChildItem(){
		}
		
		public function updateInfo(na:Array):void{
			rank = na[0];
			name = na[1];
			value = na[2];
		}
	}
}
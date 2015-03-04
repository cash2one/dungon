package com.leyou.data.paypromotion
{
	public class PayPromotionItem
	{
		public var id:int;
		
		public var type:int;
		
		public var status:int;
		
		public var currentc:int;
		
		public var maxc:int;
		
		public var dc:int;
		
		public function updateInfo(data:Array):void{
			id = data[0];
			status = data[1];
			currentc = data[2];
			maxc = data[3];
			dc = data[4];
		}
		
		public function hasChance():Boolean{
			return (currentc > 0);
		}
	}
}
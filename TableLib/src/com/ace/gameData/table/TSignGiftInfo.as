package com.ace.gameData.table
{
	public class TSignGiftInfo
	{
		public var day:int;
		
		public var exp:int;
		
		public var money:int;
		
		public var energy:int;
		
		public var bIb:int;
		
		public var item1:int;
		
		public var itemCount1:int;
		
		public var item2:int;
		
		public var itemCount2:int;
		
		public var item3:int;
		
		public var itemCount3:int;
		
		public var item4:int;
		
		public var itemCount4:int;
		
		public var vipItem1:int;
		
		public var vipItemCount1:int;
		
		public var vipItem2:int;
		
		public var vipItemCount2:int;

		public function TSignGiftInfo(xml:XML = null){
			day = xml.@day;
			bIb = xml.@bIb;
			exp = xml.@exp;
			money = xml.@money;
			energy = xml.@energy;
			item1 = xml.@item1;
			itemCount1 = xml.@item1Num;
			item2 = xml.@item2;
			itemCount2 = xml.@item2Num;
			item3 = xml.@item3;
			itemCount3 = xml.@item3Num;
			item4 = xml.@item4;
			itemCount4 = xml.@item4Num;
			vipItem1 = xml.@VIPItem1;
			vipItemCount1 = xml.@VIPItem1Num;
			vipItem2 = xml.@VIPItem2;
			vipItemCount2 = xml.@VIPItem2Num;
		}
	}
}
package com.ace.gameData.table
{
	public class TSevenDayRewardInfo
	{
		public var day:int;
		
		public var name:String;
		
		public var rMoney:uint;
		
		public var rExp:uint;
		
		public var rbib:uint;
		
		public var rEnergy:uint;
		
		public var rlp:uint;
		
		public var item1:int;
		
		public var item1Count:int;
		
		public var item2:int;
		
		public var item2Count:int;
		
		public var item3:int;
		
		public var item3Count:int;
		
		public var item4:int;
		
		public var item4Count:int;
		
		public function TSevenDayRewardInfo(xml:XML){
			day = xml.@Day_ID;
			name = xml.@Day_Name;
			rMoney = xml.@Day_Money;
			rExp = xml.@Day_Exp;
			rbib = xml.@Day_Byb;
			rEnergy = xml.@Day_Energy;
			rlp = xml.@Day_LP;
			item1 = xml.@Day_Item1;
			item1Count = xml.@DayItem_1;
			item2 = xml.@Day_Item2;
			item2Count = xml.@DayItem_2;
			item3 = xml.@Day_Item3;
			item3Count = xml.@DayItem_3;
			item4 = xml.@Day_Item4;
			item4Count = xml.@DayItem_4;
		}
	}
}
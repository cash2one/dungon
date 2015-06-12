package com.ace.gameData.table
{
	public class TMissionMarketRewardInfo
	{
		
		public var type:int;
		
		public var exp:int;
		
		public var energy:int;
		
		public var money:int;
		
		public var lp:int;
		
		public var honor:int;
		
		public var byb:int;
		
		public var item1:int;
		
		public var item1Num:int;
		
		public var item2:int;
		
		public var item2Num:int;
		
		public var item3:int;
		
		public var item3Num:int;
		
		public var item4:int;
		
		public var item4Num:int;
		
		public var item5:int;
		
		public var item5Num:int;
		
		public function TMissionMarketRewardInfo(xml:XML){
			type = xml.@Task_Type;
			exp = xml.@exp;
			money = xml.@money;
			energy = xml.@energy;
			lp = xml.@bg;
			honor = xml.@Honor;
			byb = xml.@Byb;
			item1 = xml.@item1;
			item1Num = xml.@num1;
			item2 = xml.@item2;
			item2Num = xml.@num2;
			item3 = xml.@item3;
			item3Num = xml.@num3;
			item4 = xml.@item4;
			item4Num = xml.@num4;
			item5 = xml.@item5;
			item5Num = xml.@num5;
		}
	}
}
package com.ace.gameData.table
{
	public class TQQVipLvRewardInfo
	{
		public var lv:int;
		
		public var money:int;
		
		public var exp:int;
		
		public var energy:int;
		
		public var lp:int;
		
		public var byb:int;
		
		public var item1:int;
		
		public var item1Num:int;
		
		public var item2:int;
		
		public var item2Num:int;
		
		public var item3:int;
		
		public var item3Num:int;
		
		public var item4:int;
		
		public var item4Num:int;
		
		public function TQQVipLvRewardInfo(xml:XML){
			lv = xml.@lv;
			money = xml.@qqvip_Money;
			exp = xml.@qqvip_Exp;
			energy = xml.@qqvip_Energy;
			lp = xml.@qqvip_LP;
			byb = xml.@qqvip_Byb;
			item1 = xml.@qqvip_Item1;
			item1Num = xml.@qqvip_ItemNum1;
			item2 = xml.@qqvip_Item2;
			item2Num = xml.@qqvip_ItemNum2;
			item3 = xml.@qqvip_Item3;
			item3Num = xml.@qqvip_ItemNum3;
			item4 = xml.@qqvip_Item4;
			item4Num = xml.@qqvip_ItemNum4;
		}
	}
}
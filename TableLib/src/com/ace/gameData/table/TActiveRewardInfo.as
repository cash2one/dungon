package com.ace.gameData.table
{
	public class TActiveRewardInfo
	{
		public var id:int;
		
		public var threshold:int;
		
		public var exp:int;
		
		public var money:int;
		
		public var energy:int;
		
		public var contribution:int;
		
		public var byb:int;
		
		public var item1:int;
		
		public var item1Count:int;
		
		public var item2:int;
		
		public var item2Count:int;
		
		public function TActiveRewardInfo(xml:XML){
			id = xml.@AR_level;
			threshold = xml.@AR_NA;
			exp = xml.@AR_EXP;
			money = xml.@AR_MONEY;
			energy = xml.@AR_ENERGY;
			contribution = xml.@AR_HP;
			item1 = xml.@AR_ITEM1;
			item1Count = xml.@ARITEM_NUM1;
			item2 = xml.@AR_ITEM2;
			item2Count = xml.@ARITEM_NUM2;
			byb = xml.@AR_BYB;
		}
	}
}
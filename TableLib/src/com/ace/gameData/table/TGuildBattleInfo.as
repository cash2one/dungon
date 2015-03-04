package com.ace.gameData.table
{
	public class TGuildBattleInfo
	{
		public var id:int;
		
		public var type:int;
		
		public var rank:int;
		
		public var exp:int;
		
		public var money:int;
		
		public var energy:int;
		
		public var byb:int;
		
		public var bg:int;
		
		public var item1:int;
		
		public var item1Count:int;
		
		public var item2:int;
		
		public var item2Count:int;
		
		public var item3:int;
		
		public var item3Count:int;
		
		public var item4:int;
		
		public var item4Count:int;
		
		public var vitality:int;
		
		public var groupId:String;
		
		public function TGuildBattleInfo(xml:XML){
			id = xml.@GB_ID;
			type = xml.@GB_Retype;
			rank = xml.@GB_Ranking;
			exp = xml.@GB_Exp;
			money = xml.@GB_Money;
			energy = xml.@GB_Energy;
			byb = xml.@GB_BYB;
			bg = xml.@GB_Bg;
			item1 = xml.@GB_Item1;
			item1Count = xml.@GB_INum1;
			item2 = xml.@GB_Item2;
			item2Count = xml.@GB_INum2;
			item3 = xml.@GB_Item3;
			item3Count = xml.@GB_INum3;
			item4 = xml.@GB_Item4;
			item4Count = xml.@GB_INum4;
			vitality = xml.@GB_vitality;
			groupId = xml.@GB_group;
		}
	}
}
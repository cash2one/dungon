package com.ace.gameData.table
{
	public class TCityBattleRewardInfo
	{
		public var id:int;
		
		public var type:int;
		
		public var zdlLow:int;
		
		public var zdlHigh:int;
		
		public var exp:int;
		
		public var money:int;
		
		public var energy:int;
		
		public var lp:int;
		
		public var byb:int;
		
		public var honor:int;
		
		public var item1:int;
		
		public var item1Num:int;
		
		public var item2:int;
		
		public var item2Num:int;
		
		public var item3:int;
		
		public var item3Num:int;
		
		public var item4:int;
		
		public var item4Num:int;
		
		public function TCityBattleRewardInfo(xml:XML){
			id = xml.@CF_ID;
			type = xml.@CF_Type;
			zdlLow = xml.@Battle_Down;
			zdlHigh = xml.@Battle_Up;
			exp = xml.@CF_exp;
			money = xml.@CF_money;
			energy = xml.@CF_energy;
			lp = xml.@CF_LP;
			byb = xml.@CF_BYB;
			honor = xml.@CF_Honor;
			item1 = xml.@CF_Item1;
			item1Num = xml.@CF_Num1;
			item2 = xml.@CF_Item2;
			item2Num = xml.@CF_Num2;
			item3 = xml.@CF_Item3;
			item3Num = xml.@CF_Num3;
			item4 = xml.@CF_Item4;
			item4Num = xml.@CF_Num4;
		}
	}
}
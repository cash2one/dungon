package com.ace.gameData.table
{
	public class TRankRewardInfo
	{
		public var id:int;
		
		public var type:int;
		
		public var rank:int;
		
		public var exp:int;
		
		public var money:int;
		
		public var energy:int;
		
		public var byb:int;
		
		public var bg:int;
		
		public var item1:Array;
		
		public var item1Count:int;
		
		public var item2:Array;
		
		public var item2Count:int;
		
		public var item3:Array;
		
		public var item3Count:int;
		
		public var item4:Array;
		
		public var item4Count:int;
		
		public var item5:Array;
		
		public var item5Count:int;
		
		public var item6:Array;
		
		public var item6Count:int;
		
		public function TRankRewardInfo(xml:XML){
			id = xml.@id;
			type = xml.@New_Retype;
			rank = xml.@New_Ranking;
			exp = xml.@New_Exp;
			money = xml.@New_Money;
			energy = xml.@New_Energy;
			byb = xml.@New_BYB;
			bg = xml.@New_Bg;
			var content:String = xml.@New_Item1;
			item1 = content.split("|");
			item1Count = xml.@New_INum1;
			content = xml.@New_Item2;
			item2 = content.split("|");
			item2Count = xml.@New_INum2;
			content = xml.@New_Item3;
			item3 = content.split("|");
			item3Count = xml.@New_INum3;
			content = xml.@New_Item4;
			item4 = content.split("|");
			item4Count = xml.@New_INum4;
			content = xml.@New_Item5;
			item5 = content.split("|");
			item5Count = xml.@New_INum5;
			content = xml.@New_Item6;
			item6 = content.split("|");
			item6Count = xml.@New_INum6;
		}
		
		public function getProReward(proIdx:int, itemIdx:int):int{
			var arr:Array = this["item"+itemIdx];
			if(arr[0] != ""){
				if(arr[proIdx] > 0){
					return arr[proIdx];
				}
				return arr[0];
			}
			return 0;
		}
	}
}
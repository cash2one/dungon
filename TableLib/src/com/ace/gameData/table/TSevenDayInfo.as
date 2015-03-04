package com.ace.gameData.table
{
	public class TSevenDayInfo
	{
		public var id:int;
		
		public var day:int;
		
		public var taskName:String;
		
		public var taskDes:String;
		
		public var rMoney:uint;
		
		public var rExp:uint;
		
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
		
		public var type:int;
		
		public var taskValue:int;
		
		public function TSevenDayInfo(xml:XML){
			id = xml.@day7_ID;
			day = xml.@day7_From;
			taskName = xml.@day7_Name;
			taskDes = xml.@day7_lain;
			type = xml.@day7_Type;
			taskValue = xml.@day7_Data;
			rMoney = xml.@day7_Money;
			rExp = xml.@day7_Exp;
			rEnergy = xml.@day7_Energy;
			rlp = xml.@day7_LP;
			item1 = xml.@day7_Item1;
			item1Count = xml.@item7_1;
			item2 = xml.@day7_Item2;
			item2Count = xml.@item7_2;
			item3 = xml.@day7_Item3;
			item3Count = xml.@item7_3;
			item4 = xml.@day7_Item4;
			item4Count = xml.@item7_4;
		}
	}
}
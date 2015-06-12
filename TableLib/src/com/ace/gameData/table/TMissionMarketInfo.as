package com.ace.gameData.table
{
	public class TMissionMarketInfo
	{
		public var id:int;
		
		public var type:int;
		
		public var name:String;
		
		public var des:String;
		
		public var term:int;
		
		public var need:int;
		
		public var exp:int;
		
		public var energy:int;
		
		public var money:int;
		
		public var lp:int;
		
		public var item1:int;
		
		public var item1Num:int;
		
		public var item2:int;
		
		public var item2Num:int;
		
		public var item3:int;
		
		public var item3Num:int;
		
		public var honor:int;
		
		public var byb:int;
		
		public function TMissionMarketInfo(xml:XML){
			id = xml.@Task_ID;
			type = xml.@Task_Type;
			name = xml.@Task_Name;
			des = xml.@Task_Txt;
			term = xml.@Task_Term;
			if(26 == term){
				need = 1;
			}else{
				need = xml.@Task_Need;
			}
			exp = xml.@exp;
			energy = xml.@energy;
			money = xml.@money;
			lp = xml.@bg;
			item1 = xml.@item1;
			item1Num = xml.@num1;
			item2 = xml.@item2;
			item2Num = xml.@num1;
			item3 = xml.@item2;
			item3Num = xml.@num1;
			honor = xml.@Honor;
			byb = xml.@Byb;
		}
	}
}
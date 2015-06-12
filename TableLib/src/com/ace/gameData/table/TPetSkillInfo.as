package com.ace.gameData.table
{
	public class TPetSkillInfo
	{
		public var id:int;
		
		public var race:int;
		
		public var item:int;
		
		public var skillId1:int;
		
		public var itemNum1:int;
		
		public var money1:int;
		
		public var skillId2:int;
		
		public var itemNum2:int;
		
		public var money2:int;
		
		public var skillId3:int;
		
		public var itemNum3:int;
		
		public var money3:int;
		
		public var skillId4:int;
		
		public var itemNum4:int;
		
		public var money4:int;
		
		public var skillId5:int;
		
		public var itemNum5:int;
		
		public var money5:int;
		
		public function TPetSkillInfo(xml:XML){
			id = xml.@id;
			race = xml.@race;
			item = xml.@item;
			
			skillId1 = xml.@skillId1;
			itemNum1 = xml.@itemNum1;
			money1 = xml.@money1;

			skillId2 = xml.@skillId2;
			itemNum2 = xml.@itemNum2;
			money2 = xml.@money2;
			
			skillId3 = xml.@skillId3;
			itemNum3 = xml.@itemNum3;
			money3 = xml.@money3;
			
			skillId4 = xml.@skillId4;
			itemNum4 = xml.@itemNum4;
			money4 = xml.@money4;
			
			skillId5 = xml.@skillId5;
			itemNum5 = xml.@itemNum5;
			money5 = xml.@money5;
		}
	}
}
package com.ace.gameData.table
{
	public class TSkillLvInfo
	{
		public var lv:int;
		
		public var money:int;
		
		public var energy:int;
		
		public function TSkillLvInfo(xml:XML){
			lv = xml.@lv;
			money = xml.@money;
			energy = xml.@energy;
		}
	}
}
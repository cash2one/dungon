package com.ace.gameData.table
{
	public class TTobeStrongLevelInfo
	{
		public var lv:int;
		
		public var zdl_equip:int;
		
		public var zdl_horse:int;
		
		public var zdl_skill:int;
		
		public var zdl_badge:int;
		
		public var zdl_wing:int;
		
		public var zdl_vip:int;
		
		public var zdl_gem:int;
		
		public function TTobeStrongLevelInfo(xml:XML){
			lv = xml.@lv;
			zdl_equip = xml.@zdl_equip;
			zdl_horse = xml.@zdl_horse;
			zdl_skill = xml.@zdl_skill;
			zdl_badge = xml.@zdl_badge;
			zdl_wing = xml.@zdl_wing;
			zdl_vip = xml.@zdl_vip;
			zdl_gem = xml.@zdl_gem;
		}
	}
}
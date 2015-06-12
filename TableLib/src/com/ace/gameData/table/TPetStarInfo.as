package com.ace.gameData.table
{
	public class TPetStarInfo
	{
		public var id:int;
		
		public var starLv:int;
		
		public var item:int;
		
		public var itemNum:int;
		
		public var money:int;
		
		public var pnfId1:int;
		
		public var pnfId2:int;
		
		public var oriAttNum1:int;
		
		public var oriArrNum2:int;
		
		public var fixedAtt:int;
		
		public var hp:int;
		
		public var attSpeed:int;
		
		public var revive:int;
		
		public var skillRate:int;
		
		public var element:int;
		
		public var elementLv:int;
		
		public function TPetStarInfo(xml:XML){
			id = xml.@serId;
			starLv = xml.@starLv;
			item = xml.@item;
			itemNum = xml.@itemNum;
			money = xml.@money;
			pnfId1 = xml.@pnfId1;
			pnfId2 = xml.@pnfId2;
			oriAttNum1 = xml.@oriAttNum1;
			oriArrNum2 = xml.@oriArrNum2;
			fixedAtt = xml.@fixed_attack;
			hp = xml.@life;
			attSpeed = xml.@attSpeed;
			revive = xml.@revive;
			skillRate = xml.@skillRate;
			element = xml.@element;
			elementLv = xml.@elementLv;
		}
	}
}
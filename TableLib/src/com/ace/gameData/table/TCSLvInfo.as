package com.ace.gameData.table
{
	

	public class TCSLvInfo
	{
		public var lv:int;
		
		public var legacyLimit:int;
		
		public var exp:int;
		
		public var money:int;
		
		public var energy:int;
		
		public var bIB:int;
		
		public var legacy:int;
		
		public var itemIdlist:Vector.<int> = new Vector.<int>();
		
		public var itemNumlist:Vector.<int> = new Vector.<int>();
		
		public function TCSLvInfo(xml:XML){
			lv = xml.@lv;
			legacyLimit = xml.@legacyLimit;
			exp = xml.@exp;
			bIB = xml.@bIB;
			money = xml.@money;
			energy = xml.@energy;
			legacy = xml.@legacy;
			if(exp > 0){
				itemIdlist.push(65534);
				itemNumlist.push(exp);
			}
			if(legacy > 0){
				itemIdlist.push(65524);
				itemNumlist.push(legacy);
			}
			if(money > 0){
				itemIdlist.push(65535);
				itemNumlist.push(money);
			}
			if(energy > 0){
				itemIdlist.push(65533);
				itemNumlist.push(energy);
			}
			if(bIB > 0){
				itemIdlist.push(65532);
				itemNumlist.push(bIB);
			}
			var itemId:int = xml.@itemId1;
			var itemNum:int = xml.@itemNum1;
			if(itemId > 0){
				itemIdlist.push(itemId);
				itemNumlist.push(itemNum);
			}
			itemId = xml.@itemId2;
			itemNum = xml.@itemNum2;
			if(itemId > 0){
				itemIdlist.push(itemId);
				itemNumlist.push(itemNum);
			}
			itemId = xml.@itemId3;
			itemNum = xml.@itemNum3;
			if(itemId > 0){
				itemIdlist.push(itemId);
				itemNumlist.push(itemNum);
			}
			itemId = xml.@itemId4;
			itemNum = xml.@itemNum4;
			if(itemId > 0){
				itemIdlist.push(itemId);
				itemNumlist.push(itemNum);
			}
			itemId = xml.@itemId5;
			itemNum = xml.@itemNum5;
			if(itemId > 0){
				itemIdlist.push(itemId);
				itemNumlist.push(itemNum);
			}
		}
	}
}
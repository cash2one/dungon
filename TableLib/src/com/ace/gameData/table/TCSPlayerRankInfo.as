package com.ace.gameData.table
{
	public class TCSPlayerRankInfo
	{
		public var rankId:int;
		
		public var money:int;
		
		public var energy:int;
		
		public var legacy:int;
		
		public var bIB:int;
		
		public var itemList:Vector.<int> = new Vector.<int>();
		
		public var itemNumList:Vector.<int> = new Vector.<int>();
		
		public function TCSPlayerRankInfo(xml:XML){
			rankId = xml.@rankId;
			money = xml.@money;
			energy = xml.@energy;
			legacy = xml.@legacy;
			if(legacy > 0){
				itemList.push(65524);
				itemNumList.push(legacy);
			}
			if(money > 0){
				itemList.push(65535);
				itemNumList.push(money);
			}
			if(energy > 0){
				itemList.push(65533);
				itemNumList.push(energy);
			}
			if(bIB > 0){
				itemList.push(65532);
				itemNumList.push(bIB);
			}
			var itemId:int = xml.@itemId1;
			var itemNum:int = xml.@itemNum1;
			if(itemId > 0){
				itemList.push(itemId);
				itemNumList.push(itemNum);
			}
			itemId = xml.@itemId2;
			itemNum = xml.@itemNum2;
			if(itemId > 0){
				itemList.push(itemId);
				itemNumList.push(itemNum);
			}
			itemId = xml.@itemId3;
			itemNum = xml.@itemNum3;
			if(itemId > 0){
				itemList.push(itemId);
				itemNumList.push(itemNum);
			}
			itemId = xml.@itemId4;
			itemNum = xml.@itemNum4;
			if(itemId > 0){
				itemList.push(itemId);
				itemNumList.push(itemNum);
			}
			itemId = xml.@itemId5;
			itemNum = xml.@itemNum5;
			if(itemId > 0){
				itemList.push(itemId);
				itemNumList.push(itemNum);
			}
		}
	}
}
package com.ace.gameData.table
{
	public class TLevelGiftInfo
	{
		public var level:int;
		
		private var itemIds:Vector.<int> = new Vector.<int>();
		
		private var itemNums:Vector.<int> = new Vector.<int>();
		
		public function TLevelGiftInfo(xml:XML){
			level = xml.@Level;
			var itemId:int = xml.@item1;
			itemIds.push(itemId);
			itemId = xml.@item2;
			itemIds.push(itemId);
			itemId = xml.@item3;
			itemIds.push(itemId);
			itemId = xml.@item4;
			itemIds.push(itemId);
			itemId = xml.@item5;
			itemIds.push(itemId);
			itemId = xml.@item6;
			itemIds.push(itemId);
			var itemNum:int = xml.@item_Num1;
			itemNums.push(itemNum);
			itemNum = xml.@item_Num2;
			itemNums.push(itemNum);
			itemNum = xml.@item_Num3;
			itemNums.push(itemNum);
			itemNum = xml.@item_Num4;
			itemNums.push(itemNum);
			itemNum = xml.@item_Num5;
			itemNums.push(itemNum);
			itemNum = xml.@item_Num6;
			itemNums.push(itemNum);
		}
		
		public function getItemId(index:int):int{
			return itemIds[index];
		}
		
		public function getItemNum(index:int):int{
			return itemNums[index];
		}
	}
}
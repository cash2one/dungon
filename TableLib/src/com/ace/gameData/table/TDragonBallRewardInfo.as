package com.ace.gameData.table
{
	public class TDragonBallRewardInfo{
		
		public var id:int;
		
		public var name:String;
		
		public var des:String;
		
		public var items:Vector.<int> = new Vector.<int>();
		
		public var itemNums:Vector.<int> = new Vector.<int>();
		
//		public var item1:int;
//		
//		public var item1Count:int;
//		
//		public var item2:int;
//		
//		public var item2Count:int;
//		
//		public var item3:int;
//		
//		public var item3Count:int;
//		
//		public var item4:int;
//		
//		public var item4Count:int;
//		
//		public var item5:int;
//		
//		public var item5Count:int;
//		
//		public var item6:int;
//		
//		public var item6Count:int;
//		
//		public var item7:int;
//		
//		public var item7Count:int;
//		
//		public var item8:int;
//		
//		public var item8Count:int;
//		
//		public var item9:int;
//		
//		public var item9Count:int;
		
		public var energy_num:int;
		
		public var rewardItems:Vector.<int> = new Vector.<int>();
		
		public var rewardNums:Vector.<int> = new Vector.<int>();
		
//		public var reward_item1:int;
//		
//		public var item1_num:int;
//		
//		public var reward_item2:int;
//		
//		public var item2_num:int;
//		
//		public var reward_item3:int;
//		
//		public var item3_num:int;
		
		public function TDragonBallRewardInfo(xml:XML){
			id = xml.@Lh_ID;
			name = xml.@Lh_Name;
			des = xml.@Lh_Dic;
			var itemId:int = xml.@Lh_Item1;
			var itemNum:int = xml.@Lh_Num1;
			if(itemId > 0){
				items.push(itemId);
				itemNums.push(itemNum);
			}
			itemId = xml.@Lh_Item2;
			itemNum = xml.@Lh_Num2;
			if(itemId > 0){
				items.push(itemId);
				itemNums.push(itemNum);
			}
			itemId = xml.@Lh_Item3;
			itemNum = xml.@Lh_Num3;
			if(itemId > 0){
				items.push(itemId);
				itemNums.push(itemNum);
			}
			itemId = xml.@Lh_Item4;
			itemNum = xml.@Lh_Num4;
			if(itemId > 0){
				items.push(itemId);
				itemNums.push(itemNum);
			}
			itemId = xml.@Lh_Item5;
			itemNum = xml.@Lh_Num5;
			if(itemId > 0){
				items.push(itemId);
				itemNums.push(itemNum);
			}
			itemId = xml.@Lh_Item6;
			itemNum = xml.@Lh_Num6;
			if(itemId > 0){
				items.push(itemId);
				itemNums.push(itemNum);
			}
			itemId = xml.@Lh_Item7;
			itemNum = xml.@Lh_Num7;
			if(itemId > 0){
				items.push(itemId);
				itemNums.push(itemNum);
			}
			itemId = xml.@Lh_Item8;
			itemNum = xml.@Lh_Num8;
			if(itemId > 0){
				items.push(itemId);
				itemNums.push(itemNum);
			}
			itemId = xml.@Lh_Item9;
			itemNum = xml.@Lh_Num9;
			if(itemId > 0){
				items.push(itemId);
				itemNums.push(itemNum);
			}
			energy_num = xml.@Lh_Convert;
			
			
			itemId = xml.@Co_Item1;
			itemNum = xml.@Co_Num1;
			if(itemId > 0){
				rewardItems.push(itemId);
				rewardNums.push(itemNum);
			}
			itemId = xml.@Co_Item2;
			itemNum = xml.@Co_Num2;
			if(itemId > 0){
				rewardItems.push(itemId);
				rewardNums.push(itemNum);
			}
			itemId = xml.@Co_Item3;
			itemNum = xml.@Co_Num3;
			if(itemId > 0){
				rewardItems.push(itemId);
				rewardNums.push(itemNum);
			}
		}
	}
}
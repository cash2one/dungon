package com.ace.gameData.table
{
	
	

	public class TGroupBuyItemInfo
	{
		public var id:int;
		
		public var type:int;
		
		public var nPrice:int;
		
		public var cPrice:int;
		
		public var giftItem:int;
		
		public var byb:int;
		
		public var groupGift1:int;
		
		public var groupGift2:int;
		
		public var groupGift3:int;
		
		public var groupGift4:int;
		
		public var groupGift5:int;
		
		public var groupGift6:int;
		
		public function TGroupBuyItemInfo(xml:XML){
			id = xml.@id;
			type = xml.@type;
			nPrice = xml.@price_orig;
			cPrice = xml.@price_real;
			giftItem = xml.@drop0;
			byb = xml.@drop1;
			groupGift1 = 65532;
			groupGift2 = xml.@drop2;
			groupGift3 = xml.@drop3;
			groupGift4 = xml.@drop4;
			groupGift5 = xml.@drop5;
			groupGift6 = xml.@drop6;
		}
		
		public function getReward(index:int):int{
			return this["groupGift"+(index+1)];
		}
		
		public function getRewardCount(index:int):int{
			if(0 == index){
				return byb;
			}
			return 0;
		}
	}
}
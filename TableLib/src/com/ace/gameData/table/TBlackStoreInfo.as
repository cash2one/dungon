package com.ace.gameData.table
{
	public class TBlackStoreInfo
	{
		public var id:int;
		
		public var type:int;
		
		public var moneyType:int;
		
		public var nprice:int;
		
		public var price:int;
		
		public var vipLv:int;
		
		public var itemId:int;
		
		public var num:int;
		
		public var tip:String;
		
		public function TBlackStoreInfo(xml:XML){
			id = xml.@Ds_ID;
			type = xml.@DS_Type;
			moneyType = xml.@Ds_Coin;
			nprice = xml.@Ds_NPrice;
			price = xml.@Ds_Price;
			vipLv = xml.@Ds_VIP;
			itemId = xml.@Ds_Item;
			num = xml.@Ds_Num;
			tip = xml.@Ds_Pic;
		}
	}
}
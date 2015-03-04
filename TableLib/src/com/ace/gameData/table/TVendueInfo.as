package com.ace.gameData.table
{
	public class TVendueInfo
	{
		public var id:int;
		
		public var nprice:int;
		
		public var bprice:int;
		
		public var itemId:int;
		
		public var itemCount:int;
		
		public function TVendueInfo(xml:XML){
			id = xml.@id;
			nprice = xml.@price_0;
			bprice = xml.@price;
			itemId = xml.@item;
			itemCount = xml.@num;
		}
	}
}
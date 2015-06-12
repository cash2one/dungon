package com.ace.gameData.table
{
	public class TMarketInfo
	{
		public var id:int;
		
		public var itemId:int;
		
		public var tagId:int;
		
		public function TMarketInfo(xml:XML){
			id = xml.@id;
			itemId = xml.@itemId;
			tagId = xml.@tagId;
		}
		
		public function isBind():Boolean{
			return (tagId == 4);
		}
	}
}
package com.ace.gameData.table
{
	public class TFindBackInfo
	{
		public var id:int;
		
		public var type:int;
		
		public var img_01:String;
		
		public var img_02:String;
		
		public var money:int;
		
		public var ib:int;
		
		public function TFindBackInfo(xml:XML){
			id = xml.@id;
			type = xml.@type;
			img_01 = xml.@img_01;
			img_02 = xml.@img_02;
			money = xml.@money;
			ib = xml.@ib;
		}
	}
}
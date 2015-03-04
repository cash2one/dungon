package com.ace.gameData.table
{
	public class TTobeStrongInfo
	{
		public var id:int;
		
		public var type:int;
		
		public var ico:String;
		
		public var des_title:String;
		
		public var des_btn:String;
		
		public var des1:String;
		
		public var des2:String;

		public function TTobeStrongInfo(xml:XML){
			id = xml.@id;
			type = xml.@type;
			ico = xml.@ico;
			des_title = xml.@des_title;
			des_btn = xml.@des_btn;
			des1 = xml.@des1;
			des2 = xml.@des2;
		}
	}
}
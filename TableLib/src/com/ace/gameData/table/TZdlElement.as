package com.ace.gameData.table
{
	public class TZdlElement
	{
		public var id:int;
		
		public var rate:Number;
		
		public var des:String;
		
		public function TZdlElement(xml:XML){
			id = xml.@id;
			rate = xml.@rate;
			des = xml.@des;
		}
	}
}
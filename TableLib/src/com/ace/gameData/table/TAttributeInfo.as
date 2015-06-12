package com.ace.gameData.table
{
	public class TAttributeInfo
	{
		public var id:int;
		
		public var attibuteDes:String;
		
		public function TAttributeInfo(xml:XML){
			id = xml.@id;
			attibuteDes = xml.@des_s;
		}
	}
}
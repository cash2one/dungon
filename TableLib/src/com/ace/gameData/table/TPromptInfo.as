package com.ace.gameData.table
{
	public class TPromptInfo
	{
		public var id:int;
		
		public var des:String;
		
		public function TPromptInfo(xml:XML){
			id = xml.@id;
			des = xml.@des;
		}
	}
}
package com.ace.gameData.table
{
	

	public class TPassivitySkillInfo
	{
		public var id:int;
		
		public var name:String;
		
		public var ico:String;
		
		public var des:String;
		
		public var module:int;
		
		public var cd:int;
		
		public var openLv:int;
		
		public function TPassivitySkillInfo(xml:XML){
			id = xml.@id;
			name = xml.@name;
			ico = xml.@ico;
			des = xml.@des;
			module = xml.@module;
			cd = xml.@CD;
			openLv = xml.@vipLv;
		}
	}
}
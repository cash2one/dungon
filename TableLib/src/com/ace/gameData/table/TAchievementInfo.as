package com.ace.gameData.table
{
	public class TAchievementInfo
	{
		public var id:int;
		
		public var tag:int;
		
		public var type:int;
		
		public var name:String;
		
		public var ico:String;
		
		public var des:String;
		
		public var money:int;
		
		public var energy:int;
		
		public var boundIB:int;
		
		public var titleId:int;
		
		public var threshold:int;
		
		public function TAchievementInfo(xml:XML){
			id = xml.@id;
			tag = xml.@tag;
			type = xml.@type;
			name = xml.@name;
			ico = xml.@ico;
			des = xml.@des;
			money = xml.@money;
			energy = xml.@energy;
			boundIB = xml.@boundIB;
			titleId = xml.@title;
			threshold = xml.@num;
		}
	}
}
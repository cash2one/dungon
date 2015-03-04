package com.ace.gameData.table
{
	public class TFunForcastInfo
	{
		public var id:int;
		
		public var showLevel:int;
		
		public var openLevel:int;
		
		public var name:String;
		
		public var tips:String;
		
		public var icon:String;
		
		public function TFunForcastInfo(xml:XML){
			id = xml.@id;
			name = xml.@function_name;
			showLevel = xml.@open_lv;
			openLevel = xml.@function_lv;
			tips = xml.@function_tips;
			icon = xml.@function_icon;
		}
	}
}
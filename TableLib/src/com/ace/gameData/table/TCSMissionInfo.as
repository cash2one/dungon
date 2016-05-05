package com.ace.gameData.table
{
	public class TCSMissionInfo
	{
		public var id:int;
		
		public var name:String;
		
		public var message:String;
		
		public var type:int;
		
		public var missionTarget:String;
		
		public var missionItem:int;
		
		public var missionRate:int;
		
		public var missionNum:int;
		
		public var missionpoint:int;
		
		public function TCSMissionInfo(xml:XML){
			id = xml.@id;
			name = xml.@name;
			message = xml.@message;
			type = xml.@type;
			missionTarget = xml.@missionTarget;
			missionItem = xml.@missionItem;
			missionRate = xml.@missionRate;
			missionNum = xml.@missionNum;
			missionpoint = xml.@missionpoint;
		}
	}
}
package com.ace.gameData.table
{
	public class TPetFriendlyInfo
	{
		public var lv:int;
		
		public var friendlyNum:int;
		
		public function TPetFriendlyInfo(xml:XML){
			lv = xml.@friId;
			friendlyNum = xml.@friNum;
		}
	}
}
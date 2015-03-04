package com.ace.gameData.table
{
	public class TInvestInfo
	{
		public var lv:int;
		
		public var byb:uint;
		
		public function TInvestInfo(xml:XML){
			lv = xml.@lv;
			byb = xml.@bIB;
		}
	}
}
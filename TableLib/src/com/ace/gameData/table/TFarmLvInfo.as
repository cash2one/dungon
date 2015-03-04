package com.ace.gameData.table
{
	public class TFarmLvInfo
	{
		public var level:int;
		
		public var cost:int;
		
		public var profitRate:int;
		
		public function TFarmLvInfo(xml:XML=null){
			if(xml == null)
				return;
			this.level=xml.@farmLv;
			this.cost=xml.@addIB;
			this.profitRate=xml.@profitRate;
		}
	}
}
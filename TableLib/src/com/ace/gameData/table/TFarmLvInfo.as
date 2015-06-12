package com.ace.gameData.table
{
	public class TFarmLvInfo
	{
		public var level:int;
		
		public var costIB:int;
		
		public var costGold:int;
		
		public var profitRate:int;
		
		public function TFarmLvInfo(xml:XML=null){
			if(xml == null)
				return;
			this.level=xml.@farmLv;
			this.costIB=xml.@addIB;
			this.costGold=xml.@money;
			this.profitRate=xml.@profitRate;
		}
	}
}
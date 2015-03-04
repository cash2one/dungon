package com.ace.gameData.table
{
	public class TFarmLandInfo
	{
		public var index:int;
		
		public var openLv:int;
		
		public var cost:int;
		
		public var bcost:int;
		
		public function TFarmLandInfo(xml:XML=null){
			if(xml == null)
				return;
			this.index=xml.@index;
			this.openLv=xml.@addLv;
			this.cost=xml.@addMoney;
			this.bcost=xml.@addBMoney;
		}
	}
}
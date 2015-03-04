package com.leyou.data.cityBattle
{
	public class CityBattleData
	{
		public var cityData:CityBattleCityData = new CityBattleCityData();
		
		public var trackData:CityBattleTrackData = new CityBattleTrackData();
		
		public var finalData:CityBattleFinalData = new CityBattleFinalData();
		
		public function CityBattleData(){
		}
		
		public function loadData_I(obj:Object):void{
			cityData.unserialize(obj);
		}
		
		public function loadData_T(obj:Object):void{
			trackData.unserialize(obj);
		}
		
		public function loadData_J(obj:Object):void{
			finalData.unserialize(obj);
		}
	}
}
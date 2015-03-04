package com.leyou.data.cityBattle
{
	public class CityBattleFinalData
	{
		public var winGName:String;
		
		public var winPName:String;
		
		public var honour:int;
		
		public var exp:int;
		
		public var energy:int;
		
		public var wid:int;
		
		public function CityBattleFinalData(){
		}
		
		public function unserialize(obj:Object):void{
			winGName = obj.wuname;
			winPName = obj.wname;
			honour = obj.honour;
			exp = obj.exp;
			energy = obj.energy;
			wid = obj.wjlid;
		}
	}
}
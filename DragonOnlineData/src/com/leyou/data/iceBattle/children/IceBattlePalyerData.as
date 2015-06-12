package com.leyou.data.iceBattle.children
{
	public class IceBattlePalyerData
	{
		public var camp:int;
		
		public var rank:int;
		
		public var name:String;
		
		public var credit:int;
		
		public var kill:int;
		
		public var assist:int;
		
		public var honour:int;
		
		public function IceBattlePalyerData(){
		}
		
		public function unserailize(data:Array):void{
			camp = data[0];
			rank = data[1];
			name = data[2];
			credit = data[3];
			kill = data[4];
			assist = data[5];
			honour = data[6];
		}
	}
}
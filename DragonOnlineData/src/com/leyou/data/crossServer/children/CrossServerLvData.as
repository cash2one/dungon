package com.leyou.data.crossServer.children
{
	public class CrossServerLvData
	{
		public var rank:int;
		
		public var lv:int;
		
		public var serverName:String;
		
		public var masterName:String;
		
		public var boomValue:int;
		
		public var wboomValue:int;
		
		public var stime:int;
		
		public var gx:int;
		
		public function CrossServerLvData(){
		}
		
		public function loadInfo(data:Array):void{
			rank = data[0];
			lv = data[1];
			serverName = data[2];
			masterName = data[3];
			wboomValue = data[4];
			boomValue = data[5];
			stime = data[6];
		}
		
		public function loadOpenInfo(data:Array):void{
			rank = data[0];
			masterName = data[1];
			gx = data[2];
		}
	}
}
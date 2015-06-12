package com.leyou.data.missinMarket
{
	public class MissionMarketTaskData
	{
		public var tid:int;
		
		public var ps:int;
		
		public var st:int;
		
		public function MissionMarketTaskData(){
		}
		
		public function unserialize(odata:Array):void{
			tid = odata[0];
			ps = odata[1];
			st = odata[2];
		}
	}
}
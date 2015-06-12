package com.leyou.data.missinMarket
{
	public class MissionMarketChapterData
	{
		public var type:int;
		
		public var finishedNum:int;
		
		public var totalNum:int;
		
		public var status:int;
		
		public function MissionMarketChapterData(){
		}
		
		public function unserialize(odata:Array):void{
			finishedNum = odata[0];
			totalNum = odata[1];
			status = odata[2];
		}
	}
}
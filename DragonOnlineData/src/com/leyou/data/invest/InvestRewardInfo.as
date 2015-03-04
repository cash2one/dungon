package com.leyou.data.invest
{
	public class InvestRewardInfo
	{
		public var playerName:String;
		
		public var ltype:int;
		
		public var byb:int;
		
		public function InvestRewardInfo(){
		}
		
		public function updateInfo(data:Array):void{
			playerName = data[0];
			ltype = data[1];
			byb = data[2];
		}
	}
}
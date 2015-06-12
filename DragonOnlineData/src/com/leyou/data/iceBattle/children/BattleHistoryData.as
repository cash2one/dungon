package com.leyou.data.iceBattle.children
{
	public class BattleHistoryData
	{
		public var type:int;
		
		public var ltime:String;
		
		public var msgid:int;
		
		public var val:Array;
		
		public function BattleHistoryData(){
		}
		
		public function unserialize(data:Array):void{
			ltime = data[0];
			msgid = data[1];
			val = data[2].concat();
		}
	}
}
package com.leyou.data.crossServer.children
{
	public class CrossServerMissionData
	{
		public var rank:int;
		
		public var name:String;
		
		public var ptnunm:int;
		
		public function CrossServerMissionData(){
		}
		
		public function loadInfo(obj:Object):void{
			rank = obj[0];
			name = obj[1];
			ptnunm = obj[2];
		}
	}
}
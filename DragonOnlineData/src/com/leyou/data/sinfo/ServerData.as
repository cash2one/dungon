package com.leyou.data.sinfo
{
	public class ServerData
	{
		public var status:int = 1;
		
		public var stime:int;
		
		public var etime:int;
		
		public function ServerData(){
		}
		
		public function loadData_I(obj:Object):void{
			status = obj.st;
			stime = obj.stime;
			etime = obj.etime;
		}
	}
}
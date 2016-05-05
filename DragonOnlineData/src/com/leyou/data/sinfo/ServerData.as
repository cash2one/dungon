package com.leyou.data.sinfo
{
	public class ServerData
	{
		// 服务器状态 （1新服状态 2合服状态）
		public var status:int = 1;
		
		// 开服时间
		public var stime:int;
		
		// 当前时间
		public var ctime:int;
		
		public function ServerData(){
		}
		
		public function loadData_I(obj:Object):void{
			status = obj.st;
			stime = obj.stime;
			ctime = obj.ctime;
		}
		
		public function isOpening():Boolean{
			return (status == 1);
		}
	}
}
package com.leyou.data.vendue
{
	public class VendueNextData
	{
		public var id:int;
		
		public var dtime:int;
		
		public function VendueNextData(){
		}
		
		public function unserialize(data:Array):void{
			id = data[0];
			dtime = data[1];
		}
	}
}
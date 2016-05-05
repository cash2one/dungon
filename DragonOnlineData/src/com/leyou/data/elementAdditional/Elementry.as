package com.leyou.data.elementAdditional
{
	public class Elementry
	{
		public var type:int;
		
		public var lv:int;
		
		public var exp:int;
		
		public function Elementry(){
		}
		
		public function loadData(data:Array):void{
			type = data[0];
			lv = data[1];
			exp = data[2];
		}
	}
}
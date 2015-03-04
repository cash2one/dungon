package com.leyou.data.vendue
{
	public class VendueHistoryData
	{
		public var id:int; // 拍卖ID
		
		public var price:int; // 成交价格
		
		public var name:String; // 成交人
		
		public var tick:int; // 成交时间
		
		public function VendueHistoryData(){
		}
		
		public function unserialize(data:Array):void{
			id = data[0];
			price = data[1];
			name = data[2];
			tick = data[3];
		}
	}
}
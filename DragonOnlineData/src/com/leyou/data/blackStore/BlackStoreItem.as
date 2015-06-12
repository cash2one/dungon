package com.leyou.data.blackStore
{
	public class BlackStoreItem
	{
		public var id:int;
		
		public var status:int;
		
		public function BlackStoreItem(){
		}
		
		public function serialize(data:Array):void{
			id = data[0];
			status = data[1];
		}
	}
}
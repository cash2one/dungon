package com.leyou.data.groupBuy
{
	public class GroupBuyItemData
	{
		public var id:int;
		
		public var status:int;
		
		public var buyCount:int;
		
		public var receives:Array = [];
		
		public function GroupBuyItemData(){
		}
		
		public function unserialize(data:Array):void{
			id = data[0];
			status = data[1];
			buyCount = data[2];
			receives = data[3].concat();
		}
		
		public function rewardCount():int{
			return receives.length;
		}
		
		public function hasReceive(count:int):Boolean{
			return (-1 != receives.indexOf(count));
		}
	}
}
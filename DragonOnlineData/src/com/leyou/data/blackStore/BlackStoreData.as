package com.leyou.data.blackStore
{
	import flash.utils.getTimer;
	

	public class BlackStoreData
	{
		private var bindItemIdList:Vector.<BlackStoreItem> = new Vector.<BlackStoreItem>();
		
		private var unbindItemIdList:Vector.<BlackStoreItem> = new Vector.<BlackStoreItem>();
		
		// 活动图标状态
		private var iconStatus:int;
		
		// 剩余可购买次数
		public var remianC:int;
		
		// 活动剩余时间
		private var remainT:int;
		
		// 活动剩余刷新时间
		private var refreshRT:int;
		
		private var tick:uint;
		
		public var payoff:int
		
		public function BlackStoreData(){
		}
		
		public function loadData_A(obj:Object):void{
			tick = getTimer();
			iconStatus = obj.ast;
			remainT = obj.stime;
			refreshRT = obj.fstime;
		}
		
		public function loadData_I(obj:Object):void{
			remianC = obj.sc;
			payoff = obj.cc;
			var dataList:Array = obj.list;
			var itemList:Vector.<BlackStoreItem>;
			if(0 == obj.btype){
				itemList = unbindItemIdList;
			}else{
				itemList = bindItemIdList;
			}
			var length:int = dataList.length;
			itemList.length = length;
			for(var n:int = 0; n < length; n++){
				var item:BlackStoreItem = itemList[n];
				if(null == item){
					item = new BlackStoreItem();
					itemList[n] = item;
				}
				item.serialize(dataList[n]);
			}
		}
		
		public function isActive():Boolean{
			return (1 == iconStatus);
		}
		
		public function getRemainTime():int{
			var r:int = remainT - (getTimer() - tick)/1000;
			if(r < 0){
				return 0;
			}
			return r;
		}
		
		public function getRefreshTime():int{
			var r:int = refreshRT - (getTimer() - tick)/1000;
			if(r < 0){
				return 0;
			}
			return r;
		}
		
		public function getItemCount(type:int):int{
			if(0 == type){
				return unbindItemIdList.length;
			}
			return bindItemIdList.length;
		}
		
		public function getItem(type:int, index:int):BlackStoreItem{
			if(0 == type){
				return unbindItemIdList[index];
			}
			return bindItemIdList[index];
		}
	}
}
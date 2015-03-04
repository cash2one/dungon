package com.leyou.data.market
{
	/**
	 * @class 商城分页数据
	 * @author weifh
	 * 
	 */	
	public class MarketPageInfo
	{
		private var _items:Vector.<MarketItemInfo> = new Vector.<MarketItemInfo>();

		public var pageIndex:int = -1;
		
		public function MarketPageInfo(){
		}
		
		/**
		 * <T>获得数据项数量</T>
		 * 
		 * @return 数量
		 * 
		 */		
		public function get count():int{
			return _items.length;
		}
		
		/**
		 * <T>追加一个数据项</T>
		 * 
		 * @param item 数据项
		 * 
		 */		
		public function push(item:MarketItemInfo):void{
			_items.push(item);
		}
		
		/**
		 * <T>获得指定索引的数据项</T>
		 * 
		 * @param index 指定的索引值
		 * @return 数据项
		 * 
		 */		
		public function getItem(index:int):MarketItemInfo{
			if(index >= 0 && index < _items.length){
				return _items[index];
			}
			return null;
		}
		
		/**
		 * <T>查找指定编号的数据</T>
		 * 
		 * @param dataId 数据号
		 * @return 数据项
		 * 
		 */		
		public function searchItem(dataId:uint):MarketItemInfo{
			var length:int = _items.length;
			for(var n:int = 0; n < length; n++){
				var item:MarketItemInfo = _items[n];
				if(item.itemId == dataId){
					return item;
				}
			}
			return null;
		}
		
		/**
		 * <T>清空数据</T>
		 * 
		 */		
		public function clear():void{
			_items.length = 0;
		}

	}
}
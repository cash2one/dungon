package com.leyou.data.quickBuy
{
	public class QuickBuyInfo
	{
		public var name:String;
		
		// 道具ID
		public var itemId:uint;
		
		// 对应的绑定或非绑定道具
		public var relativeItem:QuickBuyInfo;
		
		// 是否绑定
		private var _isBind:Boolean;
		
		// 是否勾选自动购买
		public var autoBuy:Boolean;
		
		// 道具价格
		public var price:uint;
		
		public var quality:int;
		
		public var select:Boolean;
		
		// 偶数是钻石买  奇数是绑定钻石
		public function get  isBind():Boolean{
			return (itemId&1) == 1;
		}
		
		public function set isBind(value:Boolean):void{
			_isBind = value;
		}
	}
}
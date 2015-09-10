package com.leyou.data.market
{
	/**
	 * @class 商城商品数据
	 * @author weifh
	 * 
	 */	
	public class MarketItemInfo
	{
		/**
		 * <T>物品编号</T>
		 */
		public var itemId:uint;
		
		/**
		 * <T>使用货币类型</T>
		 * 
		 * 0 -- 金币
		 * 1 -- 礼金 
		 * 2 -- 元宝
		 */
		public var moneyType:int;
		
		/**
		 * <T>原价格</T>
		 */
		public var price:uint;
		
		/**
		 * <T>现价格</T>
		 */
		public var nowPrice:uint;
		
		/**
		 * <T>是否可以打折</T>
		 */		
		public var acceptDiscount:Boolean;
		
		/**
		 * <T>是否热销</T>
		 */
		public var hot:Boolean;
		
		/**
		 * <T>是否已经请求打折</T>
		 */
		public var isapply:Boolean;
		
		/**
		 * <T>负责渲染数据的对象</T>
		 */		
		public var render:*;
		
		/**
		 * <T>标签页类型</T>
		 */		
		public var pageType:int;
		
		public var buyType:int;
		
		/**
		 * <T>构造</T>
		 * 
		 */		
		public function MarketItemInfo(){
		}
		
		/**
		 * <T>是否打折</T>
		 */
		public function get discount():Boolean{ return (price != nowPrice) }
		
		/**
		 * <T>加载数据信息</T>
		 * 
		 * @param arr 信息列表
		 * 
		 */		
		public function loadInfo(arr:Array, $pageType:int):void{ 
			itemId   = arr[0];
			price    = arr[1];
			nowPrice = arr[2];
			hot      = arr[3];
			isapply  = arr[4];
			pageType = $pageType;
			moneyType = (4 == pageType) ? 1 : 2;
			acceptDiscount = arr[5];
			if(null != render){
				render.updataRender();
			}
		}
	}
}
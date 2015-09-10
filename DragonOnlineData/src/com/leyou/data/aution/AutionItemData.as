package com.leyou.data.aution
{
	import com.leyou.data.tips.TipsInfo;
	

	public class AutionItemData
	{
		/**
		 * <T>出售编号</T>
		 */		
		public var id:uint;
		
		/**
		 * <T>物品编号</T>
		 */		
		public var itemId:uint;
		
		/**
		 * <T>售卖人编号</T>
		 */		
		public var sellerId:String;
		
		/**
		 * <T>售卖人</T>
		 */		
		public var sellerName:String;
		
		/**
		 * <T>购买人</T>
		 */		
		public var buyName:String;
		
		/**
		 * <T>物品所属类型</T>
		 */		
		public var type:uint;
		
		/**
		 * <T>价格</T>
		 */
		public var price:uint;
		
		/**
		 * <T>物品等级</T>
		 * 
		 */		
		public var level:uint;
		
		/**
		 * <T>使用货币类型</T>
		 * 
		 * 0 -- 金币
		 * 1 -- 礼金 
		 * 2 -- 元宝
		 */
		public var moneyType:int;
		
		/**
		 * <T>物品名称</T>
		 */		
		public var itemName:String;
		
		/**
		 * <T>物品数量</T>
		 */		
		public var itemCount:uint;
		
		/**
		 * <T>所属职业</T>
		 */		
		public var profession:int;
		
		/**
		 * <T>品质</T>
		 */		
		public var quality:int;
		
		/**
		 * <T>交易类型(日志用)</T>
		 * 
		 * 1--出售
		 * 2--取消
		 * 3--购买
		 * 
		 */		
		public var operate:int;
		
		/**
		 * <T>购买人编号</T>
		 */		
		public var buyerId:uint;
		
		/**
		 * <T>出售时间</T>
		 */		
		public var tick:String;
		
		/**
		 * <T>是否在线</T>
		 */		
		public var online:Object;
		
		public var invpos:Object;
		
		/**
		 * <T>金币数量</T>
		 */		
		public var item_type:int;
		
		public var tips:TipsInfo = new TipsInfo();
		
		public function updata(data:Array):void{
			id         = data[ 0];
			sellerId   = data[ 1];
			sellerName = data[ 2];
			invpos     = data[ 3];
			item_type  = data[ 4];
			itemId     = (0 == data[ 5]) ? 65535 : data[5];
			itemName   = data[ 6];
			itemCount  = data[ 7];
			moneyType  = data[ 8];
			price      = data[ 9];
			level      = data[10];
			profession = data[11];
			quality    = data[12];
			operate    = data[13];
			online     = data[14];
			buyerId    = data[15];
			buyName    = data[16];
			tick       = data[17];
			tips.clear();
			var tipsData:Object = data[18];
			if(null != tipsData){
				tips.unserialize(tipsData);
			}else{
				tips.itemid = itemId;
			}
		}
		
		public function updateLog(data:Array):void{
			id         = data[ 0];
			sellerId   = data[ 1];
			sellerName = data[ 2];
			item_type  = data[ 3];
			itemId     = (0 == data[ 4]) ? 65535 : data[4];
			itemName   = data[ 5];
			itemCount  = data[ 6];
			moneyType  = data[ 7];
			price      = data[ 8];
			buyName    = data[ 9];
			operate    = data[10];
			tick       = data[11];
		}
	}
}
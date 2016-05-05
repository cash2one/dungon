package com.ace.gameData.table {

	public class TShop {

		/**
		*	ID
		*	商店ID
		*/
		public var shopId:int;

		/**
		*	标签ID
		*/
		public var tagId:int;

		/**
		*	标签名
		*/
		public var tagName:String;

		/**
		*	职业限制
		*	通用 0
		*	武师 1
		*	法师 2
		*	术士 3
		*	游侠 4
		*/
		public var Class:int;

		/**
		*	道具ID
		*	索引道具表
		*/
		public var itemId:int;

		/**
		*	货币ID
		*	0 游戏币
		*	1 绑定元宝
		*	2 元宝
		*	3 真气
		*/
		public var moneyId:int;

		/**
		*	售价
		*/
		public var moneyNum:int;

		/**
		*	消耗道具ID
		*/
		public var consumeItem:int;

		/**
		*	消耗道具数量
		*/
		public var itemNum:int;

		/**
		 *每日限購數量 
		 */		
		public var limitNum:int;
		
		/**
		 *限購國家等級 
		 */		
		public var limitNation:int;

		public function TShop(data:XML=null) {
			if (data == null)
				return;

			this.shopId=data.@shopId;
			this.tagId=data.@tagId;
			this.tagName=data.@tagName;
			this.Class=data.@Class;
			this.itemId=data.@itemId;
			this.moneyId=data.@moneyId;
			this.moneyNum=data.@moneyNum;
			this.consumeItem=data.@consumeItem;
			this.itemNum=data.@itemNum;
			this.limitNum=data.@limitNum;
			this.limitNation=data.@limitNation;

		}



	}
}

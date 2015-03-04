package com.ace.gameData.table {

	public class TWing_Trade {
		
		
		
		/**
		 *	id
		 */
		public var id:int;

		/**
		 *	飞升重数
		 */
		public var unit:int;

		/**
		 *	飞升级数
		 */
		public var level:int;

		/**
		 *	加成百分比
		 */
		public var rate:int;

		/**
		 *	消耗道具数量
		 */
		public var itemNum:int;

		/**
		 *	消耗金币数量
		 */
		public var money:int;

		/**
		 *	总经验值
		 */
		public var exp:int;



		public function TWing_Trade(data:XML=null) {
			if (data == null)
				return;

			this.id=data.@id;
			this.unit=data.@unit;
			this.level=data.@level;
			this.rate=data.@rate;
			this.itemNum=data.@itemNum;
			this.money=data.@money;
			this.exp=data.@exp;
		}
		
		
	}
}

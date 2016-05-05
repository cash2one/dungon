package com.ace.gameData.table {

	public class TElementTrans {

		/**
		 *	装备等级
		 */
		public var lv:int;

		/**
		 *	装备品质
		 *	3紫
		 *	4橙
		 *	5 红
		 */
		public var quality:int;

		/**
		 *	转换用道具ID
		 */
		public var tranItemId:String;

		/**
		 *	转换道具数量
		 */
		public var tranItemNum:int;

		/**
		 *	转换金币数量
		 */
		public var tranMoney:int;

		/**
		 *	重置道具ID
		 */
		public var resetItemId:String;

		/**
		 *	重置道具数量
		 */
		public var resetItemNum:int;

		/**
		 *	重置金币数量
		 */
		public var resetMoney:int;



		public function TElementTrans(data:XML=null) {
			if (data == null)
				return;

			this.lv=data.@lv;
			this.quality=data.@quality;
			this.tranItemId=data.@tranItemId;
			this.tranItemNum=data.@tranItemNum;
			this.tranMoney=data.@tranItemMoney;
			this.resetItemId=data.@resetItemId;
			this.resetItemNum=data.@resetItemNum;
			this.resetMoney=data.@resetMoney;


		}



	}
}

package com.ace.gameData.table {

	public class TBackpackAdd {

		/**
		*	背包ID
		*/
		public var backId:int;

		/**
		*	开启所需时间（秒)
		*/
		public var addTime:int;

		/**
		*	开启所需元宝
		*/
		public var addMoney:int;
		
		/**
		 *开启所需绑定元宝 
		 */		
		public var addBMoney:int;

		/**
		*	获得HP上限
		*/
		public var addHP:int;

		/**
		*	获得经验
		*/
		public var addExp:int;



		public function TBackpackAdd(data:XML=null) {
			if (data == null)
				return;

			this.backId=data.@backId;
			this.addTime=data.@addTime;
			this.addMoney=data.@addMoney;
			this.addBMoney=data.@addBMoney;
			this.addHP=data.@addHP;
			this.addExp=data.@addExp;


		}



	}
}

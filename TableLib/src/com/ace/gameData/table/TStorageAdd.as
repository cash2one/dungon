package com.ace.gameData.table
{

	public class TStorageAdd
	{
		
		/**
		*	背包ID
		*/
		public var storId:int;

		/**
		*	开启所需时间（秒)
		*/
		public var addTime:int;

		/**
		*	开启所需元宝
		*/
		public var addMoney:int;
		
		/**
		 * 开启所需绑定元宝
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


		
		public function TStorageAdd(data:XML=null)
		{
			if(data==null) return ;
			
			this.storId=data.@storId;
			this.addTime=data.@addTime;
			this.addMoney=data.@addMoney;
			this.addBMoney=data.@addBMoney;
			this.addHP=data.@addHP;
			this.addExp=data.@addExp;

			
		}
		
		
		
	}
}

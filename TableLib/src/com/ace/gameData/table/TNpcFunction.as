package com.ace.gameData.table
{

	public class TNpcFunction
	{
		
		/**
		*	功能表ID
		*/
		public var index:int;

		/**
		*	描述
		*/
		public var des:String;

		/**
		*	功能ID
		*	1 商店
		*	2 仓库
		*	3 传送
		*	4 押镖
		*/
		public var funid:int;

		/**
		*	级别限制
		*	0或不填 不限制
		*/
		public var limitLv:int;

		/**
		*	参数1
		*	商店 商店ID
		*	传送 目标场景ID
		*/
		public var parameter1:int;

		/**
		*	参数2
		*	传送 价格
		*/
		public var parameter2:int;

		/**
		*	参数3
		*	传送 对应点表ID
		*/
		public var parameter3:int;
		
		/**
		 * 功能NPC头顶显示图标
		 */		
		public var flagPnfId:int;


		
		public function TNpcFunction(data:XML=null)
		{
			if(data==null) return ;
			
			this.index=data.@index;
			this.des=data.@des;
			this.funid=data.@funid;
			this.limitLv=data.@limitLv;
			this.parameter1=data.@parameter1;
			this.parameter2=data.@parameter2;
			this.parameter3=data.@parameter3;
			this.flagPnfId=data.@icon;
			
		}
		
		
		
	}
}

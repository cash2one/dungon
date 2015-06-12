package com.ace.gameData.table
{

	public class TMount
	{
		
		/**
		*	坐骑级别lv--id
		*/
		public var lv:int;
		
		public var lv2:int;

		/**
		*	名字
		*/
		public var des:String;

		/**
		*	坐骑模型
		*/
		public var ModeId:int;

		/**
		*	界面坐骑模型
		*/
		public var UI_ModeId:int;

		/**
		*	升级所需经验，指坐骑升阶所需的升阶经验
		*/
		public var exp:int;

		/**
		*	每次驯养消耗道具
		*/
		public var money:int;

		/**
		*	单倍消耗道具数
		*/
		public var Multiple1:int;

		/**
		*	倍率一耗道具数
		*	当前倍率为5倍
		*/
		public var Multiple2:int;

		/**
		*	倍率二消耗道具数
		*	当前倍率为10倍
		*/
		public var Multiple5:int;

		/**
		*	等级上限
		*/
		public var lvTop:int;

		/**
		*	属性比率（百分比）
		*/
		public var proRate:int;


		
		public function TMount(data:XML=null)
		{
			if(data==null) return ;
			
			this.lv=data.@lv;
			this.lv2=data.@lv2;
			this.des=data.@des;
			this.ModeId=data.@ModeId;
			this.UI_ModeId=data.@UI_ModeId;
			this.exp=data.@exp;
			this.money=data.@money;
			this.Multiple1=data.@Multiple1;
			this.Multiple2=data.@Multiple2;
			this.Multiple5=data.@Multiple5;
			this.lvTop=data.@lvTop;
			this.proRate=data.@proRate;

			
		}
		
		
		
	}
}

package com.ace.gameData.table
{

	public class THallows
	{
		
		/**
		*	圣器组ID
		*	表示不同职业圣器所属的组别
		*/
		public var Hallows_TeamID:int;

		/**
		*	圣器ID
		*	100-199，战士专属圣器
		*	200-299，法师专属圣器
		*	300-399，术士专属圣器
		*	400-499，游侠专属圣器
		*/
		public var Hallows_ID:int;

		/**
		*	圣器名称
		*/
		public var Hallows_Name:String;

		/**
		*	动画资源
		*/
		public var Hallows_AM:String;

		/**
		*	激活任务ID
		*	完成该任务后才会激活该圣器
		*/
		public var Mission_ID:int;

		/**
		*	属性1
		*	填写属性ID
		*/
		public var H_property_1:int;

		/**
		*	属性数值1
		*	属性ID所对应的数值
		*/
		public var Property_Amount_1:int;

		/**
		*	属性2
		*/
		public var H_property_2:int;

		/**
		*	属性数值2
		*/
		public var Property_Amount_2:int;

		/**
		*	属性3
		*/
		public var H_property_3:int;

		/**
		*	属性数值3
		*/
		public var Property_Amount_3:int;

		/**
		*	属性4
		*/
		public var H_property_4:int;

		/**
		*	属性数值4
		*/
		public var Property_Amount_4:int;


		
		public function THallows(data:XML=null)
		{
			if(data==null) return ;
			
			this.Hallows_TeamID=data.@Hallows_TeamID;
			this.Hallows_ID=data.@Hallows_ID;
			this.Hallows_Name=data.@Hallows_Name;
			this.Hallows_AM=data.@Hallows_AM;
			this.Mission_ID=data.@Mission_ID;
			this.H_property_1=data.@H_property_1;
			this.Property_Amount_1=data.@Property_Amount_1;
			this.H_property_2=data.@H_property_2;
			this.Property_Amount_2=data.@Property_Amount_2;
			this.H_property_3=data.@H_property_3;
			this.Property_Amount_3=data.@Property_Amount_3;
			this.H_property_4=data.@H_property_4;
			this.Property_Amount_4=data.@Property_Amount_4;

			
		}
		
		
		
	}
}

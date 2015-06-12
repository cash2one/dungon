package com.ace.gameData.table
{

	public class TBloodBase
	{
		
		/**
		*	血脉层
		*	id
		*/
		public var bloodId:String;

		/**
		*	血脉层
		*	名称
		*/
		public var des:String;

		/**
		*	血脉层
		*	图标
		*/
		public var icon:String;

		/**
		*	血脉节点
		*	id
		*/
		public var bPId:String;

		/**
		*	血脉节点
		*	名称
		*/
		public var bPDes:String;

		/**
		*	成功几率
		*/
		public var rate:String;

		/**
		*	消耗金币
		*/
		public var money:String;

		/**
		*	消耗真气
		*/
		public var energy:String;

		/**
		*	增加物理攻击
		*/
		public var p_attack:String;

		/**
		*	增加物理防御
		*/
		public var p_defense:String;

		/**
		*	增加法术攻击
		*/
		public var m_attack:String;

		/**
		*	增加法术防御
		*/
		public var m_defense:String;

		/**
		*	增加生命
		*/
		public var extraHP:String;

		/**
		*	增加法力
		*/
		public var extraMP:String;

		/**
		*	增加暴击等级
		*/
		public var crit:String;

		/**
		*	增加韧性等级
		*/
		public var critReduce:String;

		/**
		*	增加命中等级
		*/
		public var hit:String;

		/**
		*	增加闪避等级
		*/
		public var dodge:String;

		/**
		*	增加必杀等级
		*/
		public var critDam:String;

		/**
		*	增加守护等级
		*/
		public var critDamReduce:String;

		/**
		*	成功获得经验
		*/
		public var expSuccess:String;

		/**
		*	失败获得经验
		*/
		public var expFail:String;


		
		public function TBloodBase(data:XML=null)
		{
			if(data==null) return ;
			
			this.bloodId=data.@bloodId;
			this.des=data.@des;
			this.icon=data.@icon;
			this.bPId=data.@bPId;
			this.bPDes=data.@bPDes;
			this.rate=data.@rate;
			this.money=data.@money;
			this.energy=data.@energy;
			this.p_attack=data.@p_attack;
			this.p_defense=data.@p_defense;
			this.m_attack=data.@m_attack;
			this.m_defense=data.@m_defense;
			this.extraHP=data.@extraHP;
//			this.extraMP=data.@extraMP;
			this.extraMP="0";
			this.crit=data.@crit;
			this.critReduce=data.@critReduce;
			this.hit=data.@hit;
			this.dodge=data.@dodge;
			this.critDam=data.@critDam;
			this.critDamReduce=data.@critDamReduce;
			this.expSuccess=data.@expSuccess;
			this.expFail=data.@expFail;

			
		}
		
		
		
	}
}

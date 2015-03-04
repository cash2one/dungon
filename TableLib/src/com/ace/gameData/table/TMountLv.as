package com.ace.gameData.table
{

	public class TMountLv
	{
		
		/**
		*	等级id
		*/
		public var lv:int;

		/**
		*	物攻
		*/
		public var p_attack:int;

		/**
		*	法攻
		*/
		public var m_attack:int;

		/**
		*	物防
		*/
		public var p_defense:int;

		/**
		*	法防
		*/
		public var m_defense:int;

		/**
		*	生命上限
		*/
		public var extraHp:int;

		/**
		*	法力上限
		*/
		public var extraMp:int;

		/**
		*	暴击
		*/
		public var crit:int;

		/**
		*	韧性
		*/
		public var critReduce:int;

		/**
		*	命中
		*/
		public var hit:int;

		/**
		*	闪避
		*/
		public var dodge:int;

		/**
		*	必杀
		*/
		public var critDam:int;

		/**
		*	守护
		*/
		public var critDamReduce:int;

		/**
		*	移动速度
		*/
		public var speed:int;


		
		public function TMountLv(data:XML=null)
		{
			if(data==null) return ;
			
			this.lv=data.@lv;
			this.p_attack=data.@p_attack;
			this.m_attack=data.@m_attack;
			this.p_defense=data.@p_defense;
			this.m_defense=data.@m_defense;
			this.extraHp=data.@extraHp;
			this.extraMp=data.@extraMp;
			this.crit=data.@crit;
			this.critReduce=data.@critReduce;
			this.hit=data.@hit;
			this.dodge=data.@dodge;
			this.critDam=data.@critDam;
			this.critDamReduce=data.@critDamReduce;
			this.speed=data.@speed;

			
		}
		
		
		
	}
}

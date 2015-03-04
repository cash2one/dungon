package com.ace.gameData.table {

	public class TBuffAward {

		/**
		*	id
		*/
		public var id:int;

		/**
		*	索引标题
		*/
		public var name:String;

		/**
		*	1.buff栏显示
		*	2.角色栏显示
		*	3.buff栏有时显示，没有不显示
		*/
		public var type:int;

		/**
		*	未激活
		*	索引字典表
		*/
		public var tip_unown:int;

		/**
		*	激活
		*	索引字典表
		*/
		public var tip_own:int;

		/**
		*	物攻
		*/
		public var attack:int;

		/**
		*	物防
		*/
		public var phyDef:int;

		/**
		*	法攻
		*/
		public var magic:int;

		/**
		*	法防
		*/
		public var magicDef:int;

		/**
		*	生命
		*/
		public var life:int;

		/**
		*	暴击
		*/
		public var crit:int;

		/**
		*	韧性
		*/
		public var tenacity:int;

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
		public var slay:int;

		/**
		*	守护
		*/
		public var guard:int;



		public function TBuffAward(data:XML=null) {
			if (data == null)
				return;

			this.id=data.@id;
			this.name=data.@name;
			this.type=data.@type;
			this.tip_unown=data.@tip_unown;
			this.tip_own=data.@tip_own;
			this.attack=data.@attack;
			this.phyDef=data.@phyDef;
			this.magic=data.@magic;
			this.magicDef=data.@magicDef;
			this.life=data.@life;
			this.crit=data.@crit;
			this.tenacity=data.@tenacity;
			this.hit=data.@hit;
			this.dodge=data.@dodge;
			this.slay=data.@slay;
			this.guard=data.@guard;


		}



	}
}

package com.ace.gameData.table
{
	public class TPetAttackInfo
	{
		public var id:int;
		
		public var starLv:int;
		
		public var lv:int;
		
		public var exp:int;
		
		public var revive:int;
		
		public var fixedAtt:int;
		
		public var hp:int;
		
		public var crit:int;
		
		public var hit:int;
		
		public var dodge:int;
		
		public var tenacity:int;
		
		public var slay:int;
		
		public var guard:int;
		
		public function TPetAttackInfo(xml:XML){
			id = xml.@id;
			starLv = xml.@starLv;
			lv = xml.@lv;
			exp = xml.@exp;
			revive = xml.@revive;
			fixedAtt = xml.@fixed_attack;
			hp = xml.@life;
			crit = xml.@crit;
			hit = xml.@hit;
			dodge = xml.@dodge;
			tenacity = xml.@tenacity;
			slay = xml.@slay;
			guard = xml.@guard;
		}
	}
}
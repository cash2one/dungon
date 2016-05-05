package com.ace.gameData.table
{
	public class TElementInfo
	{
		public var id:int;
		
		public var type:int;
		
		public var lv:int;
		
		public var sound1:int;
		
		public var sound2:int;
		
		public var itemNum1:int;
		
		public var itemNum2:int;
		
		public var exp:int;
		
		public var money:int;
		
		public var energy:int;
		
		public var pnfId:int;
		
		public var name:String;
		
		public var passiveSkill:int;
		
		public var damageE:int;
		
		public var p_attack:int;
		
		public var p_defense:int;
		
		public var extraHp:int;
		
		public var crit:int;
		
		public var tenacity:int;
		
		public var hit:int;
		
		public var dodge:int;
		
		public var slay:int;
		
		public var guard:int;
		
		public var pnfId2:int;
		
		public function TElementInfo(xml:XML){
			id = xml.@id;
			type = xml.@type;
			lv = xml.@lv;
			sound1 = xml.@sound1;
			sound2 = xml.@sound2;
			itemNum1 = xml.@itemNum1;
			itemNum2 = xml.@itemNum2;
			exp = xml.@exp;
			money = xml.@money;
			energy = xml.@energy;
			pnfId = xml.@pnfId;
			pnfId2 = xml.@pnfId2;
			name = xml.@name;
			passiveSkill = xml.@passiveSkill;
			damageE = xml.@damageE;
			p_attack = xml.@p_attack;
			p_defense = xml.@p_defense;
			extraHp = xml.@extraHp;
			crit = xml.@crit;
			tenacity = xml.@tenacity;
			hit = xml.@hit;
			dodge = xml.@dodge;
			slay = xml.@slay;
			guard = xml.@guard;
		}
	}
}
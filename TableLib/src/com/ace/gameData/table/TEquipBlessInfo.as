package com.ace.gameData.table
{
	public class TEquipBlessInfo
	{
		public var id:int;
		
		public var name:String;
		
		public var type:int;
		
		public var lv:int;
		
		public var attack:int;
		
		public var phyDef:int;
		
		public var magicAtt:int;
		
		public var magicDef:int;
		
		public var hp:int;
		
		public var crit:int;
		
		public var hit:int;
		
		public var dodge:int;
		
		public var tenacity:int;
		
		public var slay:int;
		
		public var guard:int;
		
		public function TEquipBlessInfo(xml:XML){
			id = xml.@id;
			name = xml.@name;
			type = xml.@type;
			lv = xml.@lv;
			attack = xml.@attack;
			phyDef = xml.@phyDef;
			magicAtt = xml.@magic;
			magicDef = xml.@magicDef;
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
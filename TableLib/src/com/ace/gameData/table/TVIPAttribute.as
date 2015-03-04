package com.ace.gameData.table
{
	public class TVIPAttribute
	{
		public var lv:int;
		
		public var phyAtt:int;
		
		public var phyDef:int;
		
		public var maigcAtt:int;
		
		public var magicDef:int;
		
		public var hp:int;
		
		public var crit:int;
		
		public var hit:int;
		
		public var dodge:int;
		
		public var tenacity:int;
		
		public var slay:int;
		
		public var guard:int;
		
		public function TVIPAttribute(xml:XML){
			lv = xml.@lv;
			phyAtt = xml.@attack;
			phyDef = xml.@phyDef;
			maigcAtt = xml.@magic;
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
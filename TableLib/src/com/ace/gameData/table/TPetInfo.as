package com.ace.gameData.table
{
	public class TPetInfo
	{
		public var id:int;
		
		public var name:String;
		
		public var race:int;
		
		public var activeItem:int;
		
		public var itemCount:int;
		
		public var skill1:int;
		
		public var skill2:int;
		
		public var gift:int;
		
		public var giftCount:int;
		
		public var phyAtt:int;
		
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
		
		public var fixedAtt:int;
		
		public var fixedDef:int;
		
		public function TPetInfo(xml:XML){
			id = xml.@id;
			name = xml.@name;
			race = xml.@race;
			activeItem = xml.@item;
			itemCount = xml.@itemNum;
			skill1 = xml.@skill;
			skill2 = xml.@skill2;
			gift = xml.@gift;
			giftCount = xml.@giftNum;
			phyAtt = xml.@attack;
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
			fixedAtt = xml.@fixed_attack;
			fixedDef = xml.@fixed_defense;
		}
	}
}
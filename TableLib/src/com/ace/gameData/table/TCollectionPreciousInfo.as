package com.ace.gameData.table
{
	public class TCollectionPreciousInfo
	{
		public var id:int;
		
		public var groupId:int;
		
		public var frontGroup:int;
		
		public var mapName:String;
		
		public var monsterName:String;
		
		public var proName:String;
		
		public var proItem:int;
		
		public var proMax:int;
		
		public var toProIcon:String;
		
		public var toProName:String;
		
		public var mapPic_S:String;
		
		public var mapPic_B:String;
		
		public var targetPoint:int;
		
		// 奖励货币
		public var exp:int;
		
		public var money:int;
		
		public var energy:int;
		
		public var lp:int;
		
		public var byb:int;
		
		// 奖励属性
		public var hp:int;
		
		public var mp:int;
		
		public var phyAtt:int;
		
		public var magicAtt:int;
		
		public var phyDef:int;
		
		public var magicDef:int;
		
		public var magic:int;
		
		public var crit:int;
		
		public var tenacity:int;
		
		public var hit:int;
		
		public var dodge:int;
		
		public var slay:int;
		
		public var guard:int;
		
		public function TCollectionPreciousInfo(xml:XML){
			id = xml.@Setin_ID;
			groupId = xml.@Setin_Group;
			frontGroup = xml.@Setin_Frist;
			mapName = xml.@Setin_Mnam;
			proName = xml.@Setin_Name;
			monsterName = xml.@Setin_Mon;
			proItem = xml.@Setin_Item;
			proMax = xml.@Setin_Num;
			toProIcon = xml.@Setout_Img;
			toProName = xml.@Setout_Name;
			mapPic_S = xml.@map_Pics;
			mapPic_B = xml.@map_Picb;
			targetPoint = xml.@Setin_Point;
			exp = xml.@SetR_Exp;
			money = xml.@SetR_Money;
			energy = xml.@SetR_En;
			lp = xml.@SetR_LP;
			byb = xml.@SetR_BYB;
			hp = xml.@hp_max;
			mp = xml.@mp_max;
			phyAtt = xml.@p_attack;
			magicAtt = xml.@m_attack;
			phyDef = xml.@p_defense;
			magicDef = xml.@m_defense;
			crit = xml.@crit;
			tenacity = xml.@tenacity;
			hit = xml.@hit;
			dodge = xml.@dodge;
			slay = xml.@slay;
			guard = xml.@guard;
			magic = xml.@mp_max;
		}
		
		public function hasReward():Boolean{
			return (exp > 0) || (money > 0) || (energy > 0) || (lp > 0) || (byb > 0);
		}
		
		public function hasPro():Boolean{
			return (hp > 0) || (mp > 0) || (phyAtt > 0) || (magicAtt > 0) || (phyDef > 0) || (magicDef > 0) || (crit > 0) 
				|| (tenacity > 0) || (hit > 0) || (dodge > 0) || (slay > 0) || (guard > 0) || (magic > 0);
		}
	}
}
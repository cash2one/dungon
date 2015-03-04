package com.ace.gameData.table
{
	public class TCopyInfo
	{
		public var id:int;
		
		public var sceneId:int;
		
		public var name:String;
		
		public var exp:int;
		
		public var energy:int;
		
		public var money:int;
		
		public var guild:int;
		
		public var des:String;
		
		public var sourceUrl:String;
		
		public var openLevel:int;
		
		public var monsterId:int;
		
		public var fightEnergy:int;
		
		public var firstEXP:int;
		
		public var firstEnergy:int;
		
		public var firstMoney:int;
		
		public var firstItem1:int;
		
		public var firstItemCount1:int;
		
		public var firstItem2:int;
		
		public var firstItemCount2:int;
		
		public var item1:int;
		public var item2:int;
		public var item3:int;
		public var item4:int;
		public var item5:int;
		public var item6:int;
		public var item7:int;
		public var item8:int;
		
		public function TCopyInfo(xml:XML=null){
			if(xml == null)
				return;
			this.id=xml.@Dungeon_ID;
			this.sceneId=xml.@Dungeon_Scene;
			this.name=xml.@Dungeon_Name;
			this.des=xml.@Dungeon_Des;
			this.exp=xml.@M_Exp;
			this.energy=xml.@M_Energy;
			this.money=xml.@M_Money;
			this.guild=xml.@M_Guild;
			this.sourceUrl=xml.@DB_Pic;
			this.openLevel=xml.@Key_Level;
			this.monsterId=xml.@DB_Monster;
			this.fightEnergy=xml.@DBN_FC;
			this.firstEXP = xml.@First_Exp;
			this.firstEnergy = xml.@First_energy;
			this.firstMoney = xml.@First_Money;
			this.firstItem1 = xml.@First_Item1;
			this.firstItemCount1 = xml.@Fitem_Num1;
			this.firstItem2 = xml.@First_Item2;
			this.firstItemCount2 = xml.@Fitem_Num2;
			
			var itemV:String;
			itemV = xml.@DBC_ITEM1;
			this.item1 = itemV.split(",")[0];
			itemV = xml.@DBC_ITEM2;
			this.item2 = itemV.split(",")[0];
			itemV = xml.@DBC_ITEM3;
			this.item3 = itemV.split(",")[0];
			itemV = xml.@DBC_ITEM4;
			this.item4 = itemV.split(",")[0];
			itemV = xml.@DBC_ITEM5;
			this.item5 = itemV.split(",")[0];
			itemV = xml.@DBC_ITEM6;
			this.item6 = itemV.split(",")[0];
			itemV = xml.@DBC_ITEM7;
			this.item7 = itemV.split(",")[0];
			itemV = xml.@DBC_ITEM8;
			this.item8 = itemV.split(",")[0];
		}
	}
}
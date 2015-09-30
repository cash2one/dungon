package com.ace.gameData.table
{
	public class TCopyInfo
	{
		public var id:int;
		
		public var type:int;
		
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
		
		public var fastTop:Boolean;
		
		public var item1Data:Array;
		public var item2Data:Array;
		public var item3Data:Array;
		public var item4Data:Array;
		public var item5Data:Array;
		public var item6Data:Array;
		public var item7Data:Array;
		public var item8Data:Array;
		
		public var ticket1:int;
		public var ticket2:int;
		public var ticket3:int;
		public var ticket4:int;
		public var ticketC1:int;
		public var ticketC2:int;
		public var ticketC3:int;
		public var ticketC4:int;
		
		public function TCopyInfo(xml:XML=null){
			this.type=xml.@Dungeon_Type;
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
			
			var itemV:String = xml.@DBC_ITEM1;
			item1Data = itemV.split(",");
			itemV = xml.@DBC_ITEM2;
			item2Data = itemV.split(",");
			itemV = xml.@DBC_ITEM3;
			item3Data = itemV.split(",");
			itemV = xml.@DBC_ITEM4;
			item4Data = itemV.split(",");
			itemV = xml.@DBC_ITEM5;
			item5Data = itemV.split(",");
			itemV = xml.@DBC_ITEM6;
			item6Data = itemV.split(",");
			itemV = xml.@DBC_ITEM7;
			item7Data = itemV.split(",");
			itemV = xml.@DBC_ITEM8;
			item8Data = itemV.split(",");

			ticket1 = xml.@D_ticket1;
			ticket2 = xml.@D_ticket2;
			ticket3 = xml.@D_ticket3;
			ticket4 = xml.@D_ticket4;
			ticketC1 = xml.@DT_Num1;
			ticketC2 = xml.@DT_Num2;
			ticketC3 = xml.@DT_Num3;
			ticketC4 = xml.@DT_Num4;
			
			fastTop = ("1" == xml.@D_FastTop);
		}
	}
}
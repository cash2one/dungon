package com.ace.gameData.table
{
	public class TAreaCelebrateInfo
	{
		public var id:int;
		
		public var type:int;
		
		public var threshold:int;
		
		public var des:String;
		
		public var rMoney:uint;
		
		public var rExp:uint;
		
		public var rEnergy:uint;
		
		public var rbib:uint;
		
		public var rlp:uint;
		
		public var item1:int;
		
		public var item1Count:int;
		
		public var item2:int;
		
		public var item2Count:int;
		
		public var item3:int;
		
		public var item3Count:int;
		
		public function TAreaCelebrateInfo(xml:XML){
			id = id;
			type = xml.@Open_Type;
			threshold = xml.@Open_Par;
			des = xml.@Open_Des;
			rMoney = xml.@Open_Rmoney;
			rExp = xml.@Open_Rexp;
			rEnergy = xml.@Open_Rerg;
			rbib = xml.@Open_Rbyb;
			rlp = xml.@Open_Rlp;
			item1 = xml.@Open_Ritem1;
			item1Count = xml.@Open_Rnum1;
			item2 = xml.@Open_Ritem2;
			item2Count = xml.@Open_Rnum2;
			item3 = xml.@Open_Ritem3;
			item3Count = xml.@Open_Rnum3;
		}
	}
}
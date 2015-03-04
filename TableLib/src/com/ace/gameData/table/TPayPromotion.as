package com.ace.gameData.table
{
	public class TPayPromotion
	{
		public var id:int;
		
		public var groupId:int;
		
		public var value:int;
		
		public var des1:String;
		
		public var des2:String;
		
		public var des3:String;
		
		public var des4:String;
		
		public var rItem1:int;
		
		public var rItemNum1:int;
		
		public var rItem2:int;
		
		public var rItemNum2:int;
		
		public var rItem3:int;
		
		public var rItemNum3:int;
		
		public var rItem4:int;
		
		public var rItemNum4:int;
		
		public var rItem5:int;
		
		public var rItemNum5:int;
		
		public function TPayPromotion(xml:XML){
			id = xml.@id;
			groupId = xml.@Re_Group;
			value = xml.@Rp_Position;
			des1 = xml.@Re_script1;
			des2 = xml.@Re_script2;
			des3 = xml.@Re_script3;
			des4 = xml.@Re_script4;
			rItem1 = xml.@Rp_Reward1;
			rItemNum1 = xml.@Rpr_Num1;
			rItem2 = xml.@Rp_Reward2;
			rItemNum2 = xml.@Rpr_Num2;
			rItem3 = xml.@Rp_Reward3;
			rItemNum3 = xml.@Rpr_Num3;
			rItem4 = xml.@Rp_Reward4;
			rItemNum4 = xml.@Rpr_Num4;
			rItem5 = xml.@Rp_Reward5;
			rItemNum5 = xml.@Rpr_Num5;
		}
	}
}
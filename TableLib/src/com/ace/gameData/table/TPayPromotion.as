package com.ace.gameData.table
{
	public class TPayPromotion
	{
		public var id:int;
		
		public var groupId:int;
		
		public var value:int;
		
		public var type:int;
		
		public var rp_time:String;
		
		public var start_time:String;
		
		public var end_time:String;
		
		public var btnUrl:String;
		
		public var showType:int;
		
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
		
		public var rItem6:int;
		
		public var rItemNum6:int;
		
		public var rItem7:int;
		
		public var rItemNum7:int;
		
		public var rItem8:int;
		
		public var rItemNum8:int;
		
		public var ex_item1:int;
		
		public var ex_item1Num:int;
		
		public var ex_item2:int;
		
		public var ex_item2Num:int;
		
		public var ex_item3:int;
		
		public var ex_item3Num:int;
		
		public var ex_item4:int;
		
		public var ex_item4Num:int;
		
		public var items:Vector.<int> = new Vector.<int>();
		
		public var itemNums:Vector.<int> = new Vector.<int>();
		
		public var ex_items:Vector.<int> = new Vector.<int>();
		
		public var ex_itemNum:Vector.<int> = new Vector.<int>();
		
		public function TPayPromotion(xml:XML){
			id = xml.@id;
			groupId = xml.@Re_Group;
			value = xml.@Rp_Position;
			des1 = xml.@Re_script1;
			des2 = xml.@Re_script2;
			des3 = xml.@Re_script3;
			des4 = xml.@Re_script4;
			btnUrl = xml.@btn;
			showType = xml.@type;
			rp_time = xml.@RE_view;
			start_time = xml.@Re_start;
			end_time = xml.@Re_end;
			type = xml.@Re_Type;
			rItem1 = xml.@Rp_Reward1;
			rItemNum1 = xml.@Rpr_Num1;
			if(rItem1 > 0){
				items.push(rItem1);
				itemNums.push(rItemNum1);
			}
			rItem2 = xml.@Rp_Reward2;
			rItemNum2 = xml.@Rpr_Num2;
			if(rItem2 > 0){
				items.push(rItem2);
				itemNums.push(rItemNum2);
			}
			rItem3 = xml.@Rp_Reward3;
			rItemNum3 = xml.@Rpr_Num3;
			if(rItem3 > 0){
				items.push(rItem3);
				itemNums.push(rItemNum3);
			}
			rItem4 = xml.@Rp_Reward4;
			rItemNum4 = xml.@Rpr_Num4;
			if(rItem4 > 0){
				items.push(rItem4);
				itemNums.push(rItemNum4);
			}
			rItem5 = xml.@Rp_Reward5;
			rItemNum5 = xml.@Rpr_Num5;
			if(rItem5 > 0){
				items.push(rItem5);
				itemNums.push(rItemNum5);
			}
			rItem6 = xml.@Rp_Reward6;
			rItemNum6 = xml.@Rpr_Num6;
			if(rItem6 > 0){
				items.push(rItem6);
				itemNums.push(rItemNum6);
			}
			rItem7 = xml.@Rp_Reward7;
			rItemNum7 = xml.@Rpr_Num7;
			if(rItem7 > 0){
				items.push(rItem7);
				itemNums.push(rItemNum7);
			}
			rItem8 = xml.@Rp_Reward8;
			rItemNum8 = xml.@Rpr_Num8;
			if(rItem8 > 0){
				items.push(rItem8);
				itemNums.push(rItemNum8);
			}
			ex_item1 = xml.@Ex_item1;
			ex_item1Num = xml.@Exitem_Num1;
			if(ex_item1 > 0){
				ex_items.push(ex_item1);
				ex_itemNum.push(ex_item1Num);
			}
			ex_item2 = xml.@Ex_item2;
			ex_item2Num = xml.@Exitem_Num2;
			if(ex_item2 > 0){
				ex_items.push(ex_item2);
				ex_itemNum.push(ex_item2Num);
			}
			ex_item3 = xml.@Ex_item3;
			ex_item3Num = xml.@Exitem_Num3;
			if(ex_item3 > 0){
				ex_items.push(ex_item3);
				ex_itemNum.push(ex_item3Num);
			}
			ex_item4 = xml.@Ex_item4;
			ex_item4Num = xml.@Exitem_Num4;
			if(ex_item4 > 0){
				ex_items.push(ex_item4);
				ex_itemNum.push(ex_item4Num);
			}
		}
	}
}
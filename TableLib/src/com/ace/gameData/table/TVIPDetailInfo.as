package com.ace.gameData.table
{
	public class TVIPDetailInfo
	{
		public var id:int;
		
		public var cost:int;
		
		public var rate:int;
		
		public var modelBigId:int;
		
		public var modelSmallId:int;
		
		public var equipName:String;
		
		public var equipSourceurl:String;
		
		public var show1PicUrl:String;
		
		public var show2PicUrl:String;
		
		public var show3PicUrl:String;
		
		public var pic1Des:String;
		
		public var pic2Des:String;
		
		public var pic3Des:String;
		
		public var item1:String;
		
		public var num1:int;
		
		public var item2:String;
		
		public var num2:int;
		
		public var item3:String;
		
		public var num3:int;
		
		public var item4:String;
		
		public var num4:int;
		
		public var item5:String;
		
		public var num5:int;
		
		public var skill1:int;
		
		public var skill2:int;
		
		public var skill3:int;
		
		public var skill4:int;
		
		public var skill5:int;
		
		public function TVIPDetailInfo(xml:XML){
			id = xml.@id;
			cost = xml.@ib;
			rate = xml.@rate;
			modelBigId = xml.@model_b;
			modelSmallId = xml.@model_s;
			equipName = xml.@name;
			equipSourceurl = xml.@name_pic;
			show1PicUrl = xml.@ad1_pic;
			show2PicUrl = xml.@ad2_pic;
			show3PicUrl = xml.@ad3_pic;
			pic1Des = xml.@ad1_des;
			pic2Des = xml.@ad2_des;
			pic3Des = xml.@ad3_des;
			item1 = xml.@item1;
			item2 = xml.@item2;
			item3 = xml.@item3;
			item4 = xml.@item4;
			item5 = xml.@item5;
			num1 = xml.@num1;
			num2 = xml.@num2;
			num3 = xml.@num3;
			num4 = xml.@num4;
			num5 = xml.@num5;
			skill1 = xml.@skill1;
			skill2 = xml.@skill2;
			skill3 = xml.@skill3;
			skill4 = xml.@skill4;
			skill5 = xml.@skill5;
		}
	}
}
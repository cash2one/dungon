package com.ace.gameData.table
{
	public class TAbidePayInfo
	{
		public var id:int;
		
		public var ib:int;
		
		public var day1:int;
		
		public var day2:int;
		
		public var day3:int;
		
		public var dayItem1:int;
		
		public var dayItem1Num:int;
		
		public var dayItem2:int;
		
		public var dayItem2Num:int;
		
		public function TAbidePayInfo(xml:XML){
			id = xml.@id;
			ib = xml.@ib;
			day1 = xml.@day1;
			day2 = xml.@day2;
			day3 = xml.@day3;
			dayItem1 = xml.@dayItem1;
			dayItem2 = xml.@dayItem2;
			dayItem1Num = xml.@item1_num;
			dayItem2Num = xml.@item2_num;
		}
		
		public function getRewardByDay($day:int):int{
			switch($day){
				case 3:
					return day1;
				case 6:
					return day2;
				case 9:
					return day3;
				default:
					return day1;
			}
			return day1;
		}
	}
}
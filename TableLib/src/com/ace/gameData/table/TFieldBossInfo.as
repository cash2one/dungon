package com.ace.gameData.table
{
	public class TFieldBossInfo
	{
		public var id:int;
		
		public var openLv:int;
		
		public var sceneId:String;
		
		public var monsterId:int;
		
		public var refreshTimes:Array;
		
		public var remindTimes:Array;
		
		public var dropDes:String;
		
		public var item1:int;
		
		public var item1Num:int;
		
		public var item2:int;
		
		public var item2Num:int;
		
		public var item3:int;
		
		public var item3Num:int;
		
		public var item4:int;
		
		public var item4Num:int;
		
		public var pointId:int;
		
		public var type:int;
		
		public var showItem1:int;
		
		public var showItem2:int;
		
		public var showItem3:int;
		
		public var showItem4:int;
		
		public var showItem5:int;
		
		public var showItem6:int;
		
		public var showItem7:int;
		
		public var showItem8:int;
		
		public var bgPic:String;
		
		public function TFieldBossInfo(xml:XML){
			id = xml.@id;
			openLv = xml.@lv;
			sceneId = xml.@scnId;
			monsterId = xml.@monsterId;
			pointId = xml.@pointId2;
			
			var timeStr:String = xml.@time;
			refreshTimes = timeStr.split("|");
			timeStr = xml.@time2;
			remindTimes = timeStr.split("|");
			
			dropDes = xml.@desEquip;
			item1 = xml.@item1;
			item1Num = xml.@itemNum1;
			item2 = xml.@item2;
			item2Num = xml.@itemNum2;
			item3 = xml.@item3;
			item3Num = xml.@itemNum3;
			item4 = xml.@item4;
			item4Num = xml.@itemNum4;
			
			type = xml.@boss_obj;
			showItem1 = xml.@ShowItem1;
			showItem2 = xml.@ShowItem2;
			showItem3 = xml.@ShowItem3;
			showItem4 = xml.@ShowItem4;
			showItem5 = xml.@ShowItem5;
			showItem6 = xml.@ShowItem6;
			showItem7 = xml.@ShowItem7;
			showItem8 = xml.@ShowItem8;
			bgPic = xml.@BOSS_Card;
		}
		
		public function getRewardByRank(rank:int):int{
			switch(rank){
				case 1:
					return item1;
				case 2:
					return item2;
				case 3:
					return item3;
				default:
					return item4;
			}
		}
		
		public function getRewardCountByRank(rank:int):int{
			switch(rank){
				case 1:
					return item1Num;
				case 2:
					return item2Num; 
				case 3:
					return item3Num;
				default:
					return item4Num;
			}
		}
	}
}
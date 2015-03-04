package com.ace.gameData.table
{
	public class TGuideInfo
	{
		public var id:int;
		
		public var level:int;
		
		public var fr_id:int;
		
		public var values:Array;
		
		public var des:String;
		
		public var type:int;
		
		public var time:int;
		
		public var act_num:int;
		
		public var ox:int;
		
		public var oy:int;
		
		public var groupId:int;
		
		public function TGuideInfo(xml:XML){
			groupId = xml.@group;
			id = xml.@id;
			level = xml.@level;
			fr_id = xml.@fr_id;
			var v:String = xml.@act_condition;
			values = v.split("|");
			des = xml.@act_des;
			type = xml.@win_type;
			time = xml.@time;
			act_num = xml.@act_num;
			ox = xml.@win_X;
			oy = xml.@win_y;
		}
	}
}
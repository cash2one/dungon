package com.ace.gameData.table {
	import com.ace.utils.StringUtil;

	public class TGuideInfo {
		static public const TYPE_MANUAL:int=0;
		static public const TYPE_BUTTON:int=1;
		static public const TYPE_TABBAR:int=2;

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
		public var act_con:int;

		public var wndId:String;
		public var uiType:int; //0：手动实现，1：按钮，2：tab
		public var uiId:String;
		public var nextId:int;
		public var uiIndex:int;
		public var guideType:int;//0:任务判断，1：1级菜单	，2：2级菜单
		public var isGuideFirst:Boolean;

		public function TGuideInfo(xml:XML) {
			groupId=xml.@group;
			id=xml.@id;
			level=xml.@level;
			fr_id=xml.@fr_id;
			var v:String=xml.@act_condition;
			values=v.split("|");
			des=xml.@act_des;
			type=xml.@win_type;
			time=xml.@time * 1000;
			act_num=xml.@act_num;
			ox=xml.@win_X;
			oy=xml.@win_y;
			act_con=xml.@act_con;

			this.wndId=xml.@uiId;
			this.uiType=xml.@packId;
			if (uiType == TYPE_TABBAR) {
				this.uiId=String(xml.@closeAct).split("|")[0];
				this.uiIndex=String(xml.@closeAct).split("|")[1];
			} else {
				this.uiId=xml.@closeAct;
			}
			this.guideType=xml.@uiClass;

			this.nextId=xml.@fr_id;
			this.isGuideFirst=StringUtil.intToBoolean(xml.@group1st);
			if(this.groupId==0){
				this.isGuideFirst=true;
			}


		}
	}
}

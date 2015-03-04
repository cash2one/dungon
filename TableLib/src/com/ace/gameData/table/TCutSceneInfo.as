package com.ace.gameData.table {

	//剧情动画
	public class TCutSceneInfo {
		public var id:int;
		public var groupId:int;
		public var eventType:int;
		public var eventValue:String;
		public var waitTime:int; //毫秒
		public var talkOwner:String;
//		public var talkImg:String;//
		public var talkContent:String;

		public function TCutSceneInfo(info:XML) {
			this.id=info.@Ani_ID;
			this.groupId=info.@Ani_Group;
			this.eventType=info.@Ani_Event;
			this.eventValue=info.@Event_Content;
			this.waitTime=info.@Ani_Time;
			this.talkOwner=info.@Ani_Role;
			this.talkContent=info.@The_Lines;
		}
	}
}

package com.ace.gameData.table {
	

	public class TTransInfo {
		public var index:int;
//		public var id:int;
		public var fromId:String;
//		public var fromPs:Point;
		public var areaId:int;
		public var toId:String;
		public var lvLimit:int; //等级限制
		public var proLimit:int; //职业限制 
		public var itemLimit:int; //道具限制

//		public var mcType:int;
//		public var doorId:int;

		public function TTransInfo(info:XML) {
			this.index=info.@index;
			this.fromId=info.@bgSceneId;
			this.areaId=info.@bgAreaId;
			this.toId=info.@edPointId;
			this.lvLimit=info.@levelLimit;
			this.proLimit=info.@careerLimit;
			this.itemLimit=info.@itemLimit;
		}
 
		public function get id():String {
			return this.fromId + ":" + this.areaId.toString();
		}

	}
}
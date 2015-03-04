package com.ace.gameData.table {

	public class TNoticeInfo {
		public var id:int;
//		public var describe:String;//描述
		public var screenId1:int;
		public var screenId2:int;
		public var screenId3:int;
		public var content:String;
		public var broadcast:int; //是否广播,服务器用
		public var imgSign:int; //图标标志

		public function TNoticeInfo(xml:XML=null) {
			if (xml == null)
				return;
			this.id=xml.@id;
//			this.describe=xml.@describe;
			this.screenId1=xml.@screenId1;
			this.screenId2=xml.@screenId2;
			this.screenId3=xml.@screenId3;
			this.content=xml.@note;
			this.broadcast=xml.@broadcast;
			this.imgSign=xml.@imgSign;
		}

		/**信息显示位置*/
		public function viewPsIs(num:int):Boolean {
			return ((num == screenId1) || (num == screenId2) || (num == screenId3));
		}
	}
}
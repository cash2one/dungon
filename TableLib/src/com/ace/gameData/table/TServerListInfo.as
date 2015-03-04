package com.ace.gameData.table {

	public class TServerListInfo {
//		<server id="字符串" name="字符串" ip="192.168.10.66" port="3389" homeUrl="" payUrl="" bugUrl="" bbsUrl="http://bbs.no2.cn/forumdisplay.php?fid=66"/>
		public var id:String;
		public var name:String;
		public var ip:String;
		public var port:int;
		public var resUrl:String
		public var mapUrl:String;
		public var homeUrl:String
		public var payUrl:String
		public var bbsUrl:String;
		public var fangUrl:String; //

		public function TServerListInfo(info:XML) {
			this.id=info.@id;
			this.name=info.@name;
			this.ip=info.@ip;
			this.port=info.@port;
			this.resUrl=info.@resUrl;
			this.mapUrl=info.@mapUrl;
			this.homeUrl=info.@homeUrl;
			this.payUrl=info.@payUrl;
			this.bbsUrl=info.@bbsUrl;
			this.fangUrl=info.@fangUrl;
		}
	}
}

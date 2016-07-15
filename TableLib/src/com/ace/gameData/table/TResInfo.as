/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2014-3-24 下午4:55:56
 */
package com.ace.gameData.table {

	public class TResInfo {

		public var type:int; //属于哪个模块
		public var url:String; //
		public var size:String; //大小，多少字节
		public var rpColor:String; //替换颜色
		public var width:int; //
		public var height:int;



		public function TResInfo(xml:XML=null) {
			if (xml == null)
				return;
			this.type=xml.@type;
			this.url=xml.@url;
			this.size=xml.@size;
			this.rpColor=xml.@replaceColor
			this.width=xml.@width;
			this.height=xml.@height;
		}

		static internal var info:TResInfo;

		static public function defaultInfo():TResInfo {
			if (!info) {
				info=new TResInfo();
				info.width=3, info.height=3, info.rpColor="0xFF0000";
			}
			return info;
		}
	}
}

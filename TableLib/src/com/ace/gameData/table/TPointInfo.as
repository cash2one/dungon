/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-10-16 下午4:57:19
 */
package com.ace.gameData.table {

	public class TPointInfo {
		public var id:int;
		public var sceneId:String;
		public var tx:int;
		public var ty:int;
		public var dir:int;
		public var dsc:String;

		public function TPointInfo(info:XML) {
			this.id=info.@id;
			this.sceneId=info.@sceneId;
			this.tx=info.@pointX;
			this.ty=info.@pointY;
			this.dir=info.@direction;
			this.dsc=info.@description;
		} 
	}
}
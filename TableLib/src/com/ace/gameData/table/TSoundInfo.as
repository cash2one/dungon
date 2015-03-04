/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2014-3-25 下午4:52:27
 */
package com.ace.gameData.table {

	public class TSoundInfo {
		public var id:int;
		public var name:String;
		public var type:int; //

		public function TSoundInfo(info:XML) {
			this.id=info.@id;
			this.name=info.@name;
			this.type=info.@type;
		}
	}
}
/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-12-5 下午3:09:46
 */
package com.ace.gameData.table {
	import com.ace.utils.StringUtil;

	public class TBuffInfo {
		public var id:int;
		public var type:int; //buff还是debuff 1/0
		public var name:String;
		public var icon:String;
		public var tipId:int;
		public var pnfId:int; //中buff时播放特效
		public var color:uint;
		public var time:uint;
		public var isRemoveOnDie:Boolean;
		public var des:String;

		public function TBuffInfo(info:XML) {
			this.id=info.@id;
			this.type=info.@buffType;
			this.name=info.@name;
			this.icon=info.@icon;
			this.tipId=info.@icon2;
			this.pnfId=info.@effectId;
			this.color=StringUtil.strToHex(info.@rgb);
			this.time=info.@buffTime;
			this.isRemoveOnDie=StringUtil.intToBoolean(info.@buffDis);
			this.des=info.@buffDes;
		}
	}
}

/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-8-15 上午10:23:59
 */
package com.ace.gameData.table {
	import com.ace.utils.StringUtil;

	public class TSceneInfo {
		public var id:String;
		public var name:String;
		public var mapFile:String; //2进制文件，默认==id
		public var mapRes:String; //地图资源文件夹：缩略图、散图
		public var type:int; //场景类型，有枚举对应
		public var soundId:int;
		public var canPk:Boolean;
		public var mask:Boolean;
		public var safeTX:int;
		public var safeTY:int;
		public var noticeFRes:String;
		public var active:Boolean;
		public var needLevel:int;
		public var autoMonsterRange:uint;
		public var isDouble:Boolean;
		public var isNeedMount:Boolean;
		public var weather:int;


		public function TSceneInfo(info:XML) {
			this.id=info.@id;
			this.name=info.@SceneName;
			this.mapFile=this.id;
			this.mapRes=info.@mapFile;
			this.type=info.@mapClass;
			this.soundId=info.@mapSound;
			this.canPk=StringUtil.intToBoolean(info.@mapPvp);
			this.mask=StringUtil.intToBoolean(info.@mapMask);

			this.safeTX=info.@safeX;
			this.safeTY=info.@safeY;
			this.noticeFRes=info.@EF_ID;
			this.active=("1" == info.@active);
			this.needLevel=info.@Map_Level;
			this.autoMonsterRange=info.@odd;
			(this.autoMonsterRange <= 0) && (this.autoMonsterRange=99999);
			this.isDouble=("1" == info.@Double_info);
			this.isNeedMount=("1" == info.@Mount_Blade);
			this.weather=info.@weather;
//			this.weather=1;
		}

		public function get isCanFindPath():Boolean {
			return true;
		}
	}
}

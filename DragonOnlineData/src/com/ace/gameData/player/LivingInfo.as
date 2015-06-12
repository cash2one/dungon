package com.ace.gameData.player {
	import com.ace.enum.PlayerEnum;
	import com.ace.gameData.player.mChild.MLivingInfo;
	import com.leyou.utils.PropUtils;


	public class LivingInfo extends MLivingInfo {
		public var idTag:String; //字符串id
		public var avTag:int; //是否有换装状态，暂时不用
//		public var roomId:int;
		public var pkMode:int;
		public var color:int; //名称颜色
		public var vipEquipId:int;
		public var equipColor:int; //装备颜色
		public var equipLv:int;
		// 平台VIP等级
		public var pfVipLv:int;
		public var pfVipType:int; // 0 -- 不是黄钻 1 -- 普通黄钻 2 -- 年费黄钻

		public var camp:int; // 0 无阵营 1 -- 寒霜 2 -- 烈红

		public function LivingInfo($info:LivingInfo=null) {
			super($info);
		}

		static public function getDefaultInfo(race:int=PlayerEnum.RACE_MONSTER):LivingInfo {
			var info:LivingInfo=new LivingInfo();
			info.level=0;
			info.name=PropUtils.getStringById(2070);
			info.race=race;
			info.id=888888;
			info.nextTile.x=1;
			info.nextTile.y=1;
			info.currentDir=PlayerEnum.DIR_S;
			info.currentAct=PlayerEnum.ACT_STAND;
			info.currentActIsLoop=true;
			return info;
		}
	}
}

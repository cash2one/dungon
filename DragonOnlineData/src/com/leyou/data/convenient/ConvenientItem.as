package com.leyou.data.convenient
{
	import com.ace.gameData.manager.MyInfoManager;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.data.role.EquipInfo;

	public class ConvenientItem
	{
		// 物品的唯一ID
		public var uid:String;
		
		// 战斗力差值
		public var dzdl:uint;
		
		// 类型
		public var type:int;
		
		// 消耗金钱
		public var cost:int;
		
		// 强化转移对应装备索引
		public var eInfoIndex:int;
		
//		public var eInfo:EquipInfo;
		
		// 在装备缓存的位置
//		public var currentIndx:int;
		
		public function get bagInfo():Baginfo{
			var li:Array = MyInfoManager.getInstance().bagItems;
			return MyInfoManager.getInstance().getBagItemByUid(uid);
		}
		
		public function clear():void{
			uid = null;
//			eInfo = null;
			eInfoIndex = -1;
		}
		
		public function get eInfo():EquipInfo{
			var einfo:EquipInfo = MyInfoManager.getInstance().equips[eInfoIndex];
			return einfo;
		}
		
		public function empty():Boolean{
			return (null == uid);
		}
		
	}
}
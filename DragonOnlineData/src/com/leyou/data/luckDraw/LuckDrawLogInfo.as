package com.leyou.data.luckDraw
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.gameData.table.TItemInfo;

	public class LuckDrawLogInfo
	{
		public var type:int;
		
		public var dtime:String;
		
		public var name:String;
		
		public var itemid:int;
		
		public var itemNum:int;
		
		public function assign(info:LuckDrawLogInfo):void{
			type = info.type;
			dtime = info.dtime;
			name = info.name;
			itemid = info.itemid;
			itemNum = info.itemNum;
		}
		
	}
}
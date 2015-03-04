package com.leyou.data.groupBuy
{
	import flash.utils.getTimer;

	public class GroupBuyData
	{
//		下行：gbuy|{"mk":"I", stime:num, glist:[[gbuyid,st,buypeople,[[jpeople,jst],...]],...]}
//			stime -- 活动剩余秒数
//		glist -- 团购列表
//		gbuyid --团购id
//		st -- 是否已购买(0未购买 1已购买)
//			buypeople  -- 已购买的人数
//				[[jpeople,pst],...]  -- 
//				jpeople -- 领取奖励需要的人数
//		jst  --(0未领取 1已领取)
		
		private var _tick:int;
		
		private var _stime:int;
		
		private var itemDataList:Vector.<GroupBuyItemData> = new Vector.<GroupBuyItemData>();
		
		public function GroupBuyData(){
		}
		
		public function get remainTime():int{
			return _stime - (getTimer() - _tick)/1000;
		}

		public function loadData_I(obj:Object):void{
			_tick = getTimer();
			_stime = obj.stime;
			var glist:Array = obj.glist;
			var l:int = glist.length;
			itemDataList.length = l;
			for(var n:int = 0; n < l; n++){
				var item:GroupBuyItemData = itemDataList[n];
				if(null == item){
					item = new GroupBuyItemData();
					itemDataList[n] = item;
				}
				item.unserialize(glist[n]);
			}
		}
		
		public function getItemCount():int{
			return itemDataList.length;
		}
		
		public function getItemData(index:int):GroupBuyItemData{
			return itemDataList[index];
		}
	}
}
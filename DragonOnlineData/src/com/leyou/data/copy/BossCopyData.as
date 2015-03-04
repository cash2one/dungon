package com.leyou.data.copy
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCopyInfo;
	

	public class BossCopyData
	{
		public var id:int;
		
		public var status:int;
		
		public var isFirst:Boolean;
		
//		private var items:Vector.<int> = new Vector.<int>();
//		
//		private var itemsCount:Vector.<int> = new Vector.<int>();
		
		public var copyInfo:TCopyInfo;
		
//		public function getRewardCount():int{
//			return items.length;
//		}
//		
//		public function getItem(index:int):int{
//			return items[index];
//		}
//		
//		public function getItemCount(index:int):int{
//			return itemsCount[index];
//		}
		
		public function updateInfo(obj:Object):void{
			id = obj.cid;
			status = obj.s;
			isFirst = obj.f;
//			var rewardList:Array = obj.rl;
//			var length:int = rewardList.length;
//			items.length = length;
//			itemsCount.length = length;
//			for(var n:int = 0; n < length; n++){
//				items[n] =  rewardList[n].iId;
//				itemsCount[n] =  rewardList[n].ic;
//			}
			copyInfo = TableManager.getInstance().getCopyInfo(id);
		}
	}
}
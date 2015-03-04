package com.leyou.data.collectioin
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCollectionPreciousInfo;

	public class CollectionData
	{
		public var zdl:int;
		
		// [key:组ID, value:已完成任务数量(int)]
//		private var mapData:Object = {};
		
		private var itemData:Object = {};
		
		private var mapData:Array = [];
		
		public var rewardCount:int;
		
		public function CollectionData(){
		}
		
		public function loadData_I(obj:Object):void{
			zdl = obj.zdl;
			var clist:Array = obj.clist;
			for each(var data:Array in clist){
				mapData[data[0]] = data[1];
			}
		}
		
		public function loadData_G(obj:Object):void{
			var rlist:Array = obj.rlist;
			var groupId:int = obj.groupid;
			var data:CollectionGroupTaskData = itemData[groupId];
			if(null == data){
				data = new CollectionGroupTaskData();
				itemData[groupId] = data;
				data.groupId = groupId;
			}
			data.unserialize(rlist);
		}
		
		public function remainTask(groupId:int):int{
			return getTaskNum(groupId) - getTaskCNum(groupId);
		}
		
		public function get cgroupId():int{
			var l:int = mapData.length;
			for(var n:int = 0; n < l; n++){
				if(mapData.hasOwnProperty(n)){
					var cc:int = mapData[n];
					if((0 == cc) || (cc < getTaskNum(n))){
						return n;
					}
				}
			}
			return -1;
		}
		
		public function getTaskCNum(group:int):int{
			return mapData[group];
		}
		
		public function getTaskData(group:int):CollectionGroupTaskData{
			return itemData[group];
		}
		
		public function getTaskNum(group:int):int{
			var count:int;
			var collectionDic:Object = TableManager.getInstance().getCollectionDic();
			for(var key:String in collectionDic){
				var info:TCollectionPreciousInfo = collectionDic[key];
				if(info.groupId == group){
					count++;
				}
			}
			return count;
		}
	}
}
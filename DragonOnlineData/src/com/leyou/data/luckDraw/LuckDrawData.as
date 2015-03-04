package com.leyou.data.luckDraw
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;

	public class LuckDrawData
	{
		// 抽取奖励列表
		private var rewardList:Vector.<LuckDrawRewardInfo> = new Vector.<LuckDrawRewardInfo>();
		
		// 获得奖励列表
		public var ownList:Array = [];
		
		// 剩余次数
		public var remainCount:int;
		
		// 最大次数
		public var maxCount:int;
		
		// 使用道具数量
		public var costCount:int;
		
		// 拥有道具数量
		public var ownCount:int;
		
		// 个人抽奖记录
		private var selfLogList:Vector.<LuckDrawLogInfo> = new Vector.<LuckDrawLogInfo>();
		
		// 服务器抽奖记录
		private var otherLogList:Vector.<LuckDrawLogInfo> = new Vector.<LuckDrawLogInfo>();
		
		// 巨龙仓库信息
		private var store:Vector.<LuckDrawRewardInfo> = new Vector.<LuckDrawRewardInfo>();
		
		public function rewardLength():int{
			return rewardList.length;
		}
		
		public function getReward(index:int):LuckDrawRewardInfo{
			if((index >= 0) && (index < rewardList.length)){
				return rewardList[index];
			}
			return null;
		}
		
		public function logLength(type:int):int{
			var list:Vector.<LuckDrawLogInfo> = (1 == type) ? selfLogList : otherLogList;
			return list.length;
		}
		
		public function getLog(type:int, index:int):LuckDrawLogInfo{
			var list:Vector.<LuckDrawLogInfo> = (1 == type) ? selfLogList : otherLogList;
			if((index >= 0) && (index < list.length)){
				return list[index];
			}
			return null;
		}
		
		public function storeLength():int{
			return store.length;
		}
		
		public function getStoreItem(index:int):LuckDrawRewardInfo{
			if((index >= 0) && (index < store.length)){
				return store[index];
			}
			return null;
		}
		
		public function loadData_I(obj:Object):void{
			var rewardInfo:Array = obj.item_d;
			remainCount = rewardInfo[0];
			maxCount = rewardInfo[1];
			ownCount = rewardInfo[2];
			costCount = rewardInfo[3];
			
			var nrList:Array = obj.dlist;
			var nl:int = nrList.length;
			rewardList.length = nl;
			for(var n:int = 0; n < nl; n++){
				var itemInfo:LuckDrawRewardInfo = rewardList[n];
				if(null == itemInfo){
					itemInfo = new LuckDrawRewardInfo();
					rewardList[n] = itemInfo;
				}
				itemInfo.itemid = nrList[n][0];
				itemInfo.count = nrList[n][1];
			}
		}
		
		public function loadData_D(obj:Object):void{
			ownList.length = 0;
			ownList = ownList.concat(obj.jlpos);
		}
		
		public function loadData_H(obj:Object):void{
			var type:int = obj.htype;
			var logList:Vector.<LuckDrawLogInfo> = null;
			if(1 == type){
				logList = selfLogList;
			}else if(2 == type){
				logList = otherLogList;
			}
			var nList:Array = obj.hlist;
			var nl:int = nList.length;
			logList.length = nl;
			for(var n:int = 0; n < nl; n++){
				var logInfo:LuckDrawLogInfo = logList[n];
				if(null == logInfo){
					logInfo = new LuckDrawLogInfo();
					logList[n] = logInfo;
				}
				logInfo.type = type;
				logInfo.dtime = nList[n][0];
				logInfo.name = nList[n][1];
				logInfo.itemid = nList[n][2];
				logInfo.itemNum = nList[n][3];
				var itemInfo:TItemInfo = TableManager.getInstance().getItemInfo(logInfo.itemid);
			}
		}
		
		public function loadData_B(obj:Object):void{
			var nl:Array = obj.s;
			var length:int = nl.length;
			store.length = length;
			for(var n:int = 0; n < length; n++){
				var itemInfo:LuckDrawRewardInfo = store[n];
				if(null == itemInfo){
					itemInfo = new LuckDrawRewardInfo();
					store[n] = itemInfo;
				}
				itemInfo.pos = nl[n][0];
				itemInfo.itemid = nl[n][1];
				itemInfo.count = nl[n][2];
			}
		}
		
		private var tmpArr:Vector.<LuckDrawRewardInfo> = new Vector.<LuckDrawRewardInfo>();
		
		public function loadData_U(obj:Object):void{
			var iList:Array = obj.hlist;
			var count:int = iList.length;
			if(otherLogList.length < count){
				otherLogList.length = count;
			}
			tmpArr.length = 0;
			var type:int = obj.htype;
			var length:int = otherLogList.length;
			// 原数据向后移动,舍弃无用数据
			for(var n:int = length-count-1; n >= 0; n--){
				if(null != otherLogList[n]){
					if(null == otherLogList[n+count]){
						otherLogList[n+count] = new LuckDrawLogInfo();
					}
					otherLogList[n+count].assign(otherLogList[n]);
				}
			} 
			//放入新数据
			for(var m:int = 0; m < count; m++){
				var logInfo:LuckDrawLogInfo = otherLogList[m];
				if(null == logInfo){
					logInfo = new LuckDrawLogInfo();
					otherLogList[m] = logInfo;
				}
				logInfo.type = type;
				logInfo.dtime = iList[m][0];
				logInfo.name = iList[m][1];
				logInfo.itemid = iList[m][2];
				logInfo.itemNum = iList[m][3];
			}
		}
	}
}
package com.leyou.data.vendue
{
	import flash.utils.getTimer;

	public class VendueData
	{
		public var pstatus:int; // 状态 0--即将拍卖 1--拍卖中
		
		public var pid:int; // 拍卖ID
		
		private var tick:uint; // 时间戳
		
		private var ptime:int; // 剩余时间
		
		public var cprice:int; // 当前竞价
		
		public var cname:String // 当前拍卖人
		
		public var bprice:int; // 最低竞价
		
		public var comeList:Vector.<VendueNextData> = new Vector.<VendueNextData>(); // 即将拍卖
		
		public var historyList:Vector.<VendueHistoryData> = new Vector.<VendueHistoryData>(); // 拍卖历史
		
		public function VendueData(){
		}
		
		public function get remianTime():int{
			return ptime - (getTimer() - tick)/1000;
		}
		
		public function loadData_I(obj:Object):void{
			tick = getTimer();
			pstatus = obj.pst;
			pid = obj.pmid;
			ptime = obj.stime;
			cprice = obj.cprice;
			cname = obj.cname;
			bprice = obj.mprice;
		}
		
		public function loadData_F(obj:Object):void{
			var list:Array = obj.comlist;
			var l:int = list.length;
			comeList.length = l;
			for(var n:int = 0; n < l; n++){
				var item:VendueNextData = comeList[n];
				if(null == item){
					item = new VendueNextData();
					comeList[n] = item;
				}
				item.unserialize(list[n]);
			}
		}

		public function loadData_L(obj:Object):void{
			var list:Array = obj.history;
			var l:int = list.length;
			historyList.length = l;
			for(var n:int = 0; n < l; n++){
				var item:VendueHistoryData = historyList[n];
				if(null == item){
					item = new VendueHistoryData();
					historyList[n] = item;
				}
				item.unserialize(list[n]);
			}
		}
		
		public function getNextCount():int{
			return comeList.length;
		}
		
		public function getNextItem(index:int):VendueNextData{
			if(index >= 0 && index < comeList.length){
				return comeList[index];
			}
			return null;
		}
		
		public function getLogCount():int{
			return historyList.length;
		}
		
		public function getLogItem(index:int):VendueHistoryData{
			if(index >= 0 && index < historyList.length){
				return historyList[index];
			}
			return null;
		}
	}
}
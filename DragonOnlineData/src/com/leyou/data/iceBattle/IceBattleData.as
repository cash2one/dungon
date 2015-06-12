package com.leyou.data.iceBattle
{
	import com.leyou.data.iceBattle.children.BattleHistoryData;
	import com.leyou.data.iceBattle.children.IceBattlePalyerData;
	
	import flash.utils.getTimer;

	public class IceBattleData
	{
		// 历史排名奖励
		private var historyList:Vector.<IceBattlePalyerData> = new Vector.<IceBattlePalyerData>();
		
		// 追踪排名
		private var trackList:Vector.<IceBattlePalyerData> = new Vector.<IceBattlePalyerData>();
		
		// 阵营1
		private var iceList:Vector.<IceBattlePalyerData> = new Vector.<IceBattlePalyerData>();
		
		// 阵营2
		private var fireList:Vector.<IceBattlePalyerData> = new Vector.<IceBattlePalyerData>();
		
		// 历史记录
		private var logHistoryList:Vector.<BattleHistoryData> = new Vector.<BattleHistoryData>();
		
		// 记录历史
		public var htype:int;
		
		// 单场剩余时间
		private var dtime:int;
		
		// 活动剩余时间
		private var stime:int;
		
		public var honour:int;
		
		public var srank:int;
		
		public var credit:int;
		
		public var exchange:int;// 1--交换前 2--交换后
		
		private var tick:uint;
		
		public var selfData:IceBattlePalyerData = new IceBattlePalyerData();
		
		public var jf:String;
		
		public var kill:String;
		
		public var ass:String;
		
		public function IceBattleData(){
		}
		
		public function getIceCL():int{
			return iceList.length;
		}
		
		public function getFireCL():int{
			return fireList.length;
		}
		
		public function getIcePlayerData(index:int):IceBattlePalyerData{
			if((index >= 0) && (index < iceList.length)){
				return iceList[index];
			}
			return null;
		}
		
		public function getFirePlayerData(index:int):IceBattlePalyerData{
			if((index >= 0) && (index < fireList.length)){
				return fireList[index];
			}
			return null;
		}
		
		public function loadData_C(obj:Object):void{
			var blist:Array = obj.blist;
			var rlist:Array = obj.rlist;
			exchange = obj.st;
			var bl:int = blist.length;
			var rl:int = rlist.length;
			iceList.length = bl;
			for(var n:int = 0; n < bl; n++){
				var iceData:IceBattlePalyerData = iceList[n];
				if(null == iceData){
					iceData = new IceBattlePalyerData();
					iceList[n] = iceData;
				}
				iceData.unserailize(blist[n]);
			}
			fireList.length = rl;
			for(var m:int = 0; m < rl; m++){
				var fireData:IceBattlePalyerData = fireList[m];
				if(null == fireData){
					fireData = new IceBattlePalyerData();
					fireList[m] = fireData;
				}
				fireData.unserailize(rlist[m]);
			}
		}
		
		public function getHistoryCL():int{
			return historyList.length;
		}
		
		public function getHistoryData(index:int):IceBattlePalyerData{
			if((index >= 0) && (index < historyList.length)){
				return historyList[index];
			}
			return null;
		}
		
		public function loadData_L(obj:Object):void{
			var ulist:Array = obj.ulist;
			var ul:int = ulist.length;
			historyList.length = ul;
			for(var n:int = 0; n < ul; n++){
				var palyerData:IceBattlePalyerData = historyList[n];
				if(null == palyerData){
					palyerData = new IceBattlePalyerData();
					historyList[n] = palyerData;
				}
				palyerData.unserailize(ulist[n]);
			}
		}
		
		public function loadData_N(obj:Object):void{
			honour = obj.honour;
			srank = obj.u_rank;
			credit = obj.jf;
		}
		
		public function loadData_I(obj:Object):void{
			jf = obj.jf;
			kill = obj.kill;
			ass = obj.ass;
		}
		
		public function getLogCount():int{
			return logHistoryList.length;
		}
		
		public function getLogData(index:int):BattleHistoryData{
			return logHistoryList[index];
		}
		
		public function loadData_H(obj:Object):void{
			htype = obj.ltype;
			var logArr:Array = obj.log;
			var l:int = logArr.length;
			logHistoryList.length = l;
			for(var n:int = 0; n < l; n++){
				var data:Array = logArr[n];
				var logData:BattleHistoryData = logHistoryList[n];
				if(null == logData){
					logData = new BattleHistoryData();
					logHistoryList[n] = logData;
				}
				logData.unserialize(data);
			}
		}
		
		public function getTrackData(index:int):IceBattlePalyerData{
			if((index >= 0) && (index < trackList.length)){
				return trackList[index];
			}
			return null;
		}
		
		public function getSRT():int{
			return (dtime - (getTimer() - tick)/1000)
		}
		
		public function getWRT():int{
			return (stime - (getTimer() - tick)/1000);
		}
		
		public function loadData_U(obj:Object):void{
			tick = getTimer();
			dtime = obj.dtime;
			stime = obj.stime;
			var ulist:Array = obj.ulist;
			selfData.unserailize(ulist.shift());
			var ul:int = ulist.length;
			trackList.length = ul;
			for(var n:int = 0; n < ul; n++){
				var palyerData:IceBattlePalyerData = trackList[n];
				if(null == palyerData){
					palyerData = new IceBattlePalyerData();
					trackList[n] = palyerData;
				}
				palyerData.unserailize(ulist[n]);
			}
		}
		
		public function creatData1():void{
			exchange = 1;
			for(var n:int = 0; n < 10; n++){
				iceList[n] = new IceBattlePalyerData();
				iceList[n].name = "camp1-"+n;
				
				fireList[n] = new IceBattlePalyerData();
				fireList[n].name = "camp2-"+n;
			}
		}
		
		
		public function creatData2():void{
			exchange = 2;
			var exData:IceBattlePalyerData = iceList[n];
			for(var n:int = 0; n < 10; n++){
				if(n == 9){
					iceList[0] = exData;
					break;
				}
				var tmpData:IceBattlePalyerData;
				if((n&1) == 0){
					// 偶数
					tmpData = fireList[n+1];
					fireList[n+1] = exData;
					exData = tmpData;
				}else{
					// 奇数
					tmpData = iceList[n+1];
					iceList[n+1] = exData;
					exData = tmpData;
				}
			}
		}
	}
}
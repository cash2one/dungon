package com.leyou.data.payrank
{
	public class PayRankData
	{
		public static const RANK_MAX_NUM:int = 10;
		
		private var rankData:Vector.<PayRankChildData> = new Vector.<PayRankChildData>();
		
		public var myRankV:int;
		
		public var myVar:int;
		
		public var remainT:int;
		
		public var pageCount:int;
		
		public function PayRankData(){
		}
		
		public function loadData_I(obj:Object):void{
			var myData:Array = obj.rankl.shift();
			myRankV = myData[0];
			myVar = myData[2];
			remainT = obj.stime;
			pageCount = Math.ceil(obj.znum/RANK_MAX_NUM);
			var rcd:PayRankChildData = getRankData(obj.rtype);
			rcd.updateInfo(obj.rankl);
		}
		
		public function getRankData(type:int):PayRankChildData{
			var rd:PayRankChildData;
			for each(rd in rankData){
				if((null != rd) && (rd.type == type)){
					return rd;
				}
			}
			rd = new PayRankChildData();
			rd.type = type;
			rankData.push(rd);
			return rd;
		}
	}
}
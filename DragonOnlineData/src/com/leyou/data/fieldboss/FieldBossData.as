package com.leyou.data.fieldboss
{
	import com.ace.manager.SOLManager;

	public class FieldBossData
	{
		// 伤害排名
		public var myRank:int;
		
		// 我的伤害
		public var myDamage:int;
		
		// 伤害对应的BOSS
		public var damBossId:int;
		
		private var rankList:Vector.<FBRankInfo> = new Vector.<FBRankInfo>();
		
		private var bossList:Vector.<FieldBossInfo> = new Vector.<FieldBossInfo>();
		
		private var lowBossList:Vector.<FieldBossInfo> = new Vector.<FieldBossInfo>();
		
		private var remindDic:Object;
		
		public function FieldBossData(){
			loadCookieData();
		}
		
//		public function get rankCount():void{
//			return rankList.length;
//		}
		
		public function getRankInfo(index:int):FBRankInfo{
			if(index < rankList.length){
				return rankList[index];
			}
			return null;
		}
		
		public function getBossCount():int{
			return bossList.length;
		}
		
		public function getBossInfo(id:int):FieldBossInfo{
			for each(var boss:FieldBossInfo in bossList){
				if((null != boss) && (boss.bossId == id)){
					return boss;
				}
			}
			return null;
		}
		
		public function getBossInfoByIdx(index:int):FieldBossInfo{
			if(index >= 0 && index < bossList.length){
				return bossList[index];
			}
			return null;
		}
		
		public function getLowBossInfoByID(id:int):FieldBossInfo{
			for each(var boss:FieldBossInfo in lowBossList){
				if((null != boss) && (boss.bossId == id)){
					return boss;
				}
			}
			return null;
		}
		
		public function getLowBossInfo(index:int):FieldBossInfo{
			return lowBossList[index];
		}
		
		private function loadCookieData():void{
			remindDic = SOLManager.getInstance().readCookie("field.boss");
			if(null == remindDic){
				remindDic = new Object();
			}
		}
		
		private function saveCookieData():void{
			if(null == remindDic) return;
			SOLManager.getInstance().saveCookie("field.boss", remindDic);
		}
		
		public function setRemind(bossId:int):void{
			if(null == remindDic) return;
			remindDic["remindId"] = bossId;
			saveCookieData();
		}
		
		public function getRemindId():int{
			if(null == remindDic) return -1;
			return remindDic["remindId"];
		}
		
		public function loadData_I(obj:Object):void{
			var bList:Array = obj.yblist;
			var bl:int = bList.length;
			bossList.length = bl;
			for(var n:int = 0; n < bl; n++){
				var bInfo:FieldBossInfo = bossList[n];
				if(null == bInfo){
					bInfo = new FieldBossInfo();
					bossList[n] = bInfo;
				}
				bInfo.unserialize(bList[n]);
			}
		}
		
		public function loadData_R(obj:Object):void{
			damBossId = obj.ybid;
			myRank = obj.myrank;
			myDamage = obj.mydamage;
			var rankL:Array = obj.rankl;
			var rl:int = rankL.length;
			rankList.length = rl;
			for(var n:int = 0; n < rl; n++){
				var rInfo:FBRankInfo = rankList[n];
				if(null == rInfo){
					rInfo = new FBRankInfo();
					rankList[n] = rInfo;
				}
				rInfo.rank = n + 1;
				rInfo.unserialize(rankL[n]);
			}
		}
		
		public function loadData_L(obj:Object):void{
			var bList:Array = obj.yblist;
			var bl:int = bList.length;
			lowBossList.length = bl;
			for(var n:int = 0; n < bl; n++){
				var bInfo:FieldBossInfo = lowBossList[n];
				if(null == bInfo){
					bInfo = new FieldBossInfo();
					lowBossList[n] = bInfo;
				}
				bInfo.bossId = bList[n][0];
				bInfo.status = bList[n][1];
			}
			lowBossList.sort(compare);
		}
		
		private function compare(p1:FieldBossInfo, p2:FieldBossInfo):int{
			if(p1.bossId > p2.bossId){
				return 1;
			}else if(p1.bossId < p2.bossId){
				return -1;
			}
			return 0;
		}
	}
}
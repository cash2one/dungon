package com.leyou.data.invest
{
	public class InvestData
	{
		// 投资理财类型
		public var type:int;
		
		// 领取状态
		public var status:int;
		
		// 剩余领取天数
		public var remainDay:int;
		
		// 绑定元宝数量
		public var byb:int;
		
		// 奖励列表
		private var _rewardList:Vector.<InvestRewardInfo> = new Vector.<InvestRewardInfo>();
		
		// 是否已购买基金
		public var fundStatus:int;

		// 是否可领奖
		public var rStatus:int;
		
		// 已领取奖励
		public var receiveList:Array;
		
		public function InvestData(){
		}
		
		public function getRewardCount():int{
			return _rewardList.length;
		}
		
		public function getReward(index:int):InvestRewardInfo{
			return _rewardList[index];
		}

		public function loadData_I(obj:Object):void{
			type = obj.ltype;
			status = obj.jlst;
			remainDay = obj.sday;
			byb = obj.byb;
		}
		
		public function loadData_L(obj:Object):void{
			var list:Array = obj.list;
			var length:int = list.length;
			_rewardList.length = length;
			for(var n:int = 0; n < length; n++){
				var rewardInfo:InvestRewardInfo = _rewardList[n];
				if(null == rewardInfo){
					rewardInfo = new InvestRewardInfo();
					_rewardList[n] = rewardInfo;
				}
				rewardInfo.updateInfo(list[n]);
			}
		}
		
		public function loadData_C(obj:Object):void{
			fundStatus = obj.cst;
			receiveList = obj.jlist.concat();
			rStatus = obj.st;
		}
	}
}
package com.leyou.data.vip
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TVIPInfo;

	public class VipData
	{
		// 已充值
		public var cnum:int;
		
		public var vipLv:int;
		
		// 各等级VIP奖励是否已领取 1 -- 已领取 0 -- 未领取
		public var status:Array;
		
		public function unserialize(obj:Object):void{
			cnum = obj.cnum;
			vipLv = obj.vlv;
			if(null == status){
				status = [];
			}
			status.length = 0;
			status = status.concat(obj.jlst);
		}
		
		public function taskPrivilegeVipLv():int{
			var tvipInfo:TVIPInfo = TableManager.getInstance().getVipInfo(23);
			for(var n:int = 0; n < 11; n++){
				var value:int = tvipInfo.getVipValue(n);
				if(value > 0){
					return n;
				}
			}
			return -1;
		}
		
		public function elementPrivilegeVipLv():Array{
			var tvipInfo:TVIPInfo = TableManager.getInstance().getVipInfo(8);
			var num:int = 0;
			var arr:Array = [];
			for(var n:int = 0; n < 11; n++){
				var value:int = tvipInfo.getVipValue(n);
				if(num != value){
					arr.push(n);
					num = value;
				}
			}
			return arr;
		}
		
		public function doubleExpVipLv():int{
			var tvipInfo:TVIPInfo = TableManager.getInstance().getVipInfo(14);
			for(var n:int = 0; n < 11; n++){
				var value:int = tvipInfo.getVipValue(n);
				if(value > 0){
					return n;
				}
			}
			return -1;
		}
		
		public function threeflodExpVipLv():int{
			var tvipInfo:TVIPInfo = TableManager.getInstance().getVipInfo(22);
			for(var n:int = 0; n < 11; n++){
				var value:int = tvipInfo.getVipValue(n);
				if(value > 0){
					return n;
				}
			}
			return -1;
		}
		
		public function getSignCount(lv:int):int{
			var tvipInfo:TVIPInfo = TableManager.getInstance().getVipInfo(6);
			return tvipInfo.getVipValue(lv);
		}
		
		public function getCopyVipLv():int{
			var tvipInfo:TVIPInfo = TableManager.getInstance().getVipInfo(20);
			for(var n:int = 0; n < 11; n++){
				var value:int = tvipInfo.getVipValue(n);
				if(value > 0){
					return n;
				}
			}
			return -1;
		}
	}
}
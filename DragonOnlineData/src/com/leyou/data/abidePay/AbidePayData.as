package com.leyou.data.abidePay
{
	

	public class AbidePayData
	{
		// 活动状态
		public var act:Boolean;
		
		// 开启时间
		public var stime:int;
		
		// 结束时间
		public var etime:int;
		
		// 今日已充值
		public var cpayValue:int;
		
		// 累计充值已领取的充值类型
		public var receiveTypeArr:Array;
		
		// 连续充值的天数
		public var payDayArr:Array;
		
		// 连续充值已领取的奖励
		public var receiveDayArr:Array;
		
		public function AbidePayData(){
		}
		
		public function loadData_I(obj:Object):void{
			act = (1 == obj.act);
			if(!act){
				return;
			}
			stime = obj.stime;
			etime = obj.etime;
			cpayValue = obj.cz;
			receiveTypeArr = obj.lcz.concat();
			payDayArr = obj.cczday.concat();
			receiveDayArr = obj.cczjl.concat();
		}
		
		public function getAbideDay(type:int):int{
			if(null == payDayArr) return 0;
			for each(var data:Array in payDayArr){
				if(data[0] == type){
					return data[1];
				}
			}
			return 0;
		}
		
		public function isEnable($day:int, $type:int):Boolean{
			if(null == receiveDayArr) return true;
			for each(var data:Array in receiveDayArr){
				if(data[0] == $day){
					return false;
				}
			}
			return true;
		}
		
		public function isReceive($day:int, $type:int):Boolean{
			if(null == receiveDayArr) return false;
			for each(var data:Array in receiveDayArr){
				if((data[0] == $day) && (data[1] == $type)){
					return true;
				}
			}
			return false;
		}
	}
}
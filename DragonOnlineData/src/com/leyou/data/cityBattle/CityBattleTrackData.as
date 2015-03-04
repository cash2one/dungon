package com.leyou.data.cityBattle
{
	import flash.utils.getTimer;

	public class CityBattleTrackData
	{
		public var stime:int;
		
		public var exp:int;
		
		public var energy:int;
		
		public var honour:int;
		
		public var name:String;
		
		public var ctime:int;
		
		public var openTime:int;
		
		private var tick:uint;
		
		public var tx:int;
		
		public var ty:int;
		
		public var stag:uint;
		
		public var guildName:String;
		
		public function CityBattleTrackData(){
		}
		
		public function unserialize(obj:Object):void{
			tick = getTimer();
			stime = obj.stime;
			exp = obj.exp;
			energy = obj.energy;
			honour = obj.honour;
			name = obj.name;
			ctime = obj.ctime;
			openTime = obj.opentime;
			tx = obj.x;
			ty = obj.y;
			stag = obj.stag;
			guildName = obj.uname;
		}
		
		// 活动剩余时间
		public function getRemainTime():int{
			return (stime - (getTimer() - tick)/1000); 
		}
		
		// 开始剩余时间
		public function getRemainOpenTime():int{
			return (openTime - (getTimer() - tick)/1000); 
		}
		
		// 已持有时间
		public function getHoldTime():int{
			if((null != name) && ("" != name)){
				return (ctime + (getTimer() - tick)/1000); 
			}
			return 0;
		}
	}
}
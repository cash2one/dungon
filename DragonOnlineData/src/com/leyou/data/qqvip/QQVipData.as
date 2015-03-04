package com.leyou.data.qqvip
{
	public class QQVipData
	{
		public var vipType:int;
		
		public var vipLevel:int;
		
		public var nStatus:int;
		
		public var dStatus:int;
		
		public var ydStatus:int;
		
		public var lvStatus:Object = {};
		
		public var actSt:int;
		
		public function QQVipData(){
		}
		
		public function loadData_N(obj:Object):void{
			nStatus = obj.st;
			vipType = obj.tve;
			vipLevel = obj.tvl;
		}
		
		public function loadData_L(obj:Object):void{
			vipType = obj.tve;
			vipLevel = obj.tvl;
			var ulist:Array = obj.ulist;
			var l:int = ulist.length;
			for(var n:int = 0; n < l; n++){
				var lvData:Array = ulist[n];
				lvStatus[lvData[0]] = lvData[1];
			}
		}
		
		public function loadData_D(obj:Object):void{
			dStatus = obj.st;
			vipType = obj.tve;
			vipLevel = obj.tvl;
			ydStatus = obj.yst;
		}
		
		public function getLvStatus(lv:int):int{
			return lvStatus[lv];
		}
	}
}
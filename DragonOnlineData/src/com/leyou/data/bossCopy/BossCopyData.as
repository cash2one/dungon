package com.leyou.data.bossCopy
{
	public class BossCopyData
	{
		private var bossList:Vector.<BossCopyBossData> = new Vector.<BossCopyBossData>();
		
		public var costyb:int;
		
		public var costbyb:int;
		
		public var remainCount:int;
		
		public function BossCopyData(){
		}
		
		public function getCount():int{
			return bossList.length;
		}
		
		public function loadData_I(obj:Object):void{
			var bl:Array = obj.cl;
			var length:int = bl.length;
			bossList.length = length;
			for(var n:int = 0; n < length; n++){
				var bossData:BossCopyBossData = bossList[n];
				if(null == bossData){
					bossData = new BossCopyBossData();
					bossList[n] = bossData;
				}
				bossData.unserialize(bl[n]);
			}
		}
		
		public function getBossData(index:int):BossCopyBossData{
			if(index >= 0 && index < bossList.length){
				return bossList[index];
			}
			return null;
		}
		
		public function loadData_A(obj:Object):void{
			costyb = obj.cyb;
			costbyb = obj.cbyb;
			remainCount = obj.cc;
		}
	}
}
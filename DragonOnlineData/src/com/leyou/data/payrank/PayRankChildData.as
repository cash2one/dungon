package com.leyou.data.payrank
{
	
	public class PayRankChildData
	{
		public var type:int;
		
		private var items:Vector.<PayRankChildItem> = new Vector.<PayRankChildItem>(PayRankData.RANK_MAX_NUM);
		
		private var _count:int;
		
		public function PayRankChildData(){
		}
		
		public function get count():int{
			return _count;
		}
		
		public function getData(index:int):PayRankChildItem{
			items[index].type = type;
			return items[index];
		}

		public function updateInfo(na:Array):void{
			_count = na.length;
			var length:int = PayRankData.RANK_MAX_NUM;
			for(var n:int = 0; n < length; n++){
				if(n >= na.length){
					break;
				}
				var data:PayRankChildItem = items[n];
				if(null == data){
					data = new PayRankChildItem();
					items[n] = data;
				}
				data.updateInfo(na[n]);
			}
		}
	}
}
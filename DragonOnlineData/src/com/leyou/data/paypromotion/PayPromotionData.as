package com.leyou.data.paypromotion
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TPayPromotion;

	public class PayPromotionData
	{
		private var payInfo:Vector.<PayPromotionItem> = new Vector.<PayPromotionItem>();
		
		private var rideInfo:Vector.<PayPromotionItem> = new Vector.<PayPromotionItem>();
		
		private var wingInfo:Vector.<PayPromotionItem> = new Vector.<PayPromotionItem>();
		
		public function PayPromotionData(){
		}
		
		public function getMinPV():int{
			var min:int = int.MAX_VALUE;
			var l:int = payInfo.length;
			for(var n:int = 0; n < l; n++){
				var info:PayPromotionItem = payInfo[n];
				var tinfo:TPayPromotion = TableManager.getInstance().getPayPromotion(info.id);
				var v:int = tinfo.value - info.dc;
				if((v > 0) && (v < min) && info.hasChance()){
					min = tinfo.value - info.dc;
				}
			}
			if(min == int.MAX_VALUE){
				return -1;
			}
			return min;
		}
		
		public function getMinRV():int{
			var min:int = int.MAX_VALUE;
			var l:int = rideInfo.length;
			for(var n:int = 0; n < l; n++){
				var info:PayPromotionItem = rideInfo[n];
				if(info.dc < min){
					min = info.dc;
				}
			}
			if(min < 5){
				return 5;
			}
			return min+1;
		}
		
		public function getMinWV():int{
			var min:int = int.MAX_VALUE;
			var l:int = wingInfo.length;
			for(var n:int = 0; n < l; n++){
				var info:PayPromotionItem = wingInfo[n];
				if(info.dc < min){
					min = info.dc;
				}
			}
			if(min < 4){
				return 4;
			}
			return min+1;
		}
		
		public function getRewardCount():int{
			var sumCount:int = 0;
			var l:int = payInfo.length;
			for(var n:int = 0; n < l; n++){
				if(1 == payInfo[n].status){
					sumCount++;
				}
			}
			l = rideInfo.length;
			for(var m:int = 0; m < l; m++){
				if(1 == rideInfo[m].status){
					sumCount++;
				}
			}
			l = wingInfo.length;
			for(var k:int = 0; k < l; k++){
				if(1 == wingInfo[k].status){
					sumCount++;
				}
			}
			return sumCount;
		}
		
		public function getInfoLength(type:int):int{
			var infoArr:Vector.<PayPromotionItem>;
			if(1 == type){
				infoArr = payInfo;
			}else if(2 == type){
				infoArr = rideInfo;
			}else if(3 == type){
				infoArr = wingInfo;
			}
			if(null != infoArr){
				return infoArr.length;
			}
			return 0;
		}
		
		public function getInfo(type:int, index:int):PayPromotionItem{
			var infoArr:Vector.<PayPromotionItem>;
			if(1 == type){
				infoArr = payInfo;
			}else if(2 == type){
				infoArr = rideInfo;
			}else if(3 == type){
				infoArr = wingInfo;
			}
			if((null != infoArr) && (index >= 0) && (index < infoArr.length)){
				return infoArr[index];
			}
			return null;
		}
		
		public function loadData_I(obj:Object):void{
			var type:int = 1;
			var data:Array = obj[type];
			if(null != data){
				var length:int = data.length;
				payInfo.length = length;
				for(var n:int = 0; n < length; n++){
					var info:PayPromotionItem = payInfo[n];
					if(null == info){
						info = new PayPromotionItem();
						payInfo[n] = info;
						info.type = type;
					}
					info.updateInfo(data[n]);
				}
			}
			type = 2;
			data = obj[type];
			if(null != data){
				length = data.length;
				rideInfo.length = length;
				for(var m:int = 0; m < length; m++){
					var rinfo:PayPromotionItem = rideInfo[m];
					if(null == rinfo){
						rinfo = new PayPromotionItem();
						rideInfo[m] = rinfo;
						rinfo.type = type;
					}
					rinfo.updateInfo(data[m]);
				}
			}
			type = 3;
			data = obj[type];
			if(null != data){
				length = data.length;
				wingInfo.length = length;
				for(var k:int = 0; k < length; k++){
					var winfo:PayPromotionItem = wingInfo[k];
					if(null == winfo){
						winfo = new PayPromotionItem();
						wingInfo[k] = winfo;
						winfo.type = type;
					}
					winfo.updateInfo(data[k]);
				}
			}
		}
		
		public function loadData_J(obj:Object):void{
			var type:int = obj.retype;
			var data:Array = obj.update;
			var infoArr:Vector.<PayPromotionItem>;
			if(1 == type){
				infoArr = payInfo;
			}else if(2 == type){
				infoArr = rideInfo;
			}else if(3 == type){
				infoArr = wingInfo;
			}
			if(null != infoArr){
				for each(var item:PayPromotionItem in infoArr){
					if((null != item) && (data[0] == item.id)){
						item.updateInfo(data);
						break;
					}
				}
			}
		}
	}
}
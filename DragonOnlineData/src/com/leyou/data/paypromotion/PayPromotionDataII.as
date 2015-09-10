package com.leyou.data.paypromotion
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TPayPromotion;
	import com.leyou.util.DateUtil;

	public class PayPromotionDataII
	{
		public var dataDic:Object = {};
		
		// 抽奖数据
		public var lotteryData1:Array;
		public var lotteryData2:Array;
		
		// 称号状态
		public var title1Status:int;
		public var title2Status:int;
		public var title3Status:int;
		public var title4Status:int;

		private var serverTick:Number;
		
		public function PayPromotionDataII(){
		}
		
		// 检查预告
		public function checkForecast():void{
			var promotionDic:Object = TableManager.getInstance().getPromotionDic();
			for(var key:String in promotionDic){
				var vnInfo:TPayPromotion = promotionDic[key];
				var bdate:Date = new Date();
				var sdate:Date = new Date();
				var edate:Date = new Date();
				bdate.time = Date.parse(DateUtil.convertDateStr(vnInfo.rp_time));
				sdate.time = Date.parse(DateUtil.convertDateStr(vnInfo.start_time));
				if(bdate.time == sdate.time) continue;
				edate.time = Date.parse(DateUtil.convertDateStr(vnInfo.end_time));
				if(serverTick > bdate.time && serverTick < edate.time){
					var itemVec:Vector.<PayPromotionItem> = dataDic[vnInfo.type];
					if(null == itemVec){
						itemVec = new Vector.<PayPromotionItem>();
						dataDic[vnInfo.type] = itemVec;
					}
					var vitem:PayPromotionItem = getInfoById(vnInfo.type, vnInfo.id);
					if(null != vitem){
						continue;
					}else{
						itemVec.push(vitem);
						vitem.id = vnInfo.id;
						vitem.hasBegin = false;
						vitem.type = vnInfo.type;
					}
				}
			}
		}
		
		public function getMinV(type:int):int{
			var infoArr:Vector.<PayPromotionItem> = dataDic[type];
			var min:int = int.MAX_VALUE;
			var l:int = infoArr.length;
			for(var n:int = 0; n < l; n++){
				var info:PayPromotionItem = infoArr[n];
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
		
		public function getRewardCount():int{
			var sumCount:int = 0;
		    for each(var infoArr:Vector.<PayPromotionItem> in dataDic){
				var l:int = infoArr.length;
				for(var n:int = 0; n < l; n++){
					var info:TPayPromotion = TableManager.getInstance().getPayPromotion(infoArr[n].id);
					if(2 == info.showType) continue;
					if(1 == infoArr[n].status){
						sumCount++;
					}
				}
			}
			return sumCount;
		}
		
		public function getInfoLength(type:int):int{
			var infoArr:Vector.<PayPromotionItem> = dataDic[type];
			if(null != infoArr){
				return infoArr.length;
			}
			return 0;
		}
		
		public function getInfo(type:int, index:int):PayPromotionItem{
			var infoArr:Vector.<PayPromotionItem> = dataDic[type];
			if((null != infoArr) && (index >= 0) && (index < infoArr.length)){
				return infoArr[index];
			}
			return null;
		}
		
		public function getInfoById(type:int, id:int):PayPromotionItem{
			var infoArr:Vector.<PayPromotionItem> = dataDic[type];
			for each(var item:PayPromotionItem in infoArr){
				if(item.id == id){
					return item;
				}
			}
			return null;
		}
		
		// 加载数据
		public function loadData_I(obj:Object):void{
			// 加载新数据
			for(var key:String in obj){
				var data:Array = obj[key] as Array;
				if(null == data) continue;
				if(int(key) == 6){
					var arr:Array = data[0][5];
					lotteryData1 = arr[0].concat();
					lotteryData2 = arr[1].concat();
					title1Status = arr[2];
					title2Status = arr[3];
					title3Status = arr[4];
					title4Status = arr[5];
				}else{
					var length:int = data.length;
					var itemVec:Vector.<PayPromotionItem> = dataDic[key];
					if(null == itemVec){
						itemVec = new Vector.<PayPromotionItem>();
						dataDic[key] = itemVec;
					}
					itemVec.length = length;
					for(var n:int = 0; n < length; n++){
						var Info:PayPromotionItem = itemVec[n];
						if(null == Info){
							Info = new PayPromotionItem();
							itemVec[n] = Info;
							Info.type = int(key);
						}
						Info.updateInfo(data[n]);
					}
				}
			}
			// 清除脏数据
			for(var dkey:String in dataDic){
				if(null == obj[dkey]){
					dataDic[dkey] = null;
					delete dataDic[dkey];
				}
			}
			serverTick = Number(obj.stime)*1000;
		}
		
		public function loadData_J(obj:Object):void{
			var data:Array = obj.update;
			var infoArr:Vector.<PayPromotionItem> = dataDic[obj.retype];
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
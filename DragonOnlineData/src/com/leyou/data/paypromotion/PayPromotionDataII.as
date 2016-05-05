package com.leyou.data.paypromotion {
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TPayPromotion;
	import com.ace.manager.TimeManager;
	import com.leyou.manager.TimerManager;
	import com.leyou.util.DateUtil;
	import com.leyou.utils.TimeUtil;

	public class PayPromotionDataII {
		public var dataDic:Object={};

		// 抽奖数据
		public var lotteryData1:Array;
		public var lotteryData2:Array;

		// 称号状态
		public var title1Status:int;
		public var title2Status:int;
		public var title3Status:int;
		public var title4Status:int;

		private var _serverTick:Number;

		public function PayPromotionDataII() {
		}

		// 检查预告

		public function get serverTick():Number {
			return _serverTick;
		}

		public function checkForecast():void {
			var promotionDic:Object=TableManager.getInstance().getPromotionDic();
			for (var key:String in promotionDic) {
				var vnInfo:TPayPromotion=promotionDic[key];
				var bdate:Date=new Date();
				var sdate:Date=new Date();
				var edate:Date=new Date();
				bdate.time=Date.parse(DateUtil.convertDateStr(vnInfo.rp_time));
				sdate.time=Date.parse(DateUtil.convertDateStr(vnInfo.start_time));
				if (bdate.time == sdate.time)
					continue;
				edate.time=Date.parse(DateUtil.convertDateStr(vnInfo.end_time));
				if (_serverTick > bdate.time && _serverTick < edate.time) {
					var itemVec:Vector.<PayPromotionItem>=dataDic[vnInfo.type];
					if (null == itemVec) {
						itemVec=new Vector.<PayPromotionItem>();
						dataDic[vnInfo.type]=itemVec;
					}
					var vitem:PayPromotionItem=getInfoById(vnInfo.type, vnInfo.id);
					if (null != vitem) {
						continue;
					} else {
						vitem=new PayPromotionItem();
						itemVec.push(vitem);
						vitem.id=vnInfo.id;
						vitem.hasBegin=false;
						vitem.type=vnInfo.type;
					}
				}
			}
		}

		public function getMinV(type:int):Object {

			var infoArr:Vector.<PayPromotionItem>=dataDic[type];

			if (null == infoArr)
				return -1;

			var dt:String;
			var min:int=int.MAX_VALUE;
			var l:int=infoArr.length;

			var d2:Date=new Date();
			var d:Date=new Date();
			for (var n:int=0; n < l; n++) {

				var info:PayPromotionItem=infoArr[n];
				var tinfo:TPayPromotion=TableManager.getInstance().getPayPromotion(info.id);
				var v:int=0;

				if (tinfo.value.indexOf(":") > -1) {

					d.time=(TimerManager.CurrentServerTime + TimerManager.currentTime) * 1000;
					d2.time=(TimerManager.CurrentServerTime + TimerManager.currentTime) * 1000;

					d2.hours=TimeUtil.getStringToTime(tinfo.value).hours;
					d2.minutes=TimeUtil.getStringToTime(tinfo.value).minutes;
					d2.seconds=TimeUtil.getStringToTime(tinfo.value).seconds;

					if (d < d2 && dt == null) {
						dt=tinfo.value;
					}

				} else {

					if (tinfo.type == 36) {
						if (info.status == 0 && min == int.MAX_VALUE)
							min=int(tinfo.value.split("|")[1]);
					} else if (tinfo.type == 12) {
						if (info.status == 0 && min == int.MAX_VALUE)
							min=int(tinfo.value)
					} else if (tinfo.type == 3) {
						if (info.status == 0 && min == int.MAX_VALUE)
							min=int(tinfo.value) / 10 + 1;
					} else {

						if (tinfo.value.indexOf("|") > -1) {
							v=int(tinfo.value.split("|")[1]) - info.dc;
						} else {
							v=int(tinfo.value) - info.dc;
						}

						if ((v > 0) && (v < min) && info.hasChance()) {
							min=v;
						}
					}
				}

			}

			if (min == int.MAX_VALUE && dt == null) {
				return -1;
			}

			if (dt != null)
				return dt;
			else
				return min;
		}

		public function getRewardCount():int {
			var sumCount:int=0;
			for each (var infoArr:Vector.<PayPromotionItem> in dataDic) {
				var l:int=infoArr.length;
				for (var n:int=0; n < l; n++) {
					var info:TPayPromotion=TableManager.getInstance().getPayPromotion(infoArr[n].id);
					if (2 == info.showType)
						continue;
					if (1 == infoArr[n].status) {
						sumCount++;
					}
				}
			}
			return sumCount;
		}

		public function getInfoLength(type:int):int {
			var infoArr:Vector.<PayPromotionItem>=dataDic[type];
			if (null != infoArr) {
				return infoArr.length;
			}
			return 0;
		}

		public function getInfo(type:int, index:int):PayPromotionItem {
			var infoArr:Vector.<PayPromotionItem>=dataDic[type];
			if ((null != infoArr) && (index >= 0) && (index < infoArr.length)) {
				return infoArr[index];
			}
			return null;
		}

		public function getInfoById(type:int, id:int):PayPromotionItem {
			var infoArr:Vector.<PayPromotionItem>=dataDic[type];
			for each (var item:PayPromotionItem in infoArr) {
				if (item.id == id) {
					return item;
				}
			}
			return null;
		}

		// 加载数据
		public function loadData_I(obj:Object):void {
			// 加载新数据
			for (var key:String in obj) {
				var data:Array=obj[key] as Array;
				if (null == data)
					continue;

				if (int(key) == 6) {
					var arr:Array=data[0][5];
					lotteryData1=arr[0].concat();
					lotteryData2=arr[1].concat();
					title1Status=arr[2];
					title2Status=arr[3];
					title3Status=arr[4];
					title4Status=arr[5];
				} else {
					var length:int=data.length;
					var itemVec:Vector.<PayPromotionItem>=dataDic[key];
					if (null == itemVec) {
						itemVec=new Vector.<PayPromotionItem>();
						dataDic[key]=itemVec;
					}
					itemVec.length=length;
					for (var n:int=0; n < length; n++) {
						var Info:PayPromotionItem=itemVec[n];
						if (null == Info) {
							Info=new PayPromotionItem();
							itemVec[n]=Info;
							Info.type=int(key);
						}
						Info.updateInfo(data[n]);
					}
				}
			}
			// 清除脏数据
			for (var dkey:String in dataDic) {
				if (null == obj[dkey]) {
					dataDic[dkey]=null;
					delete dataDic[dkey];
				}
			}
			_serverTick=Number(obj.stime) * 1000;
		}

		public function loadData_J(obj:Object):void {
			var data:Array=obj.update;
			var infoArr:Vector.<PayPromotionItem>=dataDic[obj.retype];
			if (null != infoArr) {
				for each (var item:PayPromotionItem in infoArr) {
					if ((null != item) && (data[0] == item.id)) {
						item.updateInfo(data);
						break;
					}
				}
			}
		}
	}
}

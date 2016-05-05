package com.leyou.data.paypromotion {
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TPayPromotion;
	import com.leyou.manager.TimerManager;
	import com.leyou.util.DateUtil;
	import com.leyou.utils.TimeUtil;

	public class PayPromotionData {
		private var payInfo:Vector.<PayPromotionItem>=new Vector.<PayPromotionItem>();

		private var rideInfo:Vector.<PayPromotionItem>=new Vector.<PayPromotionItem>();

		private var wingInfo:Vector.<PayPromotionItem>=new Vector.<PayPromotionItem>();

		private var collectionInfo:Vector.<PayPromotionItem>=new Vector.<PayPromotionItem>();

		private var boxInfo:Vector.<PayPromotionItem>=new Vector.<PayPromotionItem>();

		private var vipInfo:Vector.<PayPromotionItem>=new Vector.<PayPromotionItem>();

		private var costInfo:Vector.<PayPromotionItem>=new Vector.<PayPromotionItem>();

		private var dayGiftInfo:Vector.<PayPromotionItem>=new Vector.<PayPromotionItem>();

		public var lotteryData1:Array;
		public var lotteryData2:Array;

		public var title1Status:int;
		public var title2Status:int;
		public var title3Status:int;
		public var title4Status:int;

		public function PayPromotionData() {
		}

		public function getMinV(type:int):Object {
			var infoArr:Vector.<PayPromotionItem>;
			if (1 == type) {
				infoArr=payInfo;
			} else if (2 == type) {
				infoArr=rideInfo;
			} else if (3 == type) {
				infoArr=wingInfo;
			} else if (4 == type) {
				infoArr=collectionInfo;
			} else if (5 == type) {
				infoArr=boxInfo;
			} else if (7 == type) {
				infoArr=vipInfo;
			} else if (8 == type) {
				infoArr=costInfo;
			} else if (9 == type) {
				infoArr=dayGiftInfo;
			}

			var dt:String;
			var d:Date=new Date();
			var min:int=int.MAX_VALUE;
			var l:int=infoArr.length;
			for (var n:int=0; n < l; n++) {
				var info:PayPromotionItem=infoArr[n];
				var tinfo:TPayPromotion=TableManager.getInstance().getPayPromotion(info.id);
				var v:int=0;
				if (tinfo.value.indexOf(":") > -1) {

					d.time=(TimerManager.CurrentServerTime + TimerManager.currentTime) * 1000;
					if (d < TimeUtil.getStringToTime(tinfo.value)) {
						dt=tinfo.value;
					}

				} else {
					if (tinfo.value.indexOf("|") > -1) {
						v=int(tinfo.value.split("|")[1]) - info.dc;
					} else {
						v=int(tinfo.value) - info.dc;
					}

					if ((v > 0) && (v < min) && info.hasChance()) {
						min=v
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

		public function getMinPV():Object {


			var dt:String;
			var d:Date=new Date();
			var min:int=int.MAX_VALUE;
			var l:int=payInfo.length;
			for (var n:int=0; n < l; n++) {
				var info:PayPromotionItem=payInfo[n];
				var tinfo:TPayPromotion=TableManager.getInstance().getPayPromotion(info.id);

				var v:int=0;
				if (tinfo.value.indexOf(":") > -1) {

					d.time=(TimerManager.CurrentServerTime + TimerManager.currentTime) * 1000;
					if (d < TimeUtil.getStringToTime(tinfo.value)) {
						dt=tinfo.value;
					}

				} else {
					if (tinfo.value.indexOf("|") > -1) {
						v=int(tinfo.value.split("|")[1]) - info.dc;
					} else {
						v=int(tinfo.value) - info.dc;
					}

					if ((v > 0) && (v < min) && info.hasChance()) {
						min=v
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

		public function getMinCV():Object {


			var dt:String;
			var d:Date=new Date();
			var min:int=int.MAX_VALUE;
			var l:int=costInfo.length;
			for (var n:int=0; n < l; n++) {
				var info:PayPromotionItem=costInfo[n];
				var tinfo:TPayPromotion=TableManager.getInstance().getPayPromotion(info.id);
				var v:int=0;

				if (tinfo.value.indexOf(":") > -1) {

					d.time=(TimerManager.CurrentServerTime + TimerManager.currentTime) * 1000;
					if (d < TimeUtil.getStringToTime(tinfo.value)) {
						dt=tinfo.value;
					}

				} else {
					if (tinfo.value.indexOf("|") > -1) {
						v=int(tinfo.value.split("|")[1]) - info.dc;
					} else {
						v=int(tinfo.value) - info.dc;
					}

					if ((v > 0) && (v < min) && info.hasChance()) {
						min=v
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

		public function getMinRV():int {
			var min:int=int.MAX_VALUE;
			var l:int=rideInfo.length;
			for (var n:int=0; n < l; n++) {
				var info:PayPromotionItem=rideInfo[n];
				if (info.dc < min) {
					min=info.dc;
				}
			}
			if (min < 5) {
				return 5;
			}
			return min + 1;
		}

		public function getMinWV():int {
			var min:int=int.MAX_VALUE;
			var l:int=wingInfo.length;
			for (var n:int=0; n < l; n++) {
				var info:PayPromotionItem=wingInfo[n];
				if (info.dc < min) {
					min=info.dc;
				}
			}
			if (min < 4) {
				return 4;
			}
			return min + 1;
		}

		public function getRewardCount():int {
			var sumCount:int=0;
			var l:int=payInfo.length;
			for (var n:int=0; n < l; n++) {
				if (1 == payInfo[n].status) {
					sumCount++;
				}
			}
			l=rideInfo.length;
			for (var m:int=0; m < l; m++) {
				if (1 == rideInfo[m].status) {
					sumCount++;
				}
			}
			l=wingInfo.length;
			for (var k:int=0; k < l; k++) {
				if (1 == wingInfo[k].status) {
					sumCount++;
				}
			}
			l=costInfo.length;
			for (var h:int=0; h < l; h++) {
				if (1 == costInfo[h].status) {
					sumCount++;
				}
			}
			l=dayGiftInfo.length;
			for (var i:int=0; i < l; i++) {
				if (1 == dayGiftInfo[i].status) {
					sumCount++;
				}
			}
			return sumCount;
		}

		public function getInfoLength(type:int):int {
			var infoArr:Vector.<PayPromotionItem>;
			if (1 == type) {
				infoArr=payInfo;
			} else if (2 == type) {
				infoArr=rideInfo;
			} else if (3 == type) {
				infoArr=wingInfo;
			} else if (4 == type) {
				infoArr=collectionInfo;
			} else if (5 == type) {
				infoArr=boxInfo;
			} else if (7 == type) {
				infoArr=vipInfo;
			} else if (8 == type) {
				infoArr=costInfo;
			} else if (9 == type) {
				infoArr=dayGiftInfo;
			}
			if (null != infoArr) {
				return infoArr.length;
			}
			return 0;
		}

		public function getInfo(type:int, index:int):PayPromotionItem {
			var infoArr:Vector.<PayPromotionItem>;
			if (1 == type) {
				infoArr=payInfo;
			} else if (2 == type) {
				infoArr=rideInfo;
			} else if (3 == type) {
				infoArr=wingInfo;
			} else if (4 == type) {
				infoArr=collectionInfo;
			} else if (5 == type) {
				infoArr=boxInfo;
			} else if (7 == type) {
				infoArr=vipInfo;
			} else if (8 == type) {
				infoArr=costInfo;
			} else if (9 == type) {
				infoArr=dayGiftInfo;
			}
			if ((null != infoArr) && (index >= 0) && (index < infoArr.length)) {
				return infoArr[index];
			}
			return null;
		}

		public function loadData_I(obj:Object):void {
			clear();
			var type:int=1;
			var data:Array=obj[type];
			if (null != data) {
				var length:int=data.length;
				payInfo.length=length;
				for (var n:int=0; n < length; n++) {
					var info:PayPromotionItem=payInfo[n];
					if (null == info) {
						info=new PayPromotionItem();
						payInfo[n]=info;
						info.type=type;
					}
					info.updateInfo(data[n]);
				}
			}
			type=2;
			data=obj[type];
			if (null != data) {
				length=data.length;
				rideInfo.length=length;
				for (var m:int=0; m < length; m++) {
					var rinfo:PayPromotionItem=rideInfo[m];
					if (null == rinfo) {
						rinfo=new PayPromotionItem();
						rideInfo[m]=rinfo;
						rinfo.type=type;
					}
					rinfo.updateInfo(data[m]);
				}
			}
			type=3;
			data=obj[type];
			if (null != data) {
				length=data.length;
				wingInfo.length=length;
				for (var k:int=0; k < length; k++) {
					var winfo:PayPromotionItem=wingInfo[k];
					if (null == winfo) {
						winfo=new PayPromotionItem();
						wingInfo[k]=winfo;
						winfo.type=type;
					}
					winfo.updateInfo(data[k]);
				}
			}
			type=4;
			data=obj[type];
			if (null != data) {
				length=data.length;
				collectionInfo.length=length;
				for (var l:int=0; l < length; l++) {
					var colInfo:PayPromotionItem=collectionInfo[l];
					if (null == colInfo) {
						colInfo=new PayPromotionItem();
						collectionInfo[l]=colInfo;
						colInfo.type=type;
					}
					colInfo.updateInfo(data[l]);
				}
			}
			type=5;
			data=obj[type];
			if (null != data) {
				length=data.length;
				boxInfo.length=length;
				for (var h:int=0; h < length; h++) {
					var bInfo:PayPromotionItem=boxInfo[h];
					if (null == bInfo) {
						bInfo=new PayPromotionItem();
						boxInfo[h]=bInfo;
						bInfo.type=type;
					}
					bInfo.updateInfo(data[h]);
				}
			}
			type=6;
			data=obj[type];
			if (null != data) {
				var arr:Array=data[0][5];
				lotteryData1=arr[0].concat();
				lotteryData2=arr[1].concat();
				title1Status=arr[2];
				title2Status=arr[3];
				title3Status=arr[4];
				title4Status=arr[5];
			}
			type=7;
			data=obj[type];
			if (null != data) {
				length=data.length;
				vipInfo.length=length;
				for (var x:int=0; x < length; x++) {
					var vInfo:PayPromotionItem=vipInfo[x];
					if (null == vInfo) {
						vInfo=new PayPromotionItem();
						vipInfo[x]=vInfo;
						vInfo.type=type;
					}
					vInfo.updateInfo(data[x]);
				}
			} else {
				var serverTick:Number=Number(obj.stime) * 1000;
				var darr:Array=TableManager.getInstance().getPayPromotionByType(type);
				for each (var vnInfo:TPayPromotion in darr) {
					var bdate:Date=new Date();
					var edate:Date=new Date();
					bdate.time=Date.parse(DateUtil.convertDateStr(vnInfo.rp_time));
					edate.time=Date.parse(DateUtil.convertDateStr(vnInfo.end_time));
					if (serverTick > bdate.time && serverTick < edate.time) {
						var vitem:PayPromotionItem=new PayPromotionItem();
						vitem.id=vnInfo.id;
						vitem.hasBegin=false;
						vipInfo.push(vitem);
						vitem.type=type;
					}
				}
			}
			type=8;
			data=obj[type];
			if (null != data) {
				length=data.length;
				costInfo.length=length;
				for (var y:int=0; y < length; y++) {
					var cInfo:PayPromotionItem=costInfo[y];
					if (null == cInfo) {
						cInfo=new PayPromotionItem();
						costInfo[y]=cInfo;
						cInfo.type=type;
					}
					cInfo.updateInfo(data[y]);
				}
			}
			type=9;
			data=obj[type];
			if (null != data) {
				length=data.length;
				dayGiftInfo.length=length;
				for (var z:int=0; z < length; z++) {
					var dInfo:PayPromotionItem=dayGiftInfo[z];
					if (null == dInfo) {
						dInfo=new PayPromotionItem();
						dayGiftInfo[z]=dInfo;
						dInfo.type=type;
					}
					dInfo.updateInfo(data[z]);
				}
			}
		}

		public function hasForecast():Boolean {
			return (0 != payInfo.length) || (0 != rideInfo.length) || (0 != wingInfo.length) || (0 != collectionInfo.length) || (0 != boxInfo.length) || (0 != vipInfo.length);
		}

		private function clear():void {
			payInfo.length=0;
			rideInfo.length=0;
			wingInfo.length=0;
			collectionInfo.length=0;
			boxInfo.length=0;
			vipInfo.length=0;
			dayGiftInfo.length=0;
		}

		public function loadData_J(obj:Object):void {
			var type:int=obj.retype;
			var data:Array=obj.update;
			var infoArr:Vector.<PayPromotionItem>;
			if (1 == type) {
				infoArr=payInfo;
			} else if (2 == type) {
				infoArr=rideInfo;
			} else if (3 == type) {
				infoArr=wingInfo;
			} else if (4 == type) {
				infoArr=collectionInfo;
			} else if (5 == type) {
				infoArr=boxInfo;
			} else if (7 == type) {
				infoArr=vipInfo;
			} else if (8 == type) {
				infoArr=costInfo;
			} else if (9 == type) {
				infoArr=costInfo;
			}

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

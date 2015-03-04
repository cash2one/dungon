package com.leyou.ui.welfare.child.page
{
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.TimeManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Welfare;
	import com.leyou.ui.continuous.child.RollIcon;
	import com.leyou.util.DateUtil;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	/**
	 * 福利在线奖励分页
	 * @author wfh
	 * 
	 */	
	public class WelfareTimePage extends AutoSprite
	{
		private var expTimeLbl:Label;
		private var expLotteryBtn:NormalButton;
		private var expRollWidget:RollNumWidget;
		
		private var moneyTimeLbl:Label;
		private var moneyLotteryBtn:NormalButton;
		private var moneyRollWidget:RollNumWidget;
		
		private var energyTimeLbl:Label;
		private var energyLotteryBtn:NormalButton;
		private var energyRollWidget:RollNumWidget;
		
		private var marketTimeLbl:Label;
		private var marketLotteryBtn:NormalButton;
		private var marketGrid:RollIcon;
		
		private var onlineLabel:Label;
		private var receiveBtn:ImgButton;
		private var ybRollWidget:RollNumWidget;
		
		private var expRemain:int;
		private var moneyRemain:int;
		private var energyRemain:int;
		private var marketRemain:int;
		private var ybRemain:int;
		
		private var expTick:uint;
		private var moneyTick:uint;
		private var energyTick:uint;
		private var marketTick:uint;
		private var ybTick:uint;
		
		private var updateExp:Boolean = true;
		private var updateMoney:Boolean = true;
		private var updateEnergy:Boolean = true;
		private var updateMarket:Boolean = true;
		private var updateYb:Boolean = true;
		
		private var btnImg:Image;
		
		public function WelfareTimePage(){
			super(LibManager.getInstance().getXML("config/ui/welfare/welfareTime.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			expTimeLbl = getUIbyID("expTimeLbl") as Label;
			expLotteryBtn = getUIbyID("expLotteryBtn") as NormalButton;
			expRollWidget = new RollNumWidget();
			expRollWidget.spacing = 12;
			expRollWidget.x = 89;
			expRollWidget.y = 48;
			addChild(expRollWidget);
			expRollWidget.isPopNum = false;
			expRollWidget.alignLeft();
			expRollWidget.loadSource("ui/num/{num}_lzs.png");
			expRollWidget.setNum(999999);
			expLotteryBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			moneyTimeLbl = getUIbyID("moneyTimeLbl") as Label;
			moneyLotteryBtn = getUIbyID("moneyLotteryBtn") as NormalButton;
			moneyRollWidget = new RollNumWidget();
			moneyRollWidget.spacing = 12;
			moneyRollWidget.x = 89;
			moneyRollWidget.y = 156;
			moneyRollWidget.isPopNum = false;
			addChild(moneyRollWidget);
			moneyRollWidget.alignLeft();
			moneyRollWidget.loadSource("ui/num/{num}_lzs.png");
			moneyLotteryBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			energyTimeLbl = getUIbyID("energyTimeLbl") as Label;
			energyLotteryBtn = getUIbyID("energyLotteryBtn") as NormalButton;
			energyRollWidget = new RollNumWidget();
			energyRollWidget.spacing = 12;
			energyRollWidget.x = 89;
			energyRollWidget.y = 263;
			energyRollWidget.isPopNum = false;
			addChild(energyRollWidget);
			energyRollWidget.alignLeft();
			energyRollWidget.loadSource("ui/num/{num}_lzs.png");
			energyLotteryBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			marketTimeLbl = getUIbyID("marketTimeLbl") as Label;
			marketLotteryBtn = getUIbyID("marketLotteryBtn") as NormalButton;
			marketGrid = new RollIcon();
			marketGrid.x = 81;
			marketGrid.y = 351;
			addChild(marketGrid);
			marketGrid.setShowItem(65036);
			marketGrid.registerOverListener(onRollOver);
			marketLotteryBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			onlineLabel = getUIbyID("onlineLine") as Label;
			receiveBtn = getUIbyID("receiveBtn") as ImgButton;
			ybRollWidget = new RollNumWidget();
			ybRollWidget.x = 575;
			ybRollWidget.y = 75;
			ybRollWidget.isPopNum = false;
			addChild(ybRollWidget);
			ybRollWidget.alingRound();
			ybRollWidget.loadSource("ui/num/{num}_lz.png");
			receiveBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			btnImg = getUIbyID("btnImg") as Image;
			
		}
		
		private function onRollOver():void{
			FlyManager.getInstance().flyBags([marketGrid.showId], [marketGrid.localToGlobal(new Point(0, 0))]);
		}
		
		public function addTimer():void{
			if(!TimeManager.getInstance().hasITick(updateTime)){
				TimeManager.getInstance().addITick(1000, updateTime);
			}
			updateTime();
		}
		
		public function removeTimer():void{
			if(TimeManager.getInstance().hasITick(updateTime)){
				TimeManager.getInstance().removeITick(updateTime);
			}
		}
		
		protected function updateTime():void{
			if(updateExp){
				if("" != getTimeString(expRemain, expTick)){
					expTimeLbl.text = "保持在线" + getTimeString(expRemain, expTick) + "可抽奖";
				}else{
					expTimeLbl.text = "可抽奖";
					expLotteryBtn.setActive(true, 1, true);
					updateExp = false;
				}
			}
			if(updateMoney){
				if("" != getTimeString(moneyRemain, moneyTick)){
					moneyTimeLbl.text = "保持在线" + getTimeString(moneyRemain, moneyTick) + "可抽奖";
				}else{
					moneyTimeLbl.text = "可抽奖";
					moneyLotteryBtn.setActive(true, 1, true);
					updateMoney = false;
				}
			}
			if(updateEnergy){
				if("" != getTimeString(energyRemain, energyTick)){
					energyTimeLbl.text = "保持在线" + getTimeString(energyRemain, energyTick) + "可抽奖";
				}else{
					energyTimeLbl.text = "可抽奖";
					energyLotteryBtn.setActive(true, 1, true);
					updateEnergy = false;
				}
			}
			
			if(updateMarket){
				if("" != getTimeString(marketRemain, marketTick)){
					marketTimeLbl.text = "保持在线" + getTimeString(marketRemain, marketTick) + "可抽奖";
				}else{
					marketTimeLbl.text = "可抽奖";
					marketLotteryBtn.setActive(true, 1, true);
					updateMarket = false;
				}
			}
			if(updateYb){
				onlineLabel.text = getTimeString(ybRemain, ybTick);
				if("" == onlineLabel.text){
					receiveBtn.setActive(true, 1, true);
					btnImg.updateBmp("ui/welfare/btn_lqjl.png");
					updateYb = false;
				}
			}
		}
		
		protected function getTimeString(remain:int, tick:uint):String{
			var tt:int = remain*1000 - (getTimer() - tick);
			//			var hour:int = tt/3600;
			//			hour = (hour > 0) ? hour : 0;
			//			var minutes:int = tt/60%60;
			//			minutes = (minutes > 0) ? minutes : 0;
			//			var scends:int = tt%60;
			//			scends = (scends > 0) ? scends : 0;
			//			return StringUtil.lpad(hour+"", 2, "0") + ":" + StringUtil.lpad(minutes+"", 2, "0") + ":" + StringUtil.lpad(scends+"", 2, "0");
			if(tt < 0){
				tt = 0;
			}
			return DateUtil.formatTime(tt, 2);
		}
		
		protected function onButtonClick(event:MouseEvent):void{
			var btnName:String = event.target.name;
			switch(btnName){
				case "expLotteryBtn":
					Cmd_Welfare.cm_OL_J(1);
					break;
				case "moneyLotteryBtn":
					Cmd_Welfare.cm_OL_J(2);
					break;
				case "energyLotteryBtn":
					Cmd_Welfare.cm_OL_J(3);
					break;
				case "marketLotteryBtn":
					Cmd_Welfare.cm_OL_J(4);
					break;
				case "receiveBtn":
					Cmd_Welfare.cm_OL_J(5);
					break;
			}
			GuideManager.getInstance().rewardReducing();
		}
		
		public function setNumByType(type:int, value:int, stime:int, status:int):void{
			var receive:Boolean = (0 == status);
			var threshold:Boolean = (stime <= 0);
			var btnV:Boolean = receive && threshold;
//			trace("------------------------ type = "+type+"--btnVaild = " + btnV);
			switch(type){
				case 1:
					updateExp = receive;
					expRemain = stime;
					expTick = getTimer();
					expRollWidget.setNum(value);
					if(value <= 0){
						expRollWidget.setNum(999999);
					}
					expTimeLbl.visible = receive;
					expLotteryBtn.text = receive ? "抽奖" : "已抽奖";
					//					receive = (0 >= stime);
					expLotteryBtn.setActive(btnV, 1, true);
					break;
				case 2:
					updateMoney = receive;
					moneyRemain = stime;
					moneyTick = getTimer();
					moneyRollWidget.setNum(value)
					if(value <= 0){
						moneyRollWidget.setNum(9999);
					}
					moneyTimeLbl.visible = receive;
					moneyLotteryBtn.text = receive ? "抽奖" : "已抽奖";
					//					receive = (0 >= stime);
					moneyLotteryBtn.setActive(btnV, 1, true);
					break;
				case 3:
					updateEnergy = receive;
					energyRemain = stime;
					energyTick = getTimer();
					energyRollWidget.setNum(value);
					if(value <= 0){
						energyRollWidget.setNum(9999);
					}
					energyTimeLbl.visible = receive;
					energyLotteryBtn.text = receive ? "抽奖" : "已抽奖";
					//					receive = (0 >= stime);
					energyLotteryBtn.setActive(btnV, 1, true);
					break;
				case 4:
					updateMarket = receive;
					marketRemain = stime;
					marketTick = getTimer();
					//					marketGrid.updataById(value);
					marketTimeLbl.visible = receive;
					marketLotteryBtn.text = receive ? "抽奖" : "已抽奖";
					//					receive = (0 >= stime);
					marketLotteryBtn.setActive(btnV, 1, true);
					break;
				case 5:
					updateYb = receive;
					ybRemain = stime;
					ybTick = getTimer();
					ybRollWidget.setNum(value);
					onlineLabel.visible = receive;
					//					receive = (0 >= stime);
					receiveBtn.setActive(btnV, 1, true);
					var url:String;
					if(!receive){
						url = "ui/welfare/btn_lqjl2.png";
					}else{
						url = threshold ? "ui/welfare/btn_lqjl.png" : "ui/welfare/btn_lqjl3.png";
					}
					btnImg.updateBmp(url);
					break;
			}
		}
		
		public function updateInfo(obj:Object):void{
			for(var key:String in obj){
				var index:int = int(key);
				if(0 != index){
					setNumByType(index, obj[index][0], obj[index][1], obj[index][2]);
				}
			}
		}
		
		public function receiveReward(obj:Object):void{
			for(var key:String in obj){
				var type:int = int(key);
				if(0 == type){
					continue;
				}
				var val:int = obj[key][0];
				var stime:int = obj[key][1];
				var st:int = obj[key][2];
				var receive:Boolean = (0 == st);
				var threshold:Boolean = (stime <= 0);
				var btnV:Boolean = receive && threshold;
//				trace("------------------------ type = "+type+"--btnVaild = " + btnV);
				switch(type){
					case 1:
						updateExp = receive;
						expRemain = stime;
						expTick = getTimer();
						expRollWidget.rollToNum(val, false, 2);
//						expRollWidget.popText = "+经验"+val;
						expTimeLbl.visible = receive;
						expLotteryBtn.text = receive ? "抽奖" : "已抽奖";
						expLotteryBtn.setActive(btnV, 1, true);
						break;
					case 2:
						updateMoney = receive;
						moneyRemain = stime;
						moneyTick = getTimer();
						moneyRollWidget.rollToNum(val, false, 2);
//						moneyRollWidget.popText = "+金币"+val;
						moneyTimeLbl.visible = receive;
						moneyLotteryBtn.text = receive ? "抽奖" : "已抽奖";
						moneyLotteryBtn.setActive(btnV, 1, true);
						break;
					case 3:
						updateEnergy = receive;
						energyRemain = stime;
						energyTick = getTimer();
						energyRollWidget.rollToNum(val, false, 2);
//						energyRollWidget.popText = "+魂力"+val;
						energyTimeLbl.visible = receive;
						energyLotteryBtn.text = receive ? "抽奖" : "已抽奖";
						energyLotteryBtn.setActive(btnV, 1, true);
						break;
					case 4:
						updateMarket = receive;
						var rl:Array = ConfigEnum.MarketRewardValues.split("|");
						marketRemain = stime;
						marketTick = getTimer();
						marketGrid.loadResourceByArray(rl);
						marketGrid.rollToImg(val);
						marketTimeLbl.visible = receive;
						marketLotteryBtn.text = receive ? "抽奖" : "已抽奖";
						marketLotteryBtn.setActive(btnV, 1, true);
						break;
					case 5:
						updateMarket = receive;
						ybRemain = stime;
						ybTick = getTimer();
						ybRollWidget.rollToNum(val, false, 2);
//						ybRollWidget.popText = "+绑定钻石"+val;
						receiveBtn.setActive(receive);
						onlineLabel.visible = receive;
						receiveBtn.setActive(btnV, 1, true);
						var url:String;
						if(!receive){
							url = "ui/welfare/btn_lqjl2.png";
						}else{
							url = threshold ? "ui/welfare/btn_lqjl.png" : "ui/welfare/btn_lqjl3.png";
						}
						btnImg.updateBmp(url);
						break;
				}
			}
		}
		
		public function hasReward():Boolean{
			var receive:Boolean = expTimeLbl.visible;
			var tt:int = expRemain*1000 - (getTimer() - expTick);
			if(receive && tt <= 0){
				return true;
			}
			receive = moneyTimeLbl.visible;
			tt = moneyRemain*1000 - (getTimer() - moneyTick)
			if(receive && tt <= 0){
				return true;
			}
			receive = energyTimeLbl.visible;
			tt = energyRemain*1000 - (getTimer() - energyTick)
			if(receive && tt <= 0){
				return true;
			}
			receive = marketTimeLbl.visible;
			tt = marketRemain*1000 - (getTimer() - marketTick)
			if(receive && tt <= 0){
				return true;
			}
			receive = onlineLabel.visible;
			tt = ybRemain*1000 - (getTimer() - ybTick)
			if(receive && tt <= 0){
				return true;
			}
			return false;
		}
	}
}
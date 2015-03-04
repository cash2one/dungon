package com.leyou.ui.welfare.child.page
{
	import com.ace.config.Core;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TSignGiftInfo;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.leyou.net.cmd.Cmd_Welfare;
	import com.leyou.ui.market.child.MarketGrid;
	import com.leyou.ui.welfare.child.component.CalendarRender;
	import com.leyou.ui.welfare.child.component.WelfareLoginRender;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class WelfareLoginPage extends AutoSprite
	{
		private var calendar:CalendarRender;
		
		private var monthImg:Image;
		
		private var signedImg:Image;
		
		private var signImg:Image;
		
		private var signBtn:ImgButton;
		
		private var welfareLogin:TabBar;
		
		private var welfareRender:WelfareLoginRender;
		
		private var giftStatus:Object;
		
		private var numWidget:RollNumWidget;
		
		private var _currentIndex:int;
		
		private var day:int;
		
		// 补签消耗
		private var _bprice:int;
		private var _bc:int;
		
		public function WelfareLoginPage(){
			super(LibManager.getInstance().getXML("config/ui/welfare/welfareLogin.xml"));
			init();
		}
		
		public function get bc():int{
			return _bc;
		}

		public function get bprice():int{
			return _bprice;
		}

		private function init():void{
			mouseChildren = true;
			giftStatus = {};
			calendar = new CalendarRender();
			calendar.x = 10;
			calendar.y = 65;
			addChild(calendar);
			welfareRender = new WelfareLoginRender();
			welfareRender.x = 3;
			welfareRender.y = 271;
			addChild(welfareRender);
			numWidget = new RollNumWidget();
			numWidget.loadSource("ui/num/{num}_zdl.png");
			numWidget.alignLeft();
			numWidget.x = 612;
			numWidget.y = 6;
			addChild(numWidget);
			
			monthImg = getUIbyID("MonthImg") as Image;
			signedImg = getUIbyID("signedImg") as Image;
			signImg = getUIbyID("signImg") as Image;
			signBtn = getUIbyID("signBtn") as ImgButton;
			signBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
		}
		
		protected function onButtonClick(event:MouseEvent):void{
			var n:String = event.target.name;
			switch(n){
				case "signBtn":
					GuideManager.getInstance().removeGuide(48);
					var day:int = calendar.getDay();
					if(day > -1){
						Cmd_Welfare.cm_SIGN_S(day);
					}
					break;
			}
		}
		
		protected function onIndexChange(event:Event):void{
			if (_currentIndex == welfareLogin.turnOnIndex){
				return;
			}
			_currentIndex = welfareLogin.turnOnIndex;
			welfareRender.updateGift(giftStatus[_currentIndex][0], giftStatus[_currentIndex][1], giftStatus[_currentIndex][2], calendar.signCount);
		}
		
		public function updateInfo(obj:Object):void{
			_bprice = obj.bprice;
			_bc = obj.bc;
			var signCount:int;
			calendar.updateTimeByTick(obj.cdate*1000);
			var cDay:int = calendar.getDay();
			var signList:Array = obj.slist;
			var length:int = signList.length;
			for(var n:int = 0; n < length; n++){
				var dayData:Object = signList[n];
				calendar.setDayStatus(dayData[0], dayData[1]);
				if(1 == dayData[1]){
					signCount++;
					if(int(dayData[0]) == cDay){
						signImg.visible = false;
					}
				}else if(0 == dayData[1]){
					if(int(dayData[0]) == cDay){
						signImg.visible = true;
					}
				}
			}
			calendar.updateUI();
			_currentIndex = -1;
			var giftStatusList:Array = obj.sjl;
			length = giftStatusList.length;
			for(var m:int = 0; m < length; m++){
				var giftData:Object = giftStatusList[m];
				giftStatus[m] = [giftData[0], giftData[1], giftData[2]];
				if((1 != giftData[1]) || ((1 != giftData[2]) && (Core.me.info.vipLv > 0))){
					if(0 > _currentIndex){
						_currentIndex = m;
					}
				}
			}
			if(-1 == _currentIndex){
				_currentIndex = 0;
			}
			welfareRender.updateGift(giftStatus[_currentIndex][0], giftStatus[_currentIndex][1], giftStatus[_currentIndex][2], calendar.signCount);
			monthImg.updateBmp("ui/welfare/month_" + StringUtil_II.lpad(calendar.getMonth()+"", 2, "0") + ".png");
			numWidget.setNum(signCount);
			signedImg.visible = !signImg.visible;
			signBtn.setActive(signImg.visible, 1, true);
			if(null == welfareLogin){
				var tableNames:Array = [];
				for(var l:int = 0; l < length; l++){
					var tableData:Object = new Object();
					tableData.label = "签到" + giftStatusList[l][0] + "次";
					tableNames[l] = tableData;
				}
				welfareLogin = new TabBar(tableNames, "welfareLogin", length*82);
				welfareLogin.addEventListener(TabbarModel.changeTurnOnIndex, onIndexChange);
				addChild(welfareLogin);
				welfareLogin.x = 13;
				welfareLogin.y = 247;
			}
			welfareLogin.turnToTab(_currentIndex);
			if(!signedImg.visible){
				GuideManager.getInstance().showGuide(48, this);
			}
			//			checkGuide();
		}
		
		//		public function checkGuide():void{
		//			if(!signedImg.visible){
		//				GuideManager.getInstance().showGuide(48, signBtn);
		//			}
		//			welfareRender.checkGuide();	
		//		}
		
		public function flyItem():void{
			if(-1 != welfareRender.flySignCount){
				var arr:Array;
				for(var key:String in giftStatus){
					arr = giftStatus[key];
					if(arr[0] == welfareRender.flySignCount){
						break;
					}
				}
				var index:int = 0;
				var aids:Array = [];
				var starts:Array = [];
				var grids:Vector.<MarketGrid> = welfareRender.grids;
				var giftInfo:TSignGiftInfo = TableManager.getInstance().getSignGiftInfo(arr[0]);
				var grid:MarketGrid = grids[index];
				if(!welfareRender.isVip){
					if(giftInfo.exp > 0){
						index++;
						aids.push(65534);
						starts.push(grid.localToGlobal(new Point(0, 0)));
					}
					grid = grids[index];
					if(giftInfo.money > 0){
						index++;
						aids.push(65535);
						starts.push(grid.localToGlobal(new Point(0, 0)));
					}
					grid = grids[index];
					if(giftInfo.energy > 0){
						index++;
						aids.push(65533);
						starts.push(grid.localToGlobal(new Point(0, 0)));
					}
					grid = grids[index];
					if(giftInfo.bIb > 0){
						index++;
						aids.push(65532);
						starts.push(grid.localToGlobal(new Point(0, 0)));
					}
					grid = grids[index];
					if(giftInfo.item1 > 0){
						index++;
						aids.push(giftInfo.item1);
						starts.push(grid.localToGlobal(new Point(0, 0)));
					}
					grid = grids[index];
					if(giftInfo.item2 > 0){
						index++;
						aids.push(giftInfo.item2);
						starts.push(grid.localToGlobal(new Point(0, 0)));
					}
					if(giftInfo.item3 > 0){
						index++;
						aids.push(giftInfo.item3);
						starts.push(grid.localToGlobal(new Point(0, 0)));
					}
					grid = grids[index];
					if(giftInfo.item4 > 0){
						index++;
						aids.push(giftInfo.item4);
						starts.push(grid.localToGlobal(new Point(0, 0)));
					}
				}else{
					index = 6;
					grid = grids[index];
					if(giftInfo.vipItem1 > 0){
						index++;
						aids.push(giftInfo.vipItem1);
						starts.push(grid.localToGlobal(new Point(0, 0)));
					}
					grid = grids[index];
					if(giftInfo.vipItem2 > 0){
						index++;
						aids.push(giftInfo.vipItem2);
						starts.push(grid.localToGlobal(new Point(0, 0)));
					}
				}
				FlyManager.getInstance().flyBags(aids, starts)
			}
		}
		
		public function signed():Boolean{
			return signedImg.visible;
		}
		
		public function hasReward():Boolean{
			for(var key:String in giftStatus){
				var arr:Array = giftStatus[key];
				if((calendar.signCount >= arr[0]) && (0 == arr[1])){
					return true;
				}
			}
			return false;
		}
	}
}
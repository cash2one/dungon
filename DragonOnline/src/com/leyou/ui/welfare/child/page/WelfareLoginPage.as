package com.leyou.ui.welfare.child.page {
	import com.ace.config.Core;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TSignGiftInfo;
	import com.ace.gameData.table.TVIPInfo;
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
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class WelfareLoginPage extends AutoSprite {

		private static const REWARD_COUNT:int=7;

		private var calendar:CalendarRender;

		private var monthImg:Image;

		private var signedImg:Image;

		private var signImg:Image;

		private var signBtn:ImgButton;

		private var welfareLogin:TabBar;

		private var rewardReders:Vector.<WelfareLoginRender>;

		private var giftStatus:Array;

		private var numWidget:RollNumWidget;

		private var _currentIndex:int;

		// 补签消耗
		private var _bprice:int;

		private var _bc:int;

		private var vipReceiveBtn:ImgButton;

		private var receivedImg:Image;

		private var receiveImg:Image;

		private var vipRewardGrid:MarketGrid;

		public function WelfareLoginPage() {
			super(LibManager.getInstance().getXML("config/ui/welfare/welfareLogin.xml"));
			init();
		}

		public function get bc():int {
			return _bc;
		}

		public function get bprice():int {
			return _bprice;
		}

		private function init():void {
			mouseChildren=true;
			giftStatus=[];
			monthImg=getUIbyID("MonthImg") as Image;
			signedImg=getUIbyID("signedImg") as Image;
			signImg=getUIbyID("signImg") as Image;
			signBtn=getUIbyID("signBtn") as ImgButton;
			welfareLogin=getUIbyID("welfareLogin") as TabBar;
			vipReceiveBtn=getUIbyID("vipReceiveBtn") as ImgButton;
			receivedImg=getUIbyID("receivedImg") as Image;
			receiveImg=getUIbyID("receiveImg") as Image;
			// 日历
			calendar=new CalendarRender();
			calendar.x=28;
			calendar.y=78;
			addChild(calendar);
			// 奖励
			rewardReders=new Vector.<WelfareLoginRender>(REWARD_COUNT);
			for (var n:int=0; n < REWARD_COUNT; n++) {
				var welfareRender:WelfareLoginRender=new WelfareLoginRender();
				rewardReders[n]=welfareRender;
				welfareLogin.addToTab(welfareRender, n);
			}
			welfareLogin.addEventListener(TabbarModel.changeTurnOnIndex, onIndexChange);
			// 签到数
			numWidget=new RollNumWidget();
			numWidget.loadSource("ui/num/{num}_zdl.png");
			numWidget.alignLeft();
			numWidget.x=142;
			numWidget.y=265;
			addChild(numWidget);
			signBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			// vip奖励
			vipRewardGrid=new MarketGrid();
			vipRewardGrid.isShowPrice=false;
			vipRewardGrid.x=659 + 14;
			vipRewardGrid.y=140 + 14;
			addChild(vipRewardGrid);
			vipReceiveBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
		}

		protected function onButtonClick(event:MouseEvent):void {
			var n:String=event.target.name;
			switch (n) {
				case "signBtn":
//					GuideManager.getInstance().showGuide(49, this.vipReceiveBtn);
					var day:int=calendar.getDay();
					if (day > -1) {
						Cmd_Welfare.cm_SIGN_S(day, 0);
					}
					break;
				case "vipReceiveBtn":
					Cmd_Welfare.cm_SIGN_V();
					break;
			}
		}

		protected function onIndexChange(event:Event):void {
			if (_currentIndex == welfareLogin.turnOnIndex) {
				return;
			}
			_currentIndex=welfareLogin.turnOnIndex;


			rewardReders[_currentIndex].checkGuide();
		}

		
		public function updateInfo(obj:Object):void {
			// 日历显示
			_bprice=obj.bprice;
			_bc=obj.bc;
			var signCount:int;
			calendar.updateTimeByTick(obj.cdate * 1000);
			var cDay:int=calendar.getDay();
			var signList:Array=obj.slist;
			var length:int=signList.length;
			for (var n:int=0; n < length; n++) {
				var dayData:Object=signList[n];
				calendar.setDayStatus(dayData[0], dayData[1]);
				if (1 == dayData[1]) {
					signCount++;
					if (int(dayData[0]) == cDay) {
						signImg.visible=false;
					}
				} else if (0 == dayData[1]) {
					if (int(dayData[0]) == cDay) {
						signImg.visible=true;
					}
				}
			}

			calendar.updateUI();
			numWidget.setNum(obj.zsc);
			signedImg.visible=!signImg.visible;
			signBtn.setActive(signImg.visible, 1, true);
			signBtn.isActive ? GuideManager.getInstance().show(48) : GuideManager.getInstance().remove(48);
			monthImg.updateBmp("ui/welfare/month_" + StringUtil_II.lpad(calendar.getMonth() + "", 2, "0") + ".png");

			// 普通奖励处理
			_currentIndex=-1;
			var giftStatusList:Array=obj.sjl;
			length=giftStatusList.length;
			for (var m:int=0; m < length; m++) {
				var giftData:Object=giftStatusList[m];
				giftStatus[m]=[giftData[0], giftData[1]];
				if (1 != giftData[1]) {
					if (0 > _currentIndex) {
						_currentIndex=m;
					}
				}
			}

			if (-1 == _currentIndex) {
				_currentIndex=0;
			}

			welfareLogin.turnToTab(_currentIndex);
			for (var l:int=0; l < REWARD_COUNT; l++) {
				var rewardRender:WelfareLoginRender=rewardReders[l];
				rewardRender.updateGift(giftStatus[l][0], giftStatus[l][1], obj.zsc);
				welfareLogin.getTabButton(l).label.text=PropUtils.getStringById(1978) + giftStatusList[l][0] + PropUtils.getStringById(1977);
			}
			
			rewardReders[_currentIndex].checkGuide();
			// VIP奖励处理
			var vipInfo:TVIPInfo=TableManager.getInstance().getVipInfo(24);
			var vipLv:int=(Core.me.info.vipLv >= 2) ? Core.me.info.vipLv : 2;
			vipRewardGrid.updataById(vipInfo.getVipValue(vipLv));
			var vrStatus:Boolean=(int(obj.vjt) == 0);
			var reached:Boolean=(Core.me.info.vipLv >= 2);
			vipReceiveBtn.setActive((vrStatus && reached && signedImg.visible), 1, true);
			vipReceiveBtn.isActive ? GuideManager.getInstance().show(154) : GuideManager.getInstance().remove(154)
			if (!reached) {
				receiveImg.visible=false;
				receivedImg.updateBmp("ui/welfare/btn_lqjl3.png");
			} else {
				receivedImg.updateBmp("ui/welfare/btn_lqjl2.png");
				receiveImg.visible=vrStatus;
				receivedImg.visible=!vrStatus;
			}
		}

		public function flyItem(sign:int):void {
			if (1 == sign) {
				for (var n:int=0; n < REWARD_COUNT; n++) {
					var rewardRender:WelfareLoginRender=rewardReders[n];
					if (rewardRender.readyToFly) {
						rewardRender.flyItem();
					}
				}
			} else if (2 == sign) {
				FlyManager.getInstance().flyBags([vipRewardGrid.dataId], [vipRewardGrid.localToGlobal(new Point(0, 0))]);
			}
		}

		public function signed():Boolean {
			return signedImg.visible;
		}

		public function signdBtn():ImgButton {
			return signBtn;
		}

		public function hasReward():Boolean {
			for (var key:String in giftStatus) {
				var arr:Array=giftStatus[key];
				if ((calendar.signCount >= arr[0]) && (0 == arr[1])) {
					return true;
				}
			}
			return false;
		}

	}
}

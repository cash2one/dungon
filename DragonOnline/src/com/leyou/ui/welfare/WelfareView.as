package com.leyou.ui.welfare {
	import com.ace.enum.WindowEnum;
	import com.ace.manager.GuideArrowDirectManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.leyou.net.cmd.Cmd_Welfare;
	import com.leyou.ui.tools.child.RightTopWidget;
	import com.leyou.ui.welfare.child.page.WelfareGetBackPage;
	import com.leyou.ui.welfare.child.page.WelfareKeyPage;
	import com.leyou.ui.welfare.child.page.WelfareLoginPage;
	import com.leyou.ui.welfare.child.page.WelfareLvPage;
	import com.leyou.ui.welfare.child.page.WelfareOfflinePage;
	import com.leyou.ui.welfare.child.page.WelfareTimePage;
	import com.leyou.utils.PropUtils;

	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * 福利系统
	 * @author wfh
	 *
	 */
	public class WelfareView extends AutoWindow {
		protected var tabBar:TabBar;

		private var _currentIdx:int=-1;

		protected var welfareLogin:WelfareLoginPage;

		protected var welfareTime:WelfareTimePage;

		protected var welfareLv:WelfareLvPage;

		protected var welfareOutline:WelfareOfflinePage;

		protected var welfareGetBack:WelfareGetBackPage;

		protected var welfareKey:WelfareKeyPage;

		public var loginRequest:Boolean;

		public var lvRequest:Boolean;

		public var timeRequest:Boolean;

//		public var expRequest:Boolean;

		private var lock:Boolean;

		private var awardArr:Array=[];

		public function WelfareView() {
			super(LibManager.getInstance().getXML("config/ui/welfareWnd.xml"));
			init();
		}

		private function init():void {
			mouseChildren=true;
			tabBar=getUIbyID("welfareTabBar") as TabBar;
			tabBar.addEventListener(TabbarModel.changeTurnOnIndex, onTabBarChangeIndex);

			welfareLogin=new WelfareLoginPage();
			welfareTime=new WelfareTimePage();
			welfareLv=new WelfareLvPage();
			welfareOutline=new WelfareOfflinePage();
			welfareGetBack=new WelfareGetBackPage();
			welfareKey=new WelfareKeyPage();
			welfareLogin.x=-42;
			welfareTime.x=-42;
			welfareLv.x=-42;
			welfareOutline.x=-42;
			welfareGetBack.x=-42;
			welfareKey.x=-42;

			tabBar.addToTab(welfareLogin, 0);
			tabBar.addToTab(welfareTime, 1);
			tabBar.addToTab(welfareLv, 2);
			tabBar.addToTab(welfareOutline, 3);
			tabBar.addToTab(welfareGetBack, 4);
			tabBar.addToTab(welfareKey, 5);


			var awardIcon:RightTopWidget;

			for (var i:int=0; i < 4; i++) {

				awardIcon=new RightTopWidget();
				awardIcon.setpushContent();
				tabBar.getTabButton(i).addChild(awardIcon);
				awardIcon.x=tabBar.getTabButton(i).width - 25;

				awardIcon.setText(PropUtils.getStringById(1964));
				this.awardArr.push(awardIcon);
			}

		}

		public override function get width():Number {
			return 871;
		}

		public override function get height():Number {
			return 544;
		}

		public function changeTable(tindex:int):void {
			lock=true;
			tabBar.turnToTab(tindex);
		}
		
		public function updateAwardIcon(i:int, v:Boolean):void {
			this.awardArr[i].visible=v;
		}

		override public function getUIbyID(id:String):DisplayObject {
			var ds:DisplayObject=super.getUIbyID(id);

			if (ds == null)
				ds=welfareTime.getUIbyID(id);

			return ds;
		}

		public function getUIbyID2(id:String):DisplayObject {
			var ds:DisplayObject;

			ds=welfareLv.gethasReward().getUIbyID(id);

			return ds;
		}

		protected function onTabBarChangeIndex(event:Event):void {
			if (_currentIdx == tabBar.turnOnIndex) {
				return;
			}
			_currentIdx=tabBar.turnOnIndex;
			switch (_currentIdx) {
				case 0:
					welfareTime.removeTimer();
					Cmd_Welfare.cm_SIGN_I();
					break;
				case 1:
					welfareTime.addTimer();
					Cmd_Welfare.cm_OL_I();
					GuideManager.getInstance().removeGuide(48);
					break;
				case 2:
					welfareTime.removeTimer();
					Cmd_Welfare.cm_ULV_I();
					GuideManager.getInstance().removeGuide(48);
					break;
				case 3:
					welfareTime.removeTimer();
					Cmd_Welfare.cm_OFL_I();
					GuideManager.getInstance().removeGuide(48);
					break;
				case 4:
					welfareTime.removeTimer();
					Cmd_Welfare.cm_FBK_I();
					GuideManager.getInstance().removeGuide(48);
					break;
			}
		}

		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
			GuideManager.getInstance().removeGuide(47);
//			GuideManager.getInstance().removeGuide(50);
			GuideManager.getInstance().removeGuide(51);
			GuideManager.getInstance().removeGuide(52);
			GuideManager.getInstance().removeGuide(54);

//			GuideManager.getInstance().showGuide(48,this.welfareLogin.signdBtn());
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
//			Cmd_Welfare.cm_SIGN_I();
//			Cmd_Welfare.cm_OL_I();
//			Cmd_Welfare.cm_ULV_I();
		}

		protected function onEnterFrame(event:Event):void {
			if (loginRequest && lvRequest && timeRequest /* && expRequest*/) {
				if (!lock) {
					showRewardPage();
				}
				lock=false;
				if (hasEventListener(Event.ENTER_FRAME)) {
					removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
			}
		}

		public function showRewardPage():void {
			if (!welfareLogin.signed()) {
				tabBar.turnToTab(0);
			} else if (welfareLogin.hasReward()) {
				tabBar.turnToTab(0);
			} else if (welfareTime.hasReward()) {
				tabBar.turnToTab(1);
			} else if (welfareLv.hasReward()) {
				tabBar.turnToTab(2);
			} else if (welfareOutline.hasReward()) {
				tabBar.turnToTab(3);
			}
		}

		public override function hide():void {
			super.hide();

			GuideArrowDirectManager.getInstance().delArrow(WindowEnum.WELFARE + "");
			GuideManager.getInstance().removeGuide(48);
//			GuideManager.getInstance().removeGuide(49);
		}

//		public function startHide():void{
//			GuideManager.getInstance().removeGuide(48);
//			GuideManager.getInstance().removeGuide(49);
//		}
	}
}

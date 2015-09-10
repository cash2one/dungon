package com.leyou.ui.welfare
{
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.leyou.net.cmd.Cmd_Welfare;
	import com.leyou.ui.welfare.child.page.WelfareLoginPage;
	import com.leyou.ui.welfare.child.page.WelfareLvPage;
	import com.leyou.ui.welfare.child.page.WelfareOutlinePage;
	import com.leyou.ui.welfare.child.page.WelfareTimePage;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	/**
	 * 福利系统
	 * @author wfh
	 * 
	 */	
	public class WelfareView extends AutoWindow
	{
		protected var tabBar:TabBar;
		
		private var _currentIdx:int = -1;
		
		protected var welfareLogin:WelfareLoginPage;
		
		protected var welfareTime:WelfareTimePage;
		
		protected var welfareLv:WelfareLvPage;
		
		protected var welfareOutline:WelfareOutlinePage;
		
		public var loginRequest:Boolean;
		
		public var lvRequest:Boolean;
		
		public var timeRequest:Boolean;
		
//		public var expRequest:Boolean;
		
		private var lock:Boolean;
		
		public function WelfareView(){
			super(LibManager.getInstance().getXML("config/ui/welfareWnd.xml"));
			init();
//			opaqueBackground = 0xff;
		}
		
		private function init():void{
			hideBg();
			tabBar = getUIbyID("welfareTabBar") as TabBar;
			tabBar.addEventListener(TabbarModel.changeTurnOnIndex, onTabBarChangeIndex);
			
			welfareLogin = new WelfareLoginPage();
			welfareTime = new WelfareTimePage();
			welfareLv = new WelfareLvPage();
			welfareOutline = new WelfareOutlinePage();
			welfareLogin.x = -10;
			welfareLogin.y = 5;
			welfareTime.x = -10;
			welfareTime.y = 5;
			welfareLv.x = -10;
			welfareLv.y = 5;
			welfareOutline.x = -10;
			welfareOutline.y = 5;
			
			tabBar.addToTab(welfareLogin, 0);
			tabBar.addToTab(welfareTime, 1);
			tabBar.addToTab(welfareLv, 2);
			tabBar.addToTab(welfareOutline, 3);
//			tabBar.turnToTab(0);
			clsBtn.y += 20;
		}
		
		public override function get width():Number{
			return 737;
		}
		
		public override function get height():Number{
			return 563;
		}
		
		public function changeTable(tindex:int):void{
			lock = true;
			tabBar.turnToTab(tindex);
		}
		
		protected function onTabBarChangeIndex(event:Event):void{
			if (_currentIdx == tabBar.turnOnIndex){
				return;
			}
			_currentIdx = tabBar.turnOnIndex;
			switch(_currentIdx){
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
			}
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, toCenter);
			GuideManager.getInstance().removeGuide(47);
			GuideManager.getInstance().removeGuide(50);
			GuideManager.getInstance().removeGuide(51);
			GuideManager.getInstance().removeGuide(52);
			GuideManager.getInstance().removeGuide(54);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
//			Cmd_Welfare.cm_SIGN_I();
//			Cmd_Welfare.cm_OL_I();
//			Cmd_Welfare.cm_ULV_I();
		}
		
		protected function onEnterFrame(event:Event):void{
			if(loginRequest && lvRequest && timeRequest/* && expRequest*/){
				if(!lock){
					showRewardPage();
				}
				lock = false;
				if(hasEventListener(Event.ENTER_FRAME)){
					removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
			}
		}
		
		public function showRewardPage():void{
			if(!welfareLogin.signed()){
				tabBar.turnToTab(0);
			}else if(welfareLogin.hasReward()){
				tabBar.turnToTab(0);
			}else if(welfareTime.hasReward()){
				tabBar.turnToTab(1);
			}else if(welfareLv.hasReward()){
				tabBar.turnToTab(2);
			}else if(welfareOutline.hasReward()){
				tabBar.turnToTab(3);
			}
		}
		
		public override function hide():void{
			super.hide();
			GuideManager.getInstance().removeGuide(48);
			GuideManager.getInstance().removeGuide(49);
		}
		
//		public function startHide():void{
//			GuideManager.getInstance().removeGuide(48);
//			GuideManager.getInstance().removeGuide(49);
//		}
	}
}
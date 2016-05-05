package com.leyou.ui.qqVip
{
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.leyou.net.cmd.Cmd_QQVip;
	import com.leyou.ui.qqVip.children.QQVipDayPage;
	import com.leyou.ui.qqVip.children.QQVipLvPage;
	import com.leyou.ui.qqVip.children.QQVipNewUserPage;
	import com.leyou.ui.qqVip.children.QQVipPrivilegePage;
	import com.leyou.utils.PayUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class QQVipWnd extends AutoWindow
	{
		private var payVipBtn:ImgButton;
		
		private var payYearVipBtn:ImgButton;
		
		private var qqvipBar:TabBar;
		
		private var _currentIndex:int;
		
		private var privilegePage:QQVipPrivilegePage;
		
		private var newUserPage:QQVipNewUserPage;
		
		private var lvPage:QQVipLvPage;
		
		private var dayPage:QQVipDayPage;
		
		public function QQVipWnd(){
			super(LibManager.getInstance().getXML("config/ui/qqVip/qqVipWnd.xml"));
			init();
		}
		
		private function init():void{
			hideBg();
//			clsBtn.x += 4;
//			clsBtn.y += 12;
			qqvipBar = getUIbyID("qqvipBar") as TabBar;
			payVipBtn = getUIbyID("payVipBtn") as ImgButton;
			payYearVipBtn = getUIbyID("payYearVipBtn") as ImgButton;
			
			privilegePage = new QQVipPrivilegePage();
			newUserPage = new QQVipNewUserPage();
			lvPage = new QQVipLvPage();
			dayPage = new QQVipDayPage();
			qqvipBar.addToTab(privilegePage, 0);
			qqvipBar.addToTab(newUserPage, 1);
			qqvipBar.addToTab(dayPage, 2);
			qqvipBar.addToTab(lvPage, 3);
			privilegePage.x = -11;
			privilegePage.y = 20;
			newUserPage.x = -11;
			newUserPage.y = 20;
			lvPage.x = -11;
			lvPage.y = 20;
			dayPage.x = -11;
			dayPage.y = 20;
			
			qqvipBar.addEventListener(TabbarModel.changeTurnOnIndex, onChange);
			payVipBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			payYearVipBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			var st:int = DataManager.getInstance().qqvipData.actSt;
			switch(event.target.name){
				case "payVipBtn":
					if(0 == st){
						PayUtil.payQQYellowVip(1);
					}else{
						PayUtil.openQQYellowVipUrl(1);
					}
					break;
				case "payYearVipBtn":
					if(0 == st){
						PayUtil.payQQYellowVip(12);
					}else{
						PayUtil.openQQYellowVipUrl(2);
					}
					break;
			}
		}
		
		protected function onChange(event:Event):void{
			if(qqvipBar.turnOnIndex == _currentIndex){
				return;
			}
			_currentIndex = qqvipBar.turnOnIndex;
			switch(_currentIndex){
				case 0:
					break;
				case 1:
					Cmd_QQVip.cm_TX_N();
					break;
				case 2:
					Cmd_QQVip.cm_TX_D();
					break;
				case 3:
					Cmd_QQVip.cm_TX_L();
					break;
			}
		}
		
		public function updateUI_N():void{
			newUserPage.updateInfo();
		}
		
		public function updateUI_L():void{
			lvPage.updateInfo();
		}
		
		public function updateUI_D():void{
			dayPage.updateInfo();
		}
		
		public function turnToTab(index:int):void{
			qqvipBar.turnToTab(index);
		}
		
		public function resize():void{
			x = (UIEnum.WIDTH - width) >> 1;
			y = (UIEnum.HEIGHT - height) >> 1;
		}
	}
}
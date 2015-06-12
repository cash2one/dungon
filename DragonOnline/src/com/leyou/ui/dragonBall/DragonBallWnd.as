package com.leyou.ui.dragonBall
{
	import com.ace.enum.UIEnum;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.leyou.net.cmd.Cmd_Longz;
	import com.leyou.ui.dragonBall.children.DragonBallCollectionRender;
	import com.leyou.ui.dragonBall.children.DragonBallCopyRender;
	
	import flash.events.Event;
	
	public class DragonBallWnd extends AutoWindow
	{
		private var collectionPage:DragonBallCollectionRender;
		
		private var copyPage:DragonBallCopyRender;
		
		private var dragonTabBar:TabBar;
		
		private var _currentIndex:int;
		
		public function DragonBallWnd(){
			super(LibManager.getInstance().getXML("config/ui/dragonBall/dragonBallWnd.xml"));
			init();
		}
		
		private function init():void{
			dragonTabBar = getUIbyID("dragonTabBar") as TabBar;
			collectionPage = new DragonBallCollectionRender();
			copyPage = new DragonBallCopyRender();
			collectionPage.x -= 15;
			collectionPage.y += 5;
			copyPage.x -= 15;
			copyPage.y += 5;
			
			dragonTabBar.addToTab(collectionPage, 0);
			dragonTabBar.addToTab(copyPage, 1);
			dragonTabBar.addEventListener(TabbarModel.changeTurnOnIndex, onTabChange);
			hideBg();
		}
		
		public function resize():void {
			x = (UIEnum.WIDTH - width) >> 1;
			y = (UIEnum.HEIGHT - height) >> 1;
		}
		
		protected function onTabChange(event:Event):void{
			if(_currentIndex == dragonTabBar.turnOnIndex){
				return;
			}
			_currentIndex = dragonTabBar.turnOnIndex;
			switch(_currentIndex){
				case 0:
					Cmd_Longz.cm_Longz_I();
					break;
				case 1:
					Cmd_Longz.cm_Longz_C();
					break;
			}
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, toCenter);
			switch(_currentIndex){
//				case 0:
//					Cmd_Longz.cm_Longz_I();
//					break;
				case 1:
					Cmd_Longz.cm_Longz_C();
					break;
			}
		}
		
		public function updateCollectionPage():void{
			collectionPage.updateInfo();
		}
		
		public function updateCopyPage():void{
			copyPage.updateInfo();
		}
		
		public function flyReward():void{
			collectionPage.flyReward();
		}
	}
}
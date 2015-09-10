package com.leyou.ui.dragonBall
{
	import com.ace.enum.UIEnum;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.lable.Label;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.leyou.net.cmd.Cmd_Longz;
	import com.leyou.ui.dragonBall.children.DragonBallCollectionRender;
	import com.leyou.ui.dragonBall.children.DragonBallCopyRender;
	import com.leyou.ui.dragonBall.children.DragonBallPropertyRender;
	import com.leyou.ui.dragonBall.children.DragonBallRewardRender;
	
	import flash.events.Event;
	
	public class DragonBallWnd extends AutoWindow
	{
		private var collectionPage:DragonBallCollectionRender;
		
		private var copyPage:DragonBallCopyRender;
		
		private var rewardPage:DragonBallRewardRender;
		
		private var propertyPage:DragonBallPropertyRender;
		
		private var dragonTabBar:TabBar;
		
		private var energyLbl:Label;
		
		private var _currentIndex:int;
		
		public function DragonBallWnd(){
			super(LibManager.getInstance().getXML("config/ui/dragonBall/dragonBallWnd.xml"));
			init();
		}
		
		private function init():void{
			energyLbl = getUIbyID("energyLbl") as Label;
			dragonTabBar = getUIbyID("dragonTabBar") as TabBar;
			collectionPage = new DragonBallCollectionRender();
			copyPage = new DragonBallCopyRender();
			rewardPage = new DragonBallRewardRender();
			propertyPage = new DragonBallPropertyRender();
			collectionPage.x -= 15;
			collectionPage.y += 5;
			copyPage.x -= 15;
			copyPage.y += 5;
			rewardPage.x -= 15;
			rewardPage.y += 5;
			propertyPage.x -= 15;
			propertyPage.y += 5;
			
			dragonTabBar.addToTab(collectionPage, 0);
			dragonTabBar.addToTab(rewardPage, 1);
			dragonTabBar.addToTab(copyPage, 2);
			dragonTabBar.addToTab(propertyPage, 3);
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
					rewardPage.updateStatus();
					break;
				case 2:
					Cmd_Longz.cm_Longz_C();
					break;
				case 3:
					Cmd_Longz.cm_Longz_H()
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
					rewardPage.updateStatus();
					break;
				case 2:
					Cmd_Longz.cm_Longz_C();
					break;
				case 3:
					Cmd_Longz.cm_Longz_H()
					break;
			}
		}
		
		public function updateCollectionReward():void{
			collectionPage.updateCollectionReward();
		}
		
		public function updateRewardItem():void{
			rewardPage.flyItem();
		}
			
		public function updateProperty():void{
			propertyPage.updateInfo();
		}
		
		public function updateCollectionPage():void{
			collectionPage.updateInfo();
			energyLbl.text = UIManager.getInstance().backpackWnd.lh+"";
		}
		
		public function updateLh():void{
			energyLbl.text = UIManager.getInstance().backpackWnd.lh+"";
		}
		
		public function updateCopyPage():void{
			copyPage.updateInfo();
		}
		
		public function flyReward():void{
			collectionPage.flyReward();
		}
	}
}
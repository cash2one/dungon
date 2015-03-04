package com.leyou.ui.boss
{
	import com.ace.config.Core;
	import com.ace.enum.UIEnum;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_BCP;
	import com.leyou.net.cmd.Cmd_YBS;
	import com.leyou.ui.boss.children.BossCopyRender;
	import com.leyou.ui.boss.children.BossNormalRender;
	import com.leyou.ui.boss.children.BossWorldRender;
	
	import flash.events.Event;
	
	public class BossWnd extends AutoWindow
	{
		private var bossTabBar:TabBar;
		
		private var lowBossPage:BossNormalRender;
		
		private var worldBossPage:BossWorldRender;
		
		private var copyBossPage:BossCopyRender;
		
		private var _currentIndex:int = -1;
		
		public function BossWnd(){
			super(LibManager.getInstance().getXML("config/ui/boss/bossWnd.xml"));
			init();
		}
		
		private function init():void{
			bossTabBar = getUIbyID("bossTabBar") as TabBar;
			lowBossPage = new BossNormalRender();
			worldBossPage = new BossWorldRender();
			copyBossPage = new BossCopyRender();
			
			bossTabBar.addToTab(lowBossPage, 0);
			bossTabBar.addToTab(worldBossPage, 1);
			bossTabBar.addToTab(copyBossPage, 2);
			bossTabBar.addEventListener(TabbarModel.changeTurnOnIndex, onTabChange);
			bossTabBar.setTabVisible(0, false);
			bossTabBar.setTabVisible(1, false);
			bossTabBar.setTabVisible(2, false);
			if (Core.me.info.level >= ConfigEnum.BossCopyOpenLevel) {
				bossTabBar.setTabVisible(2, true);
				bossTabBar.turnToTab(2);
			}
			if (Core.me.info.level >= ConfigEnum.FieldBossOpenLevel) {
				bossTabBar.setTabVisible(0, true);
				bossTabBar.setTabVisible(1, true);
				bossTabBar.turnToTab(0);
			}
			
			lowBossPage.x -= 15;
			lowBossPage.y += 3;
			worldBossPage.x -= 15;
			worldBossPage.y += 3;
			copyBossPage.x -= 15;
			copyBossPage.y += 3;
		}
		
		public function resize():void {
			this.x=UIEnum.WIDTH - this.width >> 1;
			this.y=UIEnum.HEIGHT - this.height >> 1;
		}
		
		protected function onTabChange(event:Event):void{
			if(bossTabBar.turnOnIndex == _currentIndex){
				return;
			}
			_currentIndex = bossTabBar.turnOnIndex;
			switch(_currentIndex){
				case 0:
					Cmd_YBS.cm_YBS_L();
					break;
				case 1:
					Cmd_YBS.cm_YBS_I();
					break;
				case 2:
					Cmd_BCP.cm_BCP_I();
					break;
			}
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, toCenter);
			switch(_currentIndex){
//				case 0:
//					Cmd_YBS.cm_YBS_L();
//					break;
				case 1:
					Cmd_YBS.cm_YBS_I();
					break;
				case 2:
					Cmd_BCP.cm_BCP_I();
					break;
			}
		}
		
		public function updateLowBoss():void{
			lowBossPage.updateView();
		}
		
		public function updateWorldBoss():void{
			worldBossPage.updateView();
		}
		
		public function updateCopyBoss():void{
			copyBossPage.updateView();
		}
		
		public function updateChallengeCount():void{
			copyBossPage.updateCount();
		}
		
		public function refreshBossItem():void{
			bossTabBar.setTabVisible(0, false);
			bossTabBar.setTabVisible(1, false);
			bossTabBar.setTabVisible(2, false);
			if (Core.me.info.level >= ConfigEnum.BossCopyOpenLevel) {
				bossTabBar.setTabVisible(2, true);
			}
			if (Core.me.info.level >= ConfigEnum.FieldBossOpenLevel) {
				bossTabBar.setTabVisible(0, true);
				bossTabBar.setTabVisible(1, true);
			}
			lowBossPage.refreshBossOpenStatus();
			worldBossPage.refreshBossOpenStatus();
		}
	}
}
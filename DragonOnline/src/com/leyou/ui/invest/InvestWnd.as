package com.leyou.ui.invest
{
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.leyou.net.cmd.Cmd_Invest;
	import com.leyou.ui.invest.children.InvestJJRender;
	import com.leyou.ui.invest.children.InvestTZRender;
	
	import flash.events.Event;
	
	public class InvestWnd extends AutoWindow
	{
		private var tabBar:TabBar;
		
		private var tzRender:InvestTZRender;
		
		private var jjRender:InvestJJRender;
		
		private var _currentIdx:int = 0;
		
		public function InvestWnd(){
			super(LibManager.getInstance().getXML("config/ui/invest/tzlcWnd.xml"));
			init();
		}
		
		public function init():void{
			tabBar = getUIbyID("investTabBar") as TabBar;
			
			tzRender = new InvestTZRender();
			jjRender = new InvestJJRender();
			addChild(tzRender);
			addChild(jjRender);
			tabBar.addToTab(tzRender, 0);
			tabBar.addToTab(jjRender, 1);
			tabBar.addEventListener(TabbarModel.changeTurnOnIndex, onTabBarChangeIndex);
			tabBar.turnToTab(0);
//			clsBtn.x += 3;
//			clsBtn.y += 14;
		}
		
		protected function onTabBarChangeIndex(event:Event):void{
			if (_currentIdx == tabBar.turnOnIndex){
				return;
			}
			_currentIdx = tabBar.turnOnIndex;
			switch(_currentIdx){
				case 0:
					Cmd_Invest.cm_TZ_I();
					break;
				case 1:
					Cmd_Invest.cm_TZ_C();
					break;
			}
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, toCenter);
//			switch(_currentIdx){
//				case 0:
//					Cmd_Invest.cm_TZ_I();
//					break;
//				case 1:
//					Cmd_Invest.cm_TZ_C();
//					break;
//			}
		}
		
		public function flyTZR():void{
			tzRender.flyReward();
		}
		
		public function flyJJ(ids:Array):void{
			jjRender.flyReward(ids);
		}
		
		public function updateInfoTZ():void{
			tzRender.updateInfo(DataManager.getInstance().investData);
		}
		
		public function updateTZLog():void{
			tzRender.updateLog(DataManager.getInstance().investData);
		}
		
		public function updateInfoJJ():void{
			jjRender.updateInfo(DataManager.getInstance().investData);
		}
		
		public override function get width():Number{
			return 758;
		}
		
		public override function get height():Number{
			return 544;
		}
		
		public function resize():void{
			this.x=(UIEnum.WIDTH - this.width) / 2;
			this.y=(UIEnum.HEIGHT - this.height) / 2;
		}
	}
}
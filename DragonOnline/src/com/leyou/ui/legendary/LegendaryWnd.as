package com.leyou.ui.legendary
{
	import com.ace.enum.WindowEnum;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.leyou.ui.legendary.children.LegendaryPageRender;
	
	import flash.events.Event;
	
	public class LegendaryWnd extends AutoWindow
	{
		private var weaponPage:LegendaryPageRender;
		
		private var legendaryTabbar:TabBar;
		
		private var currentIndex:int = -1;
		
		public function LegendaryWnd(){
			super(LibManager.getInstance().getXML("config/ui/legendary/sbcqWnd.xml"));
			init();
		}
		
		private function init():void{
			hideBg();
			weaponPage = new LegendaryPageRender();
			addChild(weaponPage);
			legendaryTabbar = getUIbyID("legendaryTabbar") as TabBar;
			
			legendaryTabbar.addEventListener(TabbarModel.changeTurnOnIndex, onTabSelect);
			weaponPage.x = 10;
			weaponPage.y = 86;
			
			legendaryTabbar.turnToTab(0);
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, toCenter);
			weaponPage.startEffect();
			weaponPage.updateSelect();
		}
		
		public function updateMaterialCount():void{
			weaponPage.updateSelect();
		}
		
		public override function hide():void{
			super.hide();
			UIManager.getInstance().hideWindow(WindowEnum.QUICK_BUY);
			weaponPage.stopEffect();
			UIManager.getInstance().selectWnd.closePanel([3]);
		}
		 
		public function setMaterialEquip(destPos:int, bagInfo:Object):void{
			weaponPage.setMaterialEquip(destPos, bagInfo);
		}
		
		public function flyToBag():void{
			weaponPage.flyToBag();
		}
		
		protected function onTabSelect(event:Event):void{
			if(legendaryTabbar.turnOnIndex == currentIndex){
				return;
			}
			currentIndex = legendaryTabbar.turnOnIndex;
			var type:int = (0 == currentIndex) ? 1 : 2;
			weaponPage.updateByType(type);
		}
	}
}
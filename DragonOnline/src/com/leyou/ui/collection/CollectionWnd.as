package com.leyou.ui.collection
{
	import com.ace.enum.UIEnum;
	import com.ace.manager.LibManager;
	import com.ace.manager.TweenManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.tabbar.children.TabBar;
	import com.leyou.ui.collection.children.CollectionPreciousPage;
	
	public class CollectionWnd extends AutoWindow
	{
		private var collectionBar:TabBar;
		
		private var collectionPrecious:CollectionPreciousPage;
		
		public function CollectionWnd(){
			super(LibManager.getInstance().getXML("config/ui/collection/mineWnd.xml"));
			init();
		}
		
		private function init():void{
			collectionBar = getUIbyID("collectionBar") as TabBar;
			collectionPrecious = new CollectionPreciousPage();
			collectionBar.addToTab(collectionPrecious, 0);
			collectionPrecious.x = -30;
			collectionPrecious.y = 3;
		}
		
		public function showCollectionMap():void{
			collectionPrecious.showCollectionMap();
		}
		
		public function updateMapInfo():void{
			collectionPrecious.updateMapInfo();
		}
		
		public function updateItemInfo():void{
			collectionPrecious.updateItemInfo();
		}
		
		public function resize():void{
			x = (UIEnum.WIDTH - width)*0.5;
			y = (UIEnum.HEIGHT - height)*0.5;
		}
		
		public override function hide():void{
			super.hide();
			TweenManager.getInstance().lightingCompnent(UIManager.getInstance().toolsWnd.getUIbyID("collectBtn"));
		}
	}
}
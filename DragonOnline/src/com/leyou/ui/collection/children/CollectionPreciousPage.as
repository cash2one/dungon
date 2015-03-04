package com.leyou.ui.collection.children
{
	import com.ace.gameData.manager.DataManager;
	import com.ace.ui.button.children.ImgButton;
	import com.leyou.data.collectioin.CollectionData;
	import com.leyou.net.cmd.Cmd_Collection;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class CollectionPreciousPage extends Sprite
	{
		private var collectionItem:CollectionItemRender;
		
		private var collectionMap:CollectionMapRender;
		
		public function CollectionPreciousPage(){
			init();
		}
		
		private function init():void{
			collectionItem = new CollectionItemRender();
			collectionMap = new CollectionMapRender();
			addChild(collectionItem);
			collectionItem.visible = false;
			addChild(collectionMap);
			collectionMap.addEventListener(MouseEvent.CLICK, onMouseClick);
			collectionItem.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			var target:CollectionMap = event.target as CollectionMap;
			if((null != target) && !target.close){
				showCollectionItem(target.groupId);
			}
			var btn:ImgButton = event.target as ImgButton;
			if((null != btn) && ("exitBtn" == btn.name)){
				Cmd_Collection.cm_COL_I();
				showCollectionMap();
			}
		}
		
		public function showCollectionMap():void{
			collectionItem.visible = false;
			collectionMap.visible = true;
		}
		
		public function showCollectionItem(group:int):void{
			collectionItem.visible = true;
			collectionMap.visible = false;
			Cmd_Collection.cm_COL_G(group);
			collectionItem.loadGroupId(group);
		}
		
		public function updateMapInfo():void{
			var data:CollectionData = DataManager.getInstance().collectionData;
			collectionMap.updateInfo(data);
		}
		
		public function updateItemInfo():void{
			var data:CollectionData = DataManager.getInstance().collectionData;
			collectionItem.updateInfo(data);
		}
	}
}
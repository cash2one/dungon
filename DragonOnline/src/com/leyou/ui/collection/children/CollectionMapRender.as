package com.leyou.ui.collection.children
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCollectionPreciousInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.component.RollNumWidget;
	import com.leyou.data.collectioin.CollectionData;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class CollectionMapRender extends AutoSprite
	{
		private var leftBtn:ImgButton;
		
		private var rightBtn:ImgButton;
		
		private var panel:Sprite;
		
		private var maps:Vector.<CollectionMap>;
		
		private var zdl:RollNumWidget;

		private var pw:int = 720; // 面板宽度
		private var col:int = 2; // 行数
		private var row:int = 3; // 列数
		private var rw:int = 243; // 单项宽度
		private var rh:int = 173; // 单项高端
		private var threshold:int;
		private var currentPage:int;
		
		public function CollectionMapRender(){
			super(LibManager.getInstance().getXML("config/ui/collection/mine1Render.xml"));
			init();
		}
		
		private function init():void{
			mouseEnabled = true;
			mouseChildren = true;
			zdl = new RollNumWidget();
			zdl.loadSource("ui/num/{num}_lzs.png");
			zdl.alingRound();
			addChild(zdl);
			zdl.x = 385;
			zdl.y = 388;
			leftBtn = getUIbyID("leftBtn") as ImgButton;
			rightBtn = getUIbyID("rightBtn") as ImgButton;
			panel = new Sprite();
			maps = new Vector.<CollectionMap>();
			panel.scrollRect = new Rectangle(0, 0, pw, 360);
			addChild(panel);
			panel.x = 29;
			panel.y = 10;
			initTable();
			
			leftBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			rightBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			leftBtn.visible = false;
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "leftBtn":
					previousPage();
					break;
				case "rightBtn":
					nextPage();
					break;
			}
		}
		
		protected function nextPage():void{
			if(currentPage < Math.ceil(maps.length/4)-1){
				scrollToX(++currentPage*pw);
			}
		}
		
		protected function previousPage():void{
			if(currentPage > 0){
				scrollToX(--currentPage*pw);
			}
		}
		
		protected function scrollToX($threshold:int):void{
			threshold = $threshold;
			leftBtn.visible = (threshold > 0);
			rightBtn.visible = (threshold < (Math.ceil(maps.length/6)-1)*pw);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void{
			var rect:Rectangle = panel.scrollRect;
			if((threshold - rect.x) > 30){
				rect.x += 30;
			}else if((threshold - rect.x) < 30){
				rect.x -= 30;
			}else{
				rect.x = threshold;
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			panel.scrollRect = rect;
		}
		
		private function getMap(index:int):CollectionMap{
			if(index >= maps.length){
				maps.length = index+1;
			}
			var map:CollectionMap = maps[index];
			if(null == map){
				map = new CollectionMap();
				maps[index] = map;
			}
			return map;
		}
		
		private function initTable():void{
			var index:int = 0;
			var mapInfos:Object = TableManager.getInstance().getCollectionGroup();
			for(var key:String in mapInfos){
				var mapInfo:TCollectionPreciousInfo = mapInfos[key];
				var map:CollectionMap = getMap(index);
				map.updateTable(mapInfo);
				index++;
			}
			maps.sort(compare);
			var l:int = maps.length;
			for(var n:int = 0; n < l; n++){
				var m:CollectionMap = maps[n];
				panel.addChild(m);
				m.x = int(n/(col*row))*pw + int(n%row) * rw;
				m.y = int(n%(col*row)/row) * rh;
			}
		}
		
		private function compare(pmap:CollectionMap, nmap:CollectionMap):int{
			if(pmap.groupId > nmap.groupId){
				return 1;
			}else if(pmap.groupId < nmap.groupId){
				return -1;
			}
			return 0;
		}
		
		public function updateInfo(data:CollectionData):void{
			zdl.setNum(data.zdl);
			for each(var map:CollectionMap in maps){
				map.updateTaskCount(data);
			}
		}
	}
}
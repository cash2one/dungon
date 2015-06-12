package com.leyou.ui.missionMarket.children
{
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.leyou.data.missinMarket.MissionMarketData;
	import com.leyou.data.missinMarket.MissionMarketTaskData;
	
	import flash.events.MouseEvent;

	public class MissionMarketSingleRender extends AutoSprite
	{
		private static const SINGLE_ITEM_COUNT:int = 6;
		
//		private var row:int = 2;
		
		private var column:int = 3;
		
		private var desLbl:Label;
		
		private var quitBtn:ImgButton;
		
		private var items:Vector.<MissionMarketSingleItem>;
		
		private var switchFun:Function;
		
		private var ctype:int;
		
		public function MissionMarketSingleRender(){
			super(LibManager.getInstance().getXML("config/ui/missionMarket/missionabarRender2.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			desLbl = getUIbyID("desLbl") as Label;
			quitBtn = getUIbyID("quitBtn") as ImgButton;
			items = new Vector.<MissionMarketSingleItem>();
			for(var n:int = 0; n < SINGLE_ITEM_COUNT; n++){
				var item:MissionMarketSingleItem = new MissionMarketSingleItem();
				addChild(item);
				items.push(item);
				item.x = 232*(n%column);
				item.y = 179*int(n/column);
			}
			desLbl.htmlText = TableManager.getInstance().getSystemNotice(23100).content;
			
			quitBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			if(null != switchFun){
				switchFun.call(this);
			}
		}
		
		public function registerSwitch(fun:Function):void{
			switchFun = fun;
		}
		
		public function updateInfo(type:int):void{
			ctype = type;
			var data:MissionMarketData = DataManager.getInstance().missionMarketData;
			for(var n:int = 0; n < SINGLE_ITEM_COUNT; n++){
				var item:MissionMarketSingleItem = items[n];
				var mdata:MissionMarketTaskData = data.getMissionData(n);
				if(null != mdata){
					item.updateInfo(mdata);
				}
			}
		}
		
		public function flyItem(id:int):void{
			for(var n:int = 0; n < SINGLE_ITEM_COUNT; n++){
				var item:MissionMarketSingleItem = items[n];
				if(item.id == id){
					item.flyItem();
				}
			}
		}
	}
}
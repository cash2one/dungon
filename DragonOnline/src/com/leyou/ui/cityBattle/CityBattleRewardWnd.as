package com.leyou.ui.cityBattle
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCityBattleRewardInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.leyou.ui.cityBattle.children.CityBattleRewardCommonItem;
	import com.leyou.ui.cityBattle.children.CityBattleRewardItem;
	import com.leyou.ui.cityBattle.children.CityBattleRewardReceiveItem;
	
	import flash.events.Event;
	
	public class CityBattleRewardWnd extends AutoWindow
	{
		private static const REWARD_MAX:int = 4;
		
		private var cityRewardBar:TabBar;
		
		private var dayRewardItems:Vector.<CityBattleRewardItem>;
		
		private var vectoryItems:Vector.<CityBattleRewardItem>;
		
		private var rankItems:Vector.<CityBattleRewardItem>;
		
		private var _currentIndex:int;
		
		public function CityBattleRewardWnd(){
			super(LibManager.getInstance().getXML("config/ui/cityBattle/warCityAward.xml"));
			init();
		}
		
		private function init():void{
			clsBtn.x -= 6;
			clsBtn.y -= 14;
			cityRewardBar = getUIbyID("cityRewardBar") as TabBar;
			dayRewardItems = new Vector.<CityBattleRewardItem>(REWARD_MAX);
			vectoryItems = new Vector.<CityBattleRewardItem>(REWARD_MAX);
			rankItems = new Vector.<CityBattleRewardItem>(REWARD_MAX);
			
			for(var m:int = 0; m < REWARD_MAX; m++){
				var vectoryItem:CityBattleRewardCommonItem = vectoryItems[m] as CityBattleRewardCommonItem;
				if(null == dayItem){
					vectoryItem = new CityBattleRewardCommonItem();
					vectoryItems[m] = vectoryItem;
				}
				info = TableManager.getInstance().getCityBattleRewardInfo(REWARD_MAX*0+(REWARD_MAX-m));
				vectoryItem.updateTable(info);
			}
			
			for(var k:int = 0; k < REWARD_MAX; k++){
				var rankItem:CityBattleRewardCommonItem = rankItems[k] as CityBattleRewardCommonItem;
				if(null == rankItem){
					rankItem = new CityBattleRewardCommonItem();
					rankItems[k] = rankItem;
				}
				info = TableManager.getInstance().getCityBattleRewardInfo(REWARD_MAX*1+(REWARD_MAX-k));
				rankItem.updateTable(info);
			}
			
			var info:TCityBattleRewardInfo;
			for(var n:int = 0; n < REWARD_MAX; n++){
				var dayItem:CityBattleRewardReceiveItem = dayRewardItems[n] as CityBattleRewardReceiveItem;
				if(null == dayItem){
					dayItem = new CityBattleRewardReceiveItem();
					dayRewardItems[n] = dayItem;
				}
				info = TableManager.getInstance().getCityBattleRewardInfo(REWARD_MAX*2+(REWARD_MAX-n));
				dayItem.updateTable(info);
			}
			
			cityRewardBar.addEventListener(TabbarModel.changeTurnOnIndex, onTabChange);
			viewItemType(getTypeByIndex(_currentIndex));
		}
		
		protected function onTabChange(event:Event):void{
			if(_currentIndex == cityRewardBar.turnOnIndex){
				return;
			}
			viewItemType(getTypeByIndex(_currentIndex), true);
			_currentIndex = cityRewardBar.turnOnIndex
			viewItemType(getTypeByIndex(_currentIndex));
			switch(cityRewardBar.turnOnIndex){
				case 0:
					break;
				case 1:
					break;
				case 2:
					break;
			}
		}
		
		private function getTypeByIndex(index:int):int{
			switch(index){
				case 0:
					return 3;
				case 1:
					return 1;
				case 2:
					return 2;
			}
			return 0;
		}
		
		private function getArrayByType(type:int):Vector.<CityBattleRewardItem>{
			var items:Vector.<CityBattleRewardItem>;
			if(type == 1){
				items = vectoryItems;
			}else if(type == 2){
				items = rankItems;
			}else if(type == 3){
				items = dayRewardItems;
			}
			return items;
		}
		
		private function viewItemType(type:int, remove:Boolean=false):void{
			var items:Vector.<CityBattleRewardItem> = getArrayByType(type);
			var l:int = items.length;
			for(var n:int = 0; n < l; n++){
				var item:CityBattleRewardItem = items[n];
				if(contains(item)){
					if(remove){
						removeChild(item);
					}
				}else{
					if(!remove){
						addChild(item);
						item.x = 18;
						item.y = 66 + 10 + 93*n;
					}
				}
			}
		}
		
		public function flyItem(id:int):void{
			var l:int = dayRewardItems.length;
			for(var n:int = 0; n < l; n++){
				var item:CityBattleRewardReceiveItem = dayRewardItems[n] as CityBattleRewardReceiveItem;
				if(item.id == id){
					item.flyItem();
				}
			}
		}
	}
}
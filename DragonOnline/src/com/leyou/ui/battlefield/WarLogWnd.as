package com.leyou.ui.battlefield
{
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.leyou.data.iceBattle.IceBattleData;
	import com.leyou.data.iceBattle.children.BattleHistoryData;
	import com.leyou.ui.battlefield.children.WarLogLable;
	
	public class WarLogWnd extends AutoWindow
	{
		private var itemList:Vector.<WarLogLable>;
		
		private var _free:Vector.<WarLogLable>;
		
		public function WarLogWnd(){
			super(LibManager.getInstance().getXML("config/ui/iceBattle/warLogRender.xml"));
			init();
		}
		
		private function init():void{
			itemList = new Vector.<WarLogLable>();
			_free = new Vector.<WarLogLable>();
			clsBtn.x -= 6;
			clsBtn.y -= 14;
		}
		
		public function updateInfo():void{
			var data:IceBattleData = DataManager.getInstance().iceBattleData;
			var dl:int = data.getLogCount();
			var rl:int = itemList.length;
			var index:int;
			while((index < dl) || (index < rl)){
				if(index < dl){
					var logData:BattleHistoryData = data.getLogData(index);
					var item:WarLogLable = getItem(index);
					item.updateInfo(logData);
				}else{
					freeItem(index);
				}
				index++;
			}
			itemList.length = dl;
		}
		
		private function freeItem(index:int):void{
			var item:WarLogLable = itemList[index];
			if(null != item){
				if(contains(item)){
					removeChild(item);
				}
				_free.push(item);
			}
			itemList[index] = null;
		}
		
		private function getFreeItem():WarLogLable{
			var item:WarLogLable = _free.pop();
			if(null == item){
				item = new WarLogLable();
			}
			return item;
		}
		
		private function getItem(index:int):WarLogLable{
			if(itemList.length <= index){
				itemList.length = index+1;
			}
			var item:WarLogLable = itemList[index];
			if(null == item){
				item = getFreeItem();
				itemList[index] = item;
			}
			addChild(item);
			item.x = 19;
			item.y = 36+index*43;
			return item;
		}
	}
}
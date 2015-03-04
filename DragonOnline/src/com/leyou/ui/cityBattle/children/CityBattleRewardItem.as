package com.leyou.ui.cityBattle.children
{
	import com.ace.gameData.table.TCityBattleRewardInfo;
	import com.ace.ui.auto.AutoSprite;
	import com.leyou.ui.market.child.MarketGrid;
	
	public class CityBattleRewardItem extends AutoSprite
	{
		protected var grids:Vector.<MarketGrid>;
		
		public var id:int;
		
		public function CityBattleRewardItem(uiXMl:XML){
			super(uiXMl);
		}
		
		public function updateTable(info:TCityBattleRewardInfo):void{
		}
		
		public function updateInfo():void{
		}
	}
}
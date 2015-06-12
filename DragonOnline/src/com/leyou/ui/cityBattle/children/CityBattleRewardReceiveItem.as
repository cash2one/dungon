package com.leyou.ui.cityBattle.children
{
	import com.ace.config.Core;
	import com.ace.enum.ItemEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.table.TCityBattleRewardInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.cityBattle.CityBattleCityData;
	import com.leyou.net.cmd.Cmd_WARC;
	import com.leyou.ui.market.child.MarketGrid;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class CityBattleRewardReceiveItem extends CityBattleRewardItem
	{
		private var zdlLbl:Label;
		
		private var receiveBtn:NormalButton;
		
		public function CityBattleRewardReceiveItem(){
			super(LibManager.getInstance().getXML("config/ui/cityBattle/warCityAwardRender1.xml"));
			init();
		}
		
		private function init():void{
			mouseEnabled = true;
			mouseChildren = true;
			zdlLbl = getUIbyID("zdlLbl") as Label;
			receiveBtn = getUIbyID("receiveBtn") as NormalButton;
			grids = new Vector.<MarketGrid>(3);
			for(var n:int = 0; n < 3; n++){
				var grid:MarketGrid = grids[n];
				if(null == grid){
					grid = new MarketGrid();
					grids[n] = grid;
					grid.isShowPrice = true; 
					
				}
				grid.x = 118 + 73*n;
				grid.y = 13;
				addChild(grid);
			}
			
			receiveBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			Cmd_WARC.cm_WARC_M(id);
		}
		
		public override function updateTable(info:TCityBattleRewardInfo):void{
			var data:CityBattleCityData = DataManager.getInstance().cityBattleData.cityData;
			receiveBtn.visible = data.hasOwner && (data.guildName == Core.me.info.guildName); 
			id = info.id;
			zdlLbl.text = StringUtil.substitute("{1}~{2}", info.zdlLow, info.zdlHigh);
			var index:int = 0;
			var grid:MarketGrid = grids[index];
			if(info.exp > 0){
				grid.updataInfo({itemId:ItemEnum.EXP_VIR_ITEM_ID, count:info.exp});
				index++;
			}
			if(info.money > 0){
				grid = grids[index];
				grid.updataInfo({itemId:ItemEnum.MONEY_VIR_ITEM_ID, count:info.money});
				index++;
			}
			if(info.energy > 0){
				grid = grids[index];
				grid.updataInfo({itemId:ItemEnum.ENERGY_VIR_ITEM_ID, count:info.energy});
				index++;
			}
			if(info.lp > 0){
				grid = grids[index];
				grid.updataInfo({itemId:ItemEnum.BG_VIR_ITEM_ID, count:info.lp});
				index++;
			}
			if(info.byb > 0){
				grid = grids[index];
				grid.updataInfo({itemId:ItemEnum.BYB_VIR_ITEM_ID, count:info.byb});
				index++;
			}
			if(info.honor > 0){
				grid = grids[index];
				grid.updataInfo({itemId:ItemEnum.HONOUR_VIR_ITEM_ID, count:info.honor});
				index++;
			}
			if(info.item1 > 0){
				grid = grids[index];
				grid.updataInfo({itemId:info.item1, count:info.item1Num});
				index++;
			}
			if(info.item2 > 0){
				grid = grids[index];
				grid.updataInfo({itemId:info.item2, count:info.item2Num});
				index++;
			}
			if(info.item3 > 0){
				grid = grids[index];
				grid.updataInfo({itemId:info.item3, count:info.item3Num});
				index++;
			}
			if(info.item4 > 0){
				grid = grids[index];
				grid.updataInfo({itemId:info.item4, count:info.item4Num});
				index++;
			}
		}
		
		public function flyItem():void{
			var ids:Array = [];
			var points:Array = [];
			for each(var grid:MarketGrid in grids){
				if(null != grid){
					ids.push(grid.dataId);
					points.push(grid.localToGlobal(new Point(0,0)));
				}
			}
			FlyManager.getInstance().flyBags(ids, points);
		}
	}
}
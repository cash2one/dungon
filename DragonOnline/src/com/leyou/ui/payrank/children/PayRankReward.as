package com.leyou.ui.payrank.children
{
	import com.ace.config.Core;
	import com.ace.enum.ItemEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.gameData.table.TRankRewardInfo;
	import com.leyou.ui.mail.child.MaillGrid;
	
	import flash.display.Sprite;
	
	public class PayRankReward extends Sprite
	{
		private var grids:Vector.<MaillGrid>;
		
		public function PayRankReward(){
			init();
		}
		
		private function init():void{
			grids = new Vector.<MaillGrid>();
			for(var n:int = 0; n < 6; n++){
				var grid:MaillGrid = new MaillGrid();
				grid.isShowPrice = false;
				addChild(grid);
				grids.push(grid);
				grid.x = n * 55;
			}
		}
		
		public function updateTInfo(rInfo:TRankRewardInfo):void{
			// 确定职业
			var ridx:int = 0;
			switch(Core.me.info.profession){
				case PlayerEnum.PRO_SOLDIER:
					ridx = 0;
					break;
				case PlayerEnum.PRO_MASTER:
					ridx = 1;
					break;
				case PlayerEnum.PRO_WARLOCK:
					ridx = 2;
					break;
				case PlayerEnum.PRO_RANGER:
					ridx = 3;
					break;
			}
			var index:int = 0;
			var grid:MaillGrid = grids[index];
			if(rInfo.exp > 0){
				grid.updateInfo(ItemEnum.EXP_VIR_ITEM_ID, rInfo.exp);
				index++;
			}
			if(rInfo.money > 0){
				grid = grids[index];
				grid.updateInfo(ItemEnum.MONEY_VIR_ITEM_ID, rInfo.money);
				index++;
			}
			if(rInfo.energy > 0){
				grid = grids[index];
				grid.updateInfo(ItemEnum.ENERGY_VIR_ITEM_ID, rInfo.energy);
				index++;
			}
			if(rInfo.byb > 0){
				grid = grids[index];
				grid.updateInfo(ItemEnum.BYB_VIR_ITEM_ID, rInfo.byb);
				index++;
			}
			if(rInfo.bg > 0){
				grid = grids[index];
				grid.updateInfo(ItemEnum.BG_VIR_ITEM_ID, rInfo.bg);
				index++;
			}
			if(rInfo.getProReward(ridx, 1) > 0){
				grid = grids[index];
				grid.updateInfo(rInfo.getProReward(ridx, 1), rInfo.item1Count);
				index++;
			}
			if(rInfo.getProReward(ridx, 2) > 0){
				grid = grids[index];
				grid.updateInfo(rInfo.getProReward(ridx, 2), rInfo.item2Count);
				index++;
			}
			if(rInfo.getProReward(ridx, 3) > 0){
				grid = grids[index];
				grid.updateInfo(rInfo.getProReward(ridx, 3), rInfo.item3Count);
				index++;
			}
			if(rInfo.getProReward(ridx, 4) > 0){
				grid = grids[index];
				grid.updateInfo(rInfo.getProReward(ridx, 4), rInfo.item4Count);
				index++;
			}
			if(rInfo.getProReward(ridx, 5) > 0){
				grid = grids[index];
				grid.updateInfo(rInfo.getProReward(ridx, 5), rInfo.item5Count);
				index++;
			}
			if(rInfo.getProReward(ridx, 6) > 0){
				grid = grids[index];
				grid.updateInfo(rInfo.getProReward(ridx, 6), rInfo.item6Count);
				index++;
			}
		}
	}
}
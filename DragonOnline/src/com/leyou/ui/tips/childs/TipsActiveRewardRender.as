package com.leyou.ui.tips.childs
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.leyou.ui.market.child.MarketGrid;
	
	public class TipsActiveRewardRender extends AutoSprite
	{
		private var nameLbl:Label;
		
		private var numLbl:Label;
		
		private var grid:MarketGrid;
		
		public function TipsActiveRewardRender(){
			super(LibManager.getInstance().getXML("config/ui/tips/activeTipsRender.xml"));
			init();
		}
		
		private function init():void{
			nameLbl = getUIbyID("nameLbl") as Label;
			numLbl = getUIbyID("numLbl") as Label;
			grid = new MarketGrid();
			addChild(grid);
		}
		
		public function updateInfo(id:int, ic:int):void{
			// 找到物品信息
			grid.updataInfo({itemId:id, count:ic});
			var sourceName:String;
			var n:String;
			var itemInfo:TItemInfo = TableManager.getInstance().getItemInfo(id);
			if(null != itemInfo){
				sourceName = itemInfo.icon + ".png";
				n = itemInfo.name;
			}else{
				var equInfo:TEquipInfo = TableManager.getInstance().getEquipInfo(id);
				sourceName = equInfo.icon + ".png";
				n = equInfo.name;
			}
			nameLbl.text = n;
			numLbl.text = ic+"";
		}
		
		public function clear():void{
			nameLbl.text = "";
			numLbl.text = "";
			grid.clear();
		}
	}
}
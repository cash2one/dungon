package com.leyou.ui.dragonBall.children
{
	import com.ace.enum.FilterEnum;
	import com.ace.enum.ItemEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TDragonBallRewardInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.leyou.data.dargonball.DragonBallData;
	import com.leyou.net.cmd.Cmd_Longz;
	import com.leyou.ui.market.child.MarketGrid;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class DragonBallRewardItem extends AutoSprite
	{
		private var gridImgs:Vector.<Image>;
		
		private var plusImgs:Vector.<Image>;
		
		private var equalImg:Image;
		
		private var grids:Vector.<MarketGrid>;
		
		private var receiveBtn:NormalButton;
		
		private var _id:int;
		
		public function DragonBallRewardItem(){
			super(LibManager.getInstance().getXML("config/ui/dragonBall/dragonBall4Label.xml"));
			init();
		}
		
		public function get id():int
		{
			return _id;
		}

		private function init():void{
			mouseChildren = true;
			gridImgs = new Vector.<Image>();
			for(var n:int = 0; n < 6; n++){
				var gImg:Image = getUIbyID("gr"+(n+1)+"Img") as Image;
				gridImgs.push(gImg);
			}
			grids = new Vector.<MarketGrid>();
			for(var l:int = 0; l < 6; l++){
				var grid:MarketGrid = new MarketGrid();
				grids.push(grid);
				addChild(grid);
				grid.x = gridImgs[l].x;
				grid.y = gridImgs[l].y;
			}
			
			plusImgs = new Vector.<Image>();
			for(var m:int = 0; m < 4; m++){
				var pImg:Image = getUIbyID("plus"+(m+1)+"Img") as Image;
				plusImgs.push(pImg);
			}
			equalImg = getUIbyID("equalImg") as Image;
			receiveBtn = getUIbyID("receiveBtn") as NormalButton;
			receiveBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "receiveBtn":
					Cmd_Longz.cm_Longz_A(id);
					break;
			}
		}
		
		private function resetCollectionNum(num:int):void{
			var length:int = grids.length;
			for(var n:int = 0; n < length; n++){
				var grid:MarketGrid = grids[n];
				var gridBg:Image = gridImgs[n];
				if(( (n+1) > num ) && ( (n+1) != length )){
					grid.visible = false;
					gridBg.visible = false;
				}
				if(((n+1) >= num) && (n < 4)){
					plusImgs[n].visible = false;
				}
			}
			equalImg.x = grids[num-1].x + 64;
			grids[length-1].x = equalImg.x + 18;
			gridImgs[length-1].x = grids[length-1].x;
		}
		
		public function udpateInfo(info:TDragonBallRewardInfo):void{
			_id = info.id;
			// 搜集物品
			var items:Vector.<int> = info.items;
			var itemNums:Vector.<int> = info.itemNums;
			var length:int = items.length;
			resetCollectionNum(length);
			for(var n:int = 0; n < length; n++){
				grids[n].updataInfo({itemId:items[n], count:itemNums[n]});
			}
			if(info.energy_num > 0){
				grids[grids.length-1].updataInfo({itemId:ItemEnum.LONGHUN_VIR_ITEM_ID, count:info.energy_num});
			}
		}
		
		public function updateStatus():void{
			var info:TDragonBallRewardInfo = TableManager.getInstance().getDragonBallReward(_id);
			var items:Vector.<int> = info.items;
			var itemNums:Vector.<int> = info.itemNums;
			var length:int = items.length;
			var data:DragonBallData = DataManager.getInstance().dragonBallData;
			for(var n:int = 0; n < length; n++){
				grids[n].filters = (data.getItemCount(items[n]) >= itemNums[n]) ? null : [FilterEnum.enable];
			}
		}
		
		public function flyItem():void{
			var grid:MarketGrid = grids[grids.length-1];
			FlyManager.getInstance().flyBags([grid.dataId], [grid.localToGlobal(new Point())]);
		}
	}
}
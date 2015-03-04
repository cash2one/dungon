package com.leyou.ui.firstGift.children
{
	import com.ace.manager.LibManager;
	import com.ace.ui.FlyManager;
	import com.leyou.ui.market.child.MarketGrid;
	
	import flash.geom.Point;
	
	public class FirstGiftItemRender extends FirstGiftRender
	{
		private var grids:Vector.<MarketGrid>;

		private var flyIds:Array;

		private var starts:Array;
		
		public function FirstGiftItemRender(){
			super(LibManager.getInstance().getXML("config/ui/firstGift/schl3Render.xml"));
			init();
		}
		
		protected override function init():void{
			super.init();
			grids = new Vector.<MarketGrid>();
			for(var n:int = 0; n < 5; n++){
				var grid:MarketGrid = new MarketGrid();
				grid.x = 75 + n*67;
				grid.y = 103;
				grid.isShowPrice = false;
				addChild(grid);
				grids.push(grid);
			}
		}
		
		public function updateInfo(obj:Object):void{
			var rewardList:Array = obj.jlist;
			var count:int = rewardList.length;
			for(var n:int = 0; n < count; n++){
				var reward:Array = rewardList[n];
				grids[n].updataInfo({itemId:reward[0], count:reward[1]});
			}
		}
		
		public function setItem():void{
			flyIds=[];
			starts=[];
			for each(var grid:MarketGrid in grids){
				if(0 != grid.dataId){
					flyIds.push(grid.dataId);
					starts.push(grid.localToGlobal(new Point(0, 0)));
				}
			}
		}
		
		public function flyItem():void{
			if((null != flyIds) && (flyIds.length > 0)){
				FlyManager.getInstance().flyBags(flyIds, starts);
				flyIds.length = 0;
				starts.length = 0;
			}
		}
	}
}
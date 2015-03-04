package com.leyou.ui.welfare.child.component
{
	import com.ace.enum.FilterEnum;
	import com.ace.gameData.table.TLevelGiftInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.leyou.net.cmd.Cmd_Welfare;
	import com.leyou.ui.mail.child.MaillGrid;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class WelfareLvRender extends AutoSprite
	{
		private static const GRID_COUNT:int = 6;
		
		private var receiveBtn:ImgButton;
		
		private var lvImg:Image;
		
		private var receiveImg:Image;
		
		private var grids:Vector.<MaillGrid>;
		
		private var btnImg:Image;
		
		private var lv:int;
		
		public var waitFly:Boolean;
		
		private var status:int;
		
		public function WelfareLvRender(){
			super(LibManager.getInstance().getXML("config/ui/welfare/welfareLvRender.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			grids = new Vector.<MaillGrid>(GRID_COUNT);
			lvImg = getUIbyID("lvImg") as Image;
			receiveImg = getUIbyID("receiveImg") as Image;
			receiveBtn = getUIbyID("receiveBtn") as ImgButton;
			btnImg = getUIbyID("btnImg") as Image;
			receiveBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
		}
		
		protected function onButtonClick(event:MouseEvent):void{
			waitFly = true;
			Cmd_Welfare.cm_ULV_J(lv);
		}
		
		public function updateInfo(levelInfo:TLevelGiftInfo, re:int):void{
			status = re;
			lv = levelInfo.level;
			receiveImg.visible = (1 == re);
			var fa:Array = receiveImg.visible ? [FilterEnum.enable] : null;
			for(var n:int = 0; n < GRID_COUNT; n++){
				var grid:MaillGrid = getGrid(n);
				grid.filters = fa;
				var itemId:int = levelInfo.getItemId(n);
				if(0 != itemId){
					grid.visible = true;
					grid.updateInfo(levelInfo.getItemId(n), levelInfo.getItemNum(n));
				}else{
					grid.visible = false;
				}
			}
			lvImg.updateBmp("ui/welfare/lv_"+levelInfo.level/10+".png");
			var av:Boolean = (0 == re);
			receiveBtn.setActive(av, 1, true);
			var url:String;
			if(0 == re){
				url = "ui/welfare/btn_lqjl.png";
			}else if(1 == re){
				url = "ui/welfare/btn_lqjl2.png";
			}else if(2 == re){
				url = "ui/welfare/btn_lqjl3.png";
			}
			btnImg.updateBmp(url);
		}
		
		public function hasReward():Boolean{
			return (0 == status);
		}
		
		private function getGrid(index:int):MaillGrid{
			var grid:MaillGrid = grids[index];
			if(null == grid){
				grid = new MaillGrid();
//				grid.isShowPrice = false;
				addChildAt(grid, 1);
				grid.x = 140+index*45;
				grid.y = 10;
				grids[index] = grid;
			}
			return grid;
		}
		
		public function flyItem():void{
			var ids:Array = [];
			var starts:Array = [];
			for  each(var grid:MaillGrid in grids){
				if(grid.visible && (0 != grid.dataId)){
					ids.push(grid.dataId);
					starts.push(grid.localToGlobal(new Point(0, 0)));
				}
			}
			FlyManager.getInstance().flyBags(ids, starts);
		}
	}
}
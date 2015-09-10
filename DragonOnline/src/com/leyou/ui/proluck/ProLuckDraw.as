package com.leyou.ui.proluck
{
	import com.ace.manager.LibManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.img.child.Image;
	import com.greensock.TweenLite;
	import com.leyou.ui.boss.children.CopyRewardGrid;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class ProLuckDraw extends AutoWindow
	{
		private static const GRID_COUNT:int = 9;
		
		private var pointImg:Image;
		
		private var grids:Vector.<CopyRewardGrid>;
		
		private var whirlContainer:Sprite;
		
		private var index:int;
		
		private var played:Boolean;
		
		private var getId:int;
		
		public function ProLuckDraw(){
			super(LibManager.getInstance().getXML("config/ui/itemLuckDraw.xml"));
			init();
		}
		
		private function init():void{
			hideBg();
			clsBtn.visible = false;
			
			pointImg = getUIbyID("pointImg") as Image;
			pointImg.x = -11;
			pointImg.y = -87;
			whirlContainer = new Sprite();
			whirlContainer.addChild(pointImg);
			addChild(whirlContainer)
			whirlContainer.x = 326*0.5;
			whirlContainer.y = 326*0.5;
			
			grids = new Vector.<CopyRewardGrid>();
			for(var n:int = 0; n < GRID_COUNT; n++){
				var grid:CopyRewardGrid = new CopyRewardGrid();
				addChild(grid);
				grids.push(grid);
				grid.x = 140 + Math.cos((10 + n*40)*(Math.PI/180))*111;
				grid.y = 140 + Math.sin((10 + n*40)*(Math.PI/180))*111;
			}
		}
		
		public override function hide():void{
			super.hide();
			TweenLite.killTweensOf(whirlContainer, true);
		}
		
		public function updateInfo(obj:Object):void{
			TweenLite.killTweensOf(whirlContainer);
			var rewardList:Array = obj.rl;
			getId = obj.jl.iId;
			var count:int = obj.jl.ic;
			var length:int = grids.length;
			for (var n:int = 0; n < length; n++){
				var grid:CopyRewardGrid = grids[n];
				grid.updataInfo({itemId:rewardList[n].iId, count:rewardList[n].ic});
				if(getId == rewardList[n].iId && count == rewardList[n].ic){
					index = n;
				}
			}
			roll();
		}
		
		protected function roll():void{
			played = true;
			whirlContainer.rotation = 2*40 + 20;
			var rot:uint = 1440 + index*40 + whirlContainer.rotation;
			TweenLite.to(whirlContainer, 2, {rotation:rot, onComplete:rollOver});
			function rollOver():void{
				FlyManager.getInstance().flyBags([getId], [grids[index].localToGlobal(new Point(0, 0))]);
				TweenLite.delayedCall(2, hide);
			}
		}
	}
}
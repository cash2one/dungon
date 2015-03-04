package com.leyou.ui.copy
{
	import com.ace.delayCall.DelayCallManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.greensock.TweenLite;
	import com.leyou.net.cmd.Cmd_SCP;
	import com.leyou.ui.copy.child.CopyRewardGrid;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class StoryCopyRewarWnd extends AutoWindow
	{
		private static const GRID_COUNT:int = 9;
		
		private var energyLbl:Label;
		
		private var moneyLbl:Label;
		
		private var expLbl:Label;
		
		private var societyLbl:Label;
		
		private var beginBtn:ImgButton;
		
		private var qualityImg:Image;
		
		private var pointImg:Image;
		
		private var whirlContainer:Sprite;
		
		private var played:Boolean;
		
		private var index:int;
		
		private var copyId:int;
		
		private var grids:Vector.<CopyRewardGrid>;

		private var getId:int;
		
		private var invertedImg:Image;
		
		private var wiseImg:Image;
		
		private var invertedContainer:Sprite;
		
		private var wiseContainer:Sprite;
		
		public function StoryCopyRewarWnd(){
			super(LibManager.getInstance().getXML("config/ui/copy/dungeonStoryFinish.xml"));
			init();
		}
		
		private function init():void{
			hideBg();
			energyLbl = getUIbyID("energyLbl") as Label;
			moneyLbl = getUIbyID("moneyLbl") as Label;
			expLbl = getUIbyID("expLbl") as Label;
			societyLbl = getUIbyID("societyLbl") as Label;
			beginBtn = getUIbyID("beginBtn") as ImgButton;
			qualityImg = getUIbyID("qualityImg") as Image;
			pointImg = getUIbyID("pointImg") as Image;
			invertedImg = getUIbyID("invertedImg") as Image;
			wiseImg = getUIbyID("clockwiseImg")  as Image;
			beginBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			
			whirlContainer = new Sprite();
//			whirlContainer.opaqueBackground = 0xff0000;
			whirlContainer.x = beginBtn.x + beginBtn.width*0.5;
			whirlContainer.y = beginBtn.y + beginBtn.height*0.5;
			pointImg.x = -11;
			pointImg.y = -87;
			whirlContainer.addChild(pointImg);
			beginBtn.parent.addChild(whirlContainer);
			beginBtn.parent.swapChildren(whirlContainer, beginBtn);
			
			// 以圆心(540, 290)为中心,以111为半径,并旋转10角度,间隔40度排列格子
			grids = new Vector.<CopyRewardGrid>();
			for(var n:int = 0; n < GRID_COUNT; n++){
				var grid:CopyRewardGrid = new CopyRewardGrid();
				addChild(grid);
				grids.push(grid);
				grid.x = 540 + Math.cos((10 + n*40)*(Math.PI/180))*111;
				grid.y = 290 + Math.sin((10 + n*40)*(Math.PI/180))*111;
			}
			clsBtn.visible = false;
			
			wiseImg.x = -324;
			wiseImg.y = -324;
			invertedImg.x = -228;
			invertedImg.y = -228;
			wiseContainer = new Sprite();
			invertedContainer = new Sprite();
			invertedContainer.mouseEnabled = false;
			invertedContainer.mouseChildren = false;
			wiseContainer.mouseEnabled = false;
			wiseContainer.mouseChildren = false;
			wiseContainer.addChild(wiseImg);
			invertedContainer.addChild(invertedImg);
			pane.addChildAt(wiseContainer, 0);
			pane.addChildAt(invertedContainer, 1);
			wiseContainer.x = 133;
			wiseContainer.y = 315;
			invertedContainer.x = 133;
			invertedContainer.y = 315;
		}
		
		public override function get width():Number{
			return 724;
		}
		public override function get height():Number{ 
			return 595;
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, toCenter);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			wiseContainer.rotation = 0;
			invertedContainer.rotation = 0;
			beginBtn.setActive(true, 1, true);
		}
		
		public override function hide():void{
			super.hide();
			wiseContainer.rotation = 0;
			invertedContainer.rotation = 0;
			if(hasEventListener(Event.ENTER_FRAME)){
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			TweenLite.killTweensOf(whirlContainer, true);
		}
		
		protected function onEnterFrame(event:Event):void{
			invertedContainer.rotation +=1;
			wiseContainer.rotation -=1;
		}
		
		/**
		 * <T>按钮点击</T>
		 * 
		 * @param event 事件
		 * 
		 */		
		protected function onButtonClick(event:MouseEvent):void{
			var n:String = event.target.name;
			switch(n){
				case "beginBtn":
					if(!played){
						roll();
					}
					break;
			}
		}		
		
		/**
		 * <T>更新信息</T>
		 * 
		 * @param obj 数据
		 * 
		 */		
		public function updateInfo(obj:Object):void{
			whirlContainer.rotation = 0;
			played = false;
			var sourceUrl:String;
			switch(obj.pl){
				case 1:
					sourceUrl = "ui/dungeon/icon_d2.png"
					break;
				case 2:
					sourceUrl = "ui/dungeon/icon_c2.png"
					break;
				case 3:
					sourceUrl = "ui/dungeon/icon_b2.png"
					break;
				case 4:
					sourceUrl = "ui/dungeon/icon_a2.png"
					break;
				case 5:
					sourceUrl = "ui/dungeon/icon_s2.png"
					break;
			}
			copyId = obj.cid;
			expLbl.text = obj.exp;
			moneyLbl.text = obj.money;
			energyLbl.text = obj.energy;
			societyLbl.text = obj.bg;
			qualityImg.updateBmp(sourceUrl);
			var rewardList:Array = obj.rl;
			getId = rewardList.shift().iId;
			var length:int = grids.length;
			for (var n:int = 0; n < length; n++){
				var grid:CopyRewardGrid = grids[n];
				grid.updataInfo({itemId:rewardList[n].iId, count:rewardList[n].ic});
				if(getId == rewardList[n].iId){
					index = n;
				}
			}
		}
		
		/**
		 * <T>开始摇奖</T>
		 * 
		 */		
		protected function roll():void{
			played = true;
//			index  = (Math.random()*1000)%9;
			whirlContainer.rotation = 2*40 + 20;
			var rot:uint = 1440 + index*40 + whirlContainer.rotation;
			TweenLite.to(whirlContainer, 2, {rotation:rot, onComplete:rollOver});
			function rollOver():void{
				Cmd_SCP.cm_SCP_J(copyId);
				FlyManager.getInstance().flyBags([getId], [grids[index].localToGlobal(new Point(0, 0))]);
				DelayCallManager.getInstance().add(this, hide, "storyCopyReward", 50);
				beginBtn.setActive(false, 1, true);
			}
		}
	}
}
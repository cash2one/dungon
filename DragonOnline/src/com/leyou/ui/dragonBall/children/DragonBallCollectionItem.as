package com.leyou.ui.dragonBall.children
{
	import com.ace.enum.FilterEnum;
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.img.child.Image;
	import com.greensock.TweenMax;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Longz;
	import com.leyou.ui.market.child.MarketGrid;
	import com.leyou.utils.ItemUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class DragonBallCollectionItem extends Sprite
	{
		private static var speed:int = 10; 
		
		private var effectImg:Image;
		
		private var ballImg:Image;
		
		private var index:int;
		
//		private var beginX:int;
//		
//		private var beginY:int;
		
		private var _itemId:int;
		
		private var _itemNum:int;
		
		private var tips:TipsInfo;
		
		private var isTurnOn:Boolean;
		
		private var selectFun:Function;
		
		private var ballPanel:Sprite;
		
		private var gridPanel:Sprite;
		
		private var grid:MarketGrid;
		
		private var gridBg:Image;
		
		public function DragonBallCollectionItem(){
			init();
		}
		
		public function get itemId():int{
			return _itemId;
		}

		private function init():void{
			tips = new TipsInfo();
			
			ballPanel = new Sprite();
			addChild(ballPanel);
			effectImg = new Image("ui/dragonBall/guang.png");
			ballPanel.addChild(effectImg);
			ballImg = new Image();
			ballPanel.addChild(ballImg);
			ballImg.x = 20;
			ballImg.y = 20;
			ballPanel.addEventListener(MouseEvent.MOUSE_OVER, onMouseover);
			ballPanel.x = -49;
			ballPanel.y = -49;
			
			gridPanel = new Sprite();
			addChild(gridPanel);
			gridBg = new Image("ui/other/icon_prop_bigframe.png");
			gridPanel.addChild(gridBg);
			grid = new MarketGrid();
			grid.x = 11;
			grid.y = 11;
			grid.isShowPrice = false;
			gridPanel.addChild(grid);
			gridPanel.x = -45;
			gridPanel.y = -45;
			
			addEventListener(MouseEvent.CLICK, onMouseClick);
			
			isTurnOn = false;
			effectImg.visible = true;
			ballImg.filters = [FilterEnum.enable];
			ballPanel.filters = null;
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			if(1 == DataManager.getInstance().dragonBallData.status){
				var content:String = TableManager.getInstance().getSystemNotice(20005).content;
				PopupManager.showConfirm(content, selectItem, null, false, "dragon.ball.confirm");
			}
		}
		
		private function selectItem():void{
			Cmd_Longz.cm_Longz_W(index);
			if(null != selectFun){
				selectFun.call(this, this);
			}
		}
		
		protected function onMouseover(event:MouseEvent):void{
			if(itemId <= 0){
				return;
			}
			tips.itemid = itemId;
			var itemInfo:TItemInfo = TableManager.getInstance().getItemInfo(itemId);
			if((null != itemInfo) && (6 == itemInfo.classid)){
				var content:String = itemInfo.name;
				if(_itemNum > 10){
					content += ":"+_itemNum;
				}
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(this.stage.mouseX + 5, this.stage.mouseY + 5));
			}else{
				tips.isShowPrice = false;
				var info:TEquipInfo = TableManager.getInstance().getEquipInfo(tips.itemid);
				if(null != info){
					if(10 == info.classid){
						ToolTipManager.getInstance().show(TipEnum.TYPE_GEM_OTHER, tips, new Point(stage.mouseX, stage.mouseY));
						return;
					}
					var wear:Boolean = ItemUtil.showDiffTips(TipEnum.TYPE_EMPTY_ITEM, tips, new Point(stage.mouseX, stage.mouseY));
					if(!wear){
						ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, tips, new Point(stage.mouseX, stage.mouseY));							
					}
				}else{
					ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, tips, new Point(stage.mouseX, stage.mouseY));
				}
			}
		}
		
		public function updateInfo(n:int):void{
			index = n;
			ballImg.updateBmp("ui/dragonBall/icon_lz"+index+".png");
		}
		
		public function updateStatus($itemId:int, $itemNum:int):void{
			if((_itemId == $itemId) && (_itemNum == $itemNum)){
				return;
			}
			_itemId = $itemId;
			_itemNum = $itemNum;
			var status:int = DataManager.getInstance().dragonBallData.status;
			ballPanel.visible = (0 == status);
			gridPanel.visible = (1 == status);
			if(0 == status){
				if(_itemNum > 0){
					turnOn();
				}else{
					turnOff();
				}
			}else if(1 == status){
				grid.updataInfo({itemId:_itemId, count:_itemNum});
			}
		}
		
		private function turnOn():void{
			if(isTurnOn){
				return;
			}
			isTurnOn = true;
			ballImg.filters = null;
			effectImg.visible = false;
			TweenMax.to(ballPanel, 2, {glowFilter: {color: 0xFFD700, alpha: 1, blurX: 18, blurY: 18, strength: 4}, yoyo: true, repeat: -1});
		}
		
		private function turnOff():void{
			if(!isTurnOn){
				return;
			}
			isTurnOn = false;
			effectImg.visible = true;
			ballImg.filters = [FilterEnum.enable];
			TweenMax.killTweensOf(ballPanel);
			ballPanel.filters = null;
		}
		
		public function registerSelect(onChoice:Function):void{
			selectFun = onChoice;
		}
	}
}
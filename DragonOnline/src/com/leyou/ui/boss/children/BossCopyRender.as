package com.leyou.ui.boss.children
{
	import com.ace.enum.PlayerEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCopyInfo;
	import com.ace.gameData.table.TLivingInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.bossCopy.BossCopyBossData;
	import com.leyou.data.bossCopy.BossCopyData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_BCP;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class BossCopyRender extends AutoSprite
	{
		private static const GRID_COUNT:int = 12;
		
		private static const VIEW_PANEL_WIDTH:int = 479;
		
		private var timeLbl:Label;
		
		private var nameLbl:Label;
		
		private var pageLbl:Label;
		
		private var receiveImg:Image;
		
		private var addBtn:ImgButton;
		
		private var preBtn:ImgButton;
		
		private var nextBtn:ImgButton;
		
		private var enterBtn:ImgButton;
		
		private var items:Vector.<BossCopyColumnRender>;
		
		private var grids:Vector.<CopyRewardGrid>;
		
		private var big:SwfLoader;
		
		private var pannel:Sprite;
		
		private var currentIndex:int;
		
		private var threshold:int;
		
		private var currentBoss:BossCopyItemRender;
		
		public function BossCopyRender(){
			super(LibManager.getInstance().getXML("config/ui/boss/bossPlayerRender.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			timeLbl = getUIbyID("timeLbl") as Label;
			nameLbl = getUIbyID("nameLbl") as Label;
			pageLbl = getUIbyID("pageLbl") as Label;
			receiveImg = getUIbyID("receiveImg") as Image;
			addBtn = getUIbyID("addBtn") as ImgButton;
			preBtn = getUIbyID("preBtn") as ImgButton;
			nextBtn = getUIbyID("nextBtn") as ImgButton;
			enterBtn = getUIbyID("enterBtn") as ImgButton;
			
			addBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			preBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			nextBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			enterBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			
			big = new SwfLoader();
			big.mouseEnabled = false;
			big.x = 620;
			big.y = 220;
			addChild(big);
			swapChildren(nameLbl, big);
			
			pannel = new Sprite();
			pannel.x = 8;
			pannel.y = 54;
			pannel.scrollRect = new Rectangle(0, 0, VIEW_PANEL_WIDTH, 304);
			addChild(pannel);
			pannel.addEventListener(MouseEvent.CLICK, onBossClick);
			
			items = new Vector.<BossCopyColumnRender>();
			
			grids = new Vector.<CopyRewardGrid>();
			for(var n:int = 0; n < GRID_COUNT; n++){
				var grid:CopyRewardGrid = new CopyRewardGrid();
				if(n < 4){
					grid.x = 539 + n%4*52;
					grid.y = 278;
				}else{
					grid.x = 539 + n%4*52;
					grid.y = 345 + (int(n/4)-1)*44;
				}
				addChildAt(grid, 23);
				grids[n] = grid;
			}
			addChild(receiveImg);
			x = 3;
			y = 3;
		}
		
		protected function onBossClick(event:MouseEvent):void{
			var render:BossCopyItemRender = event.target as BossCopyItemRender;
			if(null != render){
				showBoss(render);
			}
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "addBtn":
					var costyb:int = DataManager.getInstance().bossCopyData.costyb;
//					var costbyb:int = DataManager.getInstance().bossCopyData.costbyb;
					var content:String = TableManager.getInstance().getSystemNotice(4904).content;
//					content = StringUtil.substitute(content, cost)
					PopupManager.showRadioIIConfirm(content, costyb+"", ConfigEnum.Dekaron_Fb11.split("|")[0], confirmAdd, null, false, "bossCpy.add");
					break;
				case "preBtn":
					previousColumn();
					break;
				case "nextBtn":
					nextColumn();
					break;
				case "enterBtn":
					Cmd_BCP.cm_BCP_E(currentBoss.bossData.id);
					break;
			}
		}
		
		private function confirmAdd(type:int):void{
			Cmd_BCP.cm_BCP_A(type);
		}
		
		/**
		 * <T>要滚动到的位置</T>
		 * 
		 * @param $threshold 滚动位置
		 * 
		 */		
		protected function scrollToX($threshold:int):void{
			threshold = $threshold;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
//			preBtn.visible = (threshold > 0);
//			nextBtn.visible = (threshold < (items.length-3)*(VIEW_PANEL_WIDTH/3));
		}
		
		protected function onEnterFrame(event:Event):void{
			var rect:Rectangle = pannel.scrollRect;
			var dValue:int = threshold - rect.x;
			if(Math.abs(dValue) < 21.75){
				rect.x = threshold;
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
//				var item:BossCopyRender = items[currentPage*3];
//				item.select = true;
//				if(null != selectedBoss){
//					selectedBoss.select = false;
//				}
//				item.select = true;
//				selectedBoss = item;
//				showBoss(item.bossData);
			}else if(dValue > 21.75){
				rect.x += 21.75;
			}else if(dValue < 21.75){
				rect.x -= 21.75;
			}
			pannel.scrollRect = rect;
		}
		
		/**
		 * <T>展示boss</T>
		 * 
		 */	
		public function showBoss(bossRender:BossCopyItemRender):void{
			if(null != currentBoss){
				currentBoss.select = false;
			}
			currentBoss = bossRender;
			currentBoss.select = true;
			var bossData:BossCopyBossData = bossRender.bossData;
			var copyInfo:TCopyInfo = TableManager.getInstance().getCopyInfo(bossData.id);
			var mInfo:TLivingInfo = TableManager.getInstance().getLivingInfo(copyInfo.monsterId);
			var radis:int = TableManager.getInstance().getPnfInfo(mInfo.pnfId).radius
			big.update(mInfo.pnfId);
			
			nameLbl.text = copyInfo.name;
//			nameLbl.x = big.x - nameLbl.width * 0.5;
//			nameLbl.y = big.y - 2 * radis;
			
			big.playAct(PlayerEnum.ACT_STAND, PlayerEnum.DIR_ES);
			receiveImg.visible = bossData.isFirst;
			var rc:int = grids.length;
			for(var n:int = 0; n < rc; n++){
				grids[n].clear();
			}
			var index:int = 0;
			if(copyInfo.firstEXP > 0){
				grids[index++].updataInfo({itemId:65534, count:copyInfo.firstEXP});
			}
			if(copyInfo.firstEnergy > 0){
				grids[index++].updataInfo({itemId:65533, count:copyInfo.firstEnergy});
			}
			if(copyInfo.firstMoney > 0){
				grids[index++].updataInfo({itemId:65535, count:copyInfo.firstMoney});
			}
			if(copyInfo.firstItem1 > 0){
				grids[index++].updataInfo({itemId:copyInfo.firstItem1, count:copyInfo.firstItemCount1});
			}
			if(copyInfo.firstItem2 > 0){
				grids[index++].updataInfo({itemId:copyInfo.firstItem2, count:copyInfo.firstItemCount2});
			}
			index = 4;
			if(copyInfo.item1Data[0] > 0){
				grids[index++].updataInfo({itemId:copyInfo.item1Data[0], count:copyInfo.item1Data[1]});
			}
			if(copyInfo.item2Data[0] > 0){
				grids[index++].updataInfo({itemId:copyInfo.item2Data[0], count:copyInfo.item2Data[1]});
			}
			if(copyInfo.item3Data[0] > 0){
				grids[index++].updataInfo({itemId:copyInfo.item3Data[0], count:copyInfo.item3Data[1]});
			}
			if(copyInfo.item4Data[0] > 0){
				grids[index++].updataInfo({itemId:copyInfo.item4Data[0], count:copyInfo.item4Data[1]});
			}
			if(copyInfo.item5Data[0] > 0){
				grids[index++].updataInfo({itemId:copyInfo.item5Data[0], count:copyInfo.item5Data[1]});
			}
			if(copyInfo.item6Data[0] > 0){
				grids[index++].updataInfo({itemId:copyInfo.item6Data[0], count:copyInfo.item6Data[1]});
			}
			if(copyInfo.item7Data[0] > 0){
				grids[index++].updataInfo({itemId:copyInfo.item7Data[0], count:copyInfo.item7Data[1]});
			}
			if(copyInfo.item8Data[0] > 0){
				grids[index++].updataInfo({itemId:copyInfo.item8Data[0], count:copyInfo.item8Data[1]});
			}
		}
		
		protected function nextColumn():void{
			if(currentIndex < items.length-3){
				scrollToX(++currentIndex*(VIEW_PANEL_WIDTH/3));
			}
		}
		
		protected function previousColumn():void{
			if(currentIndex > 0){
				scrollToX(--currentIndex*(VIEW_PANEL_WIDTH/3));
			}
		}
		
		public function updateView():void{
			var data:BossCopyData = DataManager.getInstance().bossCopyData;
			var count:int = Math.ceil(data.getCount()/3);
			items.length = count;
			for(var n:int = 0; n < count; n++){
				var colItem:BossCopyColumnRender = items[n];
				if(null == colItem){
					colItem = new BossCopyColumnRender();
					items[n] = colItem;
				}
				colItem.x = n * int(VIEW_PANEL_WIDTH/3+1);   //int(n/3)*VIEW_PANEL_WIDTH + (n%3)*(VIEW_PANEL_WIDTH/3);
				pannel.addChild(colItem);
				for(var m:int = 0; m < BossCopyColumnRender.COL_COUNT; m++){
					colItem.updateInfo(data.getBossData(n*3+m), data.getBossData(n*3+m-1), m);
				}
				var currentItem:BossCopyItemRender = colItem.getCurrentItem();
				if(null != currentItem){
					showBoss(currentItem);
					currentIndex = n;
					if(currentIndex > items.length-3){
						currentIndex = items.length-3;
					}
					scrollToX(currentIndex*(VIEW_PANEL_WIDTH/3));
				}
			}
//			items[0].setSelect(0);
		}
		
		public function updateCount():void{
			timeLbl.text = DataManager.getInstance().bossCopyData.remainCount+"";
		}
		
		public function removeGuide():void{
			GuideManager.getInstance().removeGuide(64);
		}
	}
}
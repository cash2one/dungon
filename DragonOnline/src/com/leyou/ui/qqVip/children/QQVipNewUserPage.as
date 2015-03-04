package com.leyou.ui.qqVip.children
{
	import com.ace.enum.FilterEnum;
	import com.ace.enum.ItemEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TQQVipNewRewardInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.leyou.data.qqvip.QQVipData;
	import com.leyou.net.cmd.Cmd_QQVip;
	import com.leyou.ui.mail.child.MaillGrid;
	
	import flash.events.MouseEvent;
	
	public class QQVipNewUserPage extends AutoSprite
	{
		private var receiveBtn:ImgButton;
		
		private var receiveImg:Image;
		
		private var grids:Vector.<MaillGrid>;
		
		public function QQVipNewUserPage(){
			super(LibManager.getInstance().getXML("config/ui/qqVip/qqVipNew.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			receiveBtn = getUIbyID("receiveBtn") as ImgButton;
			receiveImg = getUIbyID("receiveImg") as Image;
			grids = new Vector.<MaillGrid>();
			for(var n:int = 0; n < 5; n++){
				var grid:MaillGrid = new MaillGrid();
				addChild(grid);
				grids.push(grid);
				grid.x = 90 + 50*n;
				grid.y = 122;
			}
			initTable();
			receiveBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			addChild(receiveImg);
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){			
				case "receiveBtn":
					Cmd_QQVip.cm_TX_J();
					break;
			}
		}
		
		private function initTable():void{
			var rewardInfo:TQQVipNewRewardInfo = TableManager.getInstance().getQQNewInfo(1);
			var index:int = 0;
			var grid:MaillGrid;
			if(rewardInfo.exp > 0){
				grid = grids[index++];
				grid.updateInfo(ItemEnum.EXP_VIR_ITEM_ID, rewardInfo.exp);
			}
			if(rewardInfo.money > 0){
				grid = grids[index++];
				grid.updateInfo(ItemEnum.MONEY_VIR_ITEM_ID, rewardInfo.money);
			}
			if(rewardInfo.energy > 0){
				grid = grids[index++];
				grid.updateInfo(ItemEnum.ENERGY_VIR_ITEM_ID, rewardInfo.energy);
			}
			if(rewardInfo.byb > 0){
				grid = grids[index++];
				grid.updateInfo(ItemEnum.BYB_VIR_ITEM_ID, rewardInfo.byb);
			}
			if(rewardInfo.lp > 0){
				grid = grids[index++];
				grid.updateInfo(ItemEnum.BG_VIR_ITEM_ID, rewardInfo.lp);
			}
			if(rewardInfo.item1 > 0){
				grid = grids[index++];
				grid.updateInfo(rewardInfo.item1, rewardInfo.item1Num);
			}
			if(rewardInfo.item2 > 0){
				grid = grids[index++];
				grid.updateInfo(rewardInfo.item2, rewardInfo.item2Num);
			}
			if(rewardInfo.item3 > 0){
				grid = grids[index++];
				grid.updateInfo(rewardInfo.item3, rewardInfo.item3Num);
			}
			if(rewardInfo.item4 > 0){
				grid = grids[index++];
				grid.updateInfo(rewardInfo.item4, rewardInfo.item4Num);
			}
		}
		
		public function setGrid(enable:Boolean):void{
			for each(var grid:MaillGrid in grids){
				if(null != grid){
					grid.filters = enable ? null : [FilterEnum.enable];
				}
			}
		}
		
		public function updateInfo():void{
			var data:QQVipData = DataManager.getInstance().qqvipData;
			var r:Boolean = (0 == data.nStatus);
			receiveBtn.setActive(r, 1, true);
			receiveImg.visible = (1 == data.nStatus);
			setGrid(!receiveImg.visible);
		}
	}
}
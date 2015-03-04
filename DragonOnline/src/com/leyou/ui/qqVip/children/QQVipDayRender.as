package com.leyou.ui.qqVip.children
{
	import com.ace.enum.FilterEnum;
	import com.ace.enum.ItemEnum;
	import com.ace.gameData.table.TQQVipDayRewardInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.utils.StringUtil;
	import com.leyou.data.qqvip.QQVipData;
	import com.leyou.net.cmd.Cmd_QQVip;
	import com.leyou.ui.mail.child.MaillGrid;
	
	import flash.events.MouseEvent;
	
	public class QQVipDayRender extends AutoSprite
	{
		private var vipLvImg:Image;
		
		private var receiveBtn:ImgButton;
		
		private var receiveImg:Image;
		
		private var gridImgs:Vector.<Image>;
		
		private var grids:Vector.<MaillGrid>;
		
		private var vipLv:int;
		
		public function QQVipDayRender(){
			super(LibManager.getInstance().getXML("config/ui/qqVip/qqVipDayBar.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			gridImgs = new Vector.<Image>();
			gridImgs.push(getUIbyID("grid1Img"));
			gridImgs.push(getUIbyID("grid2Img"));
			gridImgs.push(getUIbyID("grid3Img"));
			gridImgs.push(getUIbyID("grid4Img"));
			vipLvImg = getUIbyID("vipLvImg") as Image;
			receiveImg = getUIbyID("receiveImg") as Image;
			receiveBtn = getUIbyID("receiveBtn") as ImgButton;
			
			grids = new Vector.<MaillGrid>();
			for(var n:int = 0; n < 3; n++){
				var grid:MaillGrid = new MaillGrid();
				addChild(grid);
				grid.isShowPrice = false;
				grids.push(grid);
				grid.x = 40 + 42*n;
				grid.y = 4;
			}
			addChild(receiveImg);
			receiveBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "receiveBtn":
					Cmd_QQVip.cm_TX_X(1);
					break;
			}
		}
		
		public function updateTableInfo(rewardInfo:TQQVipDayRewardInfo):void{
			vipLv = rewardInfo.vipLv;
			var index:int = 0;
			var url:String = StringUtil.substitute("ui/name/qq_vip_0{1}.png", rewardInfo.vipLv);
			vipLvImg.updateBmp(url);
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
		
		public function updateStatus(data:QQVipData):void{
			var r:Boolean = (data.vipLevel == vipLv) && (0 == data.dStatus);
			receiveImg.visible = (data.vipLevel == vipLv) && (1 == data.dStatus);
			receiveBtn.setActive(r, 1, true);
			setGrid(!receiveImg.visible);
		}
	}
}
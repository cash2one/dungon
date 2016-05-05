package com.leyou.ui.missionMarket.children
{
	import com.ace.enum.ItemEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TMissionMarketInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.missinMarket.MissionMarketTaskData;
	import com.leyou.net.cmd.Cmd_TaskMarket;
	import com.leyou.ui.mail.child.MaillGrid;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class MissionMarketSingleItem extends AutoSprite
	{
		private var nameLbl:Label;
		
		private var desLbl:Label;
		
		private var progressLbl:Label;
		
		private var completeImg:Image;
		
		private var receiveBtn:NormalButton;
		
		private var grids:Vector.<MaillGrid>;
		
		private var type:int;
		
		private var _id:int;
		
		public function MissionMarketSingleItem(){
			super(LibManager.getInstance().getXML("config/ui/missionMarket/missionabarBtn2.xml"));
			init();
		}
		
		public function get id():int
		{
			return _id;
		}

		private function init():void{
			mouseEnabled = true;
			mouseChildren = true;
			nameLbl = getUIbyID("nameLbl") as Label;
			desLbl = getUIbyID("desLbl") as Label;
			progressLbl = getUIbyID("progressLbl") as Label;
			completeImg = getUIbyID("completeImg") as Image;
			receiveBtn = getUIbyID("receiveBtn") as NormalButton;
			
			grids = new Vector.<MaillGrid>();
			for (var n:int=0; n < 3; n++) {
				var grid:MaillGrid = new MaillGrid();
				grid.x = 51 + 48 * n;
				grid.y = 81;
				addChild(grid);
				grids.push(grid);
			}
			addChild(completeImg);
			
			receiveBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			Cmd_TaskMarket.cm_TaskMarket_T(type, id);
		}
		
		public function flyItem():void{
			var ids:Array = [];
			var starts:Array = [];
			for  each(var grid:MaillGrid in grids){
				if(grid.visible && (0 != grid.dataId) && (ItemEnum.ENERGY_VIR_ITEM_ID == grid.dataId) && (ItemEnum.EXP_VIR_ITEM_ID == grid.dataId)){
					ids.push(grid.dataId);
					starts.push(grid.localToGlobal(new Point(0, 0)));
				}
			}
			FlyManager.getInstance().flyBags(ids, starts);
		}
		
		public function updateInfo(mdata:MissionMarketTaskData):void{
			_id = mdata.tid;
			var rewardInfo:TMissionMarketInfo = TableManager.getInstance().getMissionMarketInfo(mdata.tid);
			type = rewardInfo.type;
			nameLbl.text = rewardInfo.name;
			desLbl.text = rewardInfo.des;
			if(mdata.ps >= rewardInfo.need){
				progressLbl.text = rewardInfo.need + "/" + rewardInfo.need;
			}else{
				progressLbl.text = mdata.ps + "/" + rewardInfo.need;
			}
			
			var finished:Boolean = (mdata.ps >= rewardInfo.need);
			completeImg.visible = finished && (1 == mdata.st);
			if(finished){
				receiveBtn.text = (0 == mdata.st) ? "领取奖励" : "已领取";
				receiveBtn.setActive((0 == mdata.st), 1, true);
			}else{
				receiveBtn.text = "未完成";
				receiveBtn.setActive(false, 1, true);
			}
			var index:int;
			var grid:MaillGrid;
			if (rewardInfo.exp > 0) {
				grid=grids[index++];
				grid.updateInfo(ItemEnum.EXP_VIR_ITEM_ID, rewardInfo.exp);
			}
			if (rewardInfo.money > 0) {
				grid=grids[index++];
				grid.updateInfo(ItemEnum.MONEY_VIR_ITEM_ID, rewardInfo.money);
			}
			if (rewardInfo.energy > 0) {
				grid=grids[index++];
				grid.updateInfo(ItemEnum.ENERGY_VIR_ITEM_ID, rewardInfo.energy);
			}
			if (rewardInfo.byb > 0) {
				grid=grids[index++];
				grid.updateInfo(ItemEnum.BYB_VIR_ITEM_ID, rewardInfo.byb);
			}
			if (rewardInfo.lp > 0) {
				grid=grids[index++];
				grid.updateInfo(ItemEnum.BG_VIR_ITEM_ID, rewardInfo.lp);
			}
			if (rewardInfo.item1 > 0) {
				grid=grids[index++];
				grid.updateInfo(rewardInfo.item1, rewardInfo.item1Num);
			}
			if (rewardInfo.item2 > 0) {
				grid=grids[index++];
				grid.updateInfo(rewardInfo.item2, rewardInfo.item2Num);
			}
			if (rewardInfo.item3 > 0) {
				grid=grids[index++];
				grid.updateInfo(rewardInfo.item3, rewardInfo.item3Num);
			}
			if (rewardInfo.honor > 0) {
				grid=grids[index++];
				grid.updateInfo(ItemEnum.HONOUR_VIR_ITEM_ID, rewardInfo.honor);
			}
		}
	}
}
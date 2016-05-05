package com.leyou.ui.missionMarket.children
{
	import com.ace.enum.ItemEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TMissionMarketRewardInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.greensock.TweenMax;
	import com.leyou.data.missinMarket.MissionMarketChapterData;
	import com.leyou.net.cmd.Cmd_TaskMarket;
	import com.leyou.ui.mail.child.MaillGrid;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class MissionMarketItem extends AutoSprite
	{
		private var bgImg:Image;
		
		private var selectImg:Image;
		
		private var completeImg:Image;
		
		private var receiveBtn:NormalButton;
		
		private var switchFun:Function;
		
		public var type:int;
		
		public var receiveAble:Boolean;
		
		private var grids:Vector.<MaillGrid>;
		
		public function MissionMarketItem(){
			super(LibManager.getInstance().getXML("config/ui/missionMarket/missionabarBtn1.xml"));
			init();
		}
		
		public function registerSwitch(fun:Function):void{
			switchFun = fun;
		}
		
		private function init():void{
			mouseEnabled = true;
			mouseChildren = true;
			bgImg = getUIbyID("bgImg") as Image;
			selectImg = getUIbyID("selectImg") as Image;
			completeImg = getUIbyID("completeImg") as Image;
			receiveBtn = getUIbyID("receiveBtn") as NormalButton;
			selectImg.visible = false;
			
			addEventListener(MouseEvent.CLICK, onMouseClick);
			
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			grids = new Vector.<MaillGrid>();
			for (var n:int=0; n < 3; n++) {
				var grid:MaillGrid = new MaillGrid();
				grid.x = 19 + 48 * n;
				grid.y = 258;
				addChild(grid);
				grids.push(grid);
			}
		}
		
		protected function onMouseOut(event:MouseEvent):void{
			selectImg.visible = false;
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			selectImg.visible = true;
		}
		
		
		public function updateInfo(data:MissionMarketChapterData):void{
			type = data.type;
			bgImg.updateBmp("ui/missionbar/mk_bg_"+type+".jpg");
			var finished:Boolean = (data.finishedNum == data.totalNum);
			completeImg.visible = finished && (1 == data.status);
			if(data.jlc > 0){
				TweenMax.to(this, 2, {glowFilter: {color: 0xFFD700, alpha: 1, blurX: 18, blurY: 18, strength: 4}, yoyo: true, repeat: -1});
			}else{
				TweenMax.killTweensOf(this);
				this.filters = null;
			}
			if(finished){
				receiveBtn.text = (0 == data.status) ? "领取奖励" : "已领取";
				receiveBtn.setActive((0 == data.status), 1, true);
				
			}else{
				receiveBtn.text = "未完成";
				receiveBtn.setActive(false, 1, true);
			}
			var rewardInfo:TMissionMarketRewardInfo = TableManager.getInstance().getMissionMarketRewardInfo(type);
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
			if (rewardInfo.item4 > 0) {
				grid=grids[index++];
				grid.updateInfo(rewardInfo.item4, rewardInfo.item4Num);
			}
			
			if (rewardInfo.item5 > 0) {
				grid=grids[index++];
				grid.updateInfo(rewardInfo.item5, rewardInfo.item5Num);
			}
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
		
		protected function onMouseClick(event:MouseEvent):void{
			if(event.target != receiveBtn){
				// 进入详细任务
				if(null != switchFun){
					switchFun.call(this, type);
				}
			}else{
				// 领取奖励
				Cmd_TaskMarket.cm_TaskMarket_J(type);
			}
		}
	}
}
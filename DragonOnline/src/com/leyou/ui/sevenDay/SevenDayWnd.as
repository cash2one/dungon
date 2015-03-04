package com.leyou.ui.sevenDay
{
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TSevenDayRewardInfo;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.utils.StringUtil;
	import com.leyou.data.sevenDay.SevenDayData;
	import com.leyou.data.sevenDay.SevenDayTask;
	import com.leyou.data.sevenDay.SevenDayTaskData;
	import com.leyou.net.cmd.Cmd_Seven;
	import com.leyou.ui.market.child.MarketGrid;
	import com.leyou.ui.sevenDay.child.SevenDayRender;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class SevenDayWnd extends AutoWindow
	{
		private var dayImg:Image;
		
		private var receiveBtn:ImgButton;
		
		private var oneBtn:ImgButton;
		
		private var twoBtn:ImgButton;
		
		private var threeBtn:ImgButton;
		
		private var fourBtn:ImgButton;
		
		private var fiveBtn:ImgButton;
		
		private var sixBtn:ImgButton;
		
		private var sevenBtn:ImgButton;
		
		private var viewPanel:ScrollPane;
		
		private var items:Vector.<SevenDayRender>;
		
		private var grids:Vector.<MarketGrid>;
		
		private var gridImgs:Vector.<Image>;
		
		public var showDay:int;
		
		private var remainLbl:Label;
		
		private var lastBtn:ImgButton;
		
		public function SevenDayWnd(){
			super(LibManager.getInstance().getXML("config/ui/sevenDay/sevendWnd.xml"));
			init();
		}
		
		private function init():void{
			items = new Vector.<SevenDayRender>();
			dayImg = getUIbyID("dayImg") as Image;
			receiveBtn = getUIbyID("receiveBtn") as ImgButton;
			oneBtn = getUIbyID("oneBtn") as ImgButton;
			twoBtn = getUIbyID("twoBtn") as ImgButton;
			threeBtn = getUIbyID("threeBtn") as ImgButton;
			fourBtn = getUIbyID("fourBtn") as ImgButton;
			fiveBtn = getUIbyID("fiveBtn") as ImgButton;
			sixBtn = getUIbyID("sixBtn") as ImgButton;
			sevenBtn = getUIbyID("sevenBtn") as ImgButton;
			viewPanel = getUIbyID("viewPanel") as ScrollPane;
			remainLbl = getUIbyID("remainLbl") as Label;
			
			oneBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			twoBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			threeBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			fourBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			fiveBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			sixBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			sevenBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			receiveBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			gridImgs = new Vector.<Image>(4);
			grids = new Vector.<MarketGrid>(4);
			for(var n:int = 0; n < 4; n++){
				var grid:MarketGrid = new MarketGrid();
				grid.isShowPrice = false;
				grid.x = 166 + 97*n;
				grid.y = 82;
				pane.addChild(grid);
				grids[n] = grid;
				gridImgs[n] = getUIbyID("gridImg"+n) as Image;
			}
			oneBtn.turnOn(false);
			lastBtn = oneBtn;
		}
		
		public function resize():void{
			this.x=(UIEnum.WIDTH - this.width) / 2;
			this.y=(UIEnum.HEIGHT - this.height) / 2;
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			var tmpDay:int;
			var tmpBtn:ImgButton;
			switch(event.target.name){
				case "oneBtn":
					tmpDay = 1;
					tmpBtn = oneBtn;
					break;
				case "twoBtn":
					tmpDay = 2;
					tmpBtn = twoBtn;
					break;
				case "threeBtn":
					tmpDay = 3;
					tmpBtn = threeBtn;
					break;
				case "fourBtn":
					tmpDay = 4;
					tmpBtn = fourBtn;
					break;
				case "fiveBtn":
					tmpDay = 5;
					tmpBtn = fiveBtn;
					break;
				case "sixBtn":
					tmpDay = 6;
					tmpBtn = sixBtn;
					break;
				case "sevenBtn":
					tmpDay = 7;
					tmpBtn = sevenBtn;
					break;
				case "receiveBtn":
					Cmd_Seven.cm_SEVD_D();
					break;
			}
			if((null != tmpBtn) && (null != lastBtn)){
				lastBtn.turnOff(true);
			}
			if(null != tmpBtn){
				lastBtn = tmpBtn;
				lastBtn.turnOn(true);
			}
			if((0 != tmpDay) && (tmpDay != showDay)){
				showDay = tmpDay;
				Cmd_Seven.cm_SEVD_I(showDay);
			}
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, toCenter);
//			showDay = DataManager.getInstance().sevenDayData.currentDay;
//			Cmd_Seven.cm_SEVD_I(showDay);
			GuideManager.getInstance().removeGuide(82);
		}
		
		public function showReward(day:int):void{
			dayImg.updateBmp("ui/7d/7d_img_0"+day+".png");
			var dayTask:SevenDayTaskData = DataManager.getInstance().sevenDayData.getDayTaskInfo(showDay);
			remainLbl.text = StringUtil.substitute("剩余{num}个任务未完成", dayTask.unfinishCount);
			var rewardInfo:TSevenDayRewardInfo = TableManager.getInstance().getSevenDayRewardInfo(day);
			for(var n:int = 0; n < 4; n++){
				if(null != grids[n]){
					grids[n].clear();
					grids[n].visible = false;
				}
				gridImgs[n].visible = false;
			}
			var index:int = 0;
			var grid:MarketGrid = grids[index];
			if(rewardInfo.rMoney > 0){
				grid.visible = true;
				gridImgs[index].visible = true;
				grid.updataInfo({itemId:65535, count:rewardInfo.rMoney});
				index++;
			}
			if(rewardInfo.rEnergy > 0){
				grid = grids[index];
				grid.visible = true;
				gridImgs[index].visible = true;
				grid.updataInfo({itemId:65533, count:rewardInfo.rEnergy});
				index++;
			}
			if(rewardInfo.rbib > 0){
				grid = grids[index];
				grid.visible = true;
				gridImgs[index].visible = true;
				grid.updataInfo({itemId:65532, count:rewardInfo.rbib});
				index++;
			}
			if(rewardInfo.rExp > 0){
				grid = grids[index];
				grid.visible = true;
				gridImgs[index].visible = true;
				grid.updataInfo({itemId:65534, count:rewardInfo.rExp});
				index++;
			}
			if(rewardInfo.rlp > 0){
				grid = grids[index];
				grid.visible = true;
				gridImgs[index].visible = true;
				grid.updataInfo({itemId:65531, count:rewardInfo.rlp});
				index++;
			}
			if(rewardInfo.item1 > 0 && rewardInfo.item1Count > 0){
				grid = grids[index];
				grid.visible = true;
				gridImgs[index].visible = true;
				grid.updataInfo({itemId:rewardInfo.item1, count:rewardInfo.item1Count});
				index++;
			}
			if(rewardInfo.item2 > 0 && rewardInfo.item2Count > 0){
				grid = grids[index];
				grid.visible = true;
				gridImgs[index].visible = true;
				grid.updataInfo({itemId:rewardInfo.item2, count:rewardInfo.item2Count});
				index++;
			}
			if(rewardInfo.item3 > 0 && rewardInfo.item3Count > 0){
				grid = grids[index];
				grid.visible = true;
				gridImgs[index].visible = true;
				grid.updataInfo({itemId:rewardInfo.item3, count:rewardInfo.item3Count});
				index++;
			}
			if(rewardInfo.item4 > 0 && rewardInfo.item4Count > 0){
				grid = grids[index];
				grid.visible = true;
				gridImgs[index].visible = true;
				grid.updataInfo({itemId:rewardInfo.item4, count:rewardInfo.item4Count});
				index++;
			}
		}
		
		private function nvlViewCount(count:int):void{
			if(items.length > count){
				var l:int = items.length;
				for(var n:int = count-1; n < l; n++){
					if(viewPanel.contains(items[n])){
						viewPanel.delFromPane(items[n]);
					}
				}
				viewPanel.scrollTo(0);
				viewPanel.updateUI();
			}else{
				items.length = count;
			}
		}
		
		public function updateInfo():void{
			var sevenDayData:SevenDayData = DataManager.getInstance().sevenDayData;
			var currentDay:int = sevenDayData.currentDay;
			oneBtn.setActive((currentDay <= 1), 1, true);
			twoBtn.setActive((currentDay <= 2), 1, true);
			threeBtn.setActive((currentDay <= 3), 1, true);
			fourBtn.setActive((currentDay <= 4), 1, true);
			fiveBtn.setActive((currentDay <= 5), 1, true);
			sixBtn.setActive((currentDay <= 6), 1, true);
			sevenBtn.setActive((currentDay <= 7), 1, true);
			if(0 >= showDay){
				showDay = DataManager.getInstance().sevenDayData.currentDay;
			}
			var dayReceiveAble:Boolean = (showDay == currentDay) && (1 == sevenDayData.currentDayStatus);
			receiveBtn.setActive(dayReceiveAble, 1, true);
			var dayTask:SevenDayTaskData = sevenDayData.getDayTaskInfo(showDay);
			var count:int = dayTask.taskCount();
			nvlViewCount(count);
			for(var n:int = 0; n < count; n++){
				var task:SevenDayTask = dayTask.getTask(n);
				var item:SevenDayRender = getViewItem(n);
				item.updateInfo(task);
			}
			var cBtn:ImgButton;
			switch(showDay){
				case 1:
					cBtn = oneBtn;
					break;
				case 2:
					cBtn = twoBtn;
					break;
				case 3:
					cBtn = threeBtn;
					break;
				case 4:
					cBtn = fourBtn;
					break;
				case 5:
					cBtn = fiveBtn;
					break;
				case 6:
					cBtn = sixBtn;
					break;
				case 7:
					cBtn = sevenBtn;
					break;
			}
			if((null != lastBtn) && (lastBtn != cBtn)){
				lastBtn.turnOff();
				lastBtn = cBtn;
				lastBtn.turnOn();
			}
			showReward(showDay);
		}
		
		public function flyTaskItem(id:int):void{
			var l:int = items.length;
			for(var n:int = 0; n < l; n++){
				if(id == items[n].linkId){
					items[n].flyItem();
					break;
				}
			}
		}
		
		public function flyDayItem():void{
			var ids:Array = [];
			var starts:Array = [];
			for  each(var grid:MarketGrid in grids){
				if(grid.visible && (0 != grid.dataId)){
					ids.push(grid.dataId);
					starts.push(grid.localToGlobal(new Point(0, 0)));
				}
			}
			FlyManager.getInstance().flyBags(ids, starts);
		}
		
		public override function get width():Number{
			return 724;
		}
		
		private function getViewItem(index:int):SevenDayRender{
			var item:SevenDayRender = items[index];
			if(null == item){
				item = new SevenDayRender();
				items[index] = item;
			}
			item.y = index * 70/*item.height*/;
			viewPanel.addToPane(item);
			return item;
		}
	}
}
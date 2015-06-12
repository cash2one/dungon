package com.leyou.ui.onlineReward
{
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.TimeManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.online.OnlineRewardData;
	import com.leyou.net.cmd.Cmd_ONL;
	import com.leyou.ui.market.child.MarketGrid;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	public class OnlineRewardWnd extends AutoWindow
	{
		private var timeLbl:Label;
		
		private var closeBtn:ImgButton;
		
		private var tick:uint;
		
		private var remain:int;
		
		private var grids:Vector.<MarketGrid>;
		
		private var receiveImg:Image;
		
		private var receiveBtn:ImgButton;
		
		private var flyIds:Array;
		
		private var starts:Array;
		
		public function OnlineRewardWnd(){
			super(LibManager.getInstance().getXML("config/ui/timeReward/timeGiftPanel.xml"));
			init();
		}
		
		private function init():void{
			flyIds = [];
			starts = [];
			visible = false;
			mouseChildren = true;
			closeBtn = getUIbyID("closeBtn") as ImgButton;
			timeLbl = getUIbyID("timeLbl") as Label;
			receiveImg = getUIbyID("receiveImg") as Image;
			receiveBtn = getUIbyID("receiveBtn") as ImgButton;
			receiveBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			hideBg();
			clsBtn.visible = false;
			closeBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			grids = new Vector.<MarketGrid>();
			for(var n:int = 0; n < 4; n++){
				var grid:MarketGrid = new MarketGrid();
				grid.isShowPrice = false;
				grid.x = 230 + n*92;
				grid.y = 139;
				addChild(grid);
				grids.push(grid);
			}
		}
		
		public function flyItem():void{
			if(0 != flyIds.length){
				FlyManager.getInstance().flyBags(flyIds, starts);
			}
		}
		
		protected function onBtnClick(event:Event):void{
			var n:String = event.target.name;
			switch(n){
				case "closeBtn":
					hide();
					break;
				case "receiveBtn":
					setFlyItem();
					Cmd_ONL.cm_ONL_J();
					hide();
					break;
			}
		}
		
		private function setFlyItem():void{
			flyIds.length = 0;
			starts.length = 0;
			for each(var grid:MarketGrid in grids){
				if(0 != grid.dataId){
					flyIds.push(grid.dataId);
					starts.push(grid.localToGlobal(new Point(0, 0)));
				}
			}
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, toCenter);
			if(!TimeManager.getInstance().hasITick(updateTime)){
				TimeManager.getInstance().addITick(1000, updateTime);
			}
			updateInfo();
		}
		
		public function updateInfo():void{
			var data:OnlineRewardData = DataManager.getInstance().onlineRewardData;
			tick = getTimer();
			remain = data.remianT();
			var index:int = 0;
			var byb:int = data.byb;
			var money:int = data.money;
			if(byb > 0){
				grids[index++].updataInfo({itemId:65532, count:byb});
			}
			if(money > 0){
				grids[index++].updataInfo({itemId:65535, count:money});
			}
			var items:Array = data.items;
			var length:int = grids.length;
			for(var n:int = index; n < length; n++){
				var item:Array = items[n-index];
				if(null != item){
					grids[n].updataInfo({itemId:item[0], count:item[1]});
				}
			}
			var receivable:Boolean = (remain > 0);
			receiveBtn.visible = !receivable;
			receiveImg.visible = !receivable;
			timeLbl.visible = receivable;
			updateTime();
		}
		
		public function updateTime():void{
			var tt:int = remain - (getTimer() - tick)/1000;
			var hour:int = tt/3600;
			hour = (hour > 0) ? hour : 0;
			var minutes:int = tt/60%60;
			minutes = (minutes > 0) ? minutes : 0;
			var seconds:int = tt%60;
			seconds = (seconds > 0) ? seconds : 0;
			timeLbl.text = StringUtil_II.lpad(hour+"", 2, "0") + ":" + StringUtil_II.lpad(minutes+"", 2, "0") + ":" + StringUtil_II.lpad(seconds+"", 2, "0");
			if(hour <= 0 && minutes <= 0 && seconds <= 0){
				receiveBtn.visible = true;
				receiveImg.visible = true;
				timeLbl.visible = false;
			}
		}
		
		public override function hide():void{
			super.hide();
			if(TimeManager.getInstance().hasITick(updateTime)){
				TimeManager.getInstance().removeITick(updateTime);
			}
		}
		
		public function resize():void{
//			x = UIManager.getInstance().onlineReward.x - width;
//			y = UIManager.getInstance().onlineReward.y;
		}
	}
}
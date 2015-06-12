package com.leyou.ui.missionMarket
{
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.TimeManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.lable.Label;
	import com.leyou.data.missinMarket.MissionMarketData;
	import com.leyou.net.cmd.Cmd_TaskMarket;
	import com.leyou.ui.missionMarket.children.MissionMarketRender;
	import com.leyou.ui.missionMarket.children.MissionMarketSingleRender;
	import com.leyou.util.DateUtil;
	
	public class MissionMarketWnd extends AutoWindow
	{
		private var timeLbl:Label;
		
		private var marketRender:MissionMarketRender;
		
		private var marketSingleRender:MissionMarketSingleRender;
		
		public function MissionMarketWnd(){
			super(LibManager.getInstance().getXML("config/ui/missionMarket/missionabarWnd.xml"));
			init();
		}
		
		private function init():void{
			hideBg();
			timeLbl = getUIbyID("timeLbl") as Label;
			marketRender = new MissionMarketRender();
			marketSingleRender = new MissionMarketSingleRender();
			marketRender.x = 31;
			marketRender.y = 71;
			marketSingleRender.x = 31;
			marketSingleRender.y = 71;
			marketSingleRender.visible = false;
			pane.addChild(marketRender);
			pane.addChild(marketSingleRender);
			marketRender.registerSwitch(onSwitchRrender);
			marketSingleRender.registerSwitch(onSwitchRrender);
			
			clsBtn.x += 5;
			clsBtn.y += 14;
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, toCenter);
			if(!TimeManager.getInstance().hasITick(refreshTime)){
				TimeManager.getInstance().addITick(1000, refreshTime)
			}
			if(marketSingleRender.visible){
				Cmd_TaskMarket.cm_TaskMarket_L(marketRender.currentType);
			}
		}
		
		public override function hide():void{
			super.hide();
			if(TimeManager.getInstance().hasITick(refreshTime)){
				TimeManager.getInstance().removeITick(refreshTime);
			}
		}
		
		public function refreshTime():void{
			var remainT:int = DataManager.getInstance().missionMarketData.remainTime;
			timeLbl.text = DateUtil.formatTime(remainT*1000, 2);
		}
		
		private function onSwitchRrender():void{
			marketRender.visible = marketSingleRender.visible;
			marketSingleRender.visible = !marketRender.visible;
			if(marketSingleRender.visible){
				Cmd_TaskMarket.cm_TaskMarket_L(marketRender.currentType);
			}
		}
		
		public function flyItem(type:int):void{
			marketRender.flyItem(type);
		}
		
		public function flyTaskItem(id:int):void{
			marketSingleRender.flyItem(id);
		}
		
		public function updateView():void{
			var data:MissionMarketData = DataManager.getInstance().missionMarketData;
			marketRender.updateInfo(data);
			marketSingleRender.updateInfo(marketRender.currentType);
		}
	}
}
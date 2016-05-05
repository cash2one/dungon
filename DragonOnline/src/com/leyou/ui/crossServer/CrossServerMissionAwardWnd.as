package com.leyou.ui.crossServer
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCSLvInfo;
	import com.ace.gameData.table.TCSPlayerRankInfo;
	import com.ace.gameData.table.TCSServerRankInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.leyou.ui.crossServer.children.CrossServerPlayerAwardItem;
	import com.leyou.ui.crossServer.children.CrossServerServerAwardItem;
	
	import flash.events.Event;
	
	public class CrossServerMissionAwardWnd extends AutoWindow
	{
		private var crossRewardTab:TabBar;
		
		private var serverPanel:ScrollPane;
		
		private var playerPanel:ScrollPane;
		
		private var serverItems:Vector.<CrossServerServerAwardItem>;
		
		private var playerItems:Vector.<CrossServerPlayerAwardItem>;
		
		public function CrossServerMissionAwardWnd(){
			super(LibManager.getInstance().getXML("config/ui/crossServer/kfdtMissionAward.xml"));
			init();
		}
		
		private function init():void{
			hideBg();
			crossRewardTab = getUIbyID("crossRewardTab") as TabBar;
			crossRewardTab.addEventListener(TabbarModel.changeTurnOnIndex, onTabChange);
			
			serverPanel = new ScrollPane(406, 380);
			playerPanel = new ScrollPane(406, 380);
			addChild(serverPanel);
			addChild(playerPanel);
			crossRewardTab.addToTab(serverPanel, 0);
			crossRewardTab.addToTab(playerPanel, 1);
			serverPanel.x = -13;
			serverPanel.y = 5;
			playerPanel.x = -13;
			playerPanel.y = 5;
			
			serverItems = new Vector.<CrossServerServerAwardItem>();
			playerItems = new Vector.<CrossServerPlayerAwardItem>();
			initTableInfo();
			
//			clsBtn.x -= 6;
//			clsBtn.y -= 14;
		}
		
		private function initTableInfo():void{
			var serverRankDic:Object = TableManager.getInstance().cserverLvDic;
			var playerRankDic:Object = TableManager.getInstance().cserverPlayerRankDic;
			for(var skey:String in serverRankDic){
				var serverRankInfo:TCSLvInfo = serverRankDic[skey];
				var sitem:CrossServerServerAwardItem = new CrossServerServerAwardItem();
				sitem.updateInfo(serverRankInfo);
				serverItems.push(sitem);
			}
			var index:int = 0;
			serverItems.sort(sSortFun);
			for each(var ssitem:CrossServerServerAwardItem in serverItems){
				ssitem.y = 60 * index;
				index++;
				serverPanel.addToPane(ssitem);
			}
			serverPanel.updateUI();
			
			for(var pkey:String in playerRankDic){
				var playerRankInfo:TCSPlayerRankInfo = playerRankDic[pkey];
				var pitem:CrossServerPlayerAwardItem = new CrossServerPlayerAwardItem();
				pitem.updateInfo(playerRankInfo);
				playerItems.push(pitem);
			}
			index = 0;
			playerItems.sort(pSortFun);
			for each(var psitem:CrossServerPlayerAwardItem in playerItems){
				psitem.y = 60 * index;
				index++
				playerPanel.addToPane(psitem);
			}
			playerPanel.updateUI();
		}
		
		private function pSortFun(a:CrossServerPlayerAwardItem, b:CrossServerPlayerAwardItem):int{
			if(a.id < b.id){
				return 1;
			}else if(a.id > b.id){
				return -1;
			}
			return 0;
		}
		
		private function sSortFun(a:CrossServerServerAwardItem, b:CrossServerServerAwardItem):int{
			if(a.id > b.id){
				return 1;
			}else if(a.id < b.id){
				return -1;
			}
			return 0;
		}
		
		protected function onTabChange(event:Event):void{
		}
		
		public override function get width():Number{
			return 442;
		}
		
		public override function get height():Number{
			return 456;
		}
	}
}
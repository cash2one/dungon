package com.leyou.ui.guildBattle
{
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.leyou.data.guildBattle.GuildBattleTrackData;
	import com.leyou.ui.guildBattle.children.GuildBattleGuildMemRankRender;
	import com.leyou.ui.guildBattle.children.GuildBattleGuildRankRender;
	import com.leyou.ui.guildBattle.children.GuildBattleMemRankRender;
	
	import flash.events.Event;
	
	public class GuildBattleRankWnd extends AutoWindow
	{
		private var guildBattleReward:TabBar;
		
		private var guildRankRender:GuildBattleGuildRankRender;
		
		private var memberRankRender:GuildBattleMemRankRender;
		
//		private var guildMemberRankRender:GuildBattleGuildMemRankRender; // 去掉第一行会排名奖励
		
		private var _currentIdx:int;
		
		public function GuildBattleRankWnd(){
			super(LibManager.getInstance().getXML("config/ui/guildBattle/warGuildAward.xml"));
			init();
		}
		
		private function init():void{
			hideBg();
//			clsBtn.x -= 6;
//			clsBtn.y -= 14;
			guildBattleReward = getUIbyID("guildBattleReward") as TabBar;
			
			guildRankRender = new GuildBattleGuildRankRender();
			memberRankRender = new GuildBattleMemRankRender();
//			guildMemberRankRender = new GuildBattleGuildMemRankRender();
			guildBattleReward.addToTab(guildRankRender, 1);
			guildBattleReward.addToTab(memberRankRender, 0);
//			guildBattleReward.addToTab(guildMemberRankRender, 2);
			guildBattleReward.addEventListener(TabbarModel.changeTurnOnIndex, onTabClick);
			
//			guildRankRender.x = -12;
//			guildRankRender.y = 2;
//			memberRankRender.x = -12;
//			memberRankRender.y = 2;
//			guildMemberRankRender.x = -12;
//			guildMemberRankRender.y = 2;
//			guildBattleReward.y += 5;
//			guildBattleReward.setTabVisible(2, false);
		}
		
//		public override function get width():Number{
//			return 442;
//		}
//		
//		public override function get height():Number{
//			return 460;
//		}
		
		protected function onTabClick(event:Event):void{
			if (_currentIdx == guildBattleReward.turnOnIndex){
				return;
			}
			_currentIdx = guildBattleReward.turnOnIndex;
		}
		
		public function updateInfo():void{
			var data:GuildBattleTrackData = DataManager.getInstance().guildBattleData.rankData;
			if(1 == data.type){
				memberRankRender.updateDetailInfo(data);
			}else if(2 == data.type){
				guildRankRender.updateDetailInfo(data);
			}else if(3 == data.type){
//				guildMemberRankRender.updateDetailInfo(data);
			}
		}
	}
}
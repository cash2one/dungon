/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-9-18 下午4:42:10
 */
package com.ace.gameData.manager {
	import com.ace.gameData.tools.ToolsInfo;
	import com.ace.manager.SOLManager;
	import com.leyou.data.abidePay.AbidePayData;
	import com.leyou.data.achievement.AchievementData;
	import com.leyou.data.bossCopy.BossCopyData;
	import com.leyou.data.celebrate.AreaCelebrateData;
	import com.leyou.data.cityBattle.CityBattleData;
	import com.leyou.data.collectioin.CollectionData;
	import com.leyou.data.fieldboss.FieldBossData;
	import com.leyou.data.friend.FriendData;
	import com.leyou.data.groupBuy.GroupBuyData;
	import com.leyou.data.guildBattle.GuildBattleData;
	import com.leyou.data.integral.IntegralData;
	import com.leyou.data.invest.InvestData;
	import com.leyou.data.luckDraw.LuckDrawData;
	import com.leyou.data.online.OnlineRewardData;
	import com.leyou.data.paypromotion.PayPromotionData;
	import com.leyou.data.payrank.PayRankData;
	import com.leyou.data.qqvip.QQVipData;
	import com.leyou.data.sevenDay.SevenDayData;
	import com.leyou.data.sinfo.ServerData;
	import com.leyou.data.tobestrong.TobeStrongData;
	import com.leyou.data.vendue.VendueData;
	import com.leyou.data.vip.VipData;
  
	/**
	 * 数据管理类，类似与UIManager
	 * @author ace
	 *
	 */
	public class DataManager {
		
		private static var INSTANCE:DataManager;

		public static function getInstance():DataManager {
			if (!INSTANCE)
				INSTANCE=new DataManager();

			return INSTANCE;
		}
		
		private var _cookieData:Object;
		
		public var toolsInfo:ToolsInfo; //工具栏数据
		
		public var achievementData:AchievementData; // 成就数据
		
		public var vipData:VipData // VIP数据
		
		public var friendData:FriendData; // 好友数据
		
		public var luckdrawData:LuckDrawData; // 抽奖数据
		
		public var fieldBossData:FieldBossData; // 野外BOSS
		
		public var bossCopyData:BossCopyData; // boss副本
		
		public var payPromotionData:PayPromotionData; // 充值返利数据
		
		public var tobeStrongData:TobeStrongData; // 我要变强
		
		public var sevenDayData:SevenDayData; // 七日任务
		
		public var investData:InvestData; // 投资理财
		
		public var areaCelebrate:AreaCelebrateData; // 新服庆典
		
		public var payRankData:PayRankData; // 充值排行奖励
		
		public var onlineRewardData:OnlineRewardData; // 在线奖励
		
		public var guildBattleData:GuildBattleData; // 行会争霸
		
		public var qqvipData:QQVipData; // 腾讯黄钻
		
		public var collectionData:CollectionData; // 收集数据
		
		public var integralData:IntegralData; // 积分数据
		
		public var abidePayData:AbidePayData; // 持续充值
		
		public var serverData:ServerData; // 服务器信息
		
		public var groupBuyData:GroupBuyData; // 团购信息
		
		public var vendueData:VendueData; // 拍卖
		
		public var cityBattleData:CityBattleData; //主城争霸
		
		public function DataManager() {
		}
		
		public function get cookieData():Object{
			return _cookieData;
		}

		public function setup():void {
			this.init();
			this.loadCookieData();
		}
		
		/**
		 * 加载缓存数据
		 * 
		 */		
		private function loadCookieData():void{
			_cookieData = SOLManager.getInstance().readCookie("dragon.game");
			if(null == _cookieData){
				_cookieData = new Object();
			}
		}
		
		/**
		 * 保存缓存数据
		 * 
		 */		
		public function saveCookieData():void{
			if(null == _cookieData) return;
			SOLManager.getInstance().saveCookie("dragon.game", cookieData); 
		}
		
		/**
		 * 设置缓存数据
		 * 
		 * @param type 键值
		 * @param data 数据
		 * 
		 */		
		public function setCookie(type:String, data:Object):void{
			cookieData[type] = data;
		}
		
		/**
		 * 读取缓存数据
		 * 
		 * @param type 键值
		 * @return     数据
		 * 
		 */		
		public function readCookie(type:String):Object{
			return cookieData[type];
		}

		private function init():void {
			this.toolsInfo=new ToolsInfo();
			this.achievementData=new AchievementData();
			this.vipData=new VipData();
			this.friendData=new FriendData();
			this.luckdrawData=new LuckDrawData();
			this.fieldBossData=new FieldBossData();
			this.bossCopyData=new BossCopyData();
			this.payPromotionData=new PayPromotionData();
			this.tobeStrongData=new TobeStrongData();
			this.sevenDayData=new SevenDayData();
			this.investData=new InvestData();
			this.areaCelebrate=new AreaCelebrateData();
			this.payRankData=new PayRankData();
			this.onlineRewardData=new OnlineRewardData();
			this.guildBattleData=new GuildBattleData();
			this.qqvipData=new QQVipData();
			this.collectionData=new CollectionData();
			this.integralData=new IntegralData();
			this.abidePayData=new AbidePayData();
			this.serverData=new ServerData();
			this.groupBuyData=new GroupBuyData();
			this.vendueData=new VendueData();
			this.cityBattleData=new CityBattleData();
		}
	}
}
package com.ace.manager {

	import com.ace.config.Core;
	import com.ace.enum.EventEnum;
	import com.ace.enum.SceneEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.manager.SceneKeyManager;
	import com.ace.game.scene.ui.ReviveWnd;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.ui.LoadingManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.map.MapWnd;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.ui.roleHead.AttackRoleHead;
	import com.ace.ui.roleHead.RoleHeadWnd;
	import com.ace.ui.setting.child.AssistSoundConfigWnd;
	import com.ace.ui.setting.child.AssistViewConfigWnd;
	import com.ace.ui.smallMap.SmallMapWnd;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.PkCopyEnum;
	import com.leyou.enum.TaskEnum;
	import com.leyou.manager.LastTimeImageManager;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Act;
	import com.leyou.net.cmd.Cmd_Duel;
	import com.leyou.net.cmd.Cmd_GuildBattle;
	import com.leyou.net.cmd.Cmd_WARC;
	import com.leyou.net.cmd.Cmd_ZC;
	import com.leyou.ui.abidePay.AbidePayBoxWnd;
	import com.leyou.ui.abidePay.AbidePayWnd;
	import com.leyou.ui.achievement.AchievementWnd;
	import com.leyou.ui.achievement.child.AchievementNotifyWnd;
	import com.leyou.ui.active.ActiveWnd;
	import com.leyou.ui.arena.ArenaWnd;
	import com.leyou.ui.arena.childs.ArenaAward;
	import com.leyou.ui.arena.childs.ArenaFinish;
	import com.leyou.ui.arena.childs.ArenaList;
	import com.leyou.ui.arena.childs.ArenaMessage;
	import com.leyou.ui.arena.childs.ArenaMsgWnd;
	import com.leyou.ui.arrow.AdWnd;
	import com.leyou.ui.aution.AutionWnd;
	import com.leyou.ui.autionSale.VendueWnd;
	import com.leyou.ui.backpack.BackAddWnd;
	import com.leyou.ui.backpack.BackpackWnd;
	import com.leyou.ui.backpack.SlidesWnd;
	import com.leyou.ui.backpack.child.BackLotUseWnd;
	import com.leyou.ui.backpack.child.BagDropPanel;
	import com.leyou.ui.backpack.child.BagSplitPanel;
	import com.leyou.ui.backpack.child.MessageInputWnd;
	import com.leyou.ui.badge.BadgeRebud;
	import com.leyou.ui.badge.BadgeWnd;
	import com.leyou.ui.battlefield.IceBattlefieldEndWnd;
	import com.leyou.ui.battlefield.IceBattlefieldExplainWnd;
	import com.leyou.ui.battlefield.IceBattlefieldPauseWnd;
	import com.leyou.ui.battlefield.IceBattlefieldRewardWnd;
	import com.leyou.ui.battlefield.IceBattlefieldTrackBar;
	import com.leyou.ui.battlefield.WarLogWnd;
	import com.leyou.ui.blackStore.BlackStoreWnd;
	import com.leyou.ui.boss.BossWnd;
	import com.leyou.ui.bossCopy.BossRewardWnd;
	import com.leyou.ui.celebrate.AreaCelebrateWnd;
	import com.leyou.ui.chat.ChatWnd;
	import com.leyou.ui.chat.child.ChatConfig;
	import com.leyou.ui.chat.child.FaceWnd;
	import com.leyou.ui.chat.child.PlayerTrackWnd;
	import com.leyou.ui.cityBattle.CityBattleAnnounceWnd;
	import com.leyou.ui.cityBattle.CityBattleChallengeWnd;
	import com.leyou.ui.cityBattle.CityBattleExplain;
	import com.leyou.ui.cityBattle.CityBattleMegWnd;
	import com.leyou.ui.cityBattle.CityBattleRewardWnd;
	import com.leyou.ui.cityBattle.CityBattleTaxWnd;
	import com.leyou.ui.cityBattle.CityBattleTrack;
	import com.leyou.ui.collection.CollectionWnd;
	import com.leyou.ui.continuous.ContinuousWidget;
	import com.leyou.ui.convenientuse.ConvenientTransferWnd;
	import com.leyou.ui.convenientuse.ConvenientUseWnd;
	import com.leyou.ui.convenientuse.ConvenientWearWnd;
	import com.leyou.ui.copy.StoryCopyRewarWnd;
	import com.leyou.ui.copyTrack.ExpCopyTrackBar;
	import com.leyou.ui.copyTrack.StoryCopyTrackBar;
	import com.leyou.ui.creatUser.CreatUserWnd;
	import com.leyou.ui.day7.SdayWnd;
	import com.leyou.ui.delivery.DeliveryFinish;
	import com.leyou.ui.delivery.DeliveryPanel;
	import com.leyou.ui.delivery.DeliveryWnd;
	import com.leyou.ui.die.DieWnd;
	import com.leyou.ui.dragonBall.DragonBallWnd;
	import com.leyou.ui.dragonBall.children.DragonBallPreviewWnd;
	import com.leyou.ui.duel.DuelResultWnd;
	import com.leyou.ui.dungeonTeam.DungeonTeamFWnd;
	import com.leyou.ui.dungeonTeam.DungeonTeamWnd;
	import com.leyou.ui.dungeonTeam.childs.DungeonCreatTeam;
	import com.leyou.ui.dungeonTeam.childs.DungeonTeamTrack;
	import com.leyou.ui.equip.EquipWnd;
	import com.leyou.ui.expCopy.chlid.ExpMapWnd;
	import com.leyou.ui.farm.FarmLogWnd;
	import com.leyou.ui.farm.FarmMessageWnd;
	import com.leyou.ui.farm.FarmShopWnd;
	import com.leyou.ui.farm.FarmWnd;
	import com.leyou.ui.fieldBoss.FieldBossRemindWnd;
	import com.leyou.ui.fieldBoss.FieldBossRewardWnd;
	import com.leyou.ui.fieldBoss.FieldBossTrackBar;
	import com.leyou.ui.firstGift.FirstGiftWnd;
	import com.leyou.ui.firstPay.FirstPayWnd;
	import com.leyou.ui.firstlogin.FirstLoginWnd;
	import com.leyou.ui.friend.FriendAddWnd;
	import com.leyou.ui.friend.FriendWnd;
	import com.leyou.ui.gem.GemLvUpWnd;
	import com.leyou.ui.groupBuy.GroupBuyWnd;
	import com.leyou.ui.guild.GuildWnd;
	import com.leyou.ui.guild.child.GuildDungeonTrack;
	import com.leyou.ui.guild.child.GuildWarWin;
	import com.leyou.ui.guildBattle.GuildBattleExplainWnd;
	import com.leyou.ui.guildBattle.GuildBattleMessageWnd;
	import com.leyou.ui.guildBattle.GuildBattleRankTrack;
	import com.leyou.ui.guildBattle.GuildBattleRankWnd;
	import com.leyou.ui.guildBattle.GuildBattleWnd;
	import com.leyou.ui.integral.IntegralWnd;
	import com.leyou.ui.invest.InvestWnd;
	import com.leyou.ui.legendary.LegendaryWnd;
	import com.leyou.ui.login.LoginWnd;
	import com.leyou.ui.luckDraw.LuckDrawWnd;
	import com.leyou.ui.luckDraw.LuckPackWnd;
	import com.leyou.ui.mail.MailWnd;
	import com.leyou.ui.mail.MaillReadWnd;
	import com.leyou.ui.market.MarketWnd;
	import com.leyou.ui.market.TencentMarketWnd;
	import com.leyou.ui.medic.RoleMedicWnd;
	import com.leyou.ui.missionMarket.MissionMarketWnd;
	import com.leyou.ui.moldOpen.FunForcastWnd;
	import com.leyou.ui.moldOpen.FunOpenWnd;
	import com.leyou.ui.moldOpen.MoldOpenWnd;
	import com.leyou.ui.monsterInvade.MonsterInvadeWnd;
	import com.leyou.ui.monsterInvade.child.MonsterInFinish;
	import com.leyou.ui.mount.MountLvUpWnd;
	import com.leyou.ui.mount.MountTradeWnd;
	import com.leyou.ui.mysteryStore.MyStoreWnd;
	import com.leyou.ui.offline.OffLineWnd;
	import com.leyou.ui.onlineReward.OnlineRewardWnd;
	import com.leyou.ui.otherPlayer.OtherPlayerWnd;
	import com.leyou.ui.payfirst.PayFirstWnd;
	import com.leyou.ui.payrank.PayRankWnd;
	import com.leyou.ui.pet.PetSkillSelectWnd;
	import com.leyou.ui.pet.PetWnd;
	import com.leyou.ui.pkCopy.DungeonBWTrack;
	import com.leyou.ui.pkCopy.DungeonSGFinish;
	import com.leyou.ui.pkCopy.DungeonSGTrack;
	import com.leyou.ui.pkCopy.DungeonTZWnd;
	import com.leyou.ui.pkCopy.DungeondTBTrack;
	import com.leyou.ui.pkCopy.child.DungeonTZPanel;
	import com.leyou.ui.post.PostWnd;
	import com.leyou.ui.promotion.PromotionPayWnd;
	import com.leyou.ui.qqVip.QQVipWnd;
	import com.leyou.ui.qqVip.QQYellowWnd;
	import com.leyou.ui.question.QuestionWnd;
	import com.leyou.ui.quickBuy.QuickBuyWnd;
	import com.leyou.ui.rank.RankWnd;
	import com.leyou.ui.role.RoleWnd;
	import com.leyou.ui.role.child.SelectWnd;
	import com.leyou.ui.role.child.children.MessageWnd;
	import com.leyou.ui.selectUser.SelectUserWnd;
	import com.leyou.ui.sevenDay.SevenDayWnd;
	import com.leyou.ui.sfirstPay.SuperFirstPayWnd;
	import com.leyou.ui.shop.BuyWnd;
	import com.leyou.ui.shop.ShopWnd;
	import com.leyou.ui.skill.SkillFuWnd;
	import com.leyou.ui.skill.SkillWnd;
	import com.leyou.ui.storage.StorageWnd;
	import com.leyou.ui.task.MissionAcceptWnd;
	import com.leyou.ui.task.TaskTrack;
	import com.leyou.ui.task.TaskWnd;
	import com.leyou.ui.team.TeamWnd;
	import com.leyou.ui.tips.FcmTips;
	import com.leyou.ui.tobestrong.TobeStrongWnd;
	import com.leyou.ui.tools.LeftTopWnd;
	import com.leyou.ui.tools.RightTopWnd;
	import com.leyou.ui.tools.ToolsWnd;
	import com.leyou.ui.tools.child.CDKeyReceiveWnd;
	import com.leyou.ui.trade.TradeWnd;
	import com.leyou.ui.ttsc.TtscWnd;
	import com.leyou.ui.vip.VipWnd;
	import com.leyou.ui.welfare.WelfareWnd;
	import com.leyou.ui.wing.WingLvUpWnd;
	import com.leyou.ui.wing.WingTradeWnd;
	import com.leyou.ui.worship.WorshipWnd;
	import com.leyou.utils.PropUtils;
	
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;

	public class UIManager extends UIManagerModel {


		private static var instance:UIManager;

		public var loginWnd:LoginWnd;
		public var selectUserWnd:SelectUserWnd;
		public var creatUserWnd:CreatUserWnd;
		public var toolsWnd:ToolsWnd;
		public var smallMapWnd:SmallMapWnd;
		public var roleHeadWnd:RoleHeadWnd;
		public var storageWnd:StorageWnd;
		public var backPackSplitWnd:BagSplitPanel;
		public var backPackDropWnd:BagDropPanel;
		public var backLotUseWnd:BackLotUseWnd;
		public var backAddWnd:BackAddWnd;
		public var tradeWnd:TradeWnd;
		public var equipWnd:EquipWnd;
		public var taskWnd:TaskWnd;
		public var taskNpcTalkWnd:MissionAcceptWnd;
		public var taskTrack:TaskTrack;
		public var teamWnd:TeamWnd;
		public var friendWnd:FriendWnd;
		public var friendAddWnd:FriendAddWnd;
		public var autionWnd:AutionWnd;
		public var maillWnd:MailWnd;
		public var maillReadWnd:MaillReadWnd;
		public var offlineWnd:OffLineWnd;
		public var badgeWnd:BadgeWnd;
		public var badgeRebudWnd:BadgeRebud;
		public var taskCollectProgress:com.ace.ui.LoadingManager;

		public var backpackWnd:BackpackWnd;
		public var roleWnd:RoleWnd;
		public var selectWnd:SelectWnd;
		public var skillWnd:SkillWnd;
		public var skillFuWnd:SkillFuWnd;
		public var marketWnd:MarketWnd;
		public var shopWnd:ShopWnd;
		public var myStore:MyStoreWnd;
		public var buyWnd:BuyWnd;
		public var quickBuyWnd:QuickBuyWnd;
		public var mountLvUpwnd:MountLvUpWnd;
		public var mountTradeWnd:MountTradeWnd;
		public var wingLvUpWnd:WingLvUpWnd;
		public var wingTradeWnd:WingTradeWnd;
		public var messageWnd:MessageWnd;
		public var messageBoxWnd:MessageInputWnd;

		public var guildWnd:GuildWnd;
		public var guildCopyTrack:GuildDungeonTrack;
		public var guildWarWin:GuildWarWin;
		public var otherPlayerWnd:OtherPlayerWnd;

		public var deliveryFinish:DeliveryFinish;
		public var deliveryWnd:DeliveryWnd;
		public var deliveryPanel:DeliveryPanel;

		public var arenaWnd:ArenaWnd;
		public var arenaListWnd:ArenaList;
		public var arenaFinishWnd:ArenaFinish;
		public var arenaAwardWnd:ArenaAward;
		public var arenaMessageWnd:ArenaMessage;

		public var fcmWnd:FcmTips;

		public var questionWnd:QuestionWnd;

		public var rightTopWnd:RightTopWnd;

		public var chatWnd:ChatWnd;
		public var faceWnd:FaceWnd;
		public var chatConfigWnd:ChatConfig;

		public var farmWnd:FarmWnd;
		public var farmShopWnd:FarmShopWnd;
		public var farmLogWnd:FarmLogWnd;
//		public var storyCopyWnd:StoryCopyWnd;
		public var storyCopyReward:StoryCopyRewarWnd;
//		public var bossCpyWnd:BossCopyWnd;
		public var copyTrack:StoryCopyTrackBar;
		public var continuousWgt:ContinuousWidget;
//		public var expCopyWnd:ExpCopyWnd;
		public var expMapWnd:ExpMapWnd;
//		public var fieldBossWnd:FieldBossWnd;
		public var welfareWnd:WelfareWnd;
		public var pkCopyWnd:DungeonTZWnd;
		public var pkCopyPanel:DungeonTZPanel;
		public var pkCopySGTrack:DungeonSGTrack;
		public var pkCopyDungeonFinish:DungeonSGFinish;
		public var expCopyTrack:ExpCopyTrackBar;
		public var bossCopyReward:BossRewardWnd;

		public var monsterInvadeWnd:MonsterInvadeWnd;
		public var monsterInFinish:MonsterInFinish;

		public var topUpWnd:TtscWnd;
		public var slidesWnd:SlidesWnd;
		public var gemLvWnd:GemLvUpWnd;
		public var teamCopyWnd:DungeonTeamWnd;
		public var teamCopyTrackWnd:DungeonTeamTrack;
		public var teamCopyRewardWnd:DungeonTeamFWnd;
		public var teamCopyCreateWnd:DungeonCreatTeam;
		public var medicWnd:RoleMedicWnd;
		public var sdayWnd:SdayWnd;

		public var funForcastWnd:FunForcastWnd;
		//		public var onlineReward:OnlineReward;
		public var onlinePanel:OnlineRewardWnd;
		public var activeWnd:ActiveWnd;
		public var arenaMegWnd:ArenaMsgWnd;
		public var receiveWnd:CDKeyReceiveWnd;
		public var achievementWnd:AchievementWnd;
		public var achievementNotifyWnd:AchievementNotifyWnd;
		public var vipWnd:VipWnd;
		public var luckDrawWnd:LuckDrawWnd;
		public var luckPackWnd:LuckPackWnd;
		public var worshipWnd:WorshipWnd;
		public var farmMWnd:FarmMessageWnd;
		public var fieldBossTrack:FieldBossTrackBar;
		public var fieldBossRemind:FieldBossRemindWnd;
		public var fieldBossReward:FieldBossRewardWnd;
		public var firstloginWnd:FirstLoginWnd;
		public var funOpenWnd:FunOpenWnd;
		public var firstPay:FirstPayWnd;
		public var tobeStrong:TobeStrongWnd;
		public var payPormotion:PromotionPayWnd;
		public var playerTrack:PlayerTrackWnd;
		public var adWnd:AdWnd;
		public var postWnd:PostWnd;
		public var tbTrack:DungeondTBTrack;
		public var bltTrack:DungeonBWTrack;
		public var sevenDay:SevenDayWnd;
		public var attackHeadWnd:AttackRoleHead;
		public var duelResultWnd:DuelResultWnd;
		public var investWnd:InvestWnd;
		public var areaCelebrate:AreaCelebrateWnd;
		public var dieWnd:DieWnd;
		public var payFirst:PayFirstWnd;
		public var spayFirst:SuperFirstPayWnd;
		public var payRankWnd:PayRankWnd;
		public var guildBattleWnd:GuildBattleWnd;
		public var guildBattleRankWnd:GuildBattleRankWnd;
		public var guildBattleRankTrack:GuildBattleRankTrack;
		public var guildBattleMegWnd:GuildBattleMessageWnd;
		public var guildBattleExplain:GuildBattleExplainWnd;
		public var loadingWnd:SlidesWnd;
		public var qqVipWnd:QQVipWnd;
		public var marketQQWnd:TencentMarketWnd;
		public var qqYellowWnd:QQYellowWnd;
		public var collectionWnd:CollectionWnd;
		public var integralWnd:IntegralWnd;
		public var abidePayWnd:AbidePayWnd;
		public var abidePayBoxWnd:AbidePayBoxWnd;
		public var groupBuyWnd:GroupBuyWnd;
		public var firstGiftWnd:FirstGiftWnd;
		public var vendueWnd:VendueWnd;
		public var cityBattleAnnounce:CityBattleAnnounceWnd;
		public var cityBattleReward:CityBattleRewardWnd;
		public var cityBattleTax:CityBattleTaxWnd;
		public var cityBattleMeg:CityBattleMegWnd;
		public var cityBattleTrack:CityBattleTrack;
		public var cityBattleExplain:CityBattleExplain;
		public var cityBattleChallenge:CityBattleChallengeWnd;
		public var bossWnd:BossWnd;
		public var dragonBallWnd:DragonBallWnd;
		public var dragonBallPreviewWnd:DragonBallPreviewWnd;
		public var iceBattlefieldTrack:IceBattlefieldTrackBar;
		public var iceBattlefieldReward:IceBattlefieldRewardWnd;
		public var iceBattlefieldEnd:IceBattlefieldEndWnd;
		public var iceBattlefieldPause:IceBattlefieldPauseWnd;
		public var iceBattlefieldExplain:IceBattlefieldExplainWnd;
		public var warLogWnd:WarLogWnd;
		public var legendaryWnd:LegendaryWnd;
		public var blackStoreWnd:BlackStoreWnd;
		public var petWnd:PetWnd;
		public var petSkillSelectWnd:PetSkillSelectWnd;
		public var missionMarketWnd:MissionMarketWnd;
		// 功能开启
		public var moldWnd:MoldOpenWnd;
		// 快捷换装
		public var convenientWear:ConvenientWearWnd;
		// 快捷换装(带强化转移)
		public var convenientTransfer:ConvenientTransferWnd;
		// 快捷使用
		public var convenientUse:ConvenientUseWnd;

		public var rankWnd:RankWnd;

		public var leftTopWnd:LeftTopWnd;

		private var _claDic:Object;
		private var _keyDic:Object;

		public var soundConfig:AssistSoundConfigWnd;
		public var viewConfig:AssistViewConfigWnd;

		private var resizeWnds:Vector.<AutoWindow>;

		public var slidesWndArr:Array=[];

		public static function getInstance():UIManager {
			if (!instance)
				instance=new UIManager();
			return instance;
		}

		public function UIManager() {
			this.init();
		}

		private function init():void {
			resizeWnds=new Vector.<AutoWindow>();
			_claDic={};
			_keyDic={};
			this.loginWnd=new LoginWnd();
			LayerManager.getInstance().mainLayer.addChild(this.loginWnd);

			//-------------------------------------------------------------
			// 格式: 
			//      窗口枚举:[类, 实例名称]
			//-------------------------------------------------------------
			_claDic[WindowEnum.AUTION]=[AutionWnd, "autionWnd"];
//			_claDic[WindowEnum.BOSSCOPY]=[BossCopyWnd, "bossCpyWnd"];
			_claDic[WindowEnum.BOSSCOPY_REWARD]=[BossRewardWnd, "bossCopyReward"];
//			_claDic[WindowEnum.STORYCOPY]=[StoryCopyWnd, "storyCopyWnd"];
			_claDic[WindowEnum.STORYCOPY_REWARD]=[StoryCopyRewarWnd, "storyCopyReward"];
			_claDic[WindowEnum.COPYTRACK]=[StoryCopyTrackBar, "copyTrack"];
//			_claDic[WindowEnum.EXPCOPY]=[ExpCopyWnd, "expCopyWnd"];
			_claDic[WindowEnum.EXPCOPY_MAP]=[ExpMapWnd, "expMapWnd"];
			_claDic[WindowEnum.EXP_COPY_TRACK]=[ExpCopyTrackBar, "expCopyTrack"];
			_claDic[WindowEnum.FARM]=[FarmWnd, "farmWnd"];
			_claDic[WindowEnum.FARM_LOG]=[FarmLogWnd, "farmLogWnd"];
			_claDic[WindowEnum.FARM_SHOP]=[FarmShopWnd, "farmShopWnd"];
//			_claDic[WindowEnum.FIELDBOSS]=[FieldBossWnd, "fieldBossWnd"];
			_claDic[WindowEnum.MARKET]=[MarketWnd, "marketWnd"];
			_claDic[WindowEnum.WELFARE]=[WelfareWnd, "welfareWnd"];
			_claDic[WindowEnum.MAILL]=[MailWnd, "maillWnd"];
			_claDic[WindowEnum.MAILL_READ]=[MaillReadWnd, "maillReadWnd"];
			_claDic[WindowEnum.FRIEND]=[FriendWnd, "friendWnd"];
			_claDic[WindowEnum.FRIEDN_ADD]=[FriendAddWnd, "friendAddWnd"];
			_claDic[WindowEnum.RANK]=[RankWnd, "rankWnd"];
			_claDic[WindowEnum.ACTIVE]=[ActiveWnd, "activeWnd"];
			_claDic[WindowEnum.QUICK_BUY]=[QuickBuyWnd, "quickBuyWnd"]

			_claDic[WindowEnum.SHOP]=[ShopWnd, "shopWnd"];
			_claDic[WindowEnum.MYSTORE]=[MyStoreWnd, "myStore"];
			_claDic[WindowEnum.STOREGE]=[StorageWnd, "storageWnd"];
			_claDic[WindowEnum.GUILD]=[GuildWnd, "guildWnd"];
			_claDic[WindowEnum.GUILD_COPY_TRACK]=[GuildDungeonTrack, "guildCopyTrack"];
			_claDic[WindowEnum.GUILD_WAR_WIN]=[GuildWarWin, "guildWarWin"];
			_claDic[WindowEnum.EQUIP]=[EquipWnd, "equipWnd"];
			_claDic[WindowEnum.BADAGE]=[BadgeWnd, "badgeWnd"];
			_claDic[WindowEnum.QUESTION]=[QuestionWnd, "questionWnd"];
			_claDic[WindowEnum.ARENA]=[ArenaWnd, "arenaWnd"];
			_claDic[WindowEnum.ARENAAWARD]=[ArenaAward, "arenaAwardWnd"];
			_claDic[WindowEnum.ARENAFINISH]=[ArenaFinish, "arenaFinishWnd"];
			_claDic[WindowEnum.ARENALIST]=[ArenaList, "arenaListWnd"];
			_claDic[WindowEnum.ARENAMESSAGE]=[ArenaMessage, "arenaMessageWnd"];
			_claDic[WindowEnum.BADGEREBUD]=[BadgeRebud, "badgeRebudWnd"];
			_claDic[WindowEnum.DELIVERYFINISH]=[DeliveryFinish, "deliveryFinish"];
			_claDic[WindowEnum.MESSAGE]=[MessageWnd, "messageWnd"];
			_claDic[WindowEnum.PKCOPY]=[DungeonTZWnd, "pkCopyWnd"];
			_claDic[WindowEnum.PKCOPYPANEL]=[DungeonTZPanel, "pkCopyPanel"];
			_claDic[WindowEnum.BACKPACK]=[BackpackWnd, "backpackWnd"];
			_claDic[WindowEnum.PKCOPYSGTRACK]=[DungeonSGTrack, "pkCopySGTrack"];
			_claDic[WindowEnum.SKILL]=[SkillWnd, "skillWnd"];
			_claDic[WindowEnum.TEAM]=[TeamWnd, "teamWnd"];
			_claDic[WindowEnum.TASK]=[TaskWnd, "taskWnd"];
			_claDic[WindowEnum.RUNE]=[SkillFuWnd, "skillFuWnd"];
			_claDic[WindowEnum.MEDIC]=[RoleMedicWnd, "medicWnd"];

			_claDic[WindowEnum.ROLE]=[roleWnd, "roleWnd"];
			_claDic[WindowEnum.MOUTLVUP]=[MountLvUpWnd, "mountLvUpwnd"];
			_claDic[WindowEnum.MOUTTRADEUP]=[MountTradeWnd, "mountTradeWnd"];
			_claDic[WindowEnum.WINGLVUP]=[WingLvUpWnd, "wingLvUpWnd"];
			_claDic[WindowEnum.WING_FLY]=[WingTradeWnd, "wingTradeWnd"];
			_claDic[WindowEnum.DELIVERYPANEL]=[DeliveryPanel, "deliveryPanel"];
			_claDic[WindowEnum.PKCOPYDRAGONFINISH]=[DungeonSGFinish, "pkCopyDungeonFinish"];

			_claDic[WindowEnum.MONSTERINVADEWND]=[MonsterInvadeWnd, "monsterInvadeWnd"];
			_claDic[WindowEnum.MONSTERINFINISH]=[MonsterInFinish, "monsterInFinish"];
			_claDic[WindowEnum.TOPUP]=[TtscWnd, "topUpWnd"];
			_claDic[WindowEnum.DUNGEONTB_TRACK]=[DungeondTBTrack, "tbTrack"];
			_claDic[WindowEnum.DUNGEON_BLT_TRACK]=[DungeonBWTrack, "bltTrack"];
			_claDic[WindowEnum.GEM_LV]=[GemLvUpWnd, "gemLvWnd"];
			_claDic[WindowEnum.DUNGEON_TEAM]=[DungeonTeamWnd, "teamCopyWnd"];
			_claDic[WindowEnum.DUNGEON_TEAM_CREATE]=[DungeonCreatTeam, "teamCopyCreateWnd"];
			_claDic[WindowEnum.DUNGEON_TEAM_REWARD]=[DungeonTeamFWnd, "teamCopyRewardWnd"];
			_claDic[WindowEnum.DUNGEON_TEAM_TRACK]=[DungeonTeamTrack, "teamCopyTrackWnd"];
			_claDic[WindowEnum.KEEP_7]=[SdayWnd, "sdayWnd"];

			_claDic[WindowEnum.ARENA_NOTICE]=[ArenaMsgWnd, "arenaMegWnd"];
			_claDic[WindowEnum.CDKEY]=[CDKeyReceiveWnd, "receiveWnd"];
			_claDic[WindowEnum.ACHIEVEMENT]=[AchievementWnd, "achievementWnd"];
			_claDic[WindowEnum.ACHIEVEMENTNOTIFY]=[AchievementNotifyWnd, "achievementNotifyWnd"];
			_claDic[WindowEnum.VIP]=[VipWnd, "vipWnd"];
			_claDic[WindowEnum.LUCKDRAW]=[LuckDrawWnd, "luckDrawWnd"];
			_claDic[WindowEnum.LUCKDRAW_STORE]=[LuckPackWnd, "luckPackWnd"];
			_claDic[WindowEnum.WORSHIP]=[WorshipWnd, "worshipWnd"];
			_claDic[WindowEnum.FARMMESSAGE]=[FarmMessageWnd, "farmMWnd"];
			_claDic[WindowEnum.FIELD_BOSS_TRACK]=[FieldBossTrackBar, "fieldBossTrack"];
			_claDic[WindowEnum.FIELD_BOSS_REMIND]=[FieldBossRemindWnd, "fieldBossRemind"];
			_claDic[WindowEnum.FIELD_BOSS_REWARD]=[FieldBossRewardWnd, "fieldBossReward"];
			_claDic[WindowEnum.ONLINDREWARD]=[OnlineRewardWnd, "onlinePanel"];
			_claDic[WindowEnum.FIRST_LOGIN]=[FirstLoginWnd, "firstloginWnd"];
			_claDic[WindowEnum.SUPER_FIRST_RETURN]=[SuperFirstPayWnd, "spayFirst"];
			_claDic[WindowEnum.FIRST_PAY]=[FirstPayWnd, "firstPay"];
			_claDic[WindowEnum.FUN_OPEN]=[FunOpenWnd, "funOpenWnd"];
			_claDic[WindowEnum.PAY_PROMOTION]=[PromotionPayWnd, "payPormotion"];
			_claDic[WindowEnum.TOBE_STRONG]=[TobeStrongWnd, "tobeStrong"];
			_claDic[WindowEnum.PLAYER_TRACK]=[PlayerTrackWnd, "playerTrack"];
			_claDic[WindowEnum.SEVENDAY]=[SevenDayWnd, "sevenDay"];
			_claDic[WindowEnum.INVEST]=[InvestWnd, "investWnd"];
			_claDic[WindowEnum.AREA_CELEBRATE]=[AreaCelebrateWnd, "areaCelebrate"];
			_claDic[WindowEnum.DIE]=[DieWnd, "dieWnd"];
			_claDic[WindowEnum.PAY_RANK]=[PayRankWnd, "payRankWnd"];
			_claDic[WindowEnum.FIRST_RETURN]=[PayFirstWnd, "payFirst"];
			_claDic[WindowEnum.GUILD_BATTLE]=[GuildBattleWnd, "guildBattleWnd"];
			_claDic[WindowEnum.GUILD_BATTLE_RANK]=[GuildBattleRankWnd, "guildBattleRankWnd"];
			_claDic[WindowEnum.GUILD_BATTLE_TRACK]=[GuildBattleRankTrack, "guildBattleRankTrack"];
			_claDic[WindowEnum.GUILD_MESSAGE]=[GuildBattleMessageWnd, "guildBattleMegWnd"];
			_claDic[WindowEnum.QQ_VIP]=[QQVipWnd, "qqVipWnd"];
			_claDic[WindowEnum.QQ_MARKET]=[TencentMarketWnd, "marketQQWnd"];
			_claDic[WindowEnum.GUILD_BATTLE_EXPLAIN]=[GuildBattleExplainWnd, "guildBattleExplain"];
			_claDic[WindowEnum.QQ_YELLOW]=[QQYellowWnd, "qqYellowWnd"];
			_claDic[WindowEnum.COLLECTION]=[CollectionWnd, "collectionWnd"];
			_claDic[WindowEnum.INTEGRAL]=[IntegralWnd, "integralWnd"];
			_claDic[WindowEnum.ABIDE_PAY]=[AbidePayWnd, "abidePayWnd"];
			_claDic[WindowEnum.ABIDE_BOX]=[AbidePayBoxWnd, "abidePayBoxWnd"];
			_claDic[WindowEnum.GROUP_BUY]=[GroupBuyWnd, "groupBuyWnd"];
			_claDic[WindowEnum.FIRSTGIFT]=[FirstGiftWnd, "firstGiftWnd"];
			_claDic[WindowEnum.VENDUE]=[VendueWnd, "vendueWnd"];
			_claDic[WindowEnum.CITY_BATTLE_ANNOUNCE]=[CityBattleAnnounceWnd, "cityBattleAnnounce"];
			_claDic[WindowEnum.CITY_BATTLE_REWARD]=[CityBattleRewardWnd, "cityBattleReward"];
			_claDic[WindowEnum.CITY_BATTLE_TAX]=[CityBattleTaxWnd, "cityBattleTax"];
			_claDic[WindowEnum.CITY_BATTLE_FINAL]=[CityBattleMegWnd, "cityBattleMeg"];
			_claDic[WindowEnum.CITY_BATTLE_TRACK]=[CityBattleTrack, "cityBattleTrack"];
			_claDic[WindowEnum.CITY_BATTLE_EXPLAIN]=[CityBattleExplain, "cityBattleExplain"];
			_claDic[WindowEnum.CITY_BATTLE_CHALLENGE]=[CityBattleChallengeWnd, "cityBattleChallenge"];
			_claDic[WindowEnum.BOSS]=[BossWnd, "bossWnd"];
			_claDic[WindowEnum.DRAGON_BALL]=[DragonBallWnd, "dragonBallWnd"];
			_claDic[WindowEnum.DRAGON_PROVIEW]=[DragonBallPreviewWnd, "dragonBallPreviewWnd"];
			_claDic[WindowEnum.ICE_BATTLE_END]=[IceBattlefieldEndWnd, "iceBattlefieldEnd"];
			_claDic[WindowEnum.ICE_BATTLE_PAUSE]=[IceBattlefieldPauseWnd, "iceBattlefieldPause"];
			_claDic[WindowEnum.ICE_BATTLE_REWARD]=[IceBattlefieldRewardWnd, "iceBattlefieldReward"];
			_claDic[WindowEnum.ICE_BATTLE_TRACK]=[IceBattlefieldTrackBar, "iceBattlefieldTrack"];
			_claDic[WindowEnum.WAR_LOG]=[WarLogWnd, "warLogWnd"];
			_claDic[WindowEnum.ICE_BATTLE_RULE]=[IceBattlefieldExplainWnd, "iceBattlefieldExplain"];
			_claDic[WindowEnum.LEGENDAREY_WEAPON]=[LegendaryWnd, "legendaryWnd"];
			_claDic[WindowEnum.BLACK_STROE]=[BlackStoreWnd, "blackStoreWnd"];
			_claDic[WindowEnum.PET]=[PetWnd, "petWnd"];
			_claDic[WindowEnum.PET_SKILL_SELECT]=[PetSkillSelectWnd, "petSkillSelectWnd"];
			_claDic[WindowEnum.TASK_MARKET]=[MissionMarketWnd, "missionMarketWnd"];
			//			this.mountLvUpwnd=new MountLvUpWnd();
			//			this.mountTradeWnd=new MountTradeWnd();
			//			this.wingLvUpWnd=new WingLvUpWnd();

			//-------------------------------------------------------------
			// 格式: 
			//      快捷键:[开启等级, 窗口枚举]
			//-------------------------------------------------------------
			_keyDic[Keyboard.P]=[ConfigEnum.AutionOpenLevel, WindowEnum.AUTION];
			_keyDic[Keyboard.D]=[ConfigEnum.MarketOpenLevel, WindowEnum.MARKET];
			_keyDic[Keyboard.F]=[0, WindowEnum.FRIEND];

			_keyDic[Keyboard.L]=[0, WindowEnum.TASK];
			_keyDic[Keyboard.B]=[0, WindowEnum.BACKPACK];
			_keyDic[Keyboard.C]=[0, WindowEnum.ROLE];
			_keyDic[Keyboard.T]=[0, WindowEnum.TEAM];
			_keyDic[Keyboard.O]=[ConfigEnum.EquipIntensifyOpenLv, WindowEnum.EQUIP];
			_keyDic[Keyboard.G]=[ConfigEnum.UnionOpenLv, WindowEnum.GUILD];
			_keyDic[Keyboard.S]=[0, WindowEnum.SKILL];
			_keyDic[Keyboard.V]=[ConfigEnum.BadgeOpenLv, WindowEnum.BADAGE];
//			_keyDic[Keyboard.Y]=[ConfigEnum.servent1, WindowEnum.PET];
			_keyDic[Keyboard.R]=[ConfigEnum.FarmOpenLevel, WindowEnum.FARM];
			_keyDic[Keyboard.K]=[ConfigEnum.setin1, WindowEnum.COLLECTION];

			EventManager.getInstance().addEvent(EventEnum.SCENE_LOADED, onSceneLoaed);
		}

		private function onSceneLoaed():void {
			GuideManager.getInstance().refreshGuide();
			if (isCreate(WindowEnum.FIELD_BOSS_TRACK) && fieldBossTrack.visible) {
				fieldBossTrack.hide();
			}
			if (null != duelResultWnd) {
				duelResultWnd.hide();
			}
			ReviveWnd.getInstance().hide();

			var type:int=MapInfoManager.getInstance().type;
			switch (type) {
				case SceneEnum.SCENE_TYPE_PTCJ: // 普通场景
					NoticeManager.getInstance().broadcastMap(MapInfoManager.getInstance().sceneId);
					MapWnd.getInstance().resetSwitch();
					if (isCreate(WindowEnum.COPYTRACK)) {
						copyTrack.hide();
						copyTrack.removeExitEvent();
					}
					if (isCreate(WindowEnum.EXP_COPY_TRACK)) {
						expCopyTrack.hide();
						expCopyTrack.removeExitEvent();
					}

					if (isCreate(WindowEnum.GUILD_BATTLE_TRACK)) {
						guildBattleRankTrack.hide();
					}

					if (isCreate(WindowEnum.CITY_BATTLE_TRACK)) {
						cityBattleTrack.hide();
					}

					if (isCreate(WindowEnum.GUILD_COPY_TRACK)) {
						guildCopyTrack.hide();
					}

					if (isCreate(WindowEnum.DUNGEON_TEAM_TRACK)) {
						teamCopyTrackWnd.hide();
					}

					if (isCreate(WindowEnum.DUNGEON_TEAM_REWARD)) {
						teamCopyRewardWnd.hide();
					}

					if (isCreate(WindowEnum.MONSTERINVADEWND)) {
						monsterInvadeWnd.hide()
					}

					if (deliveryPanel != null && deliveryPanel.visible && Core.me.info.followOwnerId != 0) {
						rightTopWnd.hideBar(1);
					} else
						rightTopWnd.showBar(1);

					if (isCreate(WindowEnum.DUNGEONTB_TRACK)) {
						this.tbTrack.hide()
					}

					if (isCreate(WindowEnum.DUNGEON_BLT_TRACK)) {
						this.bltTrack.hide()
					}

					if (isCreate(WindowEnum.ICE_BATTLE_TRACK)) {
						iceBattlefieldTrack.hide();
					}

					taskTrack.show();
					smallMapWnd.switchToType(1);
					SceneKeyManager.getInstance().sceneInput(true);
					NoticeManager.getInstance().stopCount();
					break;
				case SceneEnum.SCENE_TYPE_BSFB: // boss副本
					smallMapWnd.switchToType(2);
					if (!isCreate(WindowEnum.COPYTRACK)) {
						creatWindow(WindowEnum.COPYTRACK);
					}
					MapWnd.getInstance().hideSwitch();
					copyTrack.show();
					copyTrack.addExitEvent();
					taskTrack.hide();
					rightTopWnd.hideBar(1);
					hideWindow(WindowEnum.BOSS);
					GuideManager.getInstance().showGuide(42, UIManager.getInstance().toolsWnd);
					break;
				case SceneEnum.SCENE_TYPE_JQFB: // 剧情副本
					smallMapWnd.switchToType(2);
					if (!isCreate(WindowEnum.COPYTRACK)) {
						creatWindow(WindowEnum.COPYTRACK);
					}
					MapWnd.getInstance().hideSwitch();
					copyTrack.show();
					copyTrack.addExitEvent();
					taskTrack.hide();
					rightTopWnd.hideBar(1);
					hideWindow(WindowEnum.DUNGEON_TEAM);
					if (null != Core.me) {
						Core.me.onAutoMonster();
					}
					//					GuideManager.getInstance().showGuide(42, UIManager.getInstance().toolsWnd);
					break;
				case SceneEnum.SCENE_TYPE_LJCJ: // 练级副本
					smallMapWnd.switchToType(2);
					if (!isCreate(WindowEnum.EXP_COPY_TRACK)) {
						creatWindow(WindowEnum.EXP_COPY_TRACK);
					}
					MapWnd.getInstance().hideSwitch();
					expCopyTrack.show();
					expCopyTrack.addExitEvent();
					taskTrack.hide();
					rightTopWnd.hideBar(1);
					hideWindow(WindowEnum.DUNGEON_TEAM);
					hideWindow(WindowEnum.EXPCOPY_MAP);
					GuideManager.getInstance().showGuide(42, UIManager.getInstance().toolsWnd);
					break;
				case SceneEnum.SCENE_TYPE_JDCJ:
					smallMapWnd.switchToType(2);
					MapWnd.getInstance().hideSwitch();
					taskTrack.hide();
					rightTopWnd.hideBar(1);
					if (!EventManager.getInstance().hasEvent(EventEnum.COPY_QUIT, Cmd_Duel.onQuit)) {
						EventManager.getInstance().addEvent(EventEnum.COPY_QUIT, Cmd_Duel.onQuit);
					}
					break;
				case SceneEnum.SCENE_TYPE_GUCJ:
					smallMapWnd.switchToType(2);
					MapWnd.getInstance().hideSwitch();
					taskTrack.hide();
					rightTopWnd.hideBar(1);
					if (!EventManager.getInstance().hasEvent(EventEnum.COPY_QUIT, quitScene)) {
						EventManager.getInstance().addEvent(EventEnum.COPY_QUIT, quitScene);
					}
					break;
				case SceneEnum.SCENE_TYPE_CYCJ:
					smallMapWnd.switchToType(2);
					MapWnd.getInstance().hideSwitch();
					taskTrack.hide();
					rightTopWnd.hideBar(1);
					if (!EventManager.getInstance().hasEvent(EventEnum.COPY_QUIT, quitScene)) {
						EventManager.getInstance().addEvent(EventEnum.COPY_QUIT, quitScene);
					}
					break;
				case SceneEnum.SCENE_TYPE_LZCJ:
					smallMapWnd.switchToType(2);
					if (!isCreate(WindowEnum.COPYTRACK)) {
						creatWindow(WindowEnum.COPYTRACK)
					}
					MapWnd.getInstance().hideSwitch();
					copyTrack.show();
					copyTrack.addExitEvent();
					taskTrack.hide();
					rightTopWnd.hideBar(1);
					break;
				case SceneEnum.SCENE_TYPE_SYCJ:
					smallMapWnd.switchToType(2);
					if (!isCreate(WindowEnum.ICE_BATTLE_TRACK)) {
						creatWindow(WindowEnum.ICE_BATTLE_TRACK)
					}
					MapWnd.getInstance().hideSwitch();
//					iceBattlefieldTrack.show();
					taskTrack.hide();
					rightTopWnd.hideBar(1);
					if (!EventManager.getInstance().hasEvent(EventEnum.COPY_QUIT, quitScene)) {
						EventManager.getInstance().addEvent(EventEnum.COPY_QUIT, quitScene);
					}
					break;

			}
		}

		private function quitScene():void {
			var id:int=0;
			var type:int=MapInfoManager.getInstance().type;
			switch (type) {
				case SceneEnum.SCENE_TYPE_GUCJ: // 帮战
					id=3099;
					break;
				case SceneEnum.SCENE_TYPE_CYCJ: // 城战
					id=6745;
					break;
				case SceneEnum.SCENE_TYPE_SYCJ: // 战场
					id=21004;
					break;
			}
			var content:String=TableManager.getInstance().getSystemNotice(id).content;
			content=StringUtil.substitute(content, ConfigEnum.Opbattle22 / 60);
			PopupManager.showConfirm(content, quit, null, false, "quit.copy,scene");
			function quit():void {
				switch (type) {
					case SceneEnum.SCENE_TYPE_GUCJ: // 帮战
						Cmd_GuildBattle.cm_UNZ_Q();
						break;
					case SceneEnum.SCENE_TYPE_CYCJ: // 城战
						Cmd_WARC.cm_WARC_Q();
						break;
					case SceneEnum.SCENE_TYPE_SYCJ: // 战场
						Cmd_ZC.cm_ZC_Q();
						break;
				}
			}
		}

		//选择角色
		public function addSelectUserWnd():void {
			this.selectUserWnd=new SelectUserWnd();
			LayerManager.getInstance().mainLayer.addChild(this.selectUserWnd);
		}

		//创建角色
		public function addCreatUserWnd():void {
			this.creatUserWnd=new CreatUserWnd();
			LayerManager.getInstance().mainLayer.addChild(this.creatUserWnd);
		}

		public function showPanelCallback(panelType:int):void {

			if (this.slidesWndArr[panelType]) {

				this.slidesWndArr[panelType]=false;
				if (this.slidesWndArr.indexOf(true) == -1) {
					this.slidesWnd.setEffectVisiable(false);
				}

				var data:Object=AutoWindow(this.getWindow(panelType)).dataModel;
				data[0].apply(null, data.slice(1));


					//				TweenLite.delayedCall(2, function():void {
					//					slidesWndArr[panelType]=false;
					//					
					//					if (slidesWndArr.indexOf(true) == -1) {
					//						slidesWnd.setEffectVisiable(false);
					//					}
					//
					//					var data:Object=AutoWindow(getWindow(panelType)).dataModel;
					//					data[0].apply(null, data.slice(1));
					//				});

			}


		}

		/**
		 * <T>窗体是否已经创建</T>
		 */
		public function isCreate(id:int):Boolean {
			return (null != this[_claDic[id][1]]);
		}

		/**
		 * <T>根据id获得窗体</T>
		 *
		 * @param id 窗体ID
		 * @return  窗体
		 *
		 */
		public function getWindow(id:int):DisplayObject {
			return this[_claDic[id][1]];
		}

		/**
		 * <T>创建窗体</T>
		 *
		 * @param id 窗体ID
		 * @return   创建的窗体
		 *
		 */
		public function creatWindow(id:int):DisplayObject {
			//			if (Core.clientTest)
			//				return null;
			var wnd:DisplayObject=this[_claDic[id][1]];
			if (null == wnd) {
				wnd=new _claDic[id][0];
				this[_claDic[id][1]]=wnd;
				if (wnd is AutoWindow) {
					LayerManager.getInstance().windowLayer.addChild(wnd);
				} else {
					LayerManager.getInstance().mainLayer.addChild(wnd);
				}
				wnd.visible=false;
			}
			return wnd;
		}

		/**
		 * <T>打开窗体</T>
		 *
		 * @param id 窗体ID
		 */
		public function openWindow(id:int):void {
			var wnd:Object=creatWindow(id);
			wnd.open();
		}

		/**
		 * <T>显示窗体</T>
		 *
		 * @param id 窗体ID
		 */
		public function showWindow(id:int, toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			var wnd:Object=creatWindow(id);
			wnd.show(toTop, $layer, toCenter);
		}

		/**
		 * 隐藏窗体
		 *
		 * @param id 窗体ID
		 */
		public function hideWindow(id:int):void {
			var wnd:Object=this[_claDic[id][1]];
			if ((null != wnd) && wnd.visible) {
				wnd.hide();
				this.slidesWndArr[id]=false;

				if (this.slidesWndArr.indexOf(true) == -1)
					this.slidesWnd.setEffectVisiable(false);

			}
		}

		//		/**
		//		 * <T>布局显示</T>
		//		 * <P>关闭互斥界面,调整关联界面的位置</P>
		//		 *
		//		 * @param id 窗体ID
		//		 *
		//		 */
		//		public function layoutShow(id:int):void {
		//			UILayoutManager.getInstance().show(id);
		//		}
		//
		//		/**
		//		 * <T>布局隐藏</T>
		//		 * <P>调整关联界面的位置</P>
		//		 *
		//		 * @param id 窗体ID
		//		 *
		//		 */
		//		public function layoutHide(id:int):void {
		//			UILayoutManager.getInstance().hide(id);
		//		}
		//
		//		/**
		//		 * <T>布局开启</T>
		//		 *
		//		 */
		//		public function layoutOpen(id:int):void {
		//			UILayoutManager.getInstance().open(id);
		//			UILayoutManager.getInstance().open_II(id);
		//		}

		public function openFun(funEnum:int, fun:Function=null):void {
			var funWnd:DisplayObject=creatWindow(WindowEnum.FUN_OPEN);
			if (!funWnd.visible) {
				UILayoutManager.getInstance().singleMove(funWnd, "funopen", 1, null, new Point(UIEnum.WIDTH - 575, (UIEnum.HEIGHT - 246) >> 1));
			}
			funOpenWnd.openFun(funEnum, fun);
		}

		//进入场景
		override public function addSceneWnd():void {
			super.addSceneWnd();

			this.smallMapWnd=new SmallMapWnd();
			this.roleHeadWnd=new RoleHeadWnd();
			this.toolsWnd=new ToolsWnd();
			this.rightTopWnd=new RightTopWnd();
			this.chatWnd=new ChatWnd();
			this.taskTrack=new TaskTrack();
			this.funForcastWnd=new FunForcastWnd();
			this.adWnd=new AdWnd();
			this.slidesWnd=new SlidesWnd();
			this.selectWnd=new SelectWnd();
			this.messageBoxWnd=new MessageInputWnd();
			this.leftTopWnd=new LeftTopWnd();

			LayerManager.getInstance().windowLayer.addChild(this.messageBoxWnd);
			LayerManager.getInstance().windowLayer.addChild(this.slidesWnd);
			LayerManager.getInstance().windowLayer.addChild(this.selectWnd);
			LayerManager.getInstance().mainLayer.addChild(this.smallMapWnd);
			LayerManager.getInstance().mainLayer.addChild(this.roleHeadWnd);
			LayerManager.getInstance().mainLayer.addChild(this.toolsWnd);
			LayerManager.getInstance().mainLayer.addChild(this.rightTopWnd);
			LayerManager.getInstance().mainLayer.addChild(this.chatWnd);
			LayerManager.getInstance().mainLayer.addChild(this.taskTrack);
			LayerManager.getInstance().mainLayer.addChild(this.leftTopWnd);
			this.chatWnd.addKeyDownFun();
			//			if (!Core.isTencent)
			LayerManager.getInstance().mainLayer.addChild(this.adWnd);



			this.leftTopWnd.resize();
			this.smallMapWnd.resize();
			this.toolsWnd.resize();
			this.rightTopWnd.resize();
			this.chatWnd.resize();
			this.taskTrack.resize();
			this.adWnd.resize();


			this.fcmWnd=new FcmTips();
			this.faceWnd=new FaceWnd();
			this.chatConfigWnd=new ChatConfig();
			this.moldWnd=new MoldOpenWnd();
			this.continuousWgt=new ContinuousWidget();

			//			this.onlineReward=new OnlineReward();
			//			this.onlinePanel=new OnlineRewardPanel();
			this.attackHeadWnd=new AttackRoleHead();
			this.duelResultWnd=new DuelResultWnd();

			LayerManager.getInstance().windowLayer.addChild(this.moldWnd);
			LayerManager.getInstance().mainLayer.addChild(this.fcmWnd);
			LayerManager.getInstance().mainLayer.addChild(this.chatConfigWnd);
			LayerManager.getInstance().mainLayer.addChild(this.continuousWgt);
			LayerManager.getInstance().windowLayer.addChild(this.duelResultWnd);

			LayerManager.getInstance().mainLayer.addChild(this.funForcastWnd);
			//			LayerManager.getInstance().windowLayer.addChild(this.onlinePanel);
			LayerManager.getInstance().mainLayer.addChild(this.faceWnd);
			LayerManager.getInstance().mainLayer.addChild(this.attackHeadWnd);

			// 临时用,后面改
			//			LayerManager.getInstance().mainLayer.addChild(this.onlineReward);
			//			if (Core.clientTest)
			//				return;


			this.backPackDropWnd=new BagDropPanel();
			this.backPackSplitWnd=new BagSplitPanel();
			this.backLotUseWnd=new BackLotUseWnd();
			this.backAddWnd=new BackAddWnd();
			this.taskWnd=new TaskWnd();
			this.taskNpcTalkWnd=new MissionAcceptWnd();
			//			this.friendWnd=new FriendWnd();
			//			this.friendAddWnd=new FriendAddWnd();

			this.maillWnd=new MailWnd();
			this.maillReadWnd=new MaillReadWnd();
			this.taskCollectProgress=new com.ace.ui.LoadingManager();

			this.backpackWnd=new BackpackWnd();
			this.roleWnd=new RoleWnd();
			this.skillWnd=new SkillWnd();

			this.buyWnd=new BuyWnd();
			this.quickBuyWnd=new QuickBuyWnd(); //===============
			this.mountLvUpwnd=new MountLvUpWnd();
			this.mountTradeWnd=new MountTradeWnd();
			this.wingLvUpWnd=new WingLvUpWnd();
			this.wingTradeWnd=new WingTradeWnd();
			this.otherPlayerWnd=new OtherPlayerWnd(); //================

			this.teamWnd=new TeamWnd();
			this.deliveryWnd=new DeliveryWnd();
			this.postWnd=new PostWnd();
			this.pkCopyWnd=new DungeonTZWnd();

			this.soundConfig=new AssistSoundConfigWnd();
			this.viewConfig=new AssistViewConfigWnd();

			this.convenientTransfer=new ConvenientTransferWnd();
			this.convenientWear=new ConvenientWearWnd();
			this.convenientUse=new ConvenientUseWnd();

			LayerManager.getInstance().windowLayer.addChild(this.backpackWnd);
			LayerManager.getInstance().windowLayer.addChild(this.backPackSplitWnd);
			LayerManager.getInstance().windowLayer.addChild(this.backPackDropWnd);
			LayerManager.getInstance().windowLayer.addChild(this.buyWnd);
			LayerManager.getInstance().windowLayer.addChild(this.quickBuyWnd);
			LayerManager.getInstance().windowLayer.addChild(this.backLotUseWnd);
			LayerManager.getInstance().windowLayer.addChild(this.backAddWnd);
			LayerManager.getInstance().windowLayer.addChild(this.mountLvUpwnd);
			LayerManager.getInstance().windowLayer.addChild(this.mountTradeWnd);
			LayerManager.getInstance().windowLayer.addChild(this.teamWnd);
			LayerManager.getInstance().windowLayer.addChild(this.wingLvUpWnd);
			LayerManager.getInstance().windowLayer.addChild(this.wingTradeWnd);
			LayerManager.getInstance().windowLayer.addChild(this.deliveryWnd);

			LayerManager.getInstance().windowLayer.addChild(this.skillWnd);
			LayerManager.getInstance().windowLayer.addChild(this.taskWnd);
			LayerManager.getInstance().windowLayer.addChild(this.taskNpcTalkWnd);
			//			LayerManager.getInstance().windowLayer.addChild(this.friendWnd);
			//			LayerManager.getInstance().windowLayer.addChild(this.friendAddWnd);
			LayerManager.getInstance().windowLayer.addChild(this.maillWnd);
			LayerManager.getInstance().windowLayer.addChild(this.maillReadWnd);
			LayerManager.getInstance().windowLayer.addChild(this.taskCollectProgress);
			LayerManager.getInstance().windowLayer.addChild(this.otherPlayerWnd);
			LayerManager.getInstance().windowLayer.addChild(this.roleWnd);
			LayerManager.getInstance().windowLayer.addChild(this.convenientTransfer);
			LayerManager.getInstance().windowLayer.addChild(this.convenientWear);
			LayerManager.getInstance().windowLayer.addChild(this.convenientUse);
			LayerManager.getInstance().windowLayer.addChild(this.soundConfig);
			LayerManager.getInstance().windowLayer.addChild(this.viewConfig);
			LayerManager.getInstance().windowLayer.addChild(this.postWnd);
//			LayerManager.getInstance().windowLayer.addChild(this.pkCopyWnd);

			this.loadingWnd=new SlidesWnd();
			this.loadingWnd.setEffectVisiable(true);
			this.loadingWnd.visible=false;
			LayerManager.getInstance().windowLayer.addChild(this.loadingWnd);
			this.addKeyFun();
			this.onResize();
		}

		override protected function addKeyFun():void {
			super.addKeyFun();
			//			KeysManager.getInstance().addKeyFun(Keyboard.V, Cmd_backPack.cm_addStarItem); //会员面板	V
			//			KeysManager.getInstance().addKeyFun(Keyboard.J, Cmd_Trade.cm_dealTry); //交易面板	J
			//			KeysManager.getInstance().addKeyFun(Keyboard.D, Cmd_Stall.cm_btItem); //摆摊功能	D  
			//			KeysManager.getInstance().addKeyFun(Keyboard.G, this.guildWnd.showkey); //帮会面板	G

			//			KeysManager.getInstance().addKeyFun(Keyboard.A, this.deliveryWnd.open); //切换PK模式	A
			//			KeysManager.getInstance().addKeyFun(Keyboard.Q, Cmd_Qa.cmQaEnter); //切换PK模式	A

			KeysManager.getInstance().addKeyFun(Keyboard.C, onKeyDown); //人物面板	C
			KeysManager.getInstance().addKeyFun(Keyboard.B, onKeyDown); //背包面板	B
			KeysManager.getInstance().addKeyFun(Keyboard.T, onKeyDown); //背包面板	B
			KeysManager.getInstance().addKeyFun(Keyboard.F, onKeyDown); //好友面板	F
			KeysManager.getInstance().addKeyFun(Keyboard.L, onKeyDown); //好友面板	F

			KeysManager.getInstance().addKeyFun(Keyboard.X, this.roleWnd.mountUpAndDown); //好友面板	F
			KeysManager.getInstance().addKeyFun(Keyboard.G, onKeyDown);
			KeysManager.getInstance().addKeyFun(Keyboard.O, onKeyDown);
			KeysManager.getInstance().addKeyFun(Keyboard.V, onKeyDown);
			KeysManager.getInstance().addKeyFun(Keyboard.S, onKeyDown);

			KeysManager.getInstance().addKeyFun(Keyboard.D, onKeyDown); //商城面板	S
			KeysManager.getInstance().addKeyFun(Keyboard.P, onKeyDown); //寄售面板	S
			KeysManager.getInstance().addKeyFun(Keyboard.Y, onKeyDown); 
			KeysManager.getInstance().addKeyFun(Keyboard.R, onKeyDown); 
			KeysManager.getInstance().addKeyFun(Keyboard.K, onKeyDown); 

			//			KeysManager.getInstance().addKeyFun(Keyboard.M, this.mapWnd.open); //地图面板	M
			//			KeysManager.getInstance().addKeyFun(Keyboard.O, this.settingWnd.open); //系统设置	O
			//			KeysManager.getInstance().addKeyFun(Keyboard.A, this.chatWnd.aOperate); //开/关轮流切换

			//			KeysManager.getInstance().addKeyFun(Keyboard.xxxx, this.roleWnd.open);//   物品、技能快捷键	1-7QWE       
			//			KeysManager.getInstance().addKeyFun(Keyboard.ENTER, this.chatWnd.onEnterDown); //聊天焦点激活	Enter 
			//			KeysManager.getInstance().addKeyFun(Keyboard.A, AssistWnd.getInstance().open);

			KeysManager.getInstance().addKeyFun(Keyboard.H, this.roleHeadWnd.toNextPkMode);
			return;
			//测试
		}


		private function onKeyDown(event:KeyboardEvent):void {
			var code:int=event.keyCode;
//			if (code == Keyboard.Y) {
//				UILayoutManager.getInstance().open_II(WindowEnum.KEEP_7);
//				return;
//			}
//			showWindow(WindowEnum.ICE_BATTLE_PAUSE);
//			DataManager.getInstance().iceBattleData.creatData1();
//			iceBattlefieldPause.updateInfo();
//			DataManager.getInstance().iceBattleData.creatData2();
//			iceBattlefieldPause.updateInfo();
//			return;
			if (null == _keyDic[code]) {
				return;
			}
			var openLevel:int=_keyDic[code][0];
			var wndEnum:int=_keyDic[code][1];
			if (Core.me.info.level >= openLevel) {
				var wenum:Array=[WindowEnum.BACKPACK, WindowEnum.TASK, WindowEnum.ROLE, WindowEnum.TEAM, WindowEnum.EQUIP, WindowEnum.GUILD, WindowEnum.SKILL, WindowEnum.BADAGE];
				if (wenum.indexOf(wndEnum) > -1) {
					UILayoutManager.getInstance().open_II(wndEnum);
				} else {
					UIOpenBufferManager.getInstance().open(wndEnum);
				}
			}
		}

		public function updateMonster(act:int):void {

			if (act == 1) {
				this.taskTrack.updateOhterTrack(TaskEnum.taskLevel_monsterLine, [PropUtils.getStringById(1522), StringUtil.substitute(PropUtils.getStringById(1523), ["other_wbs--"]), "", "", wbscallback]);
			} else if (act == 0)
				this.taskTrack.delOtherTrack(TaskEnum.taskLevel_monsterLine);

		}

		private function wbscallback():void {
			Cmd_Act.cmActNowAccept(PkCopyEnum.PKCOPY_INVADE);
		}


		override public function onResize($w:Number=0, $h:Number=0):void {
			super.onResize($w, $h);
			this.toolsWnd.resize();
			//			this.chatWnd.resize();
			this.chatWnd.resize();
			this.faceWnd.resize();
			this.chatConfigWnd.resize();
			this.smallMapWnd.resize();
			this.taskTrack.resize();
			this.taskWnd.resize();
			this.convenientTransfer.resize();
			this.convenientUse.resize();
			this.convenientWear.resize();
			//this.noticeMidownUproll.resize();
			//			this.wingLvUpWnd.resise();

			this.roleWnd.resise();
			this.slidesWnd.reSize();

			if (this.skillWnd != null)
				this.skillWnd.resize();

			this.taskCollectProgress.resize();
			this.moldWnd.resize();

			this.soundConfig.resize();
			this.viewConfig.resize();

			this.continuousWgt.resize();
			for (var key:String in _claDic) {
				var wnd:AutoWindow=getWindow(int(key)) as AutoWindow;
				if (null != wnd) {
					wnd.setToCenter();
				}
			}

			if (this.backpackWnd != null)
				this.backpackWnd.resize();

			this.rightTopWnd.resize();

			if (this.questionWnd != null)
				this.questionWnd.resize();

			if (this.arenaWnd != null) {
				this.arenaWnd.resise();
				this.arenaWnd.reBtnsise();
			}

			if (this.deliveryWnd != null)
				this.deliveryWnd.resise();

			if (null != this.copyTrack) {
				this.copyTrack.resize();
			}
			if (null != this.expCopyTrack) {
				this.expCopyTrack.resize();
			}

			if (null != this.pkCopySGTrack) {
				this.pkCopySGTrack.reSize();
			}

			if (null != this.guildCopyTrack) {
				this.guildCopyTrack.reSize();
			}

			if (null != funOpenWnd) {
				this.funOpenWnd.resize();
			}

			this.funForcastWnd.resize();
			this.fcmWnd.reSize();

			if (null != this.monsterInvadeWnd) {
				this.monsterInvadeWnd.resize();
			}

			this.taskNpcTalkWnd.resize();

			if (null != this.guildWnd) {
				this.guildWnd.resize();
			}

			if (null != this.teamWnd) {
				this.teamWnd.resise();
			}

			if (null != this.equipWnd) {
				this.equipWnd.resise();
			}

			if (null != this.badgeWnd) {
				this.badgeWnd.resise();
			}

			if (null != this.topUpWnd) {
				this.topUpWnd.resise();
			}

			if (null != this.pkCopyWnd) {
				this.pkCopyWnd.resise();
			}

			if (null != this.myStore) {
				this.myStore.resise();
			}

			if (null != this.adWnd) {
				this.adWnd.resize();
			}

			if (null != this.postWnd) {
				this.postWnd.resize();
			}

			if (null != this.tbTrack) {
				this.tbTrack.reSize();
			}

			if (null != this.bltTrack) {
				this.bltTrack.reSize();
			}

			if (null != this.attackHeadWnd) {
				this.attackHeadWnd.resize();
			}

			if (null != this.payRankWnd) {
				this.payRankWnd.resize();
			}

			if (null != this.guildBattleRankTrack) {
				this.guildBattleRankTrack.resize();
			}

			if (null != this.loadingWnd) {
				this.loadingWnd.reSize();
			}

			if (null != this.qqVipWnd) {
				this.qqVipWnd.resize();
			}


			if (null != this.teamCopyTrackWnd) {
				this.teamCopyTrackWnd.resize();
			}

			if (null != this.teamCopyRewardWnd) {
				this.teamCopyRewardWnd.resize();
			}

			if (null != this.teamCopyWnd) {
				this.teamCopyWnd.resize();
			}

			if (null != this.groupBuyWnd) {
				this.groupBuyWnd.resize();
			}

			if (null != this.cityBattleTrack) {
				this.cityBattleTrack.resize();
			}

			if (null != this.iceBattlefieldTrack) {
				this.iceBattlefieldTrack.resize();
			}

			LastTimeImageManager.getInstance().reSize();
			NoticeManager.getInstance().resize();
			GuideManager.getInstance().resize();
		}

		public function isCreateAndVisible(wndEnum:int):Boolean {
			return (isCreate(wndEnum) && getWindow(wndEnum).visible);
		}
	}
}

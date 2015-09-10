package com.ace.gameData.manager {
	import com.ace.gameData.manager.child.MTableManager;
	import com.ace.gameData.table.TAbidePayInfo;
	import com.ace.gameData.table.TAchievementInfo;
	import com.ace.gameData.table.TActiveInfo;
	import com.ace.gameData.table.TActiveRewardInfo;
	import com.ace.gameData.table.TAd;
	import com.ace.gameData.table.TAlchemy;
	import com.ace.gameData.table.TAreaCelebrateInfo;
	import com.ace.gameData.table.TAttributeInfo;
	import com.ace.gameData.table.TBackpackAdd;
	import com.ace.gameData.table.TBlackStoreInfo;
	import com.ace.gameData.table.TBuffAward;
	import com.ace.gameData.table.TCityBattleRewardInfo;
	import com.ace.gameData.table.TCollectionPreciousInfo;
	import com.ace.gameData.table.TCopyInfo;
	import com.ace.gameData.table.TDragonBallPropertyInfo;
	import com.ace.gameData.table.TDragonBallRewardInfo;
	import com.ace.gameData.table.TDungeon_Base;
	import com.ace.gameData.table.TEquipBlessInfo;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.gameData.table.TExpCopyInfo;
	import com.ace.gameData.table.TFarmLandInfo;
	import com.ace.gameData.table.TFarmLvInfo;
	import com.ace.gameData.table.TFarmPlantInfo;
	import com.ace.gameData.table.TFieldBossInfo;
	import com.ace.gameData.table.TFunForcastInfo;
	import com.ace.gameData.table.TGroupBuyItemInfo;
	import com.ace.gameData.table.TGuideInfo;
	import com.ace.gameData.table.TGuildBattleInfo;
	import com.ace.gameData.table.THallows;
	import com.ace.gameData.table.TIcebattleReward;
	import com.ace.gameData.table.TInvestInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TKeep_7;
	import com.ace.gameData.table.TLZItemInfo;
	import com.ace.gameData.table.TLaba;
	import com.ace.gameData.table.TLegendaryWeaponInfo;
	import com.ace.gameData.table.TLevelGiftInfo;
	import com.ace.gameData.table.TMarketInfo;
	import com.ace.gameData.table.TMissionDate;
	import com.ace.gameData.table.TMissionMarketInfo;
	import com.ace.gameData.table.TMissionMarketRewardInfo;
	import com.ace.gameData.table.TMount;
	import com.ace.gameData.table.TMountLv;
	import com.ace.gameData.table.TNpcFunction;
	import com.ace.gameData.table.TPassivitySkillInfo;
	import com.ace.gameData.table.TPayPromotion;
	import com.ace.gameData.table.TPetAttackInfo;
	import com.ace.gameData.table.TPetFriendlyInfo;
	import com.ace.gameData.table.TPetInfo;
	import com.ace.gameData.table.TPetSkillInfo;
	import com.ace.gameData.table.TPetStarInfo;
	import com.ace.gameData.table.TPointInfo;
	import com.ace.gameData.table.TPromptInfo;
	import com.ace.gameData.table.TQQVipDayRewardInfo;
	import com.ace.gameData.table.TQQVipLvRewardInfo;
	import com.ace.gameData.table.TQQVipNewRewardInfo;
	import com.ace.gameData.table.TQuestion;
	import com.ace.gameData.table.TRankRewardInfo;
	import com.ace.gameData.table.TSevenDayInfo;
	import com.ace.gameData.table.TSevenDayRewardInfo;
	import com.ace.gameData.table.TShop;
	import com.ace.gameData.table.TSignGiftInfo;
	import com.ace.gameData.table.TSkillInfo;
	import com.ace.gameData.table.TSkillLvInfo;
	import com.ace.gameData.table.TStorageAdd;
	import com.ace.gameData.table.TSuit;
	import com.ace.gameData.table.TTitle;
	import com.ace.gameData.table.TTobeStrongInfo;
	import com.ace.gameData.table.TTobeStrongLevelInfo;
	import com.ace.gameData.table.TTzActiive;
	import com.ace.gameData.table.TUnion_Bless;
	import com.ace.gameData.table.TUnion_attribute;
	import com.ace.gameData.table.TVIPAttribute;
	import com.ace.gameData.table.TVIPDetailInfo;
	import com.ace.gameData.table.TVIPInfo;
	import com.ace.gameData.table.TVendueInfo;
	import com.ace.gameData.table.TWing_Trade;
	import com.ace.gameData.table.TZdlElement;
	import com.ace.manager.LibManager;
	import com.leyou.utils.PropUtils;


	//单例类
	public class TableManager extends MTableManager {

		private static var INSTANCE:TableManager;


		private var itemDic:Object;
		private var equipDic:Object;
		private var shopDic:Object;
		private var pointDic:Object;
		private var missionDic:Object;
		private var hallowsDic:Object;
		private var titleDic:Object;
		private var bagAddDic:Object;
		private var storeAddDic:Object;
		private var mountDic:Object;
		private var mountlvDic:Object;
		private var plantDic:Object;
		private var landDic:Object;
		private var landLvDic:Object;
		private var npcFuncionDic:Object;
		private var copyDic:Object;
		private var questionDic:Object;
		private var expCopyDic:Object;
		private var lzLvelDic:Object;
		private var signGift:Object;
		private var levelGift:Object;
		private var funForcast:Object;
		private var activeDic:Object;
		private var activeReward:Object;
		private var guideDic:Object;
		private var promptDic:Object;
		private var zdlEDic:Object;
		private var achievementDic:Object;
		private var guildAttributeDic:Object;
		private var vipDic:Object;
		private var vipDetailDic:Object;
		private var vipAttributeDic:Object;
		private var guildCopyDic:Object;
		private var buffAwardDic:Object;
		private var passiveSkillDic:Object;
		private var equipBlessDic:Object;
		private var _achievementCount:int;
		private var fieldBossDic:Object;
		private var tobeStrongDic:Object;
		private var tobeStrongLevelDic:Object;
		private var payPromotionDic:Object;
		private var adDic:Object;
		private var pkCopyDic:Object;
		private var sevenDayDic:Object;
		private var sevenDayRewardDic:Object;
		private var investLeveDic:Object;
		private var areaCelebrateDic:Object;
		private var uniteCelebrateDic:Object;
		private var _rankRewardDic:Object;
		private var guildBattleDic:Object;
		private var qqVipNewReward:Object;
		private var qqVipLvReward:Object;
		private var qqVipDayReward:Object;
		private var collectionDic:Object;
		private var collectionGroupDic:Object;
		private var abidePayDic:Object;
		private var combineDic:Object;
		private var _rankRewardHeDic:Object;
		private var groupBuyDic:Object;
		private var vendueDic:Object;
		private var cityBattleRewardDic:Object;
		private var wingTrade:Object;
		private var iceBattleReward:Object;
		private var suitGroupDic:Object;
		private var legendaryDic:Object;
		private var attributeDic:Object;
		private var marketDic:Object;
		private var petDic:Object;
		private var petAttackDic:Object;
		private var petFriendDic:Object;
		private var petSkillDic:Object;
		private var petStarDic:Object;
		private var blackStoreDic:Object;
		private var skillLvDic:Object;
		private var missionMarketDic:Object;
		private var missionRewardDic:Object;
		private var keep7Dic:Object;
		private var guildBlessDic:Object;
		private var dragonBallRewardDic:Object;
		private var dragonBallPropertyDic:Object;
		private var alchemyDic:Object;
		private var labaDic:Object;

		public function TableManager() {
			super();
		}

		public static function getInstance():TableManager {
			if (!INSTANCE)
				INSTANCE=new TableManager();

			return INSTANCE;
		}

		public function get rankRewardDic():Object {
			if (1 == DataManager.getInstance().serverData.status) {
				return _rankRewardDic;
			} else {
				return _rankRewardHeDic;
			}
			return _rankRewardDic;
		}

		public function get achievementCount():int {
			return _achievementCount;
		}

		override protected function initMcConfig():void {
			super.initMcConfig();
			this.itemDic={};
			this.equipDic={};
			this.shopDic={};
			this.pointDic={};
			this.missionDic={};
			this.hallowsDic={};
			this.titleDic={};
			this.bagAddDic={};
			this.storeAddDic={};
			this.mountDic={};
			this.mountlvDic={};
			this.plantDic={};
			this.landDic={};
			this.landLvDic={};
			this.npcFuncionDic={};
			this.copyDic={};
			this.guildCopyDic={};
			this.questionDic={};
			this.expCopyDic={};
			this.lzLvelDic={};
			this.signGift={};
			this.levelGift={};
			this.funForcast={};
			this.activeDic={};
			this.activeReward={};
			this.guideDic={};
			this.promptDic={};
			this.zdlEDic={};
			this.achievementDic={};
			this.guildAttributeDic={};
			this.buffAwardDic={};
			this.vipDic={};
			this.vipDetailDic={};
			this.vipAttributeDic={};
			this.passiveSkillDic={};
			this.equipBlessDic={};
			this.fieldBossDic={};
			this.payPromotionDic={};
			this.adDic={};
			this.pkCopyDic={};
			this.tobeStrongDic={};
			this.tobeStrongLevelDic={};
			this.sevenDayDic={};
			this.sevenDayRewardDic={};
			this.investLeveDic={};
			this.areaCelebrateDic={};
			this.uniteCelebrateDic={};
			this._rankRewardDic={};
			this.guildBattleDic={};
			this.qqVipDayReward={};
			this.qqVipLvReward={};
			this.qqVipNewReward={};
			this.collectionDic={};
			this.collectionGroupDic={};
			this.abidePayDic={};
			this.combineDic={};
			this._rankRewardHeDic={};
			this.groupBuyDic={};
			this.vendueDic={};
			this.cityBattleRewardDic={};
			this.wingTrade={};
			this.iceBattleReward={};
			this.suitGroupDic={};
			this.legendaryDic={};
			this.attributeDic={};
			this.marketDic={};
			this.petDic={};
			this.petAttackDic={};
			this.petFriendDic={};
			this.petSkillDic={};
			this.petStarDic={};
			this.blackStoreDic={};
			this.skillLvDic={};
			this.missionMarketDic={};
			this.missionRewardDic={};
			this.keep7Dic={};
			this.guildBlessDic={};
			this.dragonBallRewardDic={};
			this.dragonBallPropertyDic={};
			this.alchemyDic={};
			this.labaDic={};
			
			var info:XML;
			var render:XML;

			//道具表格
			info=LibManager.getInstance().getXML("config/table/itemTable.xml");
			for each (render in info.children()) {
				this.itemDic[render.@id]=new TItemInfo(render);
			}

			//背包开启
			info=LibManager.getInstance().getXML("config/table/backpackAdd.xml");
			for each (render in info.children()) {
				this.bagAddDic[render.@backId]=new TBackpackAdd(render);
			}

			//仓库开启
			info=LibManager.getInstance().getXML("config/table/storageAdd.xml");
			for each (render in info.children()) {
				this.storeAddDic[render.@storId]=new TStorageAdd(render);
			}

			//道具表格
			info=LibManager.getInstance().getXML("config/table/equipTable.xml");
			for each (render in info.children()) {
				this.equipDic[render.@id]=new TEquipInfo(render);
			}

			//商店
			info=LibManager.getInstance().getXML("config/table/shop.xml");
			for each (render in info.children()) {
				this.shopDic[render.@itemId]=new TShop(render);
			}

			//点表
			info=LibManager.getInstance().getXML("config/table/pointTable.xml");
			for each (render in info.children()) {
				this.pointDic[render.@id]=new TPointInfo(render);
			}

			//圣器
			info=LibManager.getInstance().getXML("config/table/Hallows.xml");
			for each (render in info.children()) {
				this.hallowsDic[render.@Hallows_ID]=new THallows(render);
			}

			//任务
			info=LibManager.getInstance().getXML("config/table/missionDate.xml");
			for each (render in info.children()) {
				this.missionDic[render.@id]=new TMissionDate(render);
			}

			//称号
			info=LibManager.getInstance().getXML("config/table/title.xml");
			for each (render in info.children()) {
				this.titleDic[render.@titleId]=new TTitle(render);
			}

			//称号
			info=LibManager.getInstance().getXML("config/table/mount.xml");
			for each (render in info.children()) {
				this.mountDic[render.@lv2]=new TMount(render);
			}

			//称号
			info=LibManager.getInstance().getXML("config/table/mountLv.xml");
			for each (render in info.children()) {
				this.mountlvDic[render.@lv]=new TMountLv(render);
			}

			//农场作物信息
			info=LibManager.getInstance().getXML("config/table/farmPlant.xml");
			for each (render in info.children()) {
				var tinfo:TFarmPlantInfo=new TFarmPlantInfo(render);
				this.plantDic[render.@name]=tinfo;
				this.plantDic[render.@index]=tinfo;
			}

			//农场土地信息
			info=LibManager.getInstance().getXML("config/table/farmLand.xml");
			for each (render in info.children()) {
				this.landDic[render.@index]=new TFarmLandInfo(render);
			}

			//农场级别信息
			info=LibManager.getInstance().getXML("config/table/farmLv.xml");
			for each (render in info.children()) {
				this.landLvDic[render.@farmLv]=new TFarmLvInfo(render);
			}

			info=LibManager.getInstance().getXML("config/table/npcFunction.xml");
			for each (render in info.children()) {
				this.npcFuncionDic[render.@index]=new TNpcFunction(render);
			}

			// 副本信息
			info=LibManager.getInstance().getXML("config/table/Dungeon_Base.xml");
			for each (render in info.children()) {
				this.copyDic[render.@Dungeon_ID]=new TCopyInfo(render);
			}

			// 副本信息
			info=LibManager.getInstance().getXML("config/table/Dungeon_Base.xml");
			for each (render in info.children()) {
				this.guildCopyDic[render.@Dungeon_ID]=new TDungeon_Base(render);
			}

			//答题
			info=LibManager.getInstance().getXML("config/table/question.xml");
			for each (render in info.children()) {
				this.questionDic[render.@Id]=new TQuestion(render);
			}

			// 练级副本
			info=LibManager.getInstance().getXML("config/table/monsterScene.xml");
			for each (render in info.children()) {
				this.expCopyDic[render.@Id]=new TExpCopyInfo(render);
			}

			// 连斩图标配置
			info=LibManager.getInstance().getXML("config/table/Ma_Show.xml");
			for each (render in info.children()) {
				this.lzLvelDic[render.@Ma_ID]=new TLZItemInfo(render);
			}

			// 福利-签到
			info=LibManager.getInstance().getXML("config/table/giftLogin.xml");
			for each (render in info.children()) {
				this.signGift[render.@day]=new TSignGiftInfo(render);
			}

			// 福利-等级
			info=LibManager.getInstance().getXML("config/table/GiftLevel.xml");
			for each (render in info.children()) {
				this.levelGift[render.@Level]=new TLevelGiftInfo(render);
			}

			// 功能开启预告
			info=LibManager.getInstance().getXML("config/table/functionNotice.xml");
			for each (render in info.children()) {
				this.funForcast[render.@id]=new TFunForcastInfo(render);
			}

			// 活跃度
			info=LibManager.getInstance().getXML("config/table/Activity_Date.xml");
			for each (render in info.children()) {
				this.activeDic[render.@Activity_ID]=new TActiveInfo(render);
			}

			// 活跃度奖励
			info=LibManager.getInstance().getXML("config/table/Activity_Reward.xml");
			for each (render in info.children()) {
				this.activeReward[render.@AR_level]=new TActiveRewardInfo(render);
			}

			// 指引
			info=LibManager.getInstance().getXML("config/table/guildTable.xml");
			for each (render in info.children()) {
				this.guideDic[render.@id]=new TGuideInfo(render);
			}

			// 加载时小提示
			info=LibManager.getInstance().getXML("config/table/prompt.xml");
			for each (render in info.children()) {
				this.promptDic[render.@id]=new TPromptInfo(render);
			}

			// 战斗力计算元素
			info=LibManager.getInstance().getXML("config/table/zdl.xml");
			for each (render in info.children()) {
				this.zdlEDic[render.@id]=new TZdlElement(render);
			}

			// 成就信息
			info=LibManager.getInstance().getXML("config/table/history.xml");
			for each (render in info.children()) {
				_achievementCount++;
				this.achievementDic[render.@id]=new TAchievementInfo(render);
			}

			//行会技能
			info=LibManager.getInstance().getXML("config/table/Union_attribute.xml");
			for each (render in info.children()) {
				this.guildAttributeDic[render.@id]=new TUnion_attribute(render);
			}

			// VIP信息
			info=LibManager.getInstance().getXML("config/table/VIP.xml");
			for each (render in info.children()) {
				this.vipDic[render.@modid]=new TVIPInfo(render);
			}

			// VIP详细信息
			info=LibManager.getInstance().getXML("config/table/vipSet.xml");
			for each (render in info.children()) {
				this.vipDetailDic[render.@id]=new TVIPDetailInfo(render);
			}

			// VIP属性信息
			info=LibManager.getInstance().getXML("config/table/vipEquipAt.xml");
			for each (render in info.children()) {
				this.vipAttributeDic[render.@lv]=new TVIPAttribute(render);
			}

			// 七天任务
			info=LibManager.getInstance().getXML("config/table/7day_test.xml");
			for each (render in info.children()) {
				this.sevenDayDic[render.@day7_ID]=new TSevenDayInfo(render);
			}

			// 七天任务奖励
			info=LibManager.getInstance().getXML("config/table/7day_Reward.xml");
			for each (render in info.children()) {
				this.sevenDayRewardDic[render.@Day_ID]=new TSevenDayRewardInfo(render);
			}

			// 被动技能
			info=LibManager.getInstance().getXML("config/table/passiveSkill.xml");
			for each (render in info.children()) {
				this.passiveSkillDic[render.@id]=new TPassivitySkillInfo(render);
			}

			// 神器祝福
			info=LibManager.getInstance().getXML("config/table/vEquipBless.xml");
			for each (render in info.children()) {
				this.equipBlessDic[render.@id]=new TEquipBlessInfo(render);
			}

			//buffAward
			info=LibManager.getInstance().getXML("config/table/buffAward.xml");
			for each (render in info.children()) {
				this.buffAwardDic[render.@id]=new TBuffAward(render);
			}

			// 野外BOSS
			info=LibManager.getInstance().getXML("config/table/bossOut.xml");
			for each (render in info.children()) {
				this.fieldBossDic[render.@id]=new TFieldBossInfo(render);
			}

			// 充值返利
			info=LibManager.getInstance().getXML("config/table/Sale_Daily.xml");
			for each (render in info.children()) {
				this.payPromotionDic[render.@id]=new TPayPromotion(render);
			}

			// 滚动广告
			info=LibManager.getInstance().getXML("config/table/ad.xml");
			for each (render in info.children()) {
				this.adDic[render.@Id]=new TAd(render);
			}

			// 我要变强
			info=LibManager.getInstance().getXML("config/table/tobestr.xml");
			for each (render in info.children()) {
				this.tobeStrongDic[render.@id]=new TTobeStrongInfo(render);
			}

			// 我要变强等级信息
			info=LibManager.getInstance().getXML("config/table/tobestr_att.xml");
			for each (render in info.children()) {
				this.tobeStrongLevelDic[render.@lv]=new TTobeStrongLevelInfo(render);
			}

			// 我要变强等级信息
			info=LibManager.getInstance().getXML("config/table/tzActive.xml");
			for each (render in info.children()) {
				this.pkCopyDic[render.@id]=new TTzActiive(render);
			}

			// 投资理财-基金奖励
			var varId:int=1;
			info=LibManager.getInstance().getXML("config/table/invest.xml");
			for each (render in info.children()) {
				this.investLeveDic[varId++]=new TInvestInfo(render);
			}

			// 新区庆典
			info=LibManager.getInstance().getXML("config/table/open_server.xml");
			for each (render in info.children()) {
				this.areaCelebrateDic[render.@id]=new TAreaCelebrateInfo(render);
			}

			// 合服庆典
			info=LibManager.getInstance().getXML("config/table/open_server_he.xml");
			for each (render in info.children()) {
				this.uniteCelebrateDic[render.@id]=new TAreaCelebrateInfo(render);
			}

			// 充值排行奖励
			info=LibManager.getInstance().getXML("config/table/dayAward.xml");
			for each (render in info.children()) {
				this._rankRewardDic[render.@id]=new TRankRewardInfo(render);
			}

			// 和服充值排行奖励
			info=LibManager.getInstance().getXML("config/table/dayAward_he.xml");
			for each (render in info.children()) {
				this._rankRewardHeDic[render.@id]=new TRankRewardInfo(render);
			}

			// 行会争霸
			info=LibManager.getInstance().getXML("config/table/Guild_Battle.xml");
			for each (render in info.children()) {
				var guildBInfo:TGuildBattleInfo=new TGuildBattleInfo(render);
				this.guildBattleDic[render.@GB_group]=guildBInfo;
				this.guildBattleDic[render.@GB_Retype + "|" + render.@GB_Ranking]=guildBInfo;
			}

			// QQ黄钻 - 新手奖励
			info=LibManager.getInstance().getXML("config/table/qqvip_new.xml");
			for each (render in info.children()) {
				this.qqVipNewReward[render.@id]=new TQQVipNewRewardInfo(render);
			}

			// QQ黄钻 - 每日奖励
			info=LibManager.getInstance().getXML("config/table/qqvip_day.xml");
			for each (render in info.children()) {
				this.qqVipDayReward[render.@qqlv]=new TQQVipDayRewardInfo(render);
			}

			// QQ黄钻 - 升级奖励
			info=LibManager.getInstance().getXML("config/table/qqvip_lv.xml");
			for each (render in info.children()) {
				this.qqVipLvReward[render.@lv]=new TQQVipLvRewardInfo(render);
			}

			// 物品收集
			info=LibManager.getInstance().getXML("config/table/collect.xml");
			for each (render in info.children()) {
				this.collectionDic[render.@Setin_ID]=new TCollectionPreciousInfo(render);
				this.collectionGroupDic[render.@Setin_Group]=new TCollectionPreciousInfo(render);
			}

			// 团购
			info=LibManager.getInstance().getXML("config/table/groupbuy.xml");
			for each (render in info.children()) {
				this.groupBuyDic[render.@id]=new TGroupBuyItemInfo(render);
			}

			// 拍卖
			info=LibManager.getInstance().getXML("config/table/vendue.xml");
			for each (render in info.children()) {
				this.vendueDic[render.@id]=new TVendueInfo(render);
			}

			// 连续充值
			info=LibManager.getInstance().getXML("config/table/lxcz.xml");
			for each (render in info.children()) {
				this.abidePayDic[render.@id]=new TAbidePayInfo(render);
			}
			
			// 和服连冲
			info=LibManager.getInstance().getXML("config/table/hflc.xml");
			for each (render in info.children()) {
				this.combineDic[render.@id]=new TAbidePayInfo(render);
			}

			// 主城争霸--奖励
			info=LibManager.getInstance().getXML("config/table/City_Fight.xml");
			for each (render in info.children()) {
				this.cityBattleRewardDic[render.@CF_ID]=new TCityBattleRewardInfo(render);
			}

			// 翅膀飞升
			info=LibManager.getInstance().getXML("config/table/Wing_Trade.xml");
			for each (render in info.children()) {
				this.wingTrade[render.@id]=new TWing_Trade(render);
			}
			
			// 属性表
			info=LibManager.getInstance().getXML("config/table/dic_num.xml");
			for each(render in info.children()){
				this.attributeDic[render.@id]=new TAttributeInfo(render);
			}
			// 神器
			info=LibManager.getInstance().getXML("config/table/Artifact_suit.xml");
			for each (render in info.children()) {
				this.legendaryDic[render.@Formula_ID]=new TLegendaryWeaponInfo(render);
			}

			// 霜炎战场奖励
			info=LibManager.getInstance().getXML("config/table/Op_Battle.xml");
			for each (render in info.children()) {
				var rewardInfo:TIcebattleReward=new TIcebattleReward(render);
				this.iceBattleReward[render.@GB_group]=rewardInfo;
				this.iceBattleReward[render.@GB_Ranking]=rewardInfo;
			}

			info=LibManager.getInstance().getXML("config/table/Suit.xml");
			var i:int=0;
			for each (render in info.children()) {
				this.suitGroupDic[i]=new TSuit(render);
				i++;
			}
			
			info=LibManager.getInstance().getXML("config/table/dic_num.xml");
			for each (render in info.children()) {
				PropUtils.setPropsArr(render);
			}

			// 商城表
			info=LibManager.getInstance().getXML("config/table/market.xml");
			for each (render in info.children()) {
				this.marketDic[render.@id]=new TMarketInfo(render);
			}
			
			// 宠物表
			var pindex:int;
			info=LibManager.getInstance().getXML("config/table/servent.xml");
			for each (render in info.children()) {
				this.petDic[pindex++]=new TPetInfo(render);
			}
			
			// 宠物友好度
			info=LibManager.getInstance().getXML("config/table/servent_friend.xml");
			for each (render in info.children()) {
				this.petFriendDic[render.@friId]=new TPetFriendlyInfo(render);
			}
			
			// 宠物战斗属性
			info=LibManager.getInstance().getXML("config/table/servent_att.xml");
			for each (render in info.children()) {
				this.petAttackDic[render.@starLv+"|"+render.@lv]=new TPetAttackInfo(render);
			}
			
			// 宠物技能
			info=LibManager.getInstance().getXML("config/table/servent_skill.xml");
			for each (render in info.children()) {
				this.petSkillDic[render.@id]=new TPetSkillInfo(render);
			}
			
			// 宠物星级
			info=LibManager.getInstance().getXML("config/table/servent_star.xml");
			for each (render in info.children()) {
				this.petStarDic[render.@serId+"|"+render.@starLv]=new TPetStarInfo(render);
			}
			
			// 黑市
			info=LibManager.getInstance().getXML("config/table/Discount.xml");
			for each (render in info.children()) {
				this.blackStoreDic[render.@Ds_ID]=new TBlackStoreInfo(render);
			}
			
			// 任务集市
			info=LibManager.getInstance().getXML("config/table/TaskMarket.xml");
			for each(render in info.children()){
				this.missionMarketDic[render.@Task_ID]=new TMissionMarketInfo(render);
			}
			
			// 任务集市奖励
			info=LibManager.getInstance().getXML("config/table/Task_Reward.xml");
			for each(render in info.children()){
				this.missionRewardDic[render.@Task_Type]=new TMissionMarketRewardInfo(render);
			}
			
			// 技能等级消耗
			info=LibManager.getInstance().getXML("config/table/skillLv.xml");
			for each (render in info.children()) {
				this.skillLvDic[render.@lv]=new TSkillLvInfo(render);
			}
			
			// 技能等级消耗
			info=LibManager.getInstance().getXML("config/table/keep_7.xml");
			for each (render in info.children()) {
				this.keep7Dic[render.@Keep_day]=new TKeep_7(render);
			}
			
			// 技能等级消耗
			info=LibManager.getInstance().getXML("config/table/Union_Bless.xml");
			for each (render in info.children()) {
				this.guildBlessDic[render.@ID]=new TUnion_Bless(render);
			}
			
			// 龙珠奖励
			info=LibManager.getInstance().getXML("config/table/Lh_Exchange.xml");
			for each(render in info.children()){
				this.dragonBallRewardDic[render.@Lh_ID]=new TDragonBallRewardInfo(render);
			}
			
			// 龙珠属性
			info=LibManager.getInstance().getXML("config/table/Lh_Add.xml");
			for each(render in info.children()){
				this.dragonBallPropertyDic[render.@Lh_AttID]=new TDragonBallPropertyInfo(render);
			}
			
			//炼金
			info=LibManager.getInstance().getXML("config/table/Alchemy.xml");
			for each(render in info.children()){
				this.alchemyDic[render.@Al_ID]=new TAlchemy(render);
			}
			
			//拉霸
			info=LibManager.getInstance().getXML("config/table/laba.xml");
			for each(render in info.children()){
				this.labaDic[render.@id]=new TLaba(render); 
			}
		}

		//=====================================获取===================================================================
		override public function getLanguage(id:int):String {
			if(!this.attributeDic.hasOwnProperty(id))
				return　"";
			
			return this.getAttributeInfo(id).attibuteDes;
		}
		
		public function getMissionMarketRewardInfo(type:int):TMissionMarketRewardInfo{
			return this.missionRewardDic[type];
		}
		
		public function getMissionMarketInfo(id:int):TMissionMarketInfo{
			return this.missionMarketDic[id];
		}
		
		public function getShopDic():Object {
			return this.shopDic;
		}
		
		public function getPetSkillDic():Object{
			return this.petSkillDic;
		}
		
		public function getSkillLvInfo(lv:int):TSkillLvInfo{
			return this.skillLvDic[lv];
		}
		
		public function getDragonBallRewardDic():Object{
			return this.dragonBallRewardDic;
		}
		
		public function getDragonBallReward(id:int):TDragonBallRewardInfo{
			return this.dragonBallRewardDic[id];
		}
		
		public function getDragonBallPropertyDic():Object{
			return this.dragonBallPropertyDic;
		}
		
		public function getDragonBallProperty(id:int):TDragonBallPropertyInfo{
			return this.dragonBallPropertyDic[id];
		}
		
		public function getPetDic():Object{
			return this.petDic;
		}
		
		public function getPetSkill(id:int):TPetSkillInfo{
			return this.petSkillDic[id];
		}
		
		public function getPetInfo(id:int):TPetInfo{
			for(var key:String in petDic){
				var petInfo:TPetInfo = petDic[key];
				if(petInfo.id == id){
					return petInfo;
				}
			}
			return null;
		}
		
		public function getPetFriendlyInfo(lv:int):TPetFriendlyInfo{
			return this.petFriendDic[lv];
		}
		
		public function getPetStarLvInfo(id:int, starLv:int):TPetStarInfo{
			return this.petStarDic[id+"|"+starLv];
		}
		
		public function getPetLvInfo(starLv:int, level:int):TPetAttackInfo{
			return this.petAttackDic[starLv+"|"+level]
		}
		
		public function getVendueInfo(id:int):TVendueInfo {
			return this.vendueDic[id];
		}
		
		public function getMarketItem(id:int):TMarketInfo{
			for(var key:String in marketDic){
				var minfo:TMarketInfo = marketDic[key];
				if(minfo.itemId == id){
					return minfo;
				}
			}
			return null;
		}
		
		public function getBlackStoreInfo(id:int):TBlackStoreInfo{
			return this.blackStoreDic[id];
		}
		
		public function getCityBattleRewardInfo(id:int):TCityBattleRewardInfo {
			return this.cityBattleRewardDic[id];
		}
		
		public function getAttributeInfo(id:int):TAttributeInfo{
			return this.attributeDic[id];
		}

		public function getGroupbuyItemInfo(id:int):TGroupBuyItemInfo {
			return this.groupBuyDic[id];
		}

		public function getAbidePayInfo(id:int):TAbidePayInfo {
			return this.abidePayDic[id];
		}
		
		public function getCombinePayInfo(id:int):TAbidePayInfo{
			return this.combineDic[id];
		}

		public function getPreciousById(id:int):TCollectionPreciousInfo {
			return this.collectionDic[id];
		}

		public function getPreciousByGroup(groupId:int):TCollectionPreciousInfo {
			return this.collectionGroupDic[groupId];
		}

		public function getCollectionDic():Object {
			return this.collectionDic;
		}

		public function getCollectionGroup():Object {
			return this.collectionGroupDic;
		}

		public function getAreaCelebrateInfo(id:int):TAreaCelebrateInfo {
			return this.areaCelebrateDic[id];
		}

		
		public function getSuitByGroup(g:int):Array {
			var arr:Array=[];
			var tsuit:TSuit;
			for each (tsuit in this.suitGroupDic) {
				if (tsuit.Suit_Group == g)
					arr.push(tsuit);
			}

			return arr;
		}

		public function getUniteCelebrateTypList():Array {
			var arr:Array=[];
			for (var key:String in areaCelebrateDic) {
				var item:TAreaCelebrateInfo=areaCelebrateDic[key];
				var index:int=arr.indexOf(item.type);
				if (-1 == index) {
					arr.push(index);
				}
			}
			return arr;
		}

		public function getGuileBattleDic():Object {
			return this.guildBattleDic;
		}

		public function getIceBattleDic():Object {
			return this.iceBattleReward;
		}

		public function getIceBattleReward(id:int):TIcebattleReward {
			return this.iceBattleReward[id];
		}

		public function getGuildBattleInfo(id:String):TGuildBattleInfo {
			return this.guildBattleDic[id];
		}

		public function getQQNewInfo(id:int):TQQVipNewRewardInfo {
			return this.qqVipNewReward[id];
		}

		public function getQQDayInfo(id:int):TQQVipDayRewardInfo {
			return this.qqVipDayReward[id];
		}

		public function getQQLvInfo(id:int):TQQVipLvRewardInfo {
			return this.qqVipLvReward[id];
		}

		public function getInvestDic():Object {
			return this.investLeveDic;
		}

		public function getSevenDayRewardInfo(id:int):TSevenDayRewardInfo {
			return this.sevenDayRewardDic[id];
		}

		public function getSevenDayInfo(id:int):TSevenDayInfo {
			return this.sevenDayDic[id];
		}

		public function getPassiveSkill(id:int):TPassivitySkillInfo {
			return this.passiveSkillDic[id];
		}

		public function getVipBlessInfo(type:int, level:int):TEquipBlessInfo {
			for (var key:String in this.equipBlessDic) {
				var info:TEquipBlessInfo=this.equipBlessDic[key];
				if (info.type == type && info.lv == level) {
					return info;
				}
			}
			return null;
		}
		
		public function getLegendaryInfo(pro:int, type:int):Array{
			var arr:Array = [];
			for (var key:String in this.legendaryDic) {
				var info:TLegendaryWeaponInfo=this.legendaryDic[key];
				if ((info.profession == pro) && (info.type == type)) {
					arr.push(info);
				}
			}
			return arr;
		}

		public function getTobeStrongLevelInfo(lv:int):TTobeStrongLevelInfo {
			return this.tobeStrongLevelDic[lv];
		}

		public function getTobeStrongInfo(id:int):TTobeStrongInfo {
			return this.tobeStrongDic[id];
		}

		public function getTobeStrongByType(type:int):Vector.<TTobeStrongInfo> {
			var arr:Vector.<TTobeStrongInfo>=new Vector.<TTobeStrongInfo>();
			for (var key:String in this.tobeStrongDic) {
				var tinfo:TTobeStrongInfo=tobeStrongDic[key];
				if ((null != tinfo) && (type == tinfo.type)) {
					arr.push(tinfo);
				}
			}
			return arr;
		}
		
		public function getPayPromotionByType(type:int):Array{
			var arr:Array = [];
			for(var key:String in payPromotionDic){
				var info:TPayPromotion = payPromotionDic[key];
				if(info.type == type){
					arr.push(info);
				}
			}
			return arr;
		}
		
		public function getPromotionDic():Object{
			return this.payPromotionDic;
		}

		public function getPayPromotion(id:int):TPayPromotion {
			return this.payPromotionDic[id]
		}

		public function getVipInfo(modeId:int):TVIPInfo {
			return this.vipDic[modeId];
		}

		public function getVipDic():Object {
			return this.vipDic;
		}

		public function getVipDetailInfo(id:int):TVIPDetailInfo {
			return this.vipDetailDic[id];
		}

		public function getVipAttribute(lv:int):TVIPAttribute {
			return this.vipAttributeDic[lv];
		}

		public function getGuideInfo(id:int):TGuideInfo {
			return this.guideDic[id];
		}

		public function getEquipInfo(id:int):TEquipInfo {
			return this.equipDic[id];
		}

		public function getItemInfo(id:int):TItemInfo {
			return this.itemDic[id];
		}

		public function getShopItem(id:int):TShop {
			return this.shopDic[id];
		}

		public function getCopyInfo(id:int):TCopyInfo {
			return this.copyDic[id];
		}

		public function getGuildCopyInfo(id:int):TDungeon_Base {
			return this.guildCopyDic[id];
		}

		public function getPlant(id:int):TFarmPlantInfo {
			return this.plantDic[id];
		}

		public function getPlantByName(name:String):TFarmPlantInfo {
			return this.plantDic[name];
		}

		public function getLandLvInfo(id:int):TFarmLvInfo {
			return this.landLvDic[id];
		}

		public function getLandInfo(id:int):TFarmLandInfo {
			return this.landDic[id];
		}

		public function getQuestInfo(id:int):TQuestion {
			return this.questionDic[id];
		}

		public function getExpCopyInfo(id:int):TExpCopyInfo {
			return this.expCopyDic[id];
		}

		public function getLZInfo(id:int):TLZItemInfo {
			return this.lzLvelDic[id];
		}

		public function getSignGiftInfo(id:int):TSignGiftInfo {
			return this.signGift[id];
		}

		public function getLevelGiftInfo(id:int):TLevelGiftInfo {
			return this.levelGift[id];
		}

		public function getFunForcstInfoById(id:int):TFunForcastInfo {
			return this.funForcast[id];
		}

		public function getBuffAwardById(id:int):TBuffAward {
			return this.buffAwardDic[id];
		}

		public function getFunForcstInfo(level:int):TFunForcastInfo {
			for each (var v:TFunForcastInfo in funForcast) {
				if (level >= v.showLevel && level < v.openLevel) {
					return v;
				}
			}
			return null;
		}

		public function getActiveInfo(id:int):TActiveInfo {
			return activeDic[id];
		}

		public function getActiveRewardInfo(id:int):TActiveRewardInfo {
			return activeReward[id];
		}

		public function getAddById(id:int):TActiveRewardInfo {
			return this.adDic[id];
		}

		public function getAddAll():Object {
			return this.adDic;
		}

		public function getCopyInfoBySceneId(sceneId:int):TCopyInfo {
			for each (var info:TCopyInfo in copyDic) {
				if (sceneId == info.sceneId) {
					return info;
				}
			}
			return null;
		}

		public function getPromptInfo(id:int):TPromptInfo {
			return promptDic[id];
		}

		public function getZdlElement(id:int):TZdlElement {
			return zdlEDic[id];
		}

		public function getAchievementInfo(id:int):TAchievementInfo {
			return achievementDic[id];
		}

		public function getAchievementDic():Object {
			return achievementDic;
		}

		public function getFieldBossInfo(id:int):TFieldBossInfo {
			return fieldBossDic[id];
		}

		public function getFieldBossDic():Object {
			return fieldBossDic;
		}

		/**
		 * <pre>
		 *1 装备
2 药剂
3 道具
4 任务
* //=============================================
*
* 1	持续类红药
2	瞬加类红药
3	储存类红药
4	持续类蓝药
5	瞬加类蓝药
6	储存类蓝药
7	持续类黄药
8	瞬加类黄药
9	储存类黄药
10	BUFF药剂（死亡不消失）
11	BUFF药剂（死亡消失）
12	待定
13	待定
14	待定
15	待定
16	待定
17	待定
18	待定
19	待定
20	待定


* @param classid
* @param subclass
* @return
* </pre>
*/
		public function getItemListByClass(classid:int, subclass:int):Vector.<TItemInfo> {
			var vec:Vector.<TItemInfo>=new Vector.<TItemInfo>();
			var o:TItemInfo;

			for each (o in this.itemDic) {
				if (int(o.classid) == classid && int(o.subclassid) == subclass)
					vec.push(o);
			}

			return vec;
		}



		public function getItemListArrByClass(classid:int, subclass:int):Array {
			var vec:Array=[];
			var o:TItemInfo;

			for each (o in this.itemDic) {
				if (int(o.classid) == classid && int(o.subclassid) == subclass)
					vec.push(o);
			}

			return vec;
		}

		/**
		 * 装备list
		 * @param classid
		 * @param subclass
		 * @return
		 *
		 */
		public function getEquipListArrByClass(classid:int, subclass:int=-1):Array {
			var vec:Array=[];
			var o:TEquipInfo;

			for each (o in this.equipDic) {
				if (int(o.classid) == classid && (subclass == -1 || int(o.subclassid) == subclass))
					vec.push(o);
			}

			return vec;
		}

		/**
		 *获取套装
		 * @param g
		 * @return
		 *
		 */
		public function getEquipListArrBySuitGroup(g:int):Array {
			var vec:Array=[];
			var o:TEquipInfo;

			for each (o in this.equipDic) {
				if (int(o.Suit_Group) == g)
					vec.push(o);
			}

			return vec;
		}

		/**
		 * 背包格子开启
		 * @param id
		 * @return
		 *
		 */
		public function getBagAddInfo(id:int):TBackpackAdd {
			return this.bagAddDic[id];
		}

		/**
		 *开启仓库格子
		 * @param id
		 * @return
		 *
		 */
		public function getStorAddInfo(id:int):TStorageAdd {
			return this.storeAddDic[id];
		}

		public function getItemByName(name:String):TItemInfo {
//			for each (var info:TItemInfo in this.itemDic) {
//				if (name == info.name)
//					return info;
//			}
			return null;
		}

		/**
		 * 通过skillid 获取技能列表
		 * @param id
		 * @return
		 *
		 */
		public function getSkill(id:int):Vector.<TSkillInfo> {

			var sk:TSkillInfo;
			var arr:Vector.<TSkillInfo>=new Vector.<TSkillInfo>();
			for each (sk in this.skillDic) {
				if (int(sk.skillId) == id && int(sk.skillId) != 0 && int(sk.id) < 800)
					arr.push(sk);
			}

			return arr;
		}

		/**
		 *
		 * @param prof limit
		 * @return
		 *
		 */
		public function getSkillByLimit(prof:int):Array {

			var sk:TSkillInfo;
			var arr:Array=[]
			for each (sk in this.skillDic) {
				if (int(sk.limit) == prof && int(sk.id) < 800)
					arr.push(sk);
			}

			return arr;
		}

		/**
		 *
		 * @param id
		 * @return
		 *
		 */
		public function getSkillArr(id:int):Array {

			var sk:TSkillInfo;
			var arr:Array=[]
			for each (sk in this.skillDic) {
				if (int(sk.skillId) == id && int(sk.skillId) != 0 && int(sk.id) < 800)
					arr.push(sk);
			}

			arr.sortOn("id", Array.CASEINSENSITIVE | Array.NUMERIC);

			return arr;
		}

		/**
		 * <T>根据使用编号获得技能</T>
		 *
		 * @param id 技能使用编号
		 * @return   技能
		 *
		 */
		public function getSkillById(id:int):TSkillInfo {
			return skillDic[id];
		}

		/**
		 * <T>根据技能编号和符文状态获得使用编号</T>
		 *
		 * @param id   技能编号
		 * @param rune 符文状态
		 *
		 */
		public function getSkillByIdAndRune(id:int, rune:int):TSkillInfo {
			var index:int=0;
			for each (var sk:TSkillInfo in skillDic) {
				var sid:int=int(sk.skillId);
				if ((sid == id) && (0 != sid)) {
					if (index++ == rune) {
						return sk;
					}
				}
			}
			return null;
		}

		/**
		 * 通过shopid 获取商店列表
		 * @param id
		 * @return
		 *
		 */
		public function getShopByid(id:int):Vector.<TShop> {

			var sk:TShop;
			var arr:Vector.<TShop>=new Vector.<TShop>();
			for each (sk in this.shopDic) {
				if (int(sk.shopId) == id)
					arr.push(sk);
			}

			return arr;
		}

		/**
		 * @param id
		 * @return
		 */
		public function getShopBytagID(id:int):Vector.<TShop> {

			var sk:TShop;
			var arr:Vector.<TShop>=new Vector.<TShop>();
			for each (sk in this.shopDic) {
				if (int(sk.tagId) == id)
					arr.push(sk);
			}

			return arr;
		}

		/**
		 * @param id
		 * @return
		 */
		public function getHallowsByID(id:int):THallows {
			return this.hallowsDic[id];
		}

		/**
		 *
		 * @param mid  Mission_ID
		 * @param tid Hallows_TeamID
		 * @return
		 */
		public function getHallowslist(mid:int, tid:int):Vector.<THallows> {
			var sk:THallows;
			var arr:Vector.<THallows>=new Vector.<THallows>();
			for each (sk in this.hallowsDic) {
				if (int(sk.Hallows_TeamID) == tid && int(sk.Mission_ID) == mid)
					arr.push(sk);
			}

			return arr;
		}

		/**
		 *
		 * @param pid
		 * @param tid
		 * @return
		 *
		 */
		public function getHallowslistByProfressAndTeamId(pid:int, tid:int):THallows {

			var st:int=pid * 100;
			var ed:int=st + 100;

			var sk:THallows;
			var arr:Vector.<THallows>=new Vector.<THallows>();
			for each (sk in this.hallowsDic) {
				if (int(sk.Hallows_TeamID) == tid && (int(sk.Hallows_ID) >= st && int(sk.Hallows_ID) < ed))
					return sk;
					//arr.push(sk);
			}

			return null;
		}

		/**
		 * @param tid
		 * @return
		 */
		public function getHallowslistByTeamid(tid:int):Vector.<THallows> {
			var sk:THallows;
			var arr:Vector.<THallows>=new Vector.<THallows>();
			for each (sk in this.hallowsDic) {
				if (int(sk.Hallows_TeamID) == tid)
					arr.push(sk);
			}

			return arr;
		}

		public function getHallowslistByid(tid:int):Vector.<THallows> {

			var st:int=tid * 100;
			var ed:int=st + 100;

			var sk:THallows;
			var arr:Vector.<THallows>=new Vector.<THallows>();

			for each (sk in this.hallowsDic) {
				if (int(sk.Hallows_ID) >= st && int(sk.Hallows_ID) < ed)
					arr.push(sk);
			}

			return arr;
		}

		/**
		 * @param id
		 * @return
		 */
		public function getMissionDataByID(id:int):TMissionDate {
			return this.missionDic[id];
		}

		/**
		 *
		 * @param hid
		 * @return
		 *
		 */
		public function getMissionDataByHallowTeamId(hid:int):Vector.<TMissionDate> {

			var sk:TMissionDate;
			var arr:Vector.<TMissionDate>=new Vector.<TMissionDate>();
			for each (sk in this.missionDic) {
				if (int(sk.Hallows_TeamID) == hid)
					arr.push(sk);
			}

			return arr;
		}

		public function getPointInfo(id:int):TPointInfo {
			return this.pointDic[id];
		}

		/**
		 * 获取称号
		 * @param tid
		 * @return
		 *
		 */
		public function getTitleByID(tid:int):TTitle {
			return this.titleDic[tid];
		}

		public function getTitleAllData():Object {
			return this.titleDic;
		}

		public function getTitleAllDataLen():int {

			var render:TTitle;
			var num:int=0;
			for each (render in this.titleDic) {
				if (render != null) {
					if (num < render.titleId)
						num=render.titleId;
				}
			}

			return num;
		}

		public function getTitleByName(name:String):TTitle {
			var render:TTitle;
			for each (render in this.titleDic) {
				if (name == render.name)
					return render;
			}

			return null;
		}

		public function getMountByPlayerLv(lv:int):TMount {
			var render:TMount;
			for each (render in this.mountDic) {
				if (lv < render.lvTop)
					return render;
			}

			return null;
		}

		public function getMountByLv(lv:int):TMount {
			return this.mountDic[lv];
		}

		public function getMountLvByLv(lv:int):TMountLv {
			return this.mountlvDic[lv];
		}

		public function getNpcFuncInfo(id:int):TNpcFunction {
			return this.npcFuncionDic[id];
		}

		public function getguildAttributeInfo(id:int):TUnion_attribute {
			return this.guildAttributeDic[id];
		}

		public function getguildAttributeNextInfo(att:int, lv:int):TUnion_attribute {

			var tinfo:TUnion_attribute;
			for each (tinfo in this.guildAttributeDic) {
				if (tinfo.att == att && tinfo.lv > lv)
					return tinfo;
			}

			return null;
		}

		public function getGuildCopyInfoByName(name:String):TDungeon_Base {

			var tinfo:TDungeon_Base;
			for each (tinfo in this.guildCopyDic) {
				if (tinfo.Dungeon_Name == name)
					return tinfo;
			}

			return null;
		}

		/**
		 *
		 * @param id
		 * @param type
		 * @return
		 *
		 */
		public function getGuildCopyExistBySceneIDAndType(id:int, type:int):Boolean {

			var tinfo:TDungeon_Base;
			for each (tinfo in this.guildCopyDic) {
				if (tinfo.Dungeon_Scene == id && tinfo.Dungeon_Type == type)
					return true;
			}

			return false;
		}
		
		public function getTttCopyAll():Array{
			
			var arr:Array=[];
			var tdb:TDungeon_Base;
			
			for each(tdb in this.guildCopyDic){
				if(tdb.Dungeon_Type==12)
				arr.push(tdb);
			}
			
			return arr;
		}
		
		

		public function getTzActiveAll():Object {
			return this.pkCopyDic;
		}

		public function getTzActiveByID(i:int):TTzActiive {
			return this.pkCopyDic[i];
		}

		public function getWingTradeByID(i:int):TWing_Trade {
			return this.wingTrade[i];
		}


		public function getWingTradeMaxIDByID():int {

			var tw:TWing_Trade;
			var i:int=0;

			for each (tw in this.wingTrade) {
				if (tw.id > i)
					i=tw.id;
			}

			return i;
		}

		public function getKeep7ByDay(d:int):TKeep_7{
			return this.keep7Dic[d];
		}
		
		public function getGuildblessByID(d:int):TUnion_Bless{
			return this.guildBlessDic[d];
		}
		
		public function getGuildblessByType(d:int):TUnion_Bless{
			var ub:TUnion_Bless;
			for each(ub in this.guildBlessDic){
				if(ub.build_Obj==d && ub.build_Lv==1)
					return ub;
			}
			
			return null;
		}
	 
		
		public function getGuildblessByAll():Object{
			return this.guildBlessDic;
		}
		
		public function getGemByID(id:int):TAlchemy{
			return this.alchemyDic[id];
		}
	 
		public function getGemListByType(id:int,type:int=1):Array{
			
			var arr:Array=[];
			var al:TAlchemy;
			for each(al in this.alchemyDic){
				if(type==1 && al.Al_Type==id)
					arr.push(al);
				else if(type==2 && al.Al_second==id)
					arr.push(al);
				else if(type==3 && al.Al_Third==id)
					arr.push(al);
			}
			
			return (arr.length==0?null:arr);
		}
	 
		/**
		 * 
		 * @param parentID
		 * @param type
		 * @return 
		 * 
		 */		
		public function getGemListNameByType(parent2ID:int=1,parentID:int=1,type:int=1):Array{
			
			var typeArr:Array=[];
			var arr:Array=[];
			var al:TAlchemy;
			for each(al in this.alchemyDic){
				if(type==1 && typeArr.indexOf(al.Al_Type)==-1){
					arr.push(al);
					typeArr.push(al.Al_Type);
				}else if(type==2 && parentID==al.Al_Type && typeArr.indexOf(al.Al_second)==-1){
					arr.push(al);
					typeArr.push(al.Al_second);
				}else if(type==3 && parent2ID==al.Al_Type && parentID==al.Al_second  && typeArr.indexOf(al.Al_Third)==-1){
					arr.push(al);
					typeArr.push(al.Al_Third);
				}
			}
			
			return (arr.length==0?null:arr);
		}
 
		public function getGemListByAll():Object{
			return this.alchemyDic;
		}
		
		public function getLabaAll():Object{
			return this.labaDic;
		}
		
		public function getLabaById(id:int):TLaba{
			return this.labaDic[id];
		}

	}
}

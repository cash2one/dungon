package com.ace.gameData.manager {
	import com.ace.gameData.manager.child.MTableManager;
	import com.ace.gameData.table.TAbidePayInfo;
	import com.ace.gameData.table.TAchievementInfo;
	import com.ace.gameData.table.TActiveInfo;
	import com.ace.gameData.table.TActiveRewardInfo;
	import com.ace.gameData.table.TAd;
	import com.ace.gameData.table.TAreaCelebrateInfo;
	import com.ace.gameData.table.TBackpackAdd;
	import com.ace.gameData.table.TBuffAward;
	import com.ace.gameData.table.TCityBattleRewardInfo;
	import com.ace.gameData.table.TCollectionPreciousInfo;
	import com.ace.gameData.table.TCopyInfo;
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
	import com.ace.gameData.table.TInvestInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TLZItemInfo;
	import com.ace.gameData.table.TLevelGiftInfo;
	import com.ace.gameData.table.TMissionDate;
	import com.ace.gameData.table.TMount;
	import com.ace.gameData.table.TMountLv;
	import com.ace.gameData.table.TNpcFunction;
	import com.ace.gameData.table.TPassivitySkillInfo;
	import com.ace.gameData.table.TPayPromotion;
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
	import com.ace.gameData.table.TStorageAdd;
	import com.ace.gameData.table.TTitle;
	import com.ace.gameData.table.TTobeStrongInfo;
	import com.ace.gameData.table.TTobeStrongLevelInfo;
	import com.ace.gameData.table.TTzActiive;
	import com.ace.gameData.table.TUnion_attribute;
	import com.ace.gameData.table.TVIPAttribute;
	import com.ace.gameData.table.TVIPDetailInfo;
	import com.ace.gameData.table.TVIPInfo;
	import com.ace.gameData.table.TVendueInfo;
	import com.ace.gameData.table.TWing_Trade;
	import com.ace.gameData.table.TZdlElement;
	import com.ace.manager.LibManager;


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
		private var _rankRewardHeDic:Object;
		private var groupBuyDic:Object;
		private var vendueDic:Object;
		private var cityBattleRewardDic:Object;
		private var wingTrade:Object;

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
			this._rankRewardHeDic={};
			this.groupBuyDic={};
			this.vendueDic={};
			this.cityBattleRewardDic={};
			this.wingTrade={};


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
				this.mountDic[render.@lv]=new TMount(render);
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
		}

		//=====================================获取===================================================================
		public function getShopDic():Object {
			return this.shopDic;
		}

		public function getVendueInfo(id:int):TVendueInfo {
			return this.vendueDic[id];
		}

		public function getCityBattleRewardInfo(id:int):TCityBattleRewardInfo {
			return this.cityBattleRewardDic[id];
		}

		public function getGroupbuyItemInfo(id:int):TGroupBuyItemInfo {
			return this.groupBuyDic[id];
		}

		public function getAbidePayInfo(id:int):TAbidePayInfo {
			return this.abidePayDic[id];
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

	}
}

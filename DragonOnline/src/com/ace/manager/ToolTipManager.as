package com.ace.manager {
	import com.ace.enum.TipEnum;
	import com.ace.ui.tips.MapTip;
	import com.ace.ui.toolTip.MToolTipManager;
	import com.ace.ui.toolTip.children.ToolTip;
	import com.leyou.ui.tips.BuyBuffWnd;
	import com.leyou.ui.tips.DungeonTZTips;
	import com.leyou.ui.tips.GuildSciTips;
	import com.leyou.ui.tips.TipsAchievementTip;
	import com.leyou.ui.tips.TipsActiveRewardTip;
	import com.leyou.ui.tips.TipsCollectionTip;
	import com.leyou.ui.tips.TipsCopyTip;
	import com.leyou.ui.tips.TipsDMissonWnd;
	import com.leyou.ui.tips.TipsElementWnd;
	import com.leyou.ui.tips.TipsEmptyWnd;
	import com.leyou.ui.tips.TipsEquipWnd;
	import com.leyou.ui.tips.TipsFarmTip;
	import com.leyou.ui.tips.TipsFieldBossTip;
	import com.leyou.ui.tips.TipsGemEquipWnd;
	import com.leyou.ui.tips.TipsGemWnd;
	import com.leyou.ui.tips.TipsMarryWnd;
	import com.leyou.ui.tips.TipsMissionWnd;
	import com.leyou.ui.tips.TipsPetTip;
	import com.leyou.ui.tips.TipsRuneTip;
	import com.leyou.ui.tips.TipsSkillTip;
	import com.leyou.ui.tips.TipsTzWnd;
	import com.leyou.ui.tips.TipsVipBlessTip;
	import com.leyou.ui.tips.TipsVipEquipTip;
	import com.leyou.ui.tips.TipsVipSkillTip;
	import com.leyou.ui.tips.TipsguildSWnd;
	import com.leyou.ui.tips.TitleTips;

	public class ToolTipManager extends MToolTipManager {

		private static var instance:ToolTipManager;

		private var toolTip:ToolTip=null;

		public static function getInstance():ToolTipManager {
			if (!instance)
				instance=new ToolTipManager();

			return instance;
		}

		public function ToolTipManager() {
			super();
		}

		/**添加不同类型的tip*/
		override protected function addClass():void {
			super.addClass();
			this.classDic[TipEnum.TYPE_MAP]=MapTip;
			this.classDic[TipEnum.TYPE_EQUIP_ITEM]=TipsEquipWnd;
			this.classDic[TipEnum.TYPE_EQUIP_ITEM_DIFF]=TipsEquipWnd;
			this.classDic[TipEnum.TYPE_SKILL]=TipsSkillTip;
			this.classDic[TipEnum.TYPE_RUNE]=TipsRuneTip;
			this.classDic[TipEnum.TYPE_ELEMENTS]=TipsElementWnd;
			this.classDic[TipEnum.TYPE_EMPTY_ITEM]=TipsEmptyWnd;
			this.classDic[TipEnum.TYPE_FARM]=TipsFarmTip;
			this.classDic[TipEnum.TYPE_COPY]=TipsCopyTip;
			this.classDic[TipEnum.TYPE_PKCOPY]=DungeonTZTips;
			this.classDic[TipEnum.TYPE_BUFF]=BuyBuffWnd;
			this.classDic[TipEnum.TYPE_ACTIVE]=TipsActiveRewardTip;
			this.classDic[TipEnum.TYPE_TODAYTASK]=TipsDMissonWnd;
			this.classDic[TipEnum.TYPE_HALLOWS]=TipsMissionWnd;
			this.classDic[TipEnum.TYPE_GUILD_SKILL]=TipsguildSWnd;
			this.classDic[TipEnum.TYPE_VIP_QUEIP]=TipsVipEquipTip;
			this.classDic[TipEnum.TYPE_VIP_BLESS]=TipsVipBlessTip;
			this.classDic[TipEnum.TYPE_VIP_SKILL]=TipsVipSkillTip;
			this.classDic[TipEnum.TYPE_FIELD_BOSS]=TipsFieldBossTip;
			this.classDic[TipEnum.TYPE_ACHIEVEMENT]=TipsAchievementTip;
			this.classDic[TipEnum.TYPE_COLLECTION]=TipsCollectionTip;
			this.classDic[TipEnum.TYPE_GEM]=TipsGemEquipWnd;
			this.classDic[TipEnum.TYPE_GEM_OTHER]=TipsGemWnd;
			this.classDic[TipEnum.TYPE_TZ]=TipsTzWnd;
			this.classDic[TipEnum.TYPE_GUILD_BLESS]=GuildSciTips;
			this.classDic[TipEnum.TYPE_TITLE]=TitleTips;
			this.classDic[TipEnum.TYPE_PET]=TipsPetTip;
			this.classDic[TipEnum.TYPE_MARRY]=TipsMarryWnd;
		}

	}
}

/*

1:自己定义tip的面板，实现ITip接口,添加tip的枚举
2：添加移入、移除事件监听
3：移入调用

/
* 显示tip信息
* @param type tip类型
* @param info tip对应的信息
* @param pt   tip显示的位置，【要显示Tip的对象】localToGlobal+自定偏移
/
public function show(type:int, info:*, pt:Point):Boolean {

}
ToolTipManager.getInstance().show(TipEnum.TYPE_MAP, this.getImgTipInfo(info), new Point(this.stage.mouseX + 30, this.stage.mouseY + 30));
ToolTipManager.getInstance().hide();

*/
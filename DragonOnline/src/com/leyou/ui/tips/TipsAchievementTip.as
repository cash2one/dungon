package com.leyou.ui.tips
{
	import com.ace.ICommon.ITip;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TAchievementInfo;
	import com.leyou.data.achievement.AchievementEraData;
	import com.leyou.data.achievement.AchievementTipInfo;
	import com.leyou.ui.achievement.child.AchievementEraItem;
	
	public class TipsAchievementTip extends AchievementEraItem implements ITip
	{
		public function TipsAchievementTip(){
		}
		
		public function updateInfo(info:Object):void{
			var tipInfo:AchievementTipInfo = info as AchievementTipInfo;
			var achievement:TAchievementInfo = TableManager.getInstance().getAchievementInfo(tipInfo.id);
			update(achievement);
			var dachievement:AchievementEraData = DataManager.getInstance().achievementData.getEraData(tipInfo.id);
			updateByData(dachievement);
		}
		
		public function get isFirst():Boolean{
			return false;
		}
	}
}
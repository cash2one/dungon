package com.leyou.data.playerSkill
{
	import com.ace.gameData.table.TSkillInfo;

	public class TipSkillInfo
	{
		// 玩家当前等级
		public var level:int;
		
		// 技能是否装备了符文
		public var hasRune:Boolean;
		
		// 装备的符文
		public var runde:int;
		
		// 技能等级
		public var skillLv:int = 1;
		
		// 技能信息
		public var skillInfo:TSkillInfo;
		
		// 宠物技能
		public var isPetSkill:Boolean = false;
	}
}
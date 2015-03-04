package com.leyou.data.playerSkill {
	


	/**
	 *	itm -- 重置符文需要消耗的物品id
		num -- 重置符文需要消耗物品的数量
		sindex -- 技能面板排列的位置序号(从0开始)
	 	enabled -- 此技能是否已经获得(0 --未获得, 1 --已获得)
		skillid -- 技能的id
		level   -- 技能的等级
		rune1   -- 第1个符文的状态(0 --未获得,1 --未激活 ,2 --已激活)
		rune2   -- 第2个符文的状态(0 --未获得,1 --未激活 ,2 --已激活)
		rune3   -- 第3个符文的状态(0 --未获得,1 --未激活 ,2 --已激活)

	 * @author Administrator
	 *
	 */
	public class SkillInfo {

		public var itemId:int;
		public var num:int;
		
		public var skillItems:Array=[];
		
		public var sindex:int;
		
		public var skillid:int; //技能的id
		public var enabled:int;
		public var level:int; //技能等级 
		public var rune1:int; //技能符文
		public var rune2:int;
		public var rune3:int;
		

		public function SkillInfo() {
		}
 


	}
}

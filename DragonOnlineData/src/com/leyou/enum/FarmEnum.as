package com.leyou.enum
{
	public class FarmEnum
	{
		// 土地状态枚举
		// 未解锁状态
		public static const BLOCK_LOCK:int = 0;
		// 可解锁状态
		public static const BLOCK_ABLEUNLOCK:int = 1;
		// 解锁状态
		public static const BLOCK_UNLOCK:int = 2;
		// 生长状态
		public static const BLOCK_GROWING:int = 3;
		// 可收割状态
		public static const BLOCK_RIPE:int = 4;
		// 已成熟但未被好友摘取
		public static const BLOCK_RIPE_REMAIN:int = 5;
		
		
		// 神树状态
		// 成长状态
		public static const TREE_GROWING:int = 1;
		// 成熟状态
		public static const TREE_RIPE:int = 2;
		// 浇水冷却状态
		public static const TREE_WATER_CD:int = 3;
		// 摘取后冷却状态
		public static const TREE_RIPE_CD:int = 4;
	}
}
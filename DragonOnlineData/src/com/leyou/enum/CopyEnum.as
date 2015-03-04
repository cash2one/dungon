package com.leyou.enum
{
	public class CopyEnum
	{
		// 加锁
		public static const COPYSTATUS_LOCK:int = 0;
		
		// 解锁未通过
		public static const COPYSTATUS_UNLOCK:int = 1;
		
		// 已通过
		public static const COPYSTATUS_PAST:int = 2;
		
		// 未通过
		public static const COPYSTATUS_UNPAST:int = 3;
		
		// 可领奖
		public static const COPYSTATUS_REWARD:int = 4;
		
		// 扫荡中
		public static const COPYSTATUS_PASTING:int = 5;
		
		// 次数耗尽,未完成
		public static const COPYSTATUS_FAIL:int = 6;
		
		
		public static const PASTQUALITY_D:int = 1;
		public static const PASTQUALITY_C:int = 2;
		public static const PASTQUALITY_B:int = 3;
		public static const PASTQUALITY_A:int = 4;
		public static const PASTQUALITY_S:int = 5;
	}
}
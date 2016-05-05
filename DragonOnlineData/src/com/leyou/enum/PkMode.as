package com.leyou.enum
{
	import com.leyou.utils.PropUtils;

	public class PkMode
	{
		// 新手模式
		public static const PK_MODE_FRESH:int = 1;
		
		// 和平模式
		public static const PK_MODE_PEACE:int = 2;
		
		// 善恶模式
		public static const PK_MODE_KIND:int = 3;
		
		// 组队模式
		public static const PK_MODE_TEAM:int = 4;
		
		// 帮派模式
		public static const PK_MODE_GUILD:int = 5;
		
		// 狂暴模式
		public static const PK_MODE_HYSTERICAL:int = 6;
		
		// 阵营模式
		public static const PK_MODE_CAMP:int = 7;
		
		// 跨服模式
		public static const PK_MODE_ACROSS:int = 8;
		
		// 模式数量
		public static const PK_MODE_COUNT:int = 9
		
		// 菜单
		public static const PK_MODE_MENU:Array = [ PropUtils.getStringById(2082), 
			PropUtils.getStringById(2083), 
			PropUtils.getStringById(2084), 
			PropUtils.getStringById(2085), 
			PropUtils.getStringById(2086), 
			PropUtils.getStringById(2087),
			PropUtils.getStringById(2088) ];
		
		public static const PK_COLOR_WHITE:int = 0;
		
		public static const PK_COLOR_YELLOW:int = 1;
		
		public static const PK_COLOR_ORANGE:int = 2;
		
		public static const PK_COLOR_GREY:int = 3;
		
		public static const PK_COLOR_RED:int = 4;
	}
}
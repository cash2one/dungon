package com.ace.enum {
	import flash.geom.Point;

	public class SceneEnum {
		public static const TILE_WIDTH:Number=50;
		public static const TILE_HEIGHT:Number=25;
//		public static const TILE_WIDTH:int=48;
//		public static const TILE_HEIGHT:int=32;
		public static const TILE_HALFW:Number=TILE_WIDTH / 2;
		public static const TILE_HALFH:Number=TILE_HEIGHT / 2;
		public static const TILE_ANGLE:Number=Math.atan2(SceneEnum.TILE_HEIGHT, SceneEnum.TILE_WIDTH) * 180 / Math.PI;


		public static const BMPTILE_WIDTH:Number=256;
		public static const BMPTILE_HEIGHT:Number=256;


		public static const SCREEN_OFFSET:int=1;

		public static const LAYER_TILE:uint=1;
		public static const LAYER_NOEVT:uint=2;
		public static const LAYER_SORT:uint=3;
		public static const LAYER_TOP:uint=4;

		public static const SCENE_MAP_NAME:String="obstcale";
		public static const SCENE_MONSTER_NAME:String="monster";
		public static const SCENE_NPC_NAME:String="npc";
		public static const SCENE_EFFECT_NAME:String="effect";
		public static const SCENE_AREA_NAME:String="area";
		public static const SCENE_DECORATE_NAME:String="decorate";
		public static const SCENE_BOX_NAME:String="box";

		
		
		/**
		 *"场景类型
0 普通场景
1 剧情副本
2 BOSS副本
3 竞技场
4 时光龙穴
5 答题
6 入侵
7 练级
8.行会副本
9.龙穴探宝
10.保卫布雷特"
 
		 */		
		public static const SCENE_TYPE_PTCJ:int=0; //普通场景
		public static const SCENE_TYPE_JQFB:int=1; //剧情副本
		public static const SCENE_TYPE_BSFB:int=2; //boss副本
		public static const SCENE_TYPE_JSC:int=3; //竞技场
		public static const SCENE_TYPE_SGLX:int=4; //时光龙穴
		public static const SCENE_TYPE_DTCJ:int=5; //答题场景
		public static const SCENE_TYPE_RQCJ:int=6; //入侵场景
		public static const SCENE_TYPE_LJCJ:int=7; //练级场景
		/**
		 * 8.行会副本
		 */		
		public static const SCENE_TYPE_HHFB:int=8;
		/**
		 * 9.龙穴探宝
		 */		
		public static const SCENE_TYPE_LXTB:int=9;
		/**
		 *10.保卫布雷特" 
		 */		
		public static const SCENE_TYPE_BWBLT:int=10;
		
		
		
		public static const SCENE_TYPE_JDCJ:int=11; //决斗场景
		public static const SCENE_TYPE_GUCJ:int=12; //帮战场景
		public static const SCENE_TYPE_CYCJ:int=14; //主城争霸场景
		public static const SCENE_TYPE_LZCJ:int=15; //龙珠场景
		public static const SCENE_TYPE_SYCJ:int=16; //霜炎战场
		
		/**
		 *通天塔 
		 */		
		public static const SCENE_TYPE_TTT:int=17;
		 
		public static const SCENE_TYPE_ACROSS:int=18; //跨服场景
		
		
		public static const SCREEN_RECTANGLE:Point=new Point(100, 80); //屏幕中央不移动的区域


	}
}

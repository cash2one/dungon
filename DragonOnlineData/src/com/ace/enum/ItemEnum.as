package com.ace.enum {
	
	import com.leyou.enum.RoleEnum;

	public class ItemEnum {
       
		public static const GRID_DOUBLE_CLICK:Array=[TYPE_GRID_BACKPACK,TYPE_GRID_STORAGE,TYPE_GRID_ROLE,TYPE_GRID_SHOP,TYPE_GRID_MOUNT,TYPE_GRID_GEM];
		
		public static const TYPE_GRID_BASE:String="baseGrid";
		public static const TYPE_GRID_BACKPACK:String="backpackGrid";
		public static const TYPE_GRID_STORAGE:String="storageGrid";
		public static const TYPE_GRID_PLAYER:String="playerGrid";
		public static const TYPE_GRID_SKILL:String="skillGrid";
		public static const TYPE_GRID_RUNE:String="runeGrid";
		public static const TYPE_GRID_SHORTCUT:String="shortcutGrid";
		public static const TYPE_GRID_TRADE:String="tradeGrid";
		public static const TYPE_GRID_SHOP:String="shopGrid";
		public static const TYPE_GRID_ROLE:String="roleGrid";
		public static const TYPE_GRID_GEM:String="gemGrid";
		public static const TYPE_GRID_MOUNT:String="mountGrid";
		public static const TYPE_GRID_STALL:String="stallGrid";
		public static const TYPE_GRID_GUILD:String="guildGrid";
		public static const TYPE_GRID_VIEW_GUILD:String="guildViewGrid";
		public static const TYPE_GRID_MARKET:String="marketGrid";
		public static const TYPE_GRID_EQUIP:String="EquipGrid";
		public static const TYPE_GRID_EQUIP_BODY:String="EquipGrid_body";
		public static const TYPE_GRID_EQUIP_EQUIP:String="EquipGrid_equip";
		public static const TYPE_GRID_WING:String="WingGrid";
		public static const TYPE_GRID_MAIL:String="MailGrid";
		public static const TYPE_GRID_LUCKDRAW:String="LuckDraw";
		public static const TYPE_GRID_COPYREWARD:String="CopyRewardGrid";
		public static const TYPE_GRID_AUTIONSALE:String="autionGridSale";
		public static const TYPE_GRID_AUTIONBUY:String="autionGridBuy";

		public static const TYPE_GRID_OTHER_EQUIP:String="otherEquip";
		public static const TYPE_GRID_FORGE:String="forgeGrid";
		public static const TYPE_GRID_LOST:String="lostGrid";
		public static const TYPE_GRID_LOSTRENDER:String="lostrenderGrid";

		public static const ITEM_BG_WIDTH:int=40;
		public static const ITEM_BG_HEIGHT:int=40;

		public static const ITEM_ICO_WIDTH:int=36;
		public static const ITEM_ICO_HEIGHT:int=36;

		public static const GRID_HORIZONTAL:int=7;
		public static const GRID_SPACE:int=3;

		public static const BACKPACK_GRID_TOTAL:int=70;
		public static var BACKPACK_GRID_OPEN:int=42;

		public static const STORAGE_GRIDE_TOTAL:int=70;
		public static var STORAGE_GRIDE_OPEN:int=40;


		public static const TIP_PX:int=12;
		public static const TIP_PY:int=22;

		public static const ITEM_TYPE_EQUIP:int=1;                       //		1 装备 
		public static const ITEM_TYPE_YAOSHUI:int=2;                     //		2 药剂 
		public static const ITEM_TYPE_DAOJU:int=3;                       //		3 道具 
		public static const ITEM_TYPE_TASK:int=4;                        //		4 任务 
		public static const ITEM_TYPE_XUNI:int=6;                        //		6 虚拟
		public static const ITEM_TYPE_GEM:int=10;                        //		10 宝石
		//=====================================道具======================================================================================

		/**
		 *1	持续类红药
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

	 */
		public static const TYPE_YAOSHUI_CONTINUE_RED:int=1;
		public static const TYPE_YAOSHUI_MOMENT_RED:int=2;
		public static const TYPE_YAOSHUI_STORE_RED:int=3;

		public static const TYPE_YAOSHUI_CONTINUE_BLUE:int=4;
		public static const TYPE_YAOSHUI_MOMENT_BLUE:int=5;
		public static const TYPE_YAOSHUI_STORE_BLUE:int=6;

		public static const TYPE_YAOSHUI_CONTINUE_YELLOW:int=7;
		public static const TYPE_YAOSHUI_MOMENT_YELLOW:int=8;
		public static const TYPE_YAOSHUI_STORE_YELLOW:int=9;


		//===========================================================================================================================

		//===========================================================================================================================

		//=========================================装备==================================================================================
		/**
		 *武器
		 */
		public static const TYPE_EQUIP_WUQI:int=1;
		/**
		 * 戒指
		 */
		public static const TYPE_EQUIP_JIEZHI:int=2; //书籍
		/**
		 *手镯
		 */
		public static const TYPE_EQUIP_SHOUZHUO:int=3; //武器
		/**
		 *头盔
		 */
		public static const TYPE_EQUIP_TOUKUI:int=4; //法杖
		/**
		 *衣服
		 */
		public static const TYPE_EQUIP_YIFU:int=5; //未知物品
		/**
		 * 手套
		 */
		public static const TYPE_EQUIP_SHOUTAO:int=6; //衣服(男)
		/**
		 *鞋
		 */
		public static const TYPE_EQUIP_XIE:int=7; //衣服(女)
		/**
		 *腰带
		 */
		public static const TYPE_EQUIP_YAODAI:int=8; //头盔
		/**
		 * 裤子
		 */
		public static const TYPE_EQUIP_KUZI:int=9; //项链
		/**
		 * 项链
		 */
		public static const TYPE_EQUIP_XIANLIAN:int=10; //戒指
		/**
		 * 护符
		 */
		public static const TYPE_EQUIP_HUFU:int=11; //护腕
		/**
		 * 翅膀
		 */
		public static const TYPE_EQUIP_CHIBAN:int=12; //毒药或符 
		/**
		 * 获得后要提示的道具
		 */
		public static const CONVENIENT_ITEMS:Array = ["203", "206", "209", "316", "210"];
		
		public static var ItemToRolePos:Array=[];
		//orm
		ItemToRolePos[TYPE_EQUIP_WUQI]=[RoleEnum.ROLE_TYPE_WUQI];
		ItemToRolePos[TYPE_EQUIP_JIEZHI]=[RoleEnum.ROLE_TYPE_JIEZHI_L, RoleEnum.ROLE_TYPE_JIEZHI_R];
		ItemToRolePos[TYPE_EQUIP_SHOUZHUO]=[RoleEnum.ROLE_TYPE_SHOUZHUO_L, RoleEnum.ROLE_TYPE_SHOUZHUO_R];
		ItemToRolePos[TYPE_EQUIP_TOUKUI]=[RoleEnum.ROLE_TYPE_TOUKU];
		ItemToRolePos[TYPE_EQUIP_YIFU]=[RoleEnum.ROLE_TYPE_XIONJIA];
		ItemToRolePos[TYPE_EQUIP_SHOUTAO]=[RoleEnum.ROLE_TYPE_SHOUTAO];
		ItemToRolePos[TYPE_EQUIP_XIE]=[RoleEnum.ROLE_TYPE_XIE];
		ItemToRolePos[TYPE_EQUIP_YAODAI]=[RoleEnum.ROLE_TYPE_YAODAI];
		ItemToRolePos[TYPE_EQUIP_KUZI]=[RoleEnum.ROLE_TYPE_KUZI];
		ItemToRolePos[TYPE_EQUIP_XIANLIAN]=[RoleEnum.ROLE_TYPE_XIANLIAN];
		ItemToRolePos[TYPE_EQUIP_HUFU]=[RoleEnum.ROLE_TYPE_HUFU_L, RoleEnum.ROLE_TYPE_HUFU_R];
		//===========================================================================================================================	


		//=========================================================================/
		/**
		 * 金币
		 */
		public static const CURRENCY_TYPE_MONEY:int=0;
		/**
		 * 绑定元宝
		 */
		public static const CURRENCY_TYPE_GOLD_BOUND:int=1;
		/**
		 * 元宝
		 */
		public static const CURRENCY_TYPE_GOLD:int=2;
		/**
		 * 帮贡
		 */
		public static const CURRENCY_TYPE_GUILD_MONEY:int=3;
		//=========================================================================/
		
		// 经验虚道具ID
		public static const EXP_VIR_ITEM_ID:int = 65534;
		
		// 金钱虚道具ID
		public static const MONEY_VIR_ITEM_ID:int = 65535;
		
		// 魂力虚道具ID
		public static const ENERGY_VIR_ITEM_ID:int = 65533;
		
		// 绑定元宝虚道具ID
		public static const BYB_VIR_ITEM_ID:int = 65532;
		
		// 帮贡虚道具ID
		public static const BG_VIR_ITEM_ID:int = 65531;
		
		// 荣誉
		public static const HONOUR_VIR_ITEM_ID:int = 65526;
		
		// 竞技场积分
		public static const CREDIT_VIR_ITEM_ID:int = 65525;
		
		// 龙魂
		public static const LONGHUN_VIR_ITEM_ID:int = 65054;
	}
}

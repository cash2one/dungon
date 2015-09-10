package com.leyou.enum {
	import com.leyou.utils.PropUtils;

	public class ChatEnum {

		// 频道枚举
		public static const CHANNEL_COMPOSITE:int=0;
		public static const CHANNEL_COMMON:int=1;
		public static const CHANNEL_PRIVATE:int=2;
		public static const CHANNEL_TEAM:int=3;
		public static const CHANNEL_GUILD:int=4;
		public static const CHANNEL_MAP:int=5;
		public static const CHANNEL_WORLD:int=6;
		public static const CHANNEL_HORN:int=7;
		public static const CHANNEL_SYSTEM:int=8;

		//说话【!区域 、	!!组队、 	!~行会 、 /私聊】
		public static const FLAG_COMMON:String="/S";
		public static const FLAG_PRIVATE:String="/R";
		public static const FLAG_TEAM:String="/P";
		public static const FLAG_GUILD:String="/G";
		public static const FLAG_MAP:String="/M";
		public static const FLAG_WORLD:String="/W";
		public static const FLAG_HORN:String="/Y";
//		public static const FLAG_SYSTEM:String="#ee2211";

		//说话的颜色
		public static const COLOR_USER:String="#ffff00";
		public static const COLOR_COMMON:String="#ffffff";
		public static const COLOR_PRIVATE:String="#da70d6";
		public static const COLOR_TEAM:String="#87ceeb";
		public static const COLOR_GUILD:String="#00c957";
		public static const COLOR_MAP:String="#8bdb3c";
		public static const COLOR_WORLD:String="#fa9611";
		public static const COLOR_SYSTEM:String="#ee2211";
		public static const COLOR_HORN:String="#ffea00";
		public static const COLOR_VIP_GREEN:String="#00c957";
		public static const COLOR_MAP_POINT:String="#3fa6ed";
		public static const COLOR_YELLOW:String="#ffea00";
		public static const COLOR_NPC:String="#9363C9";

		// 字体显示颜色
		public static const COLOR_VAL_COMMON:uint=0xffffff;
		public static const COLOR_VAL_PRIVATE:uint=0xda70d6;
		public static const COLOR_VAL_TEAM:uint=0x009ef8;
		public static const COLOR_VAL_GUILD:uint=0x00c957;
		public static const COLOR_VAL_MAP:uint=0x8bdb3c;
		public static const COLOR_VAL_WORLD:uint=0xfa9611;
		public static const COLOR_VAL_SYSTEM:uint=0xee2211;
		public static const COLOR_VAL_HORN:uint=0xffea00;

		// 聊天CD时间
		public static const TIME_COMMON:int=3000;
		public static const TIME_COMPOSITE:int=3000;
		public static const TIME_PRIVATE:int=300;
		public static const TIME_TEAM:int=3000;
		public static const TIME_GUILD:int=3000;
		public static const TIME_MAP:int=3000;
		public static const TIME_WORLD:int=5000;
		public static const TIME_SYSTEM:int=3000;

		//喇叭的显示时间
		public static const TIME_HORN:int=5000;
		// 喇叭的顶替时间
//		public static const TIME_REPLACE_HORN:int=3200;
		// 喇叭的消失时间
//		public static var TIME_DISAPPEAR_HORN:int=5200;
		// 单个普通频道消息保存最大数量
		public static const COMMONMSG_MAX_COUNT:int=50;
		// 系统消息保存最大数量
		public static const SYSTEMMSG_MAX_COUNT:int=20;
		// 单条普通消息字符最大数量
		public static const COMMONMSG_MAX_BYTE:int=35;
		// 单条喇叭消息字符最大数量
		public static const HORNMSG_MAX_BYTE:int=50;
		// 私聊玩家保存数量
		public static const PALYER_NAME_REMAIN:int=5;
		// 个人聊天记录数量
		public static const MYRECORD_REMAIN:int=5;
		// 世界频道说话等级限制
		public static const WORLD_CHANNEL_LIMIT:int=20;

		// 表情数量
		public static const FACE_IMG_COUNT:int=47;
		// 表情关键字
		public static const TEXT_IMG_KEYS:Array=["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", 
			"11", "12", "13", "14", "15", "16", "17", "18", "19", "20",  
			"21", "22", "23", "24", "25", "26", "27", "28", "29", "30",
			"31", "32", "33", "34", "35", "36", "37", "38", "39", "40",
			"41", "42", "43", "44", "45", "46", "47",
			// vip图标
			"50", "51", "52", "53", "54", "55", "56", "57", "58", "59",
			// 聊天频道图标
			"60", "61", "62", "63", "64", "65"];

		// user   1    -- 玩家的名字  可点击出弹出菜单
		// item   2    -- 物品装备    弹出tips
		// map    3    -- 地图坐标    可发起寻路
		// act    4    -- 活动        弹出对应面板
		// vip    5    -- vip说明     弹出vip说明面板
		// team   6    -- 组队连接    弹出组队面板
		// team   7    -- 帮会连接    弹出帮会面板
		public static const LINK_TYPE_PLAYER:int=1;
		public static const LINK_TYPE_ITEM:int=2;
		public static const LINK_TYPE_MAP:int=3;
		public static const LINK_TYPE_ACTIVE:int=4;
		public static const LINK_TYPE_VIP:int=5;
		public static const LINK_TYPE_TEAM:int=6;
		public static const LINK_TYPE_GUILD:int=7;

		// 文本超链接连接事件名称
//		public static const LINK_EVENT_PLAYER:String = "player";
//		public static const LINK_EVENT_ITEM:String   = "item";
//		public static const LINK_EVENT_MAP:String    = "map";
//		public static const LINK_EVENT_VIP:String    = "vip";
//		public static const LINK_EVENT_ACTIVE:String = "active";

		// 超链接弹出菜单内容
		public static const CLICK_MENU:Array=[PropUtils.getStringById(1728), PropUtils.getStringById(1729), PropUtils.getStringById(2076), PropUtils.getStringById(1730), PropUtils.getStringById(2077), PropUtils.getStringById(1734)];

		// 超链接弹出菜单内容
		public static const CLICK_MENU_II:Array=[PropUtils.getStringById(1728), PropUtils.getStringById(1729), PropUtils.getStringById(1730), PropUtils.getStringById(1711), PropUtils.getStringById(1734), PropUtils.getStringById(2077), PropUtils.getStringById(1726), PropUtils.getStringById(2078), PropUtils.getStringById(2079), PropUtils.getStringById(2080), PropUtils.getStringById(1732)];
		// 超链接菜单项枚举
		public static const PRIVATE_CHAT:int=0;
		public static const CHECK_STATUS:int=1;
		public static const ADD_FRIEND:int=2;
		public static const ADD_TEAM:int=3;
		public static const ADD_GUILD:int=4;
		public static const ADD_BLACK:int=5;
		public static const COPY:int=6;
		public static const SUE:int=7;
		public static const REMOVE_FAIEND:int=8;
		public static const TRACK:int=9;
		public static const DUEL:int=10;

		// 窗体缩放标准尺寸[宽, 高]
		public static const STATUS_BG_SIZE:Array=[[296, 190], [296, 390]];
		public static const STATUS_PANNEL_SIZE:Array=[[287, 180], [287, 369]];

		// <!--------------可删------------------------>
		public static const SISEARR:Array=[[355, 225], [455, 325,], [555, 425]];
		public static const imgKeyArr:Array=["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39"];
		public static const COMBOX_CHAT_CHANNEL:String="chat_channle";
		public static const CHAT_MEMORY_LONG:int=5;
		public static const MESSAGE_MAX_COUNT:int=50
		public static const MESSAGE_LONG:int=35;
		public static const MESSAGE_HORN_LONG:int=50;
		public static const MESSAGE_SYSTEM_LONG:int=20;
		public static const EVENT_NAME_FLAG:String="n@n";
		public static const EVENT_CONTAIN_FLAG:String="c@c";
		public static const EVENT_ITEM_FLAG:String="I@I";
		public static const EVENT_VIP_FLAG:String="V@V";
		public static const EVENT_MAP_FLAG:String="M@M";
		public static const EVENT_ACTIVE_FLAG:String="A@A";
		// <!--------------可删------------------------>
	}
}

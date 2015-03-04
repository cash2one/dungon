package com.leyou.enum {
	

	public class SystemNoticeEnum {
		/**
		 *系统公告1 鼠标跟随 
		 */		
		public static const MESSAGE_1_MOUSE_FOLLOW:int=1;
		public static const Message1Count:int = 30; 			//信息栏1最多语序输入70个字符
		public static const Message1Colour:uint=0x00ff00;   //信息栏1字体颜色
		public static const Message1Font:String= "simsun";	//信息栏1使用字体为宋体
		public static const Message1Size:int = 20;  //信息栏1使用字号为20号
		public static const Message1TIME:int=2000;  // 毫秒  信息栏1消息显示时间 
		public static const Message1Num:int=4;//提示的条数
		/**
		 * 系统公告1 屏幕中间 上部
		 */
		public static const MESSAGE_2_MID_UP:int=2;
		public static const Message2Count:int= 40;			//信息栏2最多语序输入70个字符
		public static const Message2Colour:uint =0x00ff00;  //信息栏2字体颜色
		public static const Message2Font:String= "simsun";   //信息栏2使用字体为宋体
		public static const Message2TIME:int=3000;  // 毫秒  信息栏2消息显示时间 
		public static const Message2Size:int = 20;  //信息栏2使用字号为20号
		
		/**
		 *系统聊天栏 
		 */		
		public static const MESSAGE_3_CHAT:int=3;
		public static const Message3Size:int = 20;     //信息栏3使用字号为10号
		public static const Message3Colour:uint =0x00ff00;    //信息栏3字体颜色
		public static const Message3Count:int = 70;//			信息栏3最多语序输入70个字符
		public static const Message3TIME:int=4000;  // 毫秒  信息栏3消息显示时间 
		public static const Message3Font:String= "simsun";   //信息栏3使用字体为宋体
		
		/**
		 *系统公告6 屏幕中央上方 向上滚动 
		 */		
		public static const MESSAGE_6_MID_UP_ROLL:int=6;
		public static const Message6Size:int = 20;     //信息栏3使用字号为10号
		public static const Message6Colour:uint =0x00ff00;    //信息栏3字体颜色
		public static const Message6Count:int = 40;//			信息栏3最多语序输入70个字符
		public static const Message6TIME:int=3000;  // 毫秒  信息栏3消息显示时间 
		public static const Message6Font:String= "simsun";   //信息栏3使用字体为宋体
		public static const Message6Num:int=3;//条数
		
		/**
		 * 系统公告5 屏幕中央 下方
		 */		
		public static const MESSAGE_5_MID_DOWN:int=5;
		public static const Message5Count:int = 40;	 //信息栏4最多语序输入70个字符
		public static const Message5Colour:uint =0x00ff00;   //信息栏4字体颜色
		public static const Message5Font:String= "simsun"; //信息栏4使用字体为宋体
		public static const Message5Size:int = 20;//				信息栏4使用字号为10号
		public static const Message5TIME:int =3000;//				信息栏4消息显示时间
		
		//公告
		/**
		 *系统公告 屏幕最上方 从右向左滚动 
		 */		
		public static const MESSAGE_POST:int=7;
		public static const PostCount:int = 140;// 				公告栏最多语序输入70个字符
		public static const PostColour:uint =0x00ff00;//			公告栏字体颜色
		public static const PostFont:String= "simsun";//				公告栏使用字体为宋体
		public static const PostSize:int = 20;//					公告栏使用字号为10号
		public static const PostTime:int= 5000;//	公告栏消息显示时间
		public static const PostSpeed:int=2;//移动速度  单位像素
		public static const PostTimes:int=3;
		
		
//		//公告6
//		public static const MESSAGE_
//		public static const ImMessageCount:int = 70	;//重要信息栏最多语序输入70个字符
//		public static const ImMassageColour:uint =0x00ff00;  //重要信息栏字体颜色
//		public static const ImMessageFont:String="simsun"; 	//重要信息栏使用字体为宋体
//		public static const ImMessageSize:int = 10;	//重要信息栏使用字号为10号
//		public static const ImMessageAcount:int = 10;//重要信息栏最多可以存储10个重要信息（交易那种可叠加显示信息算一条
//		
		
		//文档中的系统公告4
		/**
		 *4 屏幕中央下方 带图片 向上滚动的 
		 */		
		public static const MESSAGE_4_IMG:int=4;
		
		public static const IMG_WRONG:int=0;//红色叉
		public static const IMG_WARN:int=1;//蓝色叹号
		public static const IMG_PROMPT:int=2;//黄色叹号
		
		public static const IMG_WRONG_Count:int = 30;	 //信息栏4最多语序输入70个字符
		public static const IMG_WRONG_Colour:uint =0xFF0000;   //信息栏4字体颜色
		public static const IMG_WRONG_Font:String= "simsun"; //信息栏4使用字体为宋体
		public static const IMG_WRONG_Size:int = 12;//				信息栏4使用字号为10号
		public static const IMG_WRONG_TIME:int =3000;//				信息栏4消息显示时间
		
		public static const IMG_WARN_Count:int = 30;	 //信息栏4最多语序输入70个字符
		public static const IMG_WARN_Colour:uint =0xFFFF00;   //信息栏4字体颜色
		public static const IMG_WARN_Font:String= "simsun"; //信息栏4使用字体为宋体
		public static const IMG_WARN_Size:int = 12;//				信息栏4使用字号为10号
		public static const IMG_WARN_TIME:int =3000;//	
		
		public static const IMG_PROMPT_Count:int = 30;	 //信息栏4最多语序输入70个字符
		public static const IMG_PROMPT_Colour:uint =0xffffff;   //信息栏4字体颜色
		public static const IMG_PROMPT_Font:String= "simsun"; //信息栏4使用字体为宋体
		public static const IMG_PROMPT_Size:int = 12;//				信息栏4使用字号为10号
		public static const IMG_PROMPT_TIME:int =3000;//
		
//		user   1    -- 玩家的名字  可点击出弹出菜单
//		item   2    -- 物品装备    弹出tips
//		map    3    -- 地图坐标    可发起寻路
//		act    4    -- 活动        弹出对应面板
//		vip    5    -- vip说明     弹出vip说明面板
		
		public static const LINK_TYPE_USER:int=1;
		public static const LINK_TYPE_ITEM:int=2;
		public static const LINK_TYPE_MAP:int=3;
		public static const LINK_TYPE_VIP:int=5;
		public static const LINK_TYPE_ACTIVE:int=4;
		
		public function SystemNoticeEnum() {
		}
	}
}
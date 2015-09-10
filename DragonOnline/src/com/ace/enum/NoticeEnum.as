/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-10-21 下午6:26:34
 */
package com.ace.enum {

	public class NoticeEnum {


		public static const FORMAT_MESSAGE1:String="message1";
		public static const FORMAT_MESSAGE2:String="message2";
		public static const FORMAT_MESSAGE3:String="message3";
		public static const FORMAT_MESSAGE4:String="message4";
		public static const FORMAT_MESSAGE5:String="message5";
		public static const FORMAT_MESSAGE6:String="message6";
		public static const FORMAT_MESSAGE7:String="message7";
		public static const FORMAT_MESSAGE8:String="message8";

		public static const TYPE_MESSAGER1:int=1;
		public static const TYPE_MESSAGER2:int=2;
		public static const TYPE_MESSAGER3:int=3;
		public static const TYPE_MESSAGER4:int=4;
		public static const TYPE_MESSAGER5:int=5;
		public static const TYPE_MESSAGER6:int=6;
		public static const TYPE_MESSAGER7:int=7;
		public static const TYPE_MESSAGER8:int=8;
		public static const TYPE_MESSAGER11:int=11;

		//消息1
		public static const MESSAGE1_LENGTH:int=30; //文本长度
		public static const MESSAGE1_DISTANCE_Y:int=-100; //消失距离
		public static const MESSAGE1_TIME:int=2; //持续时间 -秒为单位
		public static const MESSAGE1_NUM:int=4; //消息数量
		//消息2
		public static const MESSAGE2_PY:int=130; //文本位置Y，上部偏移
		public static const MESSAGE2_LENGTH:int=30; //文本长度
		public static const MESSAGE2_TIME:int=4; //持续时间 -秒为单位
		public static const MESSAGE2_NUM:int=4; //消息数量
		//消息4
		public static const MESSAGE4_PY:int=160; //文本位置Y偏移，底部偏移
		public static const MESSAGE4_LENGTH:int=30; //文本长度
		public static const MESSAGE4_TIME:int=4; //持续时间 -秒为单位
		public static const MESSAGE4_NUM:int=4; //消息数量

		public static const MESSAGE4_HEIGHT:int=26; //高度
		public static const MESSAGE4_GAP_HEIGHT:int=30; //高度
		public static const MESSAGE4_MIN_WIDTH:int=430; //消息最小宽度
		public static const MESSAGE4_SIGN_WIDTH:int=26; //提示图片的宽度


		public static const MESSAGE4_SIGN_FAIL:int=0; //操作失败提示
		public static const MESSAGE4_SIGN_ALERT:int=1; //警告提示
		public static const MESSAGE4_SIGN_SUCCESS:int=2; //操作成功提示

		public static const MESSAGE4_COLOR_FAIL:uint=0xFF0000; //操作失败颜色
		public static const MESSAGE4_COLOR_ALERT:uint=0xFFFFFF; //警告颜色
		public static const MESSAGE4_COLOR_SUCCESS:uint=0xFFFF00; //操作成功颜色

		//消息5
		public static const MESSAGE5_PY:int=185; //文本位置Y，上部偏移
		public static const MESSAGE5_LENGTH:int=30; //文本长度
		public static const MESSAGE5_TIME:int=2; //持续时间 -秒为单位
		public static const MESSAGE5_NUM:int=4; //消息数量


		//消息6
		public static const MESSAGE6_PY:int=110; //文本位置Y偏移，底部偏移
		public static const MESSAGE6_LENGTH:int=60; //文本长度
		public static const MESSAGE6_TIME:int=4; //持续时间 -秒为单位
		public static const MESSAGE6_NUM:int=3; //消息数量
		public static const MESSAGE6_GAP_HEIGHT:int=24; //高度
		
		
		//消息7
		public static const MESSAGE7_PY:int=25; //文本位置Y偏移，底部偏移
		public static const MESSAGE7_LENGTH:int=140; //文本长度
		public static const MESSAGE7_SPEED:int=5; //消息移动速度
		public static const MESSAGE7_TIMES:int=1; //显示次数
		
		
		//消息8
		public static const MESSAGE8_NUM:int = 8;
		public static const MESSAGE8_PX:int = 415; //横坐标偏移,屏幕中心偏移
		public static const MESSAGE8_PY:int = 145;  //纵坐标偏移,屏幕底部偏移
		
		//消息9(战斗力)
		public static const MESSAGE9_PY:int = 300; //纵坐标偏移,屏幕底部为偏移
		
		//消息10，场景提示
		public static const MESSAGE10_PY:int = 150; //纵坐标偏移,屏幕上部偏移
		
		//消息11
		public static const MESSAGE11_PX:int = 0;
		
		//连接类型
		public static const LINK_TEXT:int = 0;
		public static const LINK_ICON:int = 1;
		
		//图标连接类型
		public static const ICON_LINK_TEAM:int = 1;
		public static const ICON_LINK_GUILD:int = 2;
		public static const ICON_LINK_MAIL:int = 3;
		public static const ICON_LINK_DIE:int = 4;
		public static const ICON_LINK_CHALLENGE:int = 5;
		public static const ICON_LINK_FARM:int = 6;
		public static const ICON_LINK_FRIEND:int = 7;
		public static const ICON_LINK_DEVIL:int = 8;
		public static const ICON_LINK_THOUGHT:int = 9;
		public static const ICON_LINK_INTEAM:int = 10;
		public static const ICON_LINK_DUEL:int = 13;
	}
}
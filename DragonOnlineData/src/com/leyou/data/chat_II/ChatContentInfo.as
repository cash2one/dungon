package com.leyou.data.chat_II {
	import com.leyou.enum.ChatEnum;

	public class ChatContentInfo {
		
		public var type:int;             // 所属频道枚举
		
		public var fromUserName:String;  // 说话者名字
		
		public var toUserName:String;    // 私聊的玩家名字
		
		public var channelName:String;   // 频道名字
		
		public var content:String = "";  // 处理后拼接完毕内容
		
		public var nativeStr:String;     // 处理后的仅说话内容
		
		public var linkType:int;         // 超链接类型
		
		public var vipLv:int;
		
		public function getVipName():String{
			if((vipLv > 0) && ("" != fromUserName)){
				return "\\"+ (49+vipLv)+"  "+fromUserName;
			}
			return fromUserName;
		}
		
		/**
		 * <T>是否是玩家说话</T>
		 * 
		 * @return 是不是 
		 * 
		 */		
		public function palyerSpeak():Boolean{
			return (("" != fromUserName) && (type != ChatEnum.CHANNEL_SYSTEM));
		}
		
		/**
		 * 判断所属频道
		 * 
		 * @param type 频道枚举
		 * @return     是否属于
		 * 
		 */		
		public function isChanel(type:int):Boolean{
			return (ChatEnum.CHANNEL_WORLD == type);
		}
	}
}
package com.leyou.data.chat_II
{
	import flash.utils.Dictionary;

	public class ChatInfo
	{
		/**
		 * <T>频道列表</T>
		 */		
		private var chatChnnels:Dictionary = new Dictionary();
		
		public function ChatInfo(){
		}
		
		/**
		 * <T>推入聊天内容</T>
		 * 
		 * @param ci   聊天内容
		 * @param type 所属频道类型
		 * 
		 */		
		public function pushContent(ci:ChatContentInfo, type:int):void{
			var channel:ChatChannelInfo = getChannel(type);
			channel.pushContent(ci);
		}
		
		/**
		 * <T>获得聊天内容</T>
		 * 
		 * @param index 所在索引
		 * @param type  所属频道
		 * @return      聊天内同
		 * 
		 */		
		public function getContent(index:int, type:int):ChatContentInfo{
			var channel:ChatChannelInfo = getChannel(type);
			return channel.getContenInfo(index);
		}
		
		/**
		 * <T>获得聊天频道</T>
		 * 
		 * @param type 频道类型
		 * @return     聊天频道
		 * 
		 */		
		public function getChannel(type:int):ChatChannelInfo{
			var channel:ChatChannelInfo = chatChnnels[type];
			if(null == channel){
				channel = new ChatChannelInfo();
				chatChnnels[type] = channel;
				channel.type = type;
			}
			return channel;
		}
		
		/**
		 * <T>清空频道内容</T>
		 * 
		 * @param type 频道类型
		 * 
		 */		
		public function clear(type:int):void{
			var channel:ChatChannelInfo = getChannel(type);
			channel.clear();
		}
	}
}
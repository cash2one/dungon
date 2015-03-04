package com.leyou.data.chat_II {
	import com.leyou.enum.ChatEnum;

	/**
	 * @class 频道信息
	 * @author Administrator
	 * 
	 */	
	public class ChatChannelInfo {
		
		/**
		 * <T>频道枚举</T>
		 */		
		public var type:int;
		
		/**
		 * <T>频道所有聊天信息</T>
		 */		
		protected var store:Vector.<ChatContentInfo> = new Vector.<ChatContentInfo>();
		
		public function ChatChannelInfo() {
		}
		
		/**
		 * <T>频道信息数量</T>
		 * 
		 * @return 信息数量 
		 * 
		 */		
		public function get count():int{
			return store.length;
		}
		
		/**
		 * <T>放入频道聊天内容</T>
		 * 
		 * @param ci 聊天内容
		 * 
		 */		
		public function pushContent(ci:ChatContentInfo):void{
			store.push(ci);
			while(store.length > ChatEnum.COMMONMSG_MAX_COUNT){
				store.shift();
			}
		}
		
		/**
		 * <T>获取聊天内容</T>
		 * 
		 * @param index 信息所在索引
		 * @return      聊天信息
		 * 
		 */		
		public function getContenInfo(index:int):ChatContentInfo{
			if(index >= 0 && index < store.length){
				return store[index];
			}
			return null;
		}
		
		/**
		 * <T>清空聊天内容</T>
		 * 
		 */		
		public function clear():void{
			store.length = 0;
		}
	}
}
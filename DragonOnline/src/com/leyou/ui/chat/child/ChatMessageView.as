package com.leyou.ui.chat.child
{
	import com.ace.manager.UIManager;
	import com.leyou.data.chat_II.ChatChannelInfo;
	import com.leyou.data.chat_II.ChatContentInfo;
	import com.leyou.enum.ChatEnum;
	
	import flash.display.Sprite;
	
	public class ChatMessageView extends Sprite
	{
		// 喇叭消息显示面板
		private var hornPannel:HornPane;
		
		// 系统消息显示面板
		private var systemPannel:SystemPane;
		
		// 通用消息显示面板
		private var commonPannel:CommonPane;
		
		// 尺寸状态
		private var sizeStatus:int;
		
		public function ChatMessageView(){
			init();
		}
		
		/**
		 * <T>初始化</T>
		 * 
		 */		
		private function init():void {
			mouseChildren = true;
			hornPannel = new HornPane();
			systemPannel = new SystemPane();
			systemPannel.y = 40;
			commonPannel = new CommonPane();
			commonPannel.y = 88;
			addChild(hornPannel);
			addChild(systemPannel);
			addChild(commonPannel);
			commonPannel.tweenHide();
			systemPannel.tweenHide();
		}
		
		public function tweenShow():void{
			commonPannel.tweenShow();
			systemPannel.tweenShow();
		}
		
		public function tweenHide():void{
			commonPannel.tweenHide();
			systemPannel.tweenHide();
		}
		
		/**
		 * <T>加入通用面板</T>
		 * 
		 * @param message 消息内容
		 * 
		 */		
		public function pushInCommon(content:ChatContentInfo, link:Function):void{
			commonPannel.pushContent(content, link);
		}
		
		/**
		 * <T>加入系统面板</T>
		 * 
		 * @param message 消息内容
		 * 
		 */		
		public function pushInSystem(content:ChatContentInfo, link:Function):void{
			systemPannel.pushContent(content, link);
		}
		
		/**
		 * <T>加入喇叭面板</T>
		 * 
		 * @param message 消息内容
		 * 
		 */		
		public function pushInHorn(content:ChatContentInfo):void{
			hornPannel.pushMessage(content);
		}
		
		/**
		 * <T>显示所选频道信息</T>
		 * 
		 * @param channel 频道
		 * 
		 */		
		public function switchToChannel(channel:ChatChannelInfo, link:Function):void{
			commonPannel.clear();
			var config:ChatConfig = UIManager.getInstance().chatConfigWnd;
			var count:int = channel.count;
			for(var n:int = 0; n < count; n++){
				var content:ChatContentInfo = channel.getContenInfo(n);
				// 是否接收该频道消息
				var limit:Boolean = !config.getLimit(content.type);
				if((ChatEnum.CHANNEL_COMPOSITE != channel.type) || limit){
					commonPannel.pushContent(content, link);
				}
			}
		}
		
		/**
		 * <T>设置尺寸</T>
		 * 
		 * @param w 宽
		 * @param h 高
		 * 
		 */		
		public function changeSizeStatus():void{
			// 获取当前尺寸
			var currentSize:Array = ChatEnum.STATUS_BG_SIZE[sizeStatus]
			sizeStatus = (0 == sizeStatus) ? 1 : 0;
			// 获取应当调整成的尺寸
			var size:Array = ChatEnum.STATUS_BG_SIZE[sizeStatus];
			var dx:Number = currentSize[0] - size[0];
			var dy:Number = currentSize[1] - size[1];
			hornPannel.x += dx;
			hornPannel.y += dy;
			systemPannel.x += dx;
			systemPannel.y += dy;
			commonPannel.x += dx;
			commonPannel.y += dy;
			// 后改变尺寸
			commonPannel.setSizeStatus(sizeStatus);
		}
	}
}
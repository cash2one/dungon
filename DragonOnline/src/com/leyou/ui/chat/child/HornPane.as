package com.leyou.ui.chat.child {
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.greensock.TweenLite;
	import com.leyou.data.chat_II.ChatContentInfo;
	import com.leyou.enum.ChatEnum;
	import com.leyou.enum.ConfigEnum;
	
	import flash.events.Event;
	
	public class HornPane extends AutoSprite {
		
		/**
		 * <T>富文本显示对象</T> 
		 */		
		public var textField:RichTextFiled;
		
		/**
		 * <T>显示信息队列</T>
		 */		
		private var queue:Vector.<ChatContentInfo>;
		
		/**
		 * <T>当前显示信息时间戳,为-1时说明当前没有正在显示的信息</T>
		 */		
		private var tick:Number = - 1;
		
		public function HornPane() {
			super(LibManager.getInstance().getXML("config/ui/chat/ChatHorn.xml"));
			init();
		}
		
		/**
		 * <T>初始化</T> 
		 * 
		 */		
		private function init():void {
			alpha = 0;
			mouseChildren = true;
			textField = new RichTextFiled(270, 100);
			addChild(textField);
			textField.setScrollH();
			textField.x = 25;
			textField.y = 10;
			queue = new Vector.<ChatContentInfo>();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * <T>显示队列是否有等待显示信息</T>
		 * 
		 * @return 是否为空 
		 * 
		 */		
		public function empty():Boolean{
			return (0 == queue.length);
		}
		
		/**
		 * <T>帧事件监听</T>
		 * <P>用于处理喇叭信息显示的时间长短.</P>
		 * 
		 * @param event 帧事件
		 * 
		 */		
		protected function onEnterFrame(event:Event):void{
			var v:Boolean = (-1 != tick); // 当前是否有显示信息
			var e:Boolean = empty();      // 显示队列是否为空
			if(!v && e){
				return;
			}
			if(!v && !e){
				var chatInfo:ChatContentInfo = queue.shift();
				setRichText(chatInfo.content);
				tweenShow();
				tick = new Date().time; // 记录时间戳
			}else{
				var interval:uint = new Date().time - tick; // 计算当前显示信息已显示时间
				if(e){
					if(interval >= ConfigEnum.chat1){
						textField.clear();
						tweenHide();
						tick = -1; // 消失并重置时间戳
					}
				}else{
					if(interval >=  ConfigEnum.chat1){
						tick = -1; // 重置时间戳
					}
				}
			}
		}
		
		/**
		 * <T>向信息队列推入信息</T>
		 * 
		 * @param message 推入信息
		 * 
		 */		
		public function pushMessage(message:ChatContentInfo):void{
			queue.push(message);
		}
		
		/**
		 * <T>设置要显示的文本信息</T>
		 * 
		 * @param content 要显示的文本
		 * 
		 */		
		private function setRichText(content:String):void {
			textField.clear();
			textField.setHtmlText(content);
		}
		
		public function tweenHide():void{
			TweenLite.to(this, 0.5, {alpha:0});
		}
		
		public function tweenShow():void{
			TweenLite.to(this, 0.5, {alpha:1});
		}
	}
}
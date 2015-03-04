package com.leyou.ui.chat.child {
	import com.ace.delayCall.DelayCallManager;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.greensock.TweenLite;
	import com.leyou.data.chat_II.ChatContentInfo;
	import com.leyou.enum.ChatEnum;
	
	import flash.events.Event;

	public class CommonPane extends AutoSprite {
		
		// 背景图
		private var bgBmp:ScaleBitmap;
		
		// 显示面板
		private var pannel:ScrollPane;
		
		// 文本显示对象列表
		private var texts:Vector.<RichTextFiled>;
		
		// 当前索引
		private var currentIndex:int;
		
		// 聊天缓冲队列,每帧仅处理一个
		private var contentQueue:Vector.<ChatContentInfo>;
		
		// 点击连接监听
		private var linkFun:Function;
		
		public function CommonPane() {
			super(LibManager.getInstance().getXML("config/ui/chat/ChatText.xml"));
			init();
		}
		
		/**
		 * <T>初始化</T>
		 * 
		 */		
		public function init():void{
			mouseChildren = true;
			bgBmp = getUIbyID("bgBmp") as ScaleBitmap;
			pannel = getUIbyID("textList") as ScrollPane;
			texts = new Vector.<RichTextFiled>(ChatEnum.COMMONMSG_MAX_COUNT);
			contentQueue = new Vector.<ChatContentInfo>();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * 帧事件,检测是否有待显示的聊天内容
		 * 
		 * @param event 事件
		 * 
		 */		
		protected function onEnterFrame(event:Event):void{
			var content:ChatContentInfo = contentQueue.shift();
			if(null != content){
				processContent(content);
			}
		}
		
		private function processContent(content:ChatContentInfo):void{
			var maxCount:int = texts.length;
			var text:RichTextFiled;
			if(currentIndex < maxCount){
				text = texts[currentIndex];
				if(null == text){
					text = new RichTextFiled(280, 20);
					texts[currentIndex] = text;
				}
				currentIndex++;
				text.linkListener = linkFun;
				pannel.addToPane(text);
			}else{
				// 循环移动
				text = texts[0];
				text.clear();
				for(var n:int = 0; n < maxCount-1; n++){
					texts[n] = texts[n+1];
				}
				texts[maxCount-1] = text;
			}
			text.setHtmlText(content.content);
			reviseLocation();
		}
		
		public function tweenHide():void{
			TweenLite.to(bgBmp, 0.5, {alpha:0});
			TweenLite.to(pannel.scrollBar_Y, 0.5, {alpha:0});
		}
		
		public function tweenShow():void{
			TweenLite.to(bgBmp, 0.5, {alpha:1});
			TweenLite.to(pannel.scrollBar_Y, 0.5, {alpha:1});
		}
		
		/**
		 * <T>设置尺寸</T>
		 * 
		 * @param w 宽
		 * @param h 高
		 * 
		 */		
		public function setSizeStatus(status:int):void{
			var size:Array = ChatEnum.STATUS_BG_SIZE[status];
			var pSize:Array = ChatEnum.STATUS_PANNEL_SIZE[status];
			bgBmp.setSize(size[0], size[1]);
			pannel.resize(pSize[0], pSize[1]);
			pannel.updateUI();
		}
		
		/**
		 * <T>向面板推入聊天信息</T>
		 * 
		 * @param content 信息内容
		 * 
		 */		
		public function pushContent(content:ChatContentInfo, link:Function):void{
			linkFun = link;
			contentQueue.push(content);
		}
		
		/**
		 * <T>修正各项位置</T>
		 * 
		 */		
		public function reviseLocation():void{
			var h:int = 0;
			for(var n:int = 0; n < currentIndex; n++){
				var text:RichTextFiled = texts[n];
				text.x = 17;
				text.y = h;
				if(text.textFiled.numLines <= 2){
					h += text.textFiled.height - 3;
				}else{
					h += text.textFiled.height;
				}
			}
			pannel.updateUI();
			pannel.scrollTo(1);
		}
		
		/**
		 * <T>清空<T>
		 * 
		 */		
		public function clear():void{
			currentIndex = 0;
			var count:int = texts.length;
			for(var n:int = 0; n < count; n++){
				var text:RichTextFiled = texts[n];
				if((null != text) && pannel.contains(text)){
					text.clear();
					pannel.delFromPane(text);
				}
			}
			pannel.scrollTo(0);
			contentQueue.length = 0;
		}
	}
}
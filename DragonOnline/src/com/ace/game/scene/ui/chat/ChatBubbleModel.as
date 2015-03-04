package com.ace.game.scene.ui.chat {
	import com.ace.manager.LibManager;
	import com.ace.reuse.ReUseModel;
	import com.ace.tools.ScaleBitmap;
	import com.greensock.TweenLite;
	import com.leyou.ui.chat.child.RichTextFiled;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Rectangle;

	internal class ChatBubbleModel extends ReUseModel {
		// 最大宽度
		private static const WIDTH_MAX:int=218;

		// 显示时间
		private static const STAY_TIME:int=3000;

		// 背景
		private var bg:ScaleBitmap;

		// 文本
		private var lb:RichTextFiled;

		// 等待显示队列
		private var queue:Vector.<String>;

		// 计时时间戳
		private var tick:Number;

		private var freeII:Boolean;

		public function ChatBubbleModel() {
			init();
		}

		/**
		 * <T>初始化</T>
		 *
		 */
		protected function init():void {
			freeII=true;
			visible=false;

			var data:BitmapData=LibManager.getInstance().getImg("ui/common/paopao.png");
			bg=new ScaleBitmap(data);
			bg.scale9Grid=new Rectangle(5, 5, 20, 20);
			addChild(bg);

			lb=new RichTextFiled();
			lb.x=5;
			lb.y=5;
			addChild(lb);

			queue=new Vector.<String>()
			//			lb.textFiled.border = true;
			//			lb.textFiled.borderColor = 0xff0000;
			//			lb.textFiled.textColor = 0xff00;
			//			graphics.beginFill(0xffffff);
			//			graphics.drawRect(0,0,500,500);
			//			graphics.endFill();
		}

		/**
		 * <T>是否自动适应大小</T>
		 *
		 * @param value 是否
		 *
		 */
		protected function setAutoSize(value:Boolean):void {
			lb.textFiled.wordWrap=value;
			lb.textFiled.multiline=value;
		}

		/**
		 * <T>推入要显示的聊天信息</T>
		 *
		 * @param content 聊天信息
		 *
		 */
		public function pushContent(content:String):void {
			queue.push(content);
			showNext();
		}
		
		/**
		 * <T>非队列式显示内容(会清除原来队列所有内容)</T>
		 * 
		 * @param content 显示内容
		 * 
		 */		
		public function showContent(content:String):void{
			clearPlaying();
			pushContent(content);
		}

		/**
		 * <T>显示队列中下一条信息</T>
		 *
		 */
		private function showNext():void {
			if ((queue.length <= 0) || !freeII) {
				return;
			}
			lb.clear();
			freeII=false;
			visible=true;
			setAutoSize(false);
			var content:String=queue.shift();
			lb.textFiled.htmlText=content;
			if (lb.width > WIDTH_MAX) {
				setAutoSize(true);
				lb.setWidth(WIDTH_MAX);
			}
			lb.setHtmlText(content);
			bg.setSize(lb.width + 15, lb.height + 15);
			TweenLite.to(this, .5, {alpha: 1, onComplete: onMoveOver});
			function onMoveOver():void {
				tick=new Date().time;
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}

		/**
		 * <T>帧事件</T>
		 *
		 * @param event 事件
		 *
		 */
		protected function onEnterFrame(event:Event):void {
			var dt:uint=new Date().time - tick;
			if (dt > STAY_TIME) {
				freeII=true;
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				if (queue.length > 0) {
					showNext();
				} else {
					TweenLite.to(this, .5, {alpha: 0});
				}
			}
		}
		
		/**
		 * <T>清除正在和等待队列内的显示内容</T>
		 * 
		 */		
		protected function clearPlaying():void{
			queue.length = 0;
			freeII=true;
			TweenLite.killTweensOf(this);
			if(hasEventListener(Event.ENTER_FRAME)){
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
	}
}
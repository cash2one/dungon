package com.leyou.ui.chat
{
	import com.ace.enum.UIEnum;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.leyou.ui.chat.child.ChatController;
	import com.leyou.ui.chat.child.ChatMessageView;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class ChatWndView extends AutoSprite
	{
		// 显示按钮
		protected var showBtn:ImgButton;
		
		// 控制器
		protected var controller:ChatController;
		
		// 消息显示
		protected var messageView:ChatMessageView;
		
		// 辅助鼠标移入的监听
		protected var sprite:Sprite = new Sprite();
		
		public function ChatWndView(){
			super(LibManager.getInstance().getXML("config/ui/ChatWnd_II.xml"));
			init();
		}
		
		/**
		 * <T>初始化</T>
		 * 
		 */		
		private function init():void {
			mouseChildren = true;
			showBtn = getUIbyID("showBtn") as ImgButton;
			showBtn.visible = false;
			
			controller = new ChatController();
			controller.y = 278;
			messageView = new ChatMessageView();
			controller.setView(messageView);
			
			var g:Graphics = sprite.graphics;
			g.beginFill(0, 0);
			g.drawRect(0, 0, 295, 325);
			g.endFill();
			
			addChild(sprite);
			addChild(messageView);
			addChild(controller);
			controller.hideListener = onModuleHide;
			showBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		/**
		 * <T>鼠标移出面板隐藏</T>
		 *  
		 * @param event 鼠标事件
		 * 
		 */		
		protected function onMouseOut(event:MouseEvent):void{
			var display:DisplayObject = event.relatedObject;
			if(!display || !contains(display)){
				messageView.tweenHide();
			}
		}
		
		/**
		 * <T>鼠标移入面板显示</T>
		 * 
		 * @param event 鼠标事件
		 * 
		 */		
		protected function onMouseOver(event:MouseEvent):void{
			messageView.tweenShow();
		}
		
		
		/**
		 * <T>聊天部分隐藏监听</T>
		 * 
		 */		
		protected function onModuleHide():void{
			showBtn.visible = true;
			sprite.visible = false;
		}
		
		/**
		 * <T>按钮点击</T>
		 * 
		 * @param event 鼠标事件
		 * 
		 */		
		protected function onButtonClick(event:MouseEvent):void{
			showBtn.visible = false;
			sprite.visible = true;
			controller.setVisible(true);
		}
		
		/**
		 * <T>舞台尺寸变化</T>
		 * 
		 */		
		public function resize():void{
			var xx:Number = UIManager.getInstance().toolsWnd.x;
			if (xx > width){
				y = UIEnum.HEIGHT - 329;
			}else{
				y = UIEnum.HEIGHT - 329 - 107;
			}
		}
	}
}
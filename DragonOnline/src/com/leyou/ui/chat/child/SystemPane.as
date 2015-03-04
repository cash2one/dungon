package com.leyou.ui.chat.child
{
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.tools.SpriteNoEvt;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.greensock.TweenLite;
	import com.leyou.data.chat_II.ChatContentInfo;
	import com.leyou.enum.ChatEnum;
	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class SystemPane extends AutoSprite
	{
		// 背景
		private var bgBmp:ScaleBitmap;
		
		// 显示面板
//		private var pannel:ScrollPane;
		
		// 文本显示对象列表
		private var texts:Vector.<RichTextFiled>;
		
		private var upBtn:ImgButton;
		
		private var downBtn:ImgButton;
		
		// 当前文本索引
		private var currentIndex:int;
		
		// 当前显示文本
		private var showIndex:int;
		
		private var plane:SpriteNoEvt;
		
		public function SystemPane(){
			super(LibManager.getInstance().getXML("config/ui/chat/ChatSys.xml"));
			init();
		}
		
		/**
		 * <T>初始化</T>
		 * 
		 */		
		public function init():void{
			this.mouseChildren=true;
			bgBmp = getUIbyID("bgBmp") as ScaleBitmap;
			upBtn = getUIbyID("upBtn") as ImgButton;
			downBtn = getUIbyID("downBtn") as ImgButton;
			upBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			downBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
//			pannel = getUIbyID("systemGridList") as ScrollPane;
//			pannel.scrollBar_Y.scrollBtnVisible = false;
			plane = new SpriteNoEvt();
			plane.y = 4;
			plane.scrollRect = new Rectangle(0, 0, 280, 40);
			addChild(plane);
			texts = new Vector.<RichTextFiled>(ChatEnum.COMMONMSG_MAX_COUNT, true);
		}
		
		private function scrollTo(index:int):void{
			if(index >= 0 && index < currentIndex){
				showIndex = index;
				var t:RichTextFiled = texts[index];
				var rect:Rectangle = plane.scrollRect;
				rect.y = t.y-2;
				plane.scrollRect = rect;
			}
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "upBtn":
					if(showIndex > 0){
						scrollTo(showIndex-1);
					}
					break;
				case "downBtn":
					if(showIndex < currentIndex){
						scrollTo(showIndex+1);
					}
					break;
			}
		}
		
		public function tweenHide():void{
			TweenLite.to(bgBmp, 0.5, {alpha:0});
			TweenLite.to(upBtn, 0.5, {alpha:0});
			TweenLite.to(downBtn, 0.5, {alpha:0});
//			TweenLite.to(pannel.scrollBar_Y, 0.5, {alpha:0});
		}
		
		public function tweenShow():void{
			TweenLite.to(bgBmp, 0.5, {alpha:1});
			TweenLite.to(upBtn, 0.5, {alpha:1});
			TweenLite.to(downBtn, 0.5, {alpha:1});
//			TweenLite.to(pannel.scrollBar_Y, 0.5, {alpha:1});
		}
		
		/**
		 * <T>向面板推入系统信息</T>
		 * 
		 * @param content 信息内容
		 * 
		 */		
		public function pushContent(content:ChatContentInfo, link:Function):void{
			var maxCount:int = texts.length; 
			var text:RichTextFiled;
			if(currentIndex < maxCount){
				text = new RichTextFiled(265, 20, 4);
//				pannel.addToPane(text);
				plane.addChild(text);
				texts[currentIndex++] = text;
				text.linkListener = link;
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
			if(currentIndex > 1){
				scrollTo(currentIndex-2)
			}else{
				scrollTo(currentIndex-1)
			}
//			DelayCallManager.getInstance().add(this, pannel.scrollTo, "system", 4, 1);
//			this.pannel.delayUpdateUI();
		}
		
		/**
		 * <T>修正各项位置</T>
		 * 
		 */		
		public function reviseLocation():void{
			var sunH:int = 0;
			for(var n:int = 0; n < currentIndex; n++){
				var text:RichTextFiled = texts[n];
				text.x = 20;
				text.y = sunH;
				sunH += text.textFiled.textHeight;
//				if(text.textFiled.numLines <= 2){
//					sunH += text.textFiled.height-3;
//				}else{
//					sunH += text.textFiled.height+3;
//				}
			}
//			pannel.updateUI();
		}
	}
}
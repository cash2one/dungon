package com.leyou.ui.chat.child {
	import com.ace.enum.FontEnum;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.leyou.enum.ChatEnum;
	import com.leyou.ui.chat.ChatWnd;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class FaceWnd extends AutoSprite {
		
//		private var imgArr:Vector.<Sprite>;
		
		public function FaceWnd() {
			super(new XML())
			init();
		}

		/**
		 * <T>初始化</T>
		 * 
		 */		
		private function init():void {
			visible = false;
			mouseChildren = true;
			var count:int = ChatEnum.FACE_IMG_COUNT;
			var keyArr:Array = ChatEnum.TEXT_IMG_KEYS;
			for (var i:int = 0; i < count; i++) {
				var faceMC:* = LibManager.getInstance().getClsMC("face"+(i+1));
				faceMC.name = keyArr[i];
				faceMC.useHandCursor = true;
				addChild(faceMC);
				faceMC.name = keyArr[i];
				faceMC.x = i % 10 * (20+5)+5;
				faceMC.y = Math.floor(i / 10) * (20+5)+5;
				faceMC.addEventListener(MouseEvent.CLICK, onImgClick);
			}
//			var bg:ScaleBitmap = new ScaleBitmap(LibManager.getInstance().getImg(FontEnum.getTextScaleInfo("PanelBgOut").imgUrl));
//			bg.scale9Grid = FontEnum.getTextScaleInfo("PanelBgOut").rect;
//			bg.setSize(255, 105);
//			bg.alpha = .8;
//			addChildAt(bg, 0);
		}
		
		/**
		 * <T>显示和隐藏</T>
		 * 
		 */		
		public override function open():void{
			visible = !visible;
			resize();
		}
		
		public function resize():void{
			var chatWnd:ChatWnd = UIManager.getInstance().chatWnd;
			x = chatWnd.width;
			y = chatWnd.y + 327 - 105;
		}
		
		/**
		 * <T>表情点击监听</T>
		 * 
		 * @param evt 鼠标事件
		 * 
		 */		
		private function onImgClick(evt:MouseEvent):void {
			visible = false;
			var str:String = evt.currentTarget.name;
			UIManager.getInstance().chatWnd.addFace("\\" + str);
		}
	}
}
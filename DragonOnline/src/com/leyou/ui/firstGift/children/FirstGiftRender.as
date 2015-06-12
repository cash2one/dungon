package com.leyou.ui.firstGift.children
{
	import com.ace.ui.auto.AutoSprite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.leyou.ui.firstGift.FirstGiftWnd;
	
	import flash.events.MouseEvent;
	
	public class FirstGiftRender extends AutoSprite
	{
		public function FirstGiftRender(uiXMl:XML){
			super(uiXMl);
		}
		
		protected function init():void{
			mouseEnabled = true;
			mouseChildren = true;
//			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
//			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
//		
//		protected function onMouseOut(event:MouseEvent):void{
//			if((null == event.relatedObject) || !this.contains(event.relatedObject)){
//				TweenMax.to(this, 0.2, {scaleX:FirstGiftWnd.SCALE, scaleY:FirstGiftWnd.SCALE, ease:Back.easeOut});
//			}
//		}
//		
//		protected function onMouseOver(event:MouseEvent):void{
//			if(event.target == this){
//				TweenMax.to(this, 0.2, {scaleX:1, scaleY:1, ease:Back.easeOut});
//			}
//		}
	}
}
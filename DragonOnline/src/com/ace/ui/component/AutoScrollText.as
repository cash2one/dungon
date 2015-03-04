package com.ace.ui.component
{
	import com.ace.manager.TimeManager;
	import com.greensock.TweenLite;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * 滚动文本框
	 *  
	 * @author WFH
	 * 
	 */	
	public class AutoScrollText extends Sprite
	{
		private var container:Sprite;
		
		private var textMask:Shape;
		
		private var texts:Array;
		
		private var currentIndex:int;
		
		private var pText:TextField;
		
		private var nText:TextField;
		
		private var _defaultTextFormat:TextFormat;

		private var scrollW:int;
		
		private var scrollH:int;
		
		private var delay:int = 4000;
		
		public function AutoScrollText(){
			super();
			init();
		}
		
		public function get defaultTextFormat():TextFormat{
			return _defaultTextFormat;
		}

		private function init():void{
			container = new Sprite();
			textMask = new Shape();
			pText = new TextField();
			nText = new TextField();
			texts = [];
			
			addChild(container);
			addChild(textMask);
			container.addChild(pText);
			container.addChild(nText);
			container.mask = textMask;
			pText.autoSize = TextFieldAutoSize.LEFT;
			nText.autoSize = TextFieldAutoSize.LEFT;
		}
		
		public function set defaultTextFormat(v:TextFormat):void{
			_defaultTextFormat = v;
			pText.defaultTextFormat = _defaultTextFormat;
			nText.defaultTextFormat = _defaultTextFormat;
		}
		
		public function setScrollRect(w:int, h:int):void{
			scrollW = w;
			scrollH = h;
			var g:Graphics = textMask.graphics;
			g.clear();
			g.beginFill(0);
			g.drawRect(0, 0, scrollW, scrollH);
			g.endFill();
			pText.x = 0;
			pText.y = 0;
			nText.x = 0;
			nText.y = scrollH;
		}
		
		public function setDelay($delay:int):void{
			stopScroll();
			delay = $delay;
			startScroll();
		}
		
		public function startScroll():void{
			if(!TimeManager.getInstance().hasITick(onNextText)){
				TimeManager.getInstance().addITick(delay, onNextText);
			}
		}
		
		private function onNextText():void{
			currentIndex++;
			if(currentIndex >= texts.length){
				currentIndex = 0;
			}
			scrollTo(currentIndex);
		}
		
		public function stopScroll():void{
			if(TimeManager.getInstance().hasITick(onNextText)){
				TimeManager.getInstance().removeITick(onNextText);
			}
		}
		
		public function setTextArray(arr:Array):void{
			texts = arr;
			currentIndex = 0;
			setText(currentIndex);
		}
		
		public function setText(index:int):void{
			var content:String = texts[index];
			pText.text = content;
		}
		
		public function scrollTo(index:int):void{
			if(texts.length <= 0){
				return;
			}
			pText.x = 0;
			pText.y = 0;
			nText.x = 0;
			nText.y = scrollH;
			var content:String = texts[index];
			nText.text = content;
			TweenLite.to(pText, 1, {y:-scrollH});
			TweenLite.to(nText, 1, {y:0});
			var tmpText:TextField = pText;
			pText = nText;
			nText = tmpText;
		}
		
		public function addText(text:String):void{
			texts.push(text);
		}
		
		public function removeText(text:String):void{
			var index:int = texts.indexOf(text);
			texts.splice(index, 1);
		}
		
		public function clear():void{
			pText.text = "";
			nText.text = "";
			texts.length = 0;
		}
	}
}
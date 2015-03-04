package com.ace.game.scene.ui.chat
{
	import com.ace.enum.FilterEnum;
	import com.ace.enum.FontEnum;
	import com.ace.enum.KeysEnum;
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class ChatInputText extends Sprite
	{
		protected var bg:ScaleBitmap;
		
		protected var _input:TextField;
		
		public function  ChatInputText(w:int, h:int):void{
			init(w, h);
		}
		
		public function get input():TextField{
			return _input;
		}

		private function init(w:int, h:int):void{
			bg = new ScaleBitmap(LibManager.getInstance().getImg(FontEnum.getTextScaleInfo("PanelBgOut").imgUrl));
			bg.scale9Grid = FontEnum.getTextScaleInfo("PanelBgOut").rect;
			addChild(bg);
			bg.y = -2;
			bg.setSize(w, h);
			_input = new TextField();
			_input.type = TextFieldType.INPUT;
			_input.width = w;
			_input.height = h;
			addChild(input);
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, true);
			addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			event.stopPropagation();
		}
		
		public function set defaultTextFormat(tf:TextFormat):void{
			input.defaultTextFormat = tf;
		}
		
		protected function onFocusOut(event:FocusEvent):void{
			this.filters = null;
		}
		
		protected function onFocusIn(event:FocusEvent):void{
			this.filters = [FilterEnum.drop_shadow];
		}
		
		protected function onKeyDown(evt:KeyboardEvent):void{
			switch(evt.keyCode){
				case KeysEnum.ENTER:
				case KeysEnum.UP:
				case KeysEnum.DOWN:
					break;
				default:
					evt.stopPropagation();
					break;
			}
		}
		
		protected function onKeyUp(evt:KeyboardEvent):void{
			switch(evt.keyCode){
				case KeysEnum.ENTER:
				case KeysEnum.UP:
				case KeysEnum.DOWN:	
					break;
				default:
					evt.stopPropagation();
					break;
			}
		}
	}
}
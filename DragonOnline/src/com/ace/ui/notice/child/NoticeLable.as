/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-10-21 下午5:43:18
 */
package com.ace.ui.notice.child {
	import com.ace.enum.FilterEnum;
	import com.ace.enum.NoticeEnum;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenMax;
	
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * 提示文本
	 * @author ace
	 *
	 */
	public class NoticeLable extends TextField {
		public function NoticeLable() {
			super();
			this.init();
		}

		private function init():void {
			this.mouseEnabled=false;
//			this.cacheAsBitmap=true;
			this.selectable=false;
			this.autoSize=TextFieldAutoSize.LEFT;
			this.filters=[FilterEnum.hei_miaobian];
		}

		/**
		 * 显示文本
		 * @param notice 消息字符串
		 * @values	消息字符串替换值
		 * @param tf	文本样式
		 * @return 是否有链接事件
		 * <br> var str:String="<FONT  SIZE='21' COLOR='#FFFF00' LETTERSPACING='0' KERNING='0'><b><a href='event:typetext'>con</a></b></FONT>";
		 */
		public function show(notice:String, values:Array, tf:TextFormat=null):Boolean {
			/*{ //调试用
			this..background=true;
			this..backgroundColor=0x11FF00;
			this..border=true;
			}*/
			if (tf)
				this.defaultTextFormat=tf;
			this.htmlText=StringUtil.substitute(notice, values);
			//如果有链接事件
//			if (false) {
//				this.mouseEnabled=false;
//			} else {
//				this.mouseEnabled=true;
//				this.addEvt();
//			}
			return this.mouseEnabled;
		}

		public function clear():void {
			this.htmlText="";
		}

		private function addEvt():void {
			this.addEventListener(TextEvent.LINK, onLinkClick);
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}

		protected function onLinkClick(event:TextEvent):void {
			NoticeManager.getInstance().callBackFun.call(this, NoticeEnum.LINK_TEXT, event);
		}

		private function removeEvt():void {
			this.removeEventListener(TextEvent.LINK, onLinkClick);
			this.removeEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			this.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			this.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}

		//滑过
		protected function mouseOver(e:MouseEvent):void {
		}

		//滑出
		protected function mouseOut(e:MouseEvent):void {
		}

		//点下
		protected function mouseDown(e:MouseEvent):void {
		}

		//弹起
		protected function mouseUp(e:MouseEvent):void {
		}


		public function reset():void {
			this.htmlText="";
			if (this.hasEventListener(TextEvent.LINK)) {
				this.removeEvt();
			}
		}

		public function free():void {
			this.reset();
			this.parent && this.parent.removeChild(this);
			TweenMax.killTweensOf(this);
		}

		public function die():void {

		}
	}
}
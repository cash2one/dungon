/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-10-21 下午6:24:21
 */
package com.ace.ui.notice.message {
	import com.ace.enum.FontEnum;
	import com.ace.enum.NoticeEnum;
	import com.ace.enum.UIEnum;
	import com.ace.tools.SpriteNoEvt;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;

	/**
	 * 游戏上方中央滚动的公告栏
	 * @author ace
	 *
	 */
	public class Message7 extends SpriteNoEvt {
		private var noticeArr:Array;
		private var lbl:Label;
		private var bg:Sprite;
		private var w:Number;
		private var msk:Shape;
		private var times:int;
		private var tick:uint;

		public function Message7() {
			super();
			this.init();
			this.y=NoticeEnum.MESSAGE7_PY;
		}

		private function init():void {
			this.w=600;
			this.noticeArr=new Array();

			this.bg=new Sprite();
			this.bg.graphics.beginFill(0x000000, .5);
			this.bg.graphics.drawRect(0, 0, this.w, 30);
			this.bg.graphics.endFill();
			this.addChildAt(this.bg, 0);

			this.lbl=new Label("", FontEnum.getTextFormat(NoticeEnum.FORMAT_MESSAGE7));
			this.lbl.maxChars=NoticeEnum.MESSAGE6_LENGTH;
			this.addChild(this.lbl);

			this.msk=new Shape();
			this.msk.graphics.beginFill(0x050505, .5);
			this.msk.graphics.drawRect(0, 0, this.w, 30);
			this.msk.graphics.endFill();
			this.addChild(this.msk);
			this.lbl.mask=this.msk;
			this.lbl.x=300;
			this.lbl.y=2;
			this.lbl.visible=false;
			this.bg.visible=false;
			this.resize();
		}

		/**
		 *设置显示信息
		 * @param str  内容
		 * @param link 超链接的内容
		 *
		 */
		public function show(str:String, values:Array):void {
			if (str == null || str == "")
				return;
			str=StringUtil.substitute(str, values);
			str=getStr(str);
			if (this.lbl.hasEventListener(Event.ENTER_FRAME)) {
				this.noticeArr.push(str);
			} else {
				tick = getTimer();
				if (this.bg.hasEventListener(Event.ENTER_FRAME))
					this.bg.removeEventListener(Event.ENTER_FRAME, onBgChange);
				this.lbl.visible=true;
				this.bg.visible=true;
				this.bg.x=0;
				this.bg.width=this.w;
				this.lbl.htmlText=str;
				this.lbl.addEventListener(Event.ENTER_FRAME, onEnterFrameHandle);
				this.times=0;
			}
		}

		private function onEnterFrameHandle(evt:Event):void {
			if (this.lbl.x <= -this.lbl.width) {
				this.times++;
				this.lbl.x=this.bg.width;
				if (this.times >= 3 && this.noticeArr.length <= 0) {
					this.clearMe();
					return;
				} else if (this.noticeArr.length > 0) {
					this.times=0;
					this.lbl.htmlText=this.noticeArr.shift();
				}
			} else {
				var interval:int = getTimer() - tick;
				if(interval > 30){
					tick = getTimer();
					this.lbl.x-=NoticeEnum.MESSAGE7_SPEED;
				}
			}
		}

		private function clearMe():void {
			this.lbl.htmlText="";
			this.lbl.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandle);
			this.lbl.visible=false;
			this.bg.addEventListener(Event.ENTER_FRAME, onBgChange);
		}

		private function onBgChange(evt:Event):void {
			this.bg.x+=25;
			this.bg.width-=50;

			if (this.bg.width <= 0) {
				this.bg.removeEventListener(Event.ENTER_FRAME, onBgChange);
				this.bg.visible=false;
			}
		}

		private function getStr(str:String):String {
//			if (str.length > this.lbl.maxChars)
//				str=str.substring(0, this.lbl.maxChars);
			return str;
		}

		public function resize():void {
			this.x=(UIEnum.WIDTH - 600) / 2;
			this.y=10;
		}

	}
}
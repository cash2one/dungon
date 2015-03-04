/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-10-22 下午12:22:49
 */
package com.ace.ui.notice.message {
	import com.ace.delayCall.DelayCallManager;
	import com.ace.enum.FontEnum;
	import com.ace.enum.NoticeEnum;
	import com.ace.enum.UIEnum;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.ui.notice.child.NoticeRender;

	public class Message2 {
		protected var noticeArr:Array;
		protected var isShowing:Boolean; //是否在放映
		protected var lbl:NoticeRender;
		protected var tfName:String;
		protected var time:int;

		public function Message2() {
			super();
			this.init();
		}

		protected function init():void {
			this.tfName=NoticeEnum.FORMAT_MESSAGE2;
			this.time=NoticeEnum.MESSAGE2_TIME;

			this.noticeArr=[];
			this.lbl=new NoticeRender();
			this.lbl.y=NoticeEnum.MESSAGE2_PY;
			this.lbl.mouseEnabled = false;
			NoticeManager.getInstance().con.addChild(this.lbl);
		}

		public function broadcast(notice:String, values:Array):void {
			this.noticeArr.push(notice);
			this.noticeArr.push(values);
			this.showNext();
		}

		private function showNext():void {
			// 2014.10.13 修改为取消队列 WFH
//			if (this.isShowing || !this.hasNotice()) {
//				return;
//			}
			this.isShowing=true;
			this.lbl.visible=true;
			this.lbl.show(this.noticeArr.shift(), this.noticeArr.shift(), FontEnum.getTextFormat(this.tfName));
			this.lbl.x=(UIEnum.WIDTH - this.lbl.width) >> 1;
			if(DelayCallManager.getInstance().has(this, this.onShowOver)){
				DelayCallManager.getInstance().del(this.onShowOver);
			}
			DelayCallManager.getInstance().add(this, this.onShowOver, "onShowOver", this.time * UIEnum.FRAME);
		}

		public function onShowOver():void {
			this.isShowing=false;
//			if (!this.hasNotice()) {
				this.lbl.clear();
				this.lbl.visible=false;
//				return;
//			}
//			this.showNext();
		}

		public function hasNotice():Boolean {
			return this.noticeArr.length != 0;
		}
		
		public function resize():void{
			this.lbl.x=(UIEnum.WIDTH - this.lbl.width) >> 1;
		}
	}
}
/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-10-21 下午3:30:15
 */
package com.ace.ui.notice.child {
	import com.ace.enum.FontEnum;
	import com.ace.enum.NoticeEnum;
	import com.ace.gameData.table.TNoticeInfo;
	import com.ace.manager.LibManager;
	import com.ace.reuse.ReUseModel;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.img.child.Image;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenMax;
	
	import flash.text.TextFormat;

	public class NoticeImgRender extends ReUseModel {
		internal static var TOTAL_NUM:int=0;


		private var bg:ScaleBitmap;
		private var lbl:NoticeLable;
		private var signImg:Image;
		private var _text:String

		public function NoticeImgRender() {
			super();
			this.init();
			this.useKey=TOTAL_NUM.toString();
			TOTAL_NUM++;
		}

		public function get text():String{
			return _text;
		}

		private function init():void {
			this.bg=new ScaleBitmap(LibManager.getInstance().getImg(FontEnum.getTextScaleInfo("PanelBgOut").imgUrl));
			this.bg.scale9Grid=FontEnum.getTextScaleInfo("PanelBgOut").rect;
			this.bg.alpha=.8;
			this.addChild(this.bg);

			this.lbl=new NoticeLable();
			this.addChild(this.lbl);

			this.signImg=new Image();
			this.addChild(this.signImg);
		}

		private function getColor(info:TNoticeInfo, tf:TextFormat):TextFormat {
			if (info.imgSign == NoticeEnum.MESSAGE4_SIGN_FAIL) {
				this.signImg.updateBmp("ui/other/wrong.png");
				tf.color=NoticeEnum.MESSAGE4_COLOR_FAIL;
			}
			if (info.imgSign == NoticeEnum.MESSAGE4_SIGN_SUCCESS) {
				this.signImg.updateBmp("ui/other/prompt.png");
				tf.color=NoticeEnum.MESSAGE4_COLOR_SUCCESS;
			}
			if (info.imgSign == NoticeEnum.MESSAGE4_SIGN_ALERT) {
				this.signImg.updateBmp("ui/other/warn.png");
				tf.color=NoticeEnum.MESSAGE4_COLOR_ALERT;
			}
			return tf;
		}

		private function updataBg():void {
			if (NoticeEnum.MESSAGE4_SIGN_WIDTH + 20 + this.lbl.width <= NoticeEnum.MESSAGE4_MIN_WIDTH) {
				this.lbl.x=(NoticeEnum.MESSAGE4_MIN_WIDTH - this.lbl.width) >> 1;
				this.bg.setSize(NoticeEnum.MESSAGE4_MIN_WIDTH, NoticeEnum.MESSAGE4_HEIGHT);
			} else {
				var signWidth:int=26;
				//				this.lbl.x=this.signImg.x + NoticeEnum.MESSAGE4_SIGN_WIDTH + 10;
				this.lbl.x=this.signImg.x + NoticeEnum.MESSAGE4_SIGN_WIDTH + 10;
				this.bg.setSize(signWidth + 20 + this.lbl.width, NoticeEnum.MESSAGE4_HEIGHT);
			}
			this.lbl.y=(this.bg.height - this.lbl.height) >> 1;
		}

		public function show(info:TNoticeInfo, values:Array):Boolean {
			this._text = StringUtil.substitute(info.content, values);
			this.lbl.show(info.content, values, this.getColor(info, FontEnum.getTextFormat(NoticeEnum.FORMAT_MESSAGE4)));
			this.updataBg();
			return false;
		}

		override public function free():void {
			super.free();
			this.lbl.reset();
			this.alpha=1;
			this.parent && this.parent.removeChild(this);
			TweenMax.killTweensOf(this);
		}

	}
}

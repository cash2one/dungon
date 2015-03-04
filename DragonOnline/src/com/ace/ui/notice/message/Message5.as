/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-10-23 上午10:27:00
 */
package com.ace.ui.notice.message {
	import com.ace.enum.NoticeEnum;
	import com.ace.enum.UIEnum;
	import com.leyou.utils.FilterUtil;

	public class Message5 extends Message2 {
		public function Message5() {
			super();
		}

		override protected function init():void {
			super.init();
			this.lbl.y=UIEnum.HEIGHT-NoticeEnum.MESSAGE5_PY;
			this.tfName=NoticeEnum.FORMAT_MESSAGE5;
			this.time=NoticeEnum.MESSAGE5_TIME;
			this.lbl.filters = [FilterUtil.NotifyOutterFilter];
		}
		
		public override function resize():void{
			super.resize();
			this.lbl.y=UIEnum.HEIGHT-NoticeEnum.MESSAGE5_PY;
		}
	}
}
/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-10-22 下午2:05:47
 */
package com.ace.ui.notice.message {
	import com.ace.enum.FontEnum;
	import com.ace.enum.NoticeEnum;
	import com.ace.enum.UIEnum;
	import com.ace.gameData.table.TNoticeInfo;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.ui.notice.child.NoticeRender;
	import com.greensock.TweenMax;

	public class Message6 {
		private var noticeArr:Array;
		private var addArr:Vector.<NoticeRender>;
		private var isMoving:Boolean;


		public function Message6() {
			this.init();
		}

		private function init():void {
			this.noticeArr=[];
			this.addArr=new Vector.<NoticeRender>;
		}

		public function broadcast(info:TNoticeInfo, values:Array):void {
			if (this.checkExist())
				return;
			this.noticeArr.push(info);
			this.noticeArr.push(values);
			this.showNext();
		}

		public function showNext():void {
			if (!this.hasNotice() /*|| !this.hasPs()*/ || this.isMoving) {
				return;
			}
			syncPos();
			this.isMoving=true;
			var render:NoticeRender=NoticeManager.getInstance().noticelblReuseDic.getFreeRender() as NoticeRender;
			render.mouseEnabled = false;
			render.show((this.noticeArr.shift() as TNoticeInfo).content, this.noticeArr.shift(), FontEnum.getTextFormat(NoticeEnum.FORMAT_MESSAGE6));
			render.x=(UIEnum.WIDTH - render.width) >> 1;
			render.y=NoticeEnum.MESSAGE6_PY + NoticeEnum.MESSAGE6_GAP_HEIGHT;
			NoticeManager.getInstance().con.addChild(render);
			NoticeManager.getInstance().noticelblReuseDic.addToUse(render);
			this.addArr.push(render);
			TweenMax.to(render, NoticeEnum.MESSAGE6_TIME, {alpha: 1, onComplete: onMoveOver});
			this.adjustPs();

			function onMoveOver():void {
				TweenMax.to(render, 1, {alpha: 0, onComplete: onDisappear});
				function onDisappear():void {
					addArr.splice(addArr.indexOf(render), 1);
					NoticeManager.getInstance().noticelblReuseDic.addToFree(render);
					showNext();
				}
			}
		}

		//调整位置 		问题：显示快的话，会出现重叠，应该动画播放完毕后，直接显示2个或者多个，所以底部出现重叠
		private function adjustPs():void {
			var py:Number;
			for (var i:int=0; i < this.addArr.length; i++) {
				py=this.addArr[i].y - NoticeEnum.MESSAGE6_GAP_HEIGHT;
				if (i == addArr.length - 1) {
					TweenMax.to(addArr[i], 0.5, {y: py, onComplete: onMoveOver});
				} else {
					TweenMax.to(addArr[i], 0.5, {y: py});
				}
//				TweenMax.to(this.addArr[i], 0.5, {y: py, onComplete: onMoveOver});
				function onMoveOver():void {
					isMoving=false;
					showNext();
				}
			}
		}
		
		/**
		 * <T>同步位置,如果没有显示位置清一个</T>
		 * 
		 */		
		private function syncPos():void {
			if(!hasPs()){
				var render:NoticeRender = addArr.shift();
				TweenMax.killTweensOf(render);
				TweenMax.to(render, 0.5, {y:(render.y-render.height), alpha:0, onComplete: onMoveOver});
				function onMoveOver():void{
					render.free();
					NoticeManager.getInstance().noticelblReuseDic.addToFree(render);
				}
			}
		}

		//是否存在
		private function checkExist():Boolean {
			return false;
		}

		//是否有位置
		private function hasPs():Boolean {
			return this.addArr.length < NoticeEnum.MESSAGE6_NUM;
		}

		//是否有信息
		public function hasNotice():Boolean {
			return this.noticeArr.length != 0;
		}
		
		public function resize():void{
			var length:int = addArr.length;
			for(var n:int = 0; n < length; n++){
				var render:NoticeRender = addArr[n];
				render.x=(UIEnum.WIDTH - render.width) >> 1;
				render.y=NoticeEnum.MESSAGE6_PY + NoticeEnum.MESSAGE6_GAP_HEIGHT;
			}
		}
	}
}
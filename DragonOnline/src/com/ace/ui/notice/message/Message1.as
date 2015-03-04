/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-10-22 上午10:12:38
 */

package com.ace.ui.notice.message {
	import com.ace.enum.FontEnum;
	import com.ace.enum.NoticeEnum;
	import com.ace.game.manager.ReuseManager;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.ui.notice.child.NoticeRender;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;

	import flash.geom.Point;


	/**
	 *跟随鼠标移动  1
	 * @author Administrator
	 *
	 */
	public class Message1 {

		private var queue:Vector.<String>=new Vector.<String>();
		private var valuesArr:Array=[];
		private var pointsArr:Array=[];
		private var isShow:Boolean;

		public function Message1() {
			super();
		}

		public function broadcast(notice:String, values:Array):void {
			queue.push(notice);
			valuesArr.push(values);
			pointsArr.push(new Point(NoticeManager.getInstance().con.stage.mouseX, NoticeManager.getInstance().con.stage.mouseY));
			//trace("-----------broadcast isShow = " +isShow)
			if (!isShow) {
				showNext();
			}
		}

		private function showNext():void {
			if (queue.length <= 0) {
				return;
			}
			isShow=true;
			var render:NoticeRender=NoticeManager.getInstance().noticelblReuseDic.getFreeRender() as NoticeRender;
			//			trace(NoticeManager.getInstance().noticelblReuseDic.toString());
			render.show(queue.shift(), valuesArr.shift(), FontEnum.getTextFormat(NoticeEnum.FORMAT_MESSAGE1));
			var p:Point=pointsArr.shift();
			render.x=p.x - (render.width >> 1);
			render.y=p.y;
			//			DebugUtil.addFlag(NoticeManager.getInstance().con.stage.mouseX, NoticeManager.getInstance().con.stage.mouseY, NoticeManager.getInstance().con);
			NoticeManager.getInstance().con.addChild(render);
			NoticeManager.getInstance().noticelblReuseDic.addToUse(render);
			var dy:Number=render.y + NoticeEnum.MESSAGE1_DISTANCE_Y;
//			var nextTick:int = NoticeEnum.MESSAGE1_TIME-1;
			TweenMax.to(render, 0.4, {y: (render.y - render.height - 8), ease: Linear.easeOut, onComplete: onNext});
//			trace("-----------showNext isShow = " +isShow)

			function onNext():void {
//				trace("-----------on next isShow = " +isShow)
				TweenMax.to(render, NoticeEnum.MESSAGE1_TIME - 0.4, {y: dy, ease: Linear.easeOut, onComplete: onMoveOver});
				isShow=false;
				showNext();
//				trace("---------------next  isShow = " +isShow)
			}

			function onMoveOver():void {
				render.free();
				NoticeManager.getInstance().noticelblReuseDic.addToFree(render);
			}
		}

	}
}

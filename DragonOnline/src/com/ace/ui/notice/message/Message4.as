/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-10-22 下午2:05:47
 */
package com.ace.ui.notice.message {
	import com.ace.enum.NoticeEnum;
	import com.ace.enum.UIEnum;
	import com.ace.gameData.table.TNoticeInfo;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.ui.notice.child.NoticeImgRender;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenMax;

	public class Message4 {
		private var noticeArr:Array;
		private var addArr:Vector.<NoticeImgRender>;
		private var isMoving:Boolean;

		public function Message4() {
			init();
		}

		private function init():void {
			noticeArr=[];
			addArr=new Vector.<NoticeImgRender>;
		}

		public function broadcast(info:TNoticeInfo, values:Array):void {
			if (checkExist(StringUtil.substitute(info.content, values))){
				return;
			}
			noticeArr.push(info);
			noticeArr.push(values);
			showNext();
		}

		public function showNext():void {
			if (!hasNotice()/* || !hasPs() */|| isMoving) {
//				trace("show next failure. hasPos=" + hasPs() + ",isMoving=" + isMoving);
				return;
			}
			syncPos();
//			trace("show next succeed. hasPos=" + hasPs() + ",isMoving=" + isMoving);
			var render:NoticeImgRender=NoticeManager.getInstance().noticeImgReuseDic.getFreeRender() as NoticeImgRender;
			render.mouseEnabled = false;
			render.mouseChildren = false;
//			trace("Message4当前数量：" + NoticeManager.getInstance().noticeImgReuseDic.toString());
			render.show(noticeArr.shift(), noticeArr.shift());
			render.x=(UIEnum.WIDTH - render.width) >> 1;
			render.y=UIEnum.HEIGHT - NoticeEnum.MESSAGE4_PY + NoticeEnum.MESSAGE4_GAP_HEIGHT;
			NoticeManager.getInstance().con.addChild(render);
			NoticeManager.getInstance().noticeImgReuseDic.addToUse(render);
			addArr.push(render);
			TweenMax.to(render, NoticeEnum.MESSAGE4_TIME, {alpha: 1, onComplete: onMoveOver});
			adjustPos();

			function onMoveOver():void {
				TweenMax.to(render, 0.4, {alpha: 0, onComplete: onDisappear});
				function onDisappear():void {
//					trace("-------------disappear complete call showNext")
					addArr.splice(addArr.indexOf(render), 1);
					TweenMax.killTweensOf(render);
					render.filters = null;
					NoticeManager.getInstance().noticeImgReuseDic.addToFree(render);
					showNext();
				}
			}
		}
		
		//调整位置 		问题：显示快的话，会出现重叠，应该动画播放完毕后，直接显示2个或者多个，所以底部出现重叠
		/**
		 * <T>位置调整,新出现提示顶上去老的提示</T>
		 * 
		 */		
		private function adjustPos():void {
			isMoving=true;
			var py:Number;
			for (var i:int=0; i < addArr.length; i++) {
				py=addArr[i].y - NoticeEnum.MESSAGE4_GAP_HEIGHT;
				if (i == addArr.length - 1) {
					TweenMax.to(addArr[i], 0.5, {y: py, onComplete: onMoveOver});
				} else {
					TweenMax.to(addArr[i], 0.5, {y: py});
				}
				
				function onMoveOver():void {
//					trace("-------------adjust pos complete call showNext")
					isMoving = false;
					showNext();
				}
			}
		}

		//是否存在
		private function checkExist(msg:String):Boolean {
			var l:int = addArr.length;
			for(var n:int = 0; n < l; n++){
				var render:NoticeImgRender = addArr[n];
				if(render.text == msg){
					var arr:Array = TweenMax.getTweensOf(render);
					if((null == arr[0]) || (null != arr[0] && !arr[0].yoyo)){
						TweenMax.to(render, 1, {glowFilter: {color: 0xfa9611, alpha: 1, blurX: 12, blurY: 12, strength: 2}, yoyo: true, repeat: 1, onComplete:onFlashing, onCompleteParams: [render]});
					}
					return true;
				}
			}
			return false;
		}
		
		private function onFlashing(render:NoticeImgRender):void{
			render.filters = null;
		}
		

		/**
		 * <T>同步位置,如果没有显示位置清一个</T>
		 * 
		 */		
		private function syncPos():void {
			if(!hasPos()){
				var render:NoticeImgRender = addArr.shift();
				TweenMax.killTweensOf(render);
				TweenMax.to(render, 0.5, {y:(render.y-render.height), alpha:0, onComplete: onMoveOver});
				function onMoveOver():void{
					render.free();
					TweenMax.killTweensOf(render);
					render.filters = null;
					NoticeManager.getInstance().noticeImgReuseDic.addToFree(render);
				}
			}
		}
		
		/**
		 * <T>是否有可用的位置</T>
		 * 
		 * @return 有木有
		 * 
		 */		
		private function hasPos():Boolean{
			return addArr.length < NoticeEnum.MESSAGE4_NUM;
		}

		/**
		 * <T>显示队列是否等待显示信息</T>
		 * 
		 * @return 有木有
		 * 
		 */		
		public function hasNotice():Boolean {
			return noticeArr.length != 0;
		}
		
		public function resize():void{
			for(var i:int = 0; i < addArr.length; i++){
				var render:NoticeImgRender = addArr[i];
				render.x = (UIEnum.WIDTH - render.width) >> 1;
			}
		}
	}
}
package com.ace.ui.notice.message
{
	import com.ace.enum.UIEnum;
	import com.ace.gameData.table.TNoticeInfo;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.notice.NoticeManager;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	public class Message11
	{
		private var img:Image;
		
		private var delay:int;
		
		public function Message11(){
			init();
		}
		
		private function init():void{
			img = new Image();
		}
		
		public function broadcast(info:TNoticeInfo, values:Array):void {
			TweenLite.killTweensOf(img);
			var arr:Array = info.content.split("|");
			NoticeManager.getInstance().con.addChild(img);
			img.updateBmp(arr[0]);
			delay = arr[1];
			img.alpha = 0.2;
			img.x = UIEnum.WIDTH*0.5 + 100;
			img.y = UIEnum.HEIGHT*0.5;
			TweenLite.to(img, 0.5, {alpha:1, y:img.y-100, onComplete:onMoveOver, ease:Back.easeOut});
		}
		
		private function onMoveOver():void{
			TweenLite.to(img, delay, {onComplete:onShowOver});
		}
		
		private function onShowOver():void{
			TweenLite.to(img, 0.5, {alpha:0, onComplete:onHideOver});
			function onHideOver():void{
				NoticeManager.getInstance().con.removeChild(img);
			}
		}
		public function resize():void{
			img.x = UIEnum.WIDTH*0.5 + 100;
			img.y = UIEnum.HEIGHT*0.5;
		}
	}
}
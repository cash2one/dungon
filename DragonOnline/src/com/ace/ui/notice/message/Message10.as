package com.ace.ui.notice.message
{
	import com.ace.enum.NoticeEnum;
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TSceneInfo;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.notice.NoticeManager;
	import com.greensock.TweenLite;
	
	public class Message10
	{
		private var img:Image;
		
		public function Message10(){
			init();
		}
		
		private function init():void{
			img = new Image();
			NoticeManager.getInstance().con.addChild(img);
		}
		
		public function broadcast(sceneId:String):void{
			resize();
			TweenLite.killTweensOf(img);
			img.alpha = 0;
			var sceneInfo:TSceneInfo = TableManager.getInstance().getSceneInfo(sceneId);
			img.updateBmp("ui/map_pic/"+sceneInfo.noticeFRes);
			TweenLite.to(img, 2, {alpha:1, onComplete:onShow});
		}
		
		public function onShow():void{
			TweenLite.to(img, 1, {onComplete:onTick});
			function onTick():void{
				TweenLite.to(img, 1, {y:0, alpha:0});
			}
		}
		
		
		public function resize():void{
			img.x = (UIEnum.WIDTH - 390) * .5;
			img.y = /*UIEnum.HEIGHT - */NoticeEnum.MESSAGE10_PY;
		}
	}
}
package com.leyou.ui.duel
{
	import com.ace.enum.UIEnum;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.img.child.Image;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;
	
	public class DuelResultWnd extends AutoWindow
	{
		private var noticeImg:Image;
		
		public function DuelResultWnd(){
			super(new XML());
			init();
		}
		
		private function init():void{
			noticeImg = new Image();
			addChild(noticeImg);
			mouseEnabled = false;
			mouseChildren = false;
			clsBtn.visible = false;
			hideBg();
			noticeImg.x = -358*0.5;
			noticeImg.y = -203*0.5;
		}
		
		public function updateInfo(result:int):void{
			switch(result){
				case 0:
					noticeImg.updateBmp("ui/other/battle_lose.png");
					break;
				case 1:
					noticeImg.updateBmp("ui/other/battle_win.png");
					break;
				case 2:
					noticeImg.updateBmp("ui/other/battle_lose.png");
					break;
			}
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, UIEnum.WND_LAYER_TOP, toCenter);
			resize();
			palyeEffect();
		}
		
		private function palyeEffect():void{
			TweenLite.killTweensOf(this);
			scaleX = 4;
			scaleY = 4;
			TweenLite.to(this, 0.3, {scaleX:1, scaleY:1, ease:Back.easeOut});
		}
		
		public function resize():void{
			x = UIEnum.WIDTH*0.5;
			y = UIEnum.HEIGHT*0.5;
		}
	}
}
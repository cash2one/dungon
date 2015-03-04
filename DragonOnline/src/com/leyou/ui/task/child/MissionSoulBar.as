package com.leyou.ui.task.child {

	import com.ace.enum.PriorityEnum;
	import com.ace.enum.TipEnum;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.PnfUtil;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class MissionSoulBar extends AutoSprite {

		private var progressImg:Image;
		private var progressLbl:Label;

		private var iconImg:Image;
		private var nameImg:Image;

		private var effSwf:SwfLoader;

		private var hallowId:int=-1;

		private var twn:TweenMax;
		
		private var st:Boolean=false;

		public function MissionSoulBar() {
			super(LibManager.getInstance().getXML("config/ui/task/missionSoulBar.xml"));
			this.init();
			this.mouseChildren=true
			this.cacheAsBitmap=true;
		}

		private function init():void {
			this.progressImg=this.getUIbyID("progressImg") as Image;
			this.progressLbl=this.getUIbyID("progressLbl") as Label;

			this.iconImg=this.getUIbyID("iconImg") as Image;
			this.nameImg=this.getUIbyID("nameImg") as Image;

			this.iconImg.y=this.iconImg.y - 2;

			this.effSwf=new SwfLoader(99972);
			this.addChild(this.effSwf);

			this.effSwf.x=this.iconImg.x;
			this.effSwf.y=this.iconImg.y + 1;

			this.addChild(this.iconImg);

			var iconTips:Sprite=new Sprite();
			iconTips.graphics.beginFill(0x000000);
			iconTips.graphics.drawRect(0, 0, 60, 60);
			iconTips.graphics.endFill();

			this.addChild(iconTips);

			iconTips.alpha=0;

			iconTips.x=this.iconImg.x + 2;
			iconTips.y=this.iconImg.y + 2;

			iconTips.addEventListener(MouseEvent.MOUSE_MOVE, onTipsMouseMove);
			iconTips.addEventListener(MouseEvent.MOUSE_OUT, onTipsMouseOut);
		}

		private function onTipsMouseMove(e:MouseEvent):void {
			ToolTipManager.getInstance().show(TipEnum.TYPE_HALLOWS, [this.hallowId, this.progressLbl.text, UIManager.getInstance().taskTrack.taskID], new Point(this.stage.mouseX, this.stage.mouseY));
		}

		private function onTipsMouseOut(e:MouseEvent):void {
			ToolTipManager.getInstance().hide();
		}

		public function updateInfo(_i:int, p:Number,st:Boolean):void {

			this.progressLbl.text="" + int(p * 100) + "%";
			this.progressImg.scaleX=p;
			this.st=st;
			
			if (this.hallowId == _i)
				return;

			this.hallowId=_i;

			this.iconImg.updateBmp("ui/mission/mission_icon" + _i + "_big.png", onComplete, false, -1, -1, PriorityEnum.FIVE);
			this.nameImg.updateBmp("ui/mission/n_mission_" + _i + ".png", null, false, -1, -1, PriorityEnum.FIVE);

		}
		
		/**
		 *圣器完成动画 
		 * 
		 */		
		public function onCompleteHallow():void{
			
			if (st) {
				var sp:Point=this.localToGlobal(new Point(this.iconImg.x, this.iconImg.y));
				var ib:ImgButton=UIManager.getInstance().toolsWnd.playerBtn;
				var ep:Point=UIManager.getInstance().toolsWnd.localToGlobal(new Point(ib.x, ib.y));
				
				var bm:Bitmap=new Bitmap(this.iconImg.bitmapData);
				bm.x=sp.x;
				bm.y=sp.y;
				
				this.stage.addChild(bm);
				
				TweenLite.to(bm, 2, {x: ep.x, y: ep.y,onComplete:complte});
				
				function complte():void{
					stage.removeChild(bm);
				}
			}
			
		}

		private function onComplete(e:Image):void {

			if (this.twn == null) {
				this.twn=TweenMax.to(this.iconImg, .5, {y: this.iconImg.y + 4, yoyo: true, repeat: -1});
			}

		}

		override public function get height():Number {
			return 84;
		}
	}
}

package com.ace.ui.guide {


	import com.ace.enum.GuideEnum;
	import com.ace.gameData.table.TGuideInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.TimeManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.utils.getTimer;

	public class GuidePointTip extends AutoSprite {
		public var type:int;

		protected var pointSwf:SwfLoader;

		protected var desLbl:Label;

		private var tick:uint;

		private var remain:int;

		protected var dis:DisplayObject;

		protected var listenter:Function;

		protected var _linkInfo:TGuideInfo;

		public var check:Boolean;

		private var bgImg:Image;

		public function get guideInfo():TGuideInfo {
			return _linkInfo;
		}

		//		public function set linkId(value:int):void{
		//			_linkId = value;
		//		}

		public function GuidePointTip($url:String, $type:int) {
			super(LibManager.getInstance().getXML($url));
			init($type);
		}

		// swf width = 50 height = 40
		private function init($type:int):void {
			mouseEnabled=false;
			mouseChildren=false;
			desLbl=getUIbyID("desLbl") as Label;
			bgImg=getUIbyID("bgImg") as Image;
			pointSwf=new SwfLoader(99916);
			addChild(pointSwf);
			setType($type);
			desLbl.wordWrap=true;

//			var g:Graphics = graphics;
//			g.beginFill(0xff);
//			g.drawRect(0, 0, width, height);
//			g.beginFill(0xffff);
//			g.drawCircle(0,0,5);
//			g.endFill();
		}

		private function setType($type:int):void {
			type=$type;
			switch (type) {
				case GuideEnum.GUIDE_POINT_LEFT:
					// left
					bgImg.x=50;
					bgImg.y=0;
					pointSwf.rotation=0;
					pointSwf.x=0;
					pointSwf.y=(54 - 40) * 0.5;
					break;
				case GuideEnum.GUIDE_POINT_RIGHT:
					// right
					bgImg.x=0;
					bgImg.y=0;
					pointSwf.rotation=180;
					pointSwf.x=50 + 130;
					pointSwf.y=40 + (54 - 40) * 0.5;
					break;
				case GuideEnum.GUIDE_POINT_UP:
					// up
					bgImg.x=0;
					bgImg.y=50;
					pointSwf.rotation=90;
					pointSwf.x=40 + (130 - 40) * 0.5;
					pointSwf.y=0;
					break;
				case GuideEnum.GUIDE_POINT_DOWN:
					// down
					bgImg.x=0;
					bgImg.y=0;
					pointSwf.rotation=-90;
					pointSwf.x=(130 - 40) * 0.5;
					pointSwf.y=50 + 54;
					break;
			}
		}

		protected function updateDesPostion():void {
			if (desLbl.numLines > 1) {
				desLbl.y=bgImg.y + 5;
			} else {
				desLbl.y=bgImg.y + 14;
			}
			desLbl.x=bgImg.x + 6;
		}


		public function setListenter(fun:Function):void {
			listenter=fun;
		}

		private function setTimer(time:int):void {
			if (time <= 0) {
				return;
			}
			remain=time;
			tick=getTimer();
			if (!TimeManager.getInstance().hasITick(onTick)) {
				TimeManager.getInstance().addITick(1000, onTick);
			}
		}

		protected function onTick():void {
			var inval:int=(getTimer() - tick) / 1000;
			if (inval >= remain) {
				if (TimeManager.getInstance().hasITick(onTick)) {
					TimeManager.getInstance().removeITick(onTick);
				}
				if (null != listenter) {
					listenter.call(this, this);
				}
			}
		}

		public function valid():Boolean {
			if (!check) {
				return true;
			}
			if ((null != dis) && (null != _linkInfo) && (null != parent)) {
				var p:DisplayObject=dis;
				while (p != root) {
					if ((null == p) || !p.visible) {
						return false;
					}
					p=p.parent;
				}
				return true;
			}
			return false;
		}

		public function clear():void {
			listenter=null;
			pointSwf.stop();
			if (null != parent) {
				parent.removeChild(this);
			}
			dis=null;
		}

		public function addToContainer(con:DisplayObjectContainer):Boolean {
			if ((null == dis) || (null == _linkInfo)) {
				return false;
			}
			con.addChild(this);
			var gPt:Point=dis.localToGlobal(new Point(_linkInfo.ox, _linkInfo.oy));
			this.x=gPt.x;
			this.y=gPt.y;
			return true;
		}

		public function resize():void {
			if ((null != dis) && (null != _linkInfo) && (null != parent)) {
				var gPt:Point=dis.localToGlobal(new Point(_linkInfo.ox, _linkInfo.oy));
				this.x=gPt.x;
				this.y=gPt.y;
			}
		}

		public function updateInfo(info:TGuideInfo, $dis:DisplayObject):void {
			if (null == $dis) {
				throw new Error("要指引的显示对象为NULL,指引ID为:" + info.id);
			}
			dis=$dis;
			_linkInfo=info;
			pointSwf.update(99916);
			desLbl.htmlText=info.des;
			setTimer(info.time);
			updateDesPostion();
			//			dis.addChild(this);
			//			this.x = info.ox;
			//			this.y = info.oy;
		}
	}
}

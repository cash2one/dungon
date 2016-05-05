package com.ace.ui.guide {


	import com.ace.enum.GuideEnum;
	import com.ace.gameData.table.TGuideInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.DebugUtil;


	public class GuidePointTipII extends AutoSprite {
		internal const JT_ID:int=99916;
		internal const JT_WIDTH:int=50;
		internal const JT_HEIGHT:int=41;
		internal const BG_WIDTH:int=130;
		internal const BG_HEIGHT:int=55;


		public var tInfo:TGuideInfo;
		private var pointSwf:SwfLoader;
		private var desLbl:Label;
		private var bgImg:Image;


		public function GuidePointTipII() {
			super(LibManager.getInstance().getXML("config/ui/introduction/arrowWnd.xml"));
			this.init();

//			DebugUtil.addFlag(0, 0, this);
		}

		private function init():void {
			desLbl=getUIbyID("desLbl") as Label;
			bgImg=getUIbyID("bgImg") as Image;
			pointSwf=new SwfLoader();
			addChild(pointSwf);
			
//			this.pointSwf.opaqueBackground=0x056CB4;
//			this.bgImg.opaqueBackground=0x056CB4;


			desLbl.wordWrap=true;
		}

		private function updateJt($type:int):void {
			pointSwf.update(JT_ID);
			switch ($type) {
				case GuideEnum.GUIDE_POINT_UP: //↑
					// up
					bgImg.x=-BG_WIDTH / 2;
					bgImg.y=JT_WIDTH;
					pointSwf.rotation=90;
					pointSwf.x=JT_HEIGHT / 2;
					pointSwf.y=0;
					break;
				case GuideEnum.GUIDE_POINT_DOWN: //↓
					// down
					bgImg.x=-BG_WIDTH / 2;
					bgImg.y=-(BG_HEIGHT + JT_WIDTH);
					pointSwf.rotation=-90;
					pointSwf.x=-JT_HEIGHT / 2;
					pointSwf.y=0;
					break;
				case GuideEnum.GUIDE_POINT_LEFT: //←
					// left
					bgImg.x=(JT_WIDTH);
					bgImg.y=-BG_HEIGHT / 2;
					pointSwf.rotation=0;
					pointSwf.x=0;
					pointSwf.y=-JT_HEIGHT / 2;
					break;
				case GuideEnum.GUIDE_POINT_RIGHT: //→
					// right
					bgImg.x=-(BG_WIDTH + JT_WIDTH);
					bgImg.y=-BG_HEIGHT / 2;
					pointSwf.rotation=180;
					pointSwf.x=0
					pointSwf.y=JT_HEIGHT / 2;
					break;
			}
		}

		protected function updateLbl(txt:String):void {
			desLbl.htmlText=txt;
			if (desLbl.numLines > 1) {
				desLbl.y=bgImg.y + 5;
			} else {
				desLbl.y=bgImg.y + 14;
			}
			desLbl.x=bgImg.x + 6;
		}

		public function update(info:TGuideInfo):void {
			this.tInfo=info;
			this.updateJt(info.type);
			this.updateLbl(info.des);
//			this.x=info.ox;
//			this.y=info.oy;
		}

		override public function die():void {
			pointSwf.stop();
			this.x=this.y=0;
			if (null != parent) {
				parent.removeChild(this);
			}
		}
	}
}


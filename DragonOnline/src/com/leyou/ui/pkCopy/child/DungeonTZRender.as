package com.leyou.ui.pkCopy.child {

	import com.ace.gameData.table.TTzActiive;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.FilterUtil;
	
	import flash.events.MouseEvent;

	public class DungeonTZRender extends AutoSprite {

		private var titleImg:Image;
		private var stateImg:Image;
		private var timeLbl:Label;
		private var lvLbl:Label;
		private var bgBtn:ImgButton;

		public var id:int=0;

		public var state:int=0;

		public function DungeonTZRender() {
//			super(LibManager.getInstance().getXML("config/ui/pkCopy/dungeonTZRender.xml"));
			super(LibManager.getInstance().getXML("config/ui/pkCopy/bossTZLable.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {
			this.titleImg=this.getUIbyID("titleImg") as Image;
			this.stateImg=this.getUIbyID("stateImg") as Image;

			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.bgBtn=this.getUIbyID("bgBtn") as ImgButton;
			this.timeLbl=this.getUIbyID("timeLbl") as Label;

		}

		public function updateInfo(o:TTzActiive):void {

			this.titleImg.updateBmp("ui/tz/" + o.nameImage);
			this.lvLbl.text=o.lv + "";
			this.timeLbl.text=o.time.replace("|", "\-").replace(/(\d?\d):(\d\d):(\d\d)/, "$1:$2").replace(/(\d?\d):(\d\d):(\d\d)/, "$1:$2");
			this.id=o.id;
		}

		/**
		 * @param i
		 */
		public function updateState(i:int):void {

			this.state=i;

			switch (i) {
				case 0:
					this.filters=[]
					this.stateImg.updateBmp("ui/tz/icon_wkq.png");
					this.state=0;
					break;
				case 1:
					this.filters=[]
					this.stateImg.updateBmp("ui/tz/icon_jxz.png");
					this.state=-1;
					break;
				case 2:
					this.filters=[FilterUtil.enablefilter]
					this.stateImg.updateBmp("ui/tz/icon_yjs.png");
					this.state=1;
					break;
			}
		}

		public function setHight(v:Boolean):void {
			if (v)
				this.bgBtn.turnOn();
			else
				this.bgBtn.turnOff();
		}

		public function exeClick():void {
			this.bgBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}

		override public function get width():Number {
			return 343;
		}

		override public function get height():Number {
			return 58;
		}

	}
}

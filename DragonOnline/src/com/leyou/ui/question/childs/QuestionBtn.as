package com.leyou.ui.question.childs {

	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.FilterUtil;

	import flash.events.MouseEvent;

	public class QuestionBtn extends AutoSprite {

		private var hightImg:Image;
		private var contentLbl:Label;
		private var rightImg:Image;
		private var cbgImg:Image;

		public var isselect:Boolean=false;

		public function QuestionBtn() {
			super(LibManager.getInstance().getXML("config/ui/question/questionBtn.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.hightImg=this.getUIbyID("hightImg") as Image;
			this.rightImg=this.getUIbyID("rightImg") as Image;
			this.cbgImg=this.getUIbyID("cbgImg") as Image;

			this.contentLbl=this.getUIbyID("contentLbl") as Label;
			this.contentLbl.filters=FilterUtil.blackStrokeFilters;

			this.hightImg.visible=false;

			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
		}

		public function onMouseEvent(e:MouseEvent):void {

			if (e.type == MouseEvent.MOUSE_OVER) {
				this.setHight(true);
			} else if (e.type == MouseEvent.MOUSE_OUT) {
				if (!this.isselect)
					this.setHight(false);
			}
		}

		public function setHight(v:Boolean):void {
			this.hightImg.visible=v;
		}
		
		public function setSelectState(v:Boolean):void {
			this.hightImg.visible=v;
			this.isselect=v;
		}
		

		public function setRight(v:Boolean):void {
			this.rightImg.visible=v;
		}

		public function setBgImg(i:int=0):void {
			if (i == 1) {
				this.cbgImg.updateBmp("ui/question/dati_da_lan.png");
			} else {
				this.cbgImg.updateBmp("ui/question/dati_da_hong.png");
			}
		}

		public function setState(v:Boolean):void {
			if (v)
				this.rightImg.updateBmp("ui/question/icon_dui.png");
			else
				this.rightImg.updateBmp("ui/question/icon_cuo.png");
		}

		public function setContent(s:String):void {
			this.contentLbl.text="" + s;
		}

	}
}

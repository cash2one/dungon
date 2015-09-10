package com.leyou.ui.ttt.childs {
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;

	public class TttSmallBtn extends AutoSprite {

		private var bgBtn:ImgButton;
		private var lvLbl:Label;
		private var succImg:Image;
		private var lockImg:Image;

		public function TttSmallBtn() {
			super(LibManager.getInstance().getXML("config/ui/ttt/tttSmallBtn.xml"));
			this.init();
			this.mouseChildren=false;
			this.mouseEnabled=false;
		}

		private function init():void {

			this.bgBtn=this.getUIbyID("bgBtn") as ImgButton;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.succImg=this.getUIbyID("succImg") as Image;
			this.lockImg=this.getUIbyID("lockImg") as Image;

		}

		public function updateInfo(o:Object):void {
			this.lvLbl.text="" + o.lv;

			this.succImg.visible=(o.st==1);
			this.lockImg.visible=(o.st==-1);

//			this.bgBtn.turnOff();
		}

		public function get lv():int {
			return int(this.lvLbl.text);
		}

		override public function get height():Number {
			return 99;
		}

	}
}

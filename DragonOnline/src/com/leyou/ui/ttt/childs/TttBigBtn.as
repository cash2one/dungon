package com.leyou.ui.ttt.childs {

	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;

	public class TttBigBtn extends AutoSprite {

		private var bgBtn:ImgButton;
		private var lvLbl:Label;
		private var succImg:Image;


		public function TttBigBtn() {
			super(LibManager.getInstance().getXML("config/ui/ttt/tttBigBtn.xml"));
			this.init();
			this.mouseChildren=false;
			this.mouseEnabled=false;
		}

		private function init():void {

			this.bgBtn=this.getUIbyID("bgBtn") as ImgButton;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.succImg=this.getUIbyID("succImg") as Image;
		}
		
		public function updateInfo(o:Object):void{
			this.lvLbl.text=""+o.lv;
			this.succImg.visible=(o.st==1);
			
//			this.bgBtn.turnOn();
		}
		
		public function set select(v:Boolean):void {
			if (v)
				this.bgBtn.turnOn();
			else
				this.bgBtn.turnOff();
		}

		override public function get height():Number{
			return 153;
		}

		public function get lv():int {
			return int(this.lvLbl.text);
		}

	}
}

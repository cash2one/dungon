package com.leyou.ui.ttt.childs {


	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;

	public class TttTitleBtn extends AutoSprite {

		private var lvLbl:Label;
		private var bgBtn:ImgButton;


		public function TttTitleBtn() {
			super(LibManager.getInstance().getXML("config/ui/ttt/tttTitleBtn.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.bgBtn=this.getUIbyID("bgBtn") as ImgButton;

		}

		public function setLvTxt(s:String):void {
			this.lvLbl.text="" + s;
		}

		public function set select(v:Boolean):void {
			if (v)
				this.bgBtn.turnOn();
			else
				this.bgBtn.turnOff();
		}

	}
}

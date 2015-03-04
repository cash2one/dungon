package com.leyou.ui.question.childs {
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;

	public class QuestionQBtn extends AutoSprite {

		private var quitBtn:ImgButton;

		public function QuestionQBtn() {
			super(LibManager.getInstance().getXML("config/ui/question/questionQBtn.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {
			this.quitBtn=this.getUIbyID("quitBtn") as ImgButton;
		}


	}
}

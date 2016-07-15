package com.leyou.ui.redpackage.child {
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.PropUtils;

	public class PackageLable2 extends AutoSprite {

		private var nameLbl:Label;
		private var timeLbl:Label;
		private var countLbl:Label;
		private var bgBtn1:Image;

		public function PackageLable2() {
			super(LibManager.getInstance().getXML("config/ui/package/child/packageLable2.xml"));
			this.init();
		}

		private function init():void {

			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.timeLbl=this.getUIbyID("timeLbl") as Label;
			this.countLbl=this.getUIbyID("countLbl") as Label;
			this.bgBtn1=this.getUIbyID("bgBtn1") as Image;

		}


		public function updateInfo(o:Object, mm:Boolean=false):void {

			this.bgBtn1.visible=mm;

			this.nameLbl.text="" + o[1];
			this.timeLbl.text="" + String(o[2]).substr(5, 11);
			this.countLbl.text="" + o[0] + PropUtils.getStringById(40);

		}


	}
}

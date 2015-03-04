package com.leyou.ui.tips {
	
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.lable.Label;

	public class TitleTips extends AutoWindow {

		private var bgsc:ScaleBitmap;
		private var nameLbl:Label;
		private var openLbl:Label;
		private var timeLbl:Label;

		private var tipsInfo:Object;
		
		public function TitleTips() {
			super(LibManager.getInstance().getXML("config/ui/tips/TitleTips.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}
		
		private function init():void{
			
			this.bgsc=this.getUIbyID("bgsc") as ScaleBitmap;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.openLbl=this.getUIbyID("openLbl") as Label;
			this.timeLbl=this.getUIbyID("timeLbl") as Label;
			
			
		}
		
		public function showPane(tips:Object):void {
			this.show();
			this.tipsInfo=tips;
			this.updateInfo();
		}

		private function updateInfo():void{
			
			
			
		}


	}
}

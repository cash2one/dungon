package com.leyou.ui.offline {
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;

	import flash.events.MouseEvent;

	public class OffLineWnd extends AutoWindow {


		private var progressSc:ScaleBitmap;
		private var hpLbl:Label;
		private var zqLbl:Label;
		private var timeLbl:Label;
		private var get1Btn:NormalButton;
		private var get2Btn:NormalButton;
		private var noticeLbl:Label;


		public function OffLineWnd() {
			super(LibManager.getInstance().getXML("config/ui/OffLineWnd.xml"));
			this.init();
		}

		private function init():void {

			this.progressSc=this.getUIbyID("progressSc") as ScaleBitmap;
			this.hpLbl=this.getUIbyID("hpLbl") as Label;
			this.zqLbl=this.getUIbyID("zqLbl") as Label;
			this.timeLbl=this.getUIbyID("timeLbl") as Label;
			this.get1Btn=this.getUIbyID("get1Btn") as NormalButton;
			this.get2Btn=this.getUIbyID("get2Btn") as NormalButton;
			this.noticeLbl=this.getUIbyID("noticeLbl") as Label;

			this.get1Btn.addEventListener(MouseEvent.CLICK, onClick);
			this.get2Btn.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "get1Btn":
					break;
				case "get2Btn":
					break;
			}

		}

		public function updateInfo(info:Object):void {
			this.hpLbl.text="";
			this.zqLbl.text="";
			this.timeLbl.text="";
			this.noticeLbl.text="";
		}



	}
}

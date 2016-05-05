package com.leyou.ui.v3exp {

	import com.ace.enum.WindowEnum;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	
	import flash.events.MouseEvent;

	public class SellExpWnd3 extends AutoSprite {


		private var nowToBtn:NormalButton

		public function SellExpWnd3() {
			super(LibManager.getInstance().getXML("config/ui/v3exp/sellExpWnd3.xml"));
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {
			this.nowToBtn=this.getUIbyID("nowToBtn") as NormalButton;
			this.nowToBtn.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(e:MouseEvent):void {
			UILayoutManager.getInstance().open(WindowEnum.BLACK_STROE);
		}

	}
}

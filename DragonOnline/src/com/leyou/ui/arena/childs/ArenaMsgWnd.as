package com.leyou.ui.arena.childs {
	import com.ace.config.Core;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.leyou.net.cmd.Cmd_Arena;

	import flash.events.MouseEvent;

	public class ArenaMsgWnd extends AutoWindow {
		public static var Time:String;

		private var gotoBtn:NormalButton;

		private var cancelBtn:NormalButton;

		private var desLbl:Label;


		public function ArenaMsgWnd() {
			super(LibManager.getInstance().getXML("config/ui/arena/arenaMegWnd.xml"));
			init();
		}

		private function init():void {
			hideBg();
			gotoBtn=getUIbyID("gotoBtn") as NormalButton;
			cancelBtn=getUIbyID("cancelBtn") as NormalButton;
			desLbl=getUIbyID("desLbl") as Label;
			desLbl.wordWrap=true;
			desLbl.multiline=true;
			desLbl.width=267;
			desLbl.height=134;
			
			gotoBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			cancelBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
//			clsBtn.x -= 6;
//			clsBtn.y -= 14;
		}

		protected function onButtonClick(event:MouseEvent):void {
			var btnName:String=event.target.name;
			switch (btnName) {
				case "gotoBtn":
//					UILayoutManager.getInstance().show(WindowEnum.ARENA);
					Cmd_Arena.cm_ArenaRevenge(Time);
					hide();
					break;
				case "cancelBtn":
					hide();
					break;
			}
		}

		public function updateInfo(text:String, succes:Boolean):void {
			desLbl.htmlText=text;
			gotoBtn.setActive(!succes, 1, true);
		}
	}
}

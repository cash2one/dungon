package com.leyou.ui.tools.child
{
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.input.children.TextInput;
	import com.leyou.net.cmd.Cmd_Welfare;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class CDKeyReceiveWnd extends AutoWindow
	{
		private var keyTexInput:TextInput;
		private var confirmBtn:NormalButton;
		private var cancelBtn:NormalButton;
		public function CDKeyReceiveWnd(){
			super(LibManager.getInstance().getXML("config/ui/messageInputWnd.xml"));
			init();
		}
		
		private function init():void{
			hideBg();
			keyTexInput = getUIbyID("keyTextInput") as TextInput;
			confirmBtn = getUIbyID("confirmBtn") as NormalButton;
			cancelBtn = getUIbyID("cancelBtn") as NormalButton;
			confirmBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
			cancelBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
//			clsBtn.x -= 6;
//			clsBtn.y -= 14;
		}
		
		protected function onButtonClick(event:Event):void{
			switch(event.target.name){
				case "confirmBtn":
					hide();
					Cmd_Welfare.cm_CDK_J(keyTexInput.text);
					break;
				case "cancelBtn":
					hide();
					break;
			}
		}
	}
}
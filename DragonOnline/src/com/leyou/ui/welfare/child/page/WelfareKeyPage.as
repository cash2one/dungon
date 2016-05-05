package com.leyou.ui.welfare.child.page
{
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.input.children.TextInput;
	import com.leyou.net.cmd.Cmd_Welfare;
	
	import flash.events.MouseEvent;
	
	public class WelfareKeyPage extends AutoSprite
	{
		private var keyTexInput:TextInput;
		
		private var receiveBtn:ImgButton;
		
		public function WelfareKeyPage(){
			super(LibManager.getInstance().getXML("config/ui/welfare/welfareKey.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			keyTexInput = getUIbyID("keyTexInput") as TextInput;
			receiveBtn = getUIbyID("receiveBtn") as ImgButton;
			receiveBtn.addEventListener(MouseEvent.CLICK, onButtonClick);
		}
		
		protected function onButtonClick(event:MouseEvent):void{
			Cmd_Welfare.cm_CDK_J(keyTexInput.text);
		}
	}
}
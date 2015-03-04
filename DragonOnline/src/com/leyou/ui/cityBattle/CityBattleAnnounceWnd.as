package com.leyou.ui.cityBattle
{
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.input.children.TextInput;
	import com.leyou.net.cmd.Cmd_WARC;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class CityBattleAnnounceWnd extends AutoWindow
	{
		private var announceText:TextInput;
		
		private var confirmBtn:NormalButton;
		
		private var cancelBtn:NormalButton;
		
		public function CityBattleAnnounceWnd(){
			super(LibManager.getInstance().getXML("config/ui/cityBattle/warCityAnnounce.xml"));
			init();
		}
		
		private function init():void{
			clsBtn.x -= 6;
			clsBtn.y -= 14;
			
			announceText = getUIbyID("announceText") as TextInput;
			announceText.input.maxChars = 150;
			announceText.input.multiline = true;
			announceText.input.wordWrap = true;
			confirmBtn = getUIbyID("confirmBtn") as NormalButton;
			cancelBtn = getUIbyID("cancelBtn") as NormalButton;
			confirmBtn.addEventListener(MouseEvent.CLICK, onBtnCLick);
			cancelBtn.addEventListener(MouseEvent.CLICK, onBtnCLick);
			announceText.input.addEventListener(Event.CHANGE, onTextChage);
		}
		
		protected function onTextChage(event:Event):void{
			var txt:String = announceText.text;
			if(announceText.input.numLines > 5){
				var reText:String = "";
				for(var n:int = 0; n < 5; n++){
					reText += announceText.input.getLineText(n);
				}
				announceText.text = reText;
			}
		}
		
		protected function onBtnCLick(event:MouseEvent):void{
			switch(event.target.name){
				case "confirmBtn":
					var text:String = announceText.text;
					Cmd_WARC.cm_WARC_N(text);
					hide();
					break;
				case "cancelBtn":
					hide();
					break;
			}
		}
	}
}
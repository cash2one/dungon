package com.leyou.ui.firstlogin
{
	import com.ace.delayCall.DelayCallManager;
	import com.ace.enum.EventEnum;
	import com.ace.enum.UIEnum;
	import com.ace.manager.EventManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.leyou.enum.ConfigEnum;
	
	import flash.events.MouseEvent;
	
	public class FirstLoginWnd extends AutoWindow
	{
		public function FirstLoginWnd(){
			super(LibManager.getInstance().getXML("config/ui/introduction/firstWnd.xml"));
			init()
		}
		
		private function init():void{
			hideBg();
			clsBtn.visible = false;
			addEventListener(MouseEvent.CLICK, mouseClickHandler);
		}
		
		protected function mouseClickHandler(event:MouseEvent):void{
			hide();
		}
		
		public override function hide():void{
			super.hide();
			EventManager.getInstance().dispatchEvent(EventEnum.FIRST_LOGIN_CLICK);
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(true, $layer, toCenter);
			DelayCallManager.getInstance().add(this, hide, "firstLogin", ConfigEnum.autoTask * UIEnum.FRAME);
		}
	}
}
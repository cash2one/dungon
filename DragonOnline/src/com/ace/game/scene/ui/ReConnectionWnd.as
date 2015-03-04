package com.ace.game.scene.ui {
	import com.ace.enum.UIEnum;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.utils.getTimer;

	public class ReConnectionWnd extends AutoWindow {
		private static var instance:ReConnectionWnd;

		public static function getInstance():ReConnectionWnd {
			if (null == instance) {
				instance=new ReConnectionWnd();
			}
			return instance;
		}
		private var contentLbl:Label;

		private var confirmBtn:NormalButton;

		private var tick:int;

		public function ReConnectionWnd() {
			super(LibManager.getInstance().getXML("config/ui/messageCnWnd.xml"));
			init();
		}

		private function init():void {
			LayerManager.getInstance().windowLayer.addChild(this);
			contentLbl=getUIbyID("contentLbl") as Label;
			confirmBtn=getUIbyID("confirmBtn") as NormalButton;
			confirmBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			hideBg();
			clsBtn.visible = false;
		}

		override public function show(toTop:Boolean=true, $layer:int=UIEnum.WND_LAYER_NORMAL, toCenter:Boolean=true):void {
			super.show(toTop, UIEnum.WND_LAYER_TOP, toCenter); //显示在顶层
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			tick=getTimer();
		}

		protected function onEnterFrame(event:Event):void {
			var interval:int=getTimer() - tick;
			if (interval >= 60000) {
				refresh();
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			var remainT:int=(60000 - interval) / 1000;
			confirmBtn.text="重连(" + remainT + ")";
		}

		protected function onBtnClick(event:MouseEvent):void {
			refresh();
		}

		protected function refresh():void {
//			if(hasEventListener(Event.ENTER_FRAME)){
//				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
//			}
			if("StandAlone" != Capabilities.playerType){
				ExternalInterface.call("location.reload()");
			}else{
				System.exit(0);
			}
		}
	}
}

package com.ace.game.scene.ui {
	import com.ace.config.Core;
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.leyou.utils.PropUtils;

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
			clsBtn.visible=false;
		}

		override public function show(toTop:Boolean=true, $layer:int=UIEnum.WND_LAYER_NORMAL, toCenter:Boolean=true):void {
			super.show(toTop, UIEnum.WND_LAYER_TOP, toCenter); //显示在顶层
			var cid:int=(Core.IS_RE_LOGIN ? 10015 : 9957);
			var content:String=TableManager.getInstance().getSystemNotice(cid).content;
			contentLbl.htmlText=content;
			if (Core.IS_RE_LOGIN) {
				if (hasEventListener(Event.ENTER_FRAME)) {
					removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
				confirmBtn.text=PropUtils.getStringById(1518);
			} else {
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
				tick=getTimer();
			}
		}

		protected function onEnterFrame(event:Event):void {
			var interval:int=getTimer() - tick;
			if (interval >= 60000) {
				refresh();
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			var remainT:int=(60000 - interval) / 1000;
			confirmBtn.text=PropUtils.getStringById(1518) + "(" + remainT + ")";
		}

		protected function onBtnClick(event:MouseEvent):void {
			refresh();
		}

		protected function refresh():void {
//			if(hasEventListener(Event.ENTER_FRAME)){
//				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
//			}
			if ("StandAlone" != Capabilities.playerType) {
				ExternalInterface.call("location.reload()");
			} else {
				System.exit(0);
			}
		}
	}
}

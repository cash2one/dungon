package com.ace.game.scene.ui {
	import com.ace.enum.EventEnum;
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.EventManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;

	import flash.display.Stage3D;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.system.SecurityPanel;

	public class SettingPanelWnd extends AutoWindow {
		private static var instance:SettingPanelWnd;

		public static function getInstance():SettingPanelWnd {
			if (null == instance) {
				instance=new SettingPanelWnd();
			}
			return instance;
		}

		private var desImg:Image;

		private var pointSwf:SwfLoader;

		private var desLbl:Label;

		private var confirmBtn:NormalButton;

		private var cancelBtn:NormalButton;

		public function SettingPanelWnd() {
			super(LibManager.getInstance().getXML("config/ui/messageStWnd.xml"));
			init();
		}

		private function init():void {
			LayerManager.getInstance().windowLayer.addChild(this);
			focusRect=false;
			hide();
			hideBg();
			clsBtn.visible=false;

			desLbl=getUIbyID("desLbl") as Label;
			desImg=getUIbyID("desImg") as Image;
			pointSwf=getUIbyID("pointSwf") as SwfLoader;
			cancelBtn=getUIbyID("cancelBtn") as NormalButton;
			confirmBtn=getUIbyID("confirmBtn") as NormalButton;
			cancelBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			confirmBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
		}

		protected function onBtnClick(event:MouseEvent):void {
			switch (event.target.name) {
				case "confirmBtn":
					ExternalInterface.call("location.reload()");
					break;
				case "cancelBtn":
					close();
					EventManager.getInstance().dispatchEvent(EventEnum.FLASH_SETTING_OVER);
					break;
			}

		}

		override public function show(toTop:Boolean=true, $layer:int=UIEnum.WND_LAYER_NORMAL, toCenter:Boolean=true):void {
			super.show(toTop, UIEnum.WND_LAYER_TOP, toCenter); //显示在顶层
		}

		protected function focusHandle(event:FocusEvent):void {
			switch (event.type) {
				case FocusEvent.FOCUS_IN:
					desImg.visible=false;
					pointSwf.visible=false;
					break;
				case FocusEvent.FOCUS_OUT:
					break;
			}
			removeEventListener(FocusEvent.FOCUS_IN, focusHandle);
		}

		public function checkSetting():void {
			stage.focus=this;
			var stage3D:Stage3D=stage.stage3Ds[0];
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, context3DHandler);
			stage3D.requestContext3D();
		}

		protected function context3DHandler(event:Event):void {
			var s3d:Stage3D=event.target as Stage3D;
			if (s3d.context3D.driverInfo == "Software Hw_disabled=userDisabled") {
				show();
				addEventListener(FocusEvent.FOCUS_IN, focusHandle, false, 0, true);
//				addEventListener(FocusEvent.FOCUS_OUT, focusHandle);
				Security.showSettings(SecurityPanel.DISPLAY);
			} else {
				EventManager.getInstance().dispatchEvent(EventEnum.FLASH_SETTING_OVER);
			}
			// 已开启并且是初始状态
//			s3d.context3D && s3d.context3D.dispose();
		}
	}
}

/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-8-26 下午5:09:04
 */
package com.ace.game.manager {
	import com.ace.config.Core;
	import com.ace.enum.EventEnum;
	import com.ace.game.manager.child.SceneKeyManagerModel;
	import com.ace.game.proxy.ModuleProxy;
	import com.ace.manager.EventManager;
	import com.ace.manager.KeysManager;
	import com.ace.manager.MouseManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.setting.AssistWnd;
	import com.ace.utils.DebugUtil;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.ui.Keyboard;

	/**
	 * 场景键盘管理类
	 * @author ace
	 *
	 */
	public class SceneKeyManager extends SceneKeyManagerModel {
		private static var instance:SceneKeyManager;

		public static function getInstance():SceneKeyManager {
			if (!instance)
				instance=new SceneKeyManager();
			return instance;
		}


		public function SceneKeyManager() {

		}

		override public function setup():void {
			super.setup();
			var arr:Array=[Keyboard.NUMBER_1, Keyboard.NUMBER_2, Keyboard.NUMBER_3, Keyboard.NUMBER_4, //
				Keyboard.Q, Keyboard.W, Keyboard.E,Keyboard.NUMBER_8];


			for (var i:int=0; i < arr.length; i++) {
				KeysManager.getInstance().addKeyFun(arr[i], onShorCutDown, KeyboardEvent.KEY_DOWN);
				KeysManager.getInstance().addKeyFun(arr[i], onShorCutDown, KeyboardEvent.KEY_UP);
			}

			KeysManager.getInstance().addKeyFun(Keyboard.A, onAutoMonster);
			EventManager.getInstance().addEvent(EventEnum.SETTING_STOP_AUTO, this.onAutoMonster);
			MouseManager.getInstance().addFun(MouseEvent.RIGHT_MOUSE_DOWN, onRightClick);
			MouseManager.getInstance().addFun(MouseEvent.RIGHT_MOUSE_UP, onRightClick);

//			KeysManager.getInstance().addKeyFun(Keyboard.I, OnTest);

			if (ExternalInterface.available) {
				ExternalInterface.addCallback("sendToActionScript", quitGame);
			}
		}

		private function OnTest(evt:KeyboardEvent):void {
//			trace("当前锁定状态:", Core.me.info.isActLocked);
		}

		public function sceneInput(enable:Boolean):void {
			if (enable) {
				KeysManager.getInstance().restart();
				SceneMouseManager.getInstance().restart();
			} else {
				KeysManager.getInstance().pause(this.inputEnableTip);
				SceneMouseManager.getInstance().pause(this.inputEnableTip);
			}
		}

		private function inputEnableTip():void {
			ModuleProxy.broadcastMsg(4719);
		}

		private function onAutoMonster():void {
			AssistWnd.getInstance().onButtonClick(null);
		}

		public function quitGame():void {
//			Cmd_Scene.cm_quit();
			DebugUtil.closePlayer();
		}


		private function onRightClick(evt:MouseEvent):void {
			if (evt.type == MouseEvent.RIGHT_MOUSE_DOWN) {
				KeysManager.getInstance().disPatchEvent(Keyboard.NUMBER_8, KeyboardEvent.KEY_DOWN);
			} else if (evt.type == MouseEvent.RIGHT_MOUSE_UP) {
				KeysManager.getInstance().disPatchEvent(Keyboard.NUMBER_8, KeyboardEvent.KEY_UP);
			}
		}
 
//			1		命中特效
//			2		子弹+命中特效
//			108		施法者自身特效+命中特效
//			116		场景特效+命中特效

//		private var tmpSkills:Array=[1, 2, 108, 116, 302, 304, 308];
//		private var tmpSkills:Array=[2, 302, 1, 116, 108, 308, 106, 116, 120];

		private var isDownArr:Object={};

		private function onShorCutDown(evt:KeyboardEvent):void {

			var num:String=String.fromCharCode(evt.keyCode);

			if (evt.type == KeyboardEvent.KEY_DOWN) {

				if (this.isDownArr[evt.keyCode])
					return;

				this.isDownArr[evt.keyCode]=true;

				if ((Keyboard.NUMBER_1 <= evt.keyCode && evt.keyCode <= Keyboard.NUMBER_5) || evt.keyCode == Keyboard.NUMBER_8) {
					UIManager.getInstance().toolsWnd.useGrid(num, true);
				} else if (Keyboard.Q == evt.keyCode || Keyboard.W == evt.keyCode || Keyboard.E == evt.keyCode) {
					UIManager.getInstance().toolsWnd.useGrid(num, true);
				}

			} else {

				if (!this.isDownArr[evt.keyCode])
					return;

				this.isDownArr[evt.keyCode]=false;

				var skillId:int=-1;

				if ((Keyboard.NUMBER_1 <= evt.keyCode && evt.keyCode <= Keyboard.NUMBER_5) || evt.keyCode == Keyboard.NUMBER_8) {
					skillId=UIManager.getInstance().toolsWnd.useGrid(num);
				} else if (Keyboard.Q == evt.keyCode || Keyboard.W == evt.keyCode || Keyboard.E == evt.keyCode) {
					skillId=UIManager.getInstance().toolsWnd.useGrid(num);
				}

				//技能：条件满足
				if (skillId != -1 /*&& MagicUtil.conditionIsSatisfied(skillId)*/) {
					SceneMouseManager.getInstance().clearKeepLDown();
					Core.me.recordMagic(skillId);
				}
			}
		}


	}
}

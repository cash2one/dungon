package com.ace.ui.setting.child {
	import com.ace.enum.EventEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.SettingManager;
	import com.ace.gameData.setting.AssistInfo;
	import com.ace.manager.EventManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.event.ButtonEvent;

	import flash.events.Event;
	import flash.events.MouseEvent;

	public class AssistViewConfigWnd extends AutoSprite {
		private var allChk:CheckBox;
		private var otherChk:CheckBox;
		private var monsterChk:CheckBox;
		private var skillChk:CheckBox;
		private var sceneChk:CheckBox;
		private var guildChk:CheckBox;
		private var titleChk:CheckBox;
		private var shakeChk:CheckBox;
		private var petChk:CheckBox;

		public function AssistViewConfigWnd() {
			super(LibManager.getInstance().getXML("config/ui/setting/viewWnd.xml"));
			init();
		}

		private function init():void {
			mouseEnabled=true;
			mouseChildren=true;
			allChk=getUIbyID("allChk") as CheckBox;
			otherChk=getUIbyID("otherChk") as CheckBox;
			monsterChk=getUIbyID("monsterChk") as CheckBox;
			skillChk=getUIbyID("skillChk") as CheckBox;
			sceneChk=getUIbyID("sceneChk") as CheckBox;
			guildChk=getUIbyID("guildChk") as CheckBox;
			titleChk=getUIbyID("titleChk") as CheckBox;
			shakeChk=getUIbyID("shakeChk") as CheckBox;
			petChk=getUIbyID("petChk") as CheckBox;

			allChk.addEventListener(ButtonEvent.Switch_Change, onCheckBoxClick);
			otherChk.addEventListener(ButtonEvent.Switch_Change, onCheckBoxClick);
			monsterChk.addEventListener(ButtonEvent.Switch_Change, onCheckBoxClick);
			skillChk.addEventListener(ButtonEvent.Switch_Change, onCheckBoxClick);
			sceneChk.addEventListener(ButtonEvent.Switch_Change, onCheckBoxClick);
			guildChk.addEventListener(ButtonEvent.Switch_Change, onCheckBoxClick);
			titleChk.addEventListener(ButtonEvent.Switch_Change, onCheckBoxClick);
			shakeChk.addEventListener(ButtonEvent.Switch_Change, onCheckBoxClick);
			petChk.addEventListener(ButtonEvent.Switch_Change, onCheckBoxClick);

			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}


		protected function onMouseOut(event:MouseEvent):void {
			if (!event.relatedObject || !contains(event.relatedObject)) {
				hide();
			}
		}

		public override function hide():void {
			super.hide();
			DataManager.getInstance().saveCookieData();
		}

		/**
		 * <T>获取配置信息对象</T>
		 *
		 * @return 信息对象
		 *
		 */
		public function get info():AssistInfo {
			return SettingManager.getInstance().assitInfo;
		}

		protected function onCheckBoxClick(event:Event):void {
			var n:String=event.target.name;
			switch (n) {
				case "allChk":
					allChk.isOn ? otherChk.turnOn() : otherChk.turnOff();
					allChk.isOn ? monsterChk.turnOn() : monsterChk.turnOff();
					allChk.isOn ? skillChk.turnOn() : skillChk.turnOff();
					allChk.isOn ? sceneChk.turnOn() : sceneChk.turnOff();
					allChk.isOn ? guildChk.turnOn() : guildChk.turnOff();
					allChk.isOn ? titleChk.turnOn() : titleChk.turnOff();
					allChk.isOn ? shakeChk.turnOn() : shakeChk.turnOff();
					allChk.isOn ? petChk.turnOn() : petChk.turnOff();
					info.isHideAll=allChk.isOn;
					break;
				case "otherChk":
					if (!otherChk.isOn)
						allChk.turnOff(false);
					info.isHideOther=this.otherChk.isOn;
					EventManager.getInstance().dispatchEvent(EventEnum.SETTING_HIDE_OTHER);
					break;
				case "monsterChk":
					if (!monsterChk.isOn)
						allChk.turnOff(false);
					info.isHideMonster=this.monsterChk.isOn;
					EventManager.getInstance().dispatchEvent(EventEnum.SETTING_HIDE_MONSTER);
					break;
				case "guildChk":
					if (!guildChk.isOn)
						guildChk.turnOff(false);
					info.isHideGuid=this.guildChk.isOn;
					EventManager.getInstance().dispatchEvent(EventEnum.SETTING_HIDE_OTHER);
					break;
				case "titleChk":
					if (!titleChk.isOn)
						titleChk.turnOff(false);
					info.isHideTitle=this.titleChk.isOn;
					EventManager.getInstance().dispatchEvent(EventEnum.SETTING_HIDE_OTHER);
					break;
				case "skillChk":
					if (!skillChk.isOn)
						allChk.turnOff(false);
					info.isHideSkill=this.skillChk.isOn;
					break;
				case "sceneChk":
					if (!sceneChk.isOn)
						allChk.turnOff(false);
					info.isHideScene=this.sceneChk.isOn;
					break;
				case "shakeChk":
					if (!shakeChk.isOn)
						allChk.turnOff(false);
					info.isHideShake=this.shakeChk.isOn;
					break;
				case "petChk":
					if (!petChk.isOn)
						allChk.turnOff(false);
					info.isHidePet=this.petChk.isOn;
					trace("是否隐藏佣兵：",info.isHidePet);
					EventManager.getInstance().dispatchEvent(EventEnum.SETTING_HIDE_RACE, {race: PlayerEnum.RACE_PET, visible: info.isHidePet});
					break;
			}
			if (otherChk.isOn && monsterChk.isOn && skillChk.isOn && sceneChk.isOn) {
				allChk.turnOn(false);
			}
			UIManager.getInstance().smallMapWnd.setView(allChk.isOn);
			SettingManager.getInstance().assitInfo.setCookie();
		}

		public function loadSetting():void {
			info.isHideOther ? otherChk.turnOn(false) : otherChk.turnOff(false);
			info.isHideMonster ? monsterChk.turnOn(false) : monsterChk.turnOff(false);
			info.isHideSkill ? skillChk.turnOn(false) : skillChk.turnOff(false);
			info.isHideScene ? sceneChk.turnOn(false) : sceneChk.turnOff(false);
			info.isHideAll ? allChk.turnOn(false) : allChk.turnOff(false);
			info.isHideGuid ? guildChk.turnOn(false) : guildChk.turnOff(false);
			info.isHideTitle ? titleChk.turnOn(false) : titleChk.turnOff(false);
			UIManager.getInstance().smallMapWnd.setView(allChk.isOn);
		}

		public function resize():void {
			visible=false;
			x=UIEnum.WIDTH - 160;
			y=80;
		}
	}
}

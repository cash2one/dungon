package com.ace.ui.setting.child
{
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.SettingManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.setting.AssistInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.SoundManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.CheckBox;
	
	import flash.events.MouseEvent;
	
	public class AssistSoundConfigWnd extends AutoSprite
	{
		private var allChk:CheckBox;
		
		private var atmosphereChk:CheckBox;
		
		private var toneChk:CheckBox;
		
		private var skillChk:CheckBox;
		
		public function AssistSoundConfigWnd(){
			super(LibManager.getInstance().getXML("config/ui/setting/soundWnd.xml"));
			init();
		}
		
		private function init():void{
			mouseEnabled = true;
			mouseChildren = true;
			allChk = getUIbyID("allChk") as CheckBox;
			atmosphereChk = getUIbyID("atmosphereChk") as CheckBox;
			toneChk = getUIbyID("toneChk") as CheckBox;
			skillChk = getUIbyID("skillChk") as CheckBox;
			
			allChk.addEventListener(MouseEvent.CLICK, onCheckBoxClick);
			atmosphereChk.addEventListener(MouseEvent.CLICK, onCheckBoxClick);
			toneChk.addEventListener(MouseEvent.CLICK, onCheckBoxClick);
			skillChk.addEventListener(MouseEvent.CLICK, onCheckBoxClick);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			
		}
		
		protected function onMouseOut(event:MouseEvent):void{
			if(!event.relatedObject || !contains(event.relatedObject)){
				hide();
			}
		}
		
		public override function hide():void{
			super.hide();
			DataManager.getInstance().saveCookieData();
		}
		
		/**
		 * <T>获取配置信息对象</T>
		 * 
		 * @return 信息对象 
		 * 
		 */		
		public function get info():AssistInfo{
			return SettingManager.getInstance().assitInfo;
		}
		
		protected function onCheckBoxClick(event:MouseEvent):void{
			var n:String = event.target.name;
			switch(n){
				case "allChk":
					allChk.isOn ? atmosphereChk.turnOn(false) : atmosphereChk.turnOff(false);
					allChk.isOn ? toneChk.turnOn(false) : toneChk.turnOff(false);
					allChk.isOn ? skillChk.turnOn(false) : skillChk.turnOff(false);
					info.closeAllSound = allChk.isOn;
					info.closeAtmosphereSound = atmosphereChk.isOn;
					info.closeToneSound = toneChk.isOn;
					info.closeSkillSound = skillChk.isOn;
					checkMapSound();
					break;
				case "atmosphereChk":
					if(!atmosphereChk.isOn) allChk.turnOff(false);
					info.closeAtmosphereSound = atmosphereChk.isOn;
					checkMapSound();
					break;
				case "toneChk":
					if(!toneChk.isOn) allChk.turnOff(false);
					info.closeToneSound = toneChk.isOn;
					break;
				case "skillChk":
					if(!skillChk.isOn) allChk.turnOff(false);
					info.closeSkillSound = skillChk.isOn;
					break;
			}
			
			if(atmosphereChk.isOn && toneChk.isOn && skillChk.isOn){
				allChk.turnOn(false);
			}
//			info.closeAllSound = allChk.isOn;
//			info.closeAtmosphereSound = atmosphereChk.isOn;
//			info.closeToneSound = toneChk.isOn;
//			info.closeSkillSound = skillChk.isOn;
			UIManager.getInstance().smallMapWnd.setSound(allChk.isOn);
			SettingManager.getInstance().assitInfo.setCookie();
		}
		
		private function checkMapSound():void{
			if(allChk.isOn || atmosphereChk.isOn){
				SoundManager.getInstance().musicStop();
			}else{
				SoundManager.getInstance().play(TableManager.getInstance().getSceneInfo(MapInfoManager.getInstance().sceneId).soundId);
			}
		}
		
		public function loadSetting():void{
			info.closeAtmosphereSound ? atmosphereChk.turnOn(false) : atmosphereChk.turnOff(false);
			info.closeToneSound ? toneChk.turnOn(false) : toneChk.turnOff(false);
			info.closeSkillSound ? skillChk.turnOn(false) : skillChk.turnOff(false);
			info.closeAllSound ? allChk.turnOn(false) : allChk.turnOff(false);
			UIManager.getInstance().smallMapWnd.setSound(allChk.isOn);
			if(info.closeAllSound || info.closeAtmosphereSound){
				SoundManager.getInstance().musicStop();
			}
		}
		
		public function resize():void{
			visible = false;
			x = UIEnum.WIDTH - 130;
			y = 80;
		}
	}
}
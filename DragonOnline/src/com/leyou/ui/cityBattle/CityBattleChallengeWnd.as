package com.leyou.ui.cityBattle
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.button.children.RadioButton;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_WARC;
	
	import flash.events.MouseEvent;
	
	public class CityBattleChallengeWnd extends AutoWindow
	{
		private var proRBtn:RadioButton;
		
		private var ybRBtn:RadioButton;
		
		private var confirmBtn:NormalButton;
		
		private var cancelBtn:NormalButton;
		
		private var type:int;
		
		public function CityBattleChallengeWnd(){
			super(LibManager.getInstance().getXML("config/ui/cityBattle/warCityCh.xml"));
			init();
		}
		
		private function init():void{
			proRBtn = getUIbyID("proRBtn") as RadioButton;
			ybRBtn = getUIbyID("ybRBtn") as RadioButton;
			confirmBtn = getUIbyID("confirmBtn") as NormalButton;
			cancelBtn = getUIbyID("cancelBtn") as NormalButton;
			
			proRBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			ybRBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			confirmBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			cancelBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			
			proRBtn.text = TableManager.getInstance().getItemInfo(ConfigEnum.warCity27).name;;
			clsBtn.x -= 6;
			clsBtn.y -= 14;
			proRBtn.turnOn(false);
			type = 1;
			
			ybRBtn.text = "      " + ConfigEnum.warCity6;
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "proRBtn":
					type = 1;
					break;
				case "ybRBtn":
					type = 2;
					break;
				case "confirmBtn":
					Cmd_WARC.cm_WARC_Z(type);
					hide();
					break;
				case "cancelBtn":
					hide();
					break;
			}
		}
	}
}
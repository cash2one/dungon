package com.leyou.ui.cityBattle
{
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.button.children.RadioButton;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_WARC;
	
	import flash.events.MouseEvent;
	
	public class CityBattleTaxWnd extends AutoWindow
	{
		private var desLbl:Label;
		
		private var rate0Btn:RadioButton;
		
		private var rate5Btn:RadioButton;
		
		private var rate10Btn:RadioButton;
		
		private var confirmBtn:NormalButton;
		
		private var cancelBtn:NormalButton;
		
		private var rate:int;

		private var transferRate:int;
		
		public function CityBattleTaxWnd(){
			super(LibManager.getInstance().getXML("config/ui/cityBattle/warCityTax.xml"));
			init();
		}
		
		private function init():void{
			clsBtn.x -= 6;
			clsBtn.y -= 14;
			desLbl = getUIbyID("desLbl") as Label;
			rate0Btn = getUIbyID("rate0Btn") as RadioButton;
			rate5Btn = getUIbyID("rate5Btn") as RadioButton;
			rate10Btn = getUIbyID("rate10Btn") as RadioButton;
			confirmBtn = getUIbyID("confirmBtn") as NormalButton;
			cancelBtn = getUIbyID("cancelBtn") as NormalButton;
			
			rate0Btn.addEventListener(MouseEvent.CLICK, onBtnClick);
			rate5Btn.addEventListener(MouseEvent.CLICK, onBtnClick);
			rate10Btn.addEventListener(MouseEvent.CLICK, onBtnClick);
			confirmBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			cancelBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			
			var  arr:Array = ConfigEnum.warCity1.split("|");
			rate0Btn.text = int(int(arr[0])/100)+"%";
			rate5Btn.text = int(int(arr[1])/100)+"%";
			rate10Btn.text = int(int(arr[2])/100)+"%";
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, toCenter);
			rate0Btn.turnOff(false);
			rate5Btn.turnOff(false);
			rate10Btn.turnOff(false);
			var cessValue:int;
			var  arr:Array = ConfigEnum.warCity1.split("|");
			rate = DataManager.getInstance().cityBattleData.cityData.cess;
			switch(rate){
				case int(arr[0]):
					cessValue = int(arr[0])/100;
					rate0Btn.turnOn(false);
					break;
				case int(arr[1]):
					cessValue = int(arr[1])/100;
					rate5Btn.turnOn(false);
					break;
				case int(arr[2]):
					cessValue = int(arr[2])/100;
					rate10Btn.turnOn(false);
					break;
			}
			var content:String = TableManager.getInstance().getSystemNotice(6704).content;
			desLbl.htmlText = StringUtil.substitute(content, cessValue);
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			var  arr:Array = ConfigEnum.warCity1.split("|");
			switch(event.target.name){
				case "rate0Btn":
					transferRate = arr[0];
					break;
				case "rate5Btn":
					transferRate = arr[1];
					break;
				case "rate10Btn":
					transferRate = arr[2];
					break;
				case "confirmBtn":
					Cmd_WARC.cm_WARC_C(transferRate);
					hide();
					break;
				case "cancelBtn":
					hide();
					break;
			}
			var content:String = TableManager.getInstance().getSystemNotice(6704).content;
			desLbl.htmlText = StringUtil.substitute(content, int(transferRate/100));
		}
	}
}
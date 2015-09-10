package com.leyou.ui.farm
{
	import com.ace.gameData.table.TFarmLandInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.button.children.RadioButton;
	import com.ace.ui.lable.Label;
	import com.leyou.net.cmd.Cmd_Farm;
	
	import flash.events.MouseEvent;
	
	public class FarmMessageWnd extends AutoWindow
	{
		private var confirmBtn:NormalButton;
		
		private var cancelBtn:NormalButton;
		
		private var bybRBtn:RadioButton;
		
		private var ybRBtn:RadioButton;
		
		private var type:int = 0;
		
		private var landID:int;
		
		private var ybLbl:Label;
		
		private var bybLbl:Label;
		
		public function FarmMessageWnd(){
			super(LibManager.getInstance().getXML("config/ui/farm/messageCoSeWnd.xml"));
			init();
		}
		
		private function init():void{
			confirmBtn = getUIbyID("confirmBtn") as NormalButton;
			cancelBtn = getUIbyID("cancelBtn") as NormalButton;
			bybRBtn = getUIbyID("bybRBtn") as RadioButton;
			ybRBtn = getUIbyID("ybRBtn") as RadioButton;
			ybLbl = getUIbyID("ybLbl") as Label;
			bybLbl = getUIbyID("bybLbl") as Label;
			confirmBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			cancelBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			bybRBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			ybRBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			bybRBtn.turnOn();
			clsBtn.x -= 6;
			clsBtn.y -= 14;
			hideBg();
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			switch(event.target.name){
				case "confirmBtn":
					Cmd_Farm.cm_FAM_O(landID, type);
					hide();
					break;
				case "cancelBtn":
					hide();
					break;
				case "bybRBtn":
					type = 0;
					break;
				case "ybRBtn":
					type = 1;
					break;
			}
		}
		
		public function loadInfo(landId:int, info:TFarmLandInfo):void{
			landID = landId
			ybLbl.text = info.cost+"";
			bybLbl.text = info.bcost+"";
			type = 0;
			bybRBtn.turnOn();
		}
	}
}
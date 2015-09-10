package com.ace.ui.window.children
{
	import com.ace.manager.LibManager;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.button.children.RadioButton;
	import com.ace.ui.lable.Label;
	
	import flash.events.MouseEvent;

	public class PopRadioWnd extends PopWindow
	{
//		private var contentLbl:Label;
		
		private var ybRadio:RadioButton;
		
		private var bybRadio:RadioButton;
		
		private var cancelBtn:NormalButton;
		
//		private var confirmBtn:ImgButton;
		
		private var confirmFun:Function;
		
		private var cancelFun:Function;
		
		private var ybLbl:Label;
		
		private var bybLbl:Label;
		
		public function PopRadioWnd(info:WindInfo){
			super(info, LibManager.getInstance().getXML("config/ui/farm/messageCoSeWnd.xml"));
		}
		
		protected override function init(info:WindInfo):void{
			contentLbl = getUIbyID("contentLbl") as Label;
			ybRadio = getUIbyID("ybRBtn") as RadioButton;
			bybRadio = getUIbyID("bybRBtn") as RadioButton;
			cancelBtn = getUIbyID("cancelBtn") as NormalButton;
			confirmBtn = getUIbyID("confirmBtn") as NormalButton;
			ybLbl = getUIbyID("ybLbl") as Label;
			bybLbl = getUIbyID("bybLbl") as Label;
			cancelBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			confirmBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			bybRadio.turnOn();
			update(info);
			clsBtn.x -= 6;
			clsBtn.y -= 14;
		}
		
		protected function onBtnClick(event:MouseEvent):void{
			hide();
			switch(event.target.name){
				case "confirmBtn":
					if(null != confirmFun){
						var type:int = bybRadio.isOn ? 0 : 1;
						confirmFun.call(this, type);
					}
					break;
				case "cancelBtn":
					if(null != cancelFun){
						cancelFun.call();
					}
					break;
			}
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, toCenter);
			bybRadio.turnOn(false);
		}
		
		public override function update(info:WindInfo):void{
			contentLbl.htmlText = info.content;
			ybLbl.text = info.radioTex1;
			bybLbl.text = info.radioTex2;
			confirmFun = info.okFun;
			cancelFun = info.cancelFun;
		}
	}
}
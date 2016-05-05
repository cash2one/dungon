package com.ace.ui.window.children
{
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.button.children.RadioButton;
	import com.ace.ui.lable.Label;
	import com.leyou.data.tips.TipsInfo;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class PopRadioWnd_II extends PopWindow
	{
		private var proLbl:Label;
		
		private var ybLbl:Label;
		
		private var bybRBtn:RadioButton;
		
		private var ybRBtn:RadioButton;
		
		private var cancelBtn:NormalButton;
		
		private var confirmFun:Function;
		
		private var cancelFun:Function;
		
		private var itemId:int;
		
		private var tipInfo:TipsInfo;
		
		public function PopRadioWnd_II(info:WindInfo){
			super(info, LibManager.getInstance().getXML("config/ui/messagebox/MessageCnSeWnd.xml"));
		}
		
		protected override function init(info:WindInfo):void{
			contentLbl = getUIbyID("contentLbl") as Label;
			proLbl = getUIbyID("itemLbl") as Label;
			ybLbl = getUIbyID("ybLbl") as Label;
			bybRBtn = getUIbyID("bybRBtn") as RadioButton;
			ybRBtn = getUIbyID("ybRBtn") as RadioButton;
			confirmBtn = getUIbyID("confirmBtn") as NormalButton;
			cancelBtn = getUIbyID("cancelBtn") as NormalButton;
			
			cancelBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			confirmBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			proLbl.mouseEnabled = true;
			proLbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			tipInfo = new TipsInfo();
			updateInfo(info);
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			tipInfo.itemid = itemId;
			ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, tipInfo, new Point(stage.mouseX, stage.mouseY));
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			hide();
			switch(event.target.name){
				case "confirmBtn":
					if(null != confirmFun){
						var type:int = bybRBtn.isOn ? 1 : 0;
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
			bybRBtn.turnOn(false);
		}
		
		public function updateInfo(info:WindInfo):void{
			contentLbl.htmlText = info.content;
			ybLbl.text = info.radioTex1;
			confirmFun = info.okFun;
			cancelFun = info.cancelFun;
			
			itemId = info.itemId;
			proLbl.htmlText = TableManager.getInstance().getItemInfo(info.itemId).name;
		}
	}
}
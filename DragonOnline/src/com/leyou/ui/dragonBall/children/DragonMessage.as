package com.leyou.ui.dragonBall.children {
	import com.ace.enum.UIEnum;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.utils.PropUtils;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;

	public class DragonMessage extends AutoWindow {
		private var confirmBtn:NormalButton;
		private var cancelBtn:NormalButton;
		private var contentLbl:Label;
		private var keyTextInput:TextInput;
		private var icoImg:Image;

		public function DragonMessage() {
			super(LibManager.getInstance().getXML("config/ui/dragonBall/dragonMessage.xml"));
			this.init();
		}

		private function init():void {
			confirmBtn=this.getUIbyID("confirmBtn") as NormalButton;
			cancelBtn=this.getUIbyID("cancelBtn") as NormalButton;
			contentLbl=this.getUIbyID("contentLbl") as Label;
			keyTextInput=this.getUIbyID("keyTextInput") as TextInput;
			icoImg=this.getUIbyID("icoImg") as Image;


			this.keyTextInput.addEventListener(Event.CHANGE, onInput);
			this.confirmBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			this.cancelBtn.addEventListener(MouseEvent.CLICK, onMouseClick);

		}

		protected function onMouseClick(event:MouseEvent):void {
			switch (event.target.name) {
				case "confirmBtn":
					this.owner.preAdd(int(this.keyTextInput.text));
					break;
				case "cancelBtn":
					break;
			}
			this.hide();
		}

		private function onInput(evt:Event):void {
			if (int(this.keyTextInput.text) > this.resultHL)
				this.keyTextInput.text=this.resultHL.toString();
		}

		private var resultHL:int;
		private var owner:DragonBallPropertyItem;

		public function update(render:DragonBallPropertyItem):void {
			this.owner=render;
			this.resultHL=UIManager.getInstance().roleWnd.dragonBall.resultHL;
			this.keyTextInput.input.maxChars=this.resultHL.toString().length;
			this.contentLbl.text=StringUtil.substitute(PropUtils.getStringById(2494), this.resultHL);
			this.icoImg.updateBmp(render.iconImg.url);
			if (render.getPropertyValue() != 0) {
				this.keyTextInput.text=render.getPropertyValue().toString();
			} else {
				this.keyTextInput.text="";
			}
			this.keyTextInput.text="";
			this.show(true, UIEnum.WND_LAYER_TOP);
		}
	}
}

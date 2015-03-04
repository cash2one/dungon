package com.leyou.ui.backpack.child {


	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.Label;
	import com.leyou.net.cmd.Cmd_Bag;
	import com.leyou.net.cmd.Cmd_CpTm;
	
	import flash.events.MouseEvent;

	public class MessageInputWnd extends AutoWindow {

		private var confirmBtn:NormalButton;
		private var cancelBtn:NormalButton;

		private var contentLbl:Label;
		private var titleNameLbl:Label;

		private var keyTextInput:TextInput;

		private var pos:int=-1;

		private var type:int=0;
		
		public var param:Array=[];

		public function MessageInputWnd() {
			super(LibManager.getInstance().getXML("config/ui/messagebox/messageInputWnd.xml"));
			this.init();
			this.hideBg();
			this.clsBtn.x-=6;
			this.clsBtn.y-=14;
		}

		private function init():void {
			this.confirmBtn=this.getUIbyID("confirmBtn") as NormalButton;
			this.cancelBtn=this.getUIbyID("cancelBtn") as NormalButton;

			this.contentLbl=this.getUIbyID("contentLbl") as Label;
			this.titleNameLbl=this.getUIbyID("titleNameLbl") as Label;

			this.keyTextInput=this.getUIbyID("keyTextInput") as TextInput;

			this.confirmBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.cancelBtn.addEventListener(MouseEvent.CLICK, onClick);
		}

		public function showPanel(pos:int, type:int=0,param:Array=null):void {

			this.type=type;
			this.param=param;
			
			this.keyTextInput.text="";
			if (type == 0) {
				this.pos=pos;
				this.contentLbl.text="" + TableManager.getInstance().getSystemNotice(4120).content;
				this.titleNameLbl.text="追踪";
			} else if (type == 1) {
				this.contentLbl.text="请输入密码:";
				this.titleNameLbl.text="输入密码";
			}

			this.show();
		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "confirmBtn":
					if (this.keyTextInput.text != "") {
						if (this.type == 0) {
							Cmd_Bag.cm_bagUseOf(this.pos, this.keyTextInput.text);
						} else if (this.type == 1) {
							Cmd_CpTm.cmTeamCopyAdd(param[0], this.keyTextInput.text);
						}
					}
					break;

			}

			this.hide();
		}

		override public function hide():void {
			super.hide();

			this.pos=-1;
			this.type=0;
			this.param=[];
		}




	}
}

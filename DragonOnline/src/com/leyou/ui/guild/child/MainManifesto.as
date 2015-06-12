package com.leyou.ui.guild.child {


	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.lable.children.TextArea;
	import com.leyou.net.cmd.Cmd_Guild;
	import com.leyou.utils.PropUtils;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFieldType;

	public class MainManifesto extends AutoSprite {

		private var contentLbl:TextArea;
		private var editBtn:ImgLabelButton;
		private var lastTimeLbl:Label;

		private var editState:Boolean=false;

		public function MainManifesto() {
			super(LibManager.getInstance().getXML("config/ui/guild/mainManifesto.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.contentLbl=this.getUIbyID("contentLbl") as TextArea;
			this.editBtn=this.getUIbyID("editBtn") as ImgLabelButton;
			this.lastTimeLbl=this.getUIbyID("lastTimeLbl") as Label;

			this.editBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.contentLbl.visibleOfBg=false;

//			this.contentLbl.tf.type=TextFieldType.DYNAMIC;
//			this.contentLbl.tf.mouseEnabled=false;


			this.contentLbl.tf.wordWrap=true;
			this.contentLbl.tf.multiline=true

			this.contentLbl.width=590;

			this.contentLbl.tf.maxChars=700;
			this.contentLbl.setText("");
			this.contentLbl.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			this.contentLbl.addEventListener(Event.CHANGE, onKeyDown);
//			this.contentLbl.addEventListener(MouseEvent.CLICK,onLbL);

//			this.contentLbl.editable=false;
			this.x-=10;
		}

		private function onLbL(e:Event):void {
			this.stage.focus=this.contentLbl.tf;
		}

		private function onKeyDown(e:Event):void {

			if (this.contentLbl.tf.numLines >= 8)
				this.contentLbl.tf.text=this.contentLbl.tf.text.substring(0, this.contentLbl.tf.getLineOffset(7) + this.contentLbl.tf.getLineLength(7));

			e.stopImmediatePropagation();
		}

		private function onKeyUp(e:KeyboardEvent):void {
			e.stopImmediatePropagation();
		}

		public function setEidtBtnState(v:Boolean):void {
			this.editBtn.visible=(v);
		}

		private function onClick(e:MouseEvent):void {

			if (this.editState) {
				if (this.contentLbl.text != "") {
					Cmd_Guild.cm_GuildEditNotice(UIManager.getInstance().guildWnd.guildId, 2, this.contentLbl.text);
				}

				this.editBtn.text=PropUtils.getStringById(1752);
//				this.contentLbl.mouseChildren=this.contentLbl.mouseEnabled=false;
//				this.contentLbl.tf.type=TextFieldType.DYNAMIC;
				this.contentLbl.editable=false;

			} else {

				this.editBtn.text=PropUtils.getStringById(1742);
//				this.contentLbl.mouseChildren=this.contentLbl.mouseEnabled=true;
//				this.contentLbl.tf.type=TextFieldType.INPUT;
				this.contentLbl.editable=true;
				this.stage.focus=this.contentLbl.tf;
			}

			this.editState=!this.editState;
		}

		public function updateInfo(o:Object):void {

			var str:String=o.notice;
			str=str.replace(/\\r/g, "\r");

			this.contentLbl.editable=true;
			this.contentLbl.setText(str + "");
			this.contentLbl.editable=false;

			this.lastTimeLbl.text="" + o.time;

			this.editBtn.text=PropUtils.getStringById(1752);
			this.editState=false;
		}

	}
}

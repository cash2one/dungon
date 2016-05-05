package com.leyou.ui.guild.child {

	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.dropMenu.DropMenuModel;
	import com.ace.ui.dropMenu.children.ComboBox;
	import com.ace.ui.dropMenu.event.DropMenuEvent;
	import com.ace.ui.lable.Label;
	import com.ace.ui.lable.children.TextArea;
	import com.leyou.net.cmd.Cmd_Guild;
	import com.leyou.utils.PlayerUtil;
	import com.leyou.utils.PropUtils;

	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFieldType;

	public class GuildMemMessager extends AutoWindow {

		private var officeCb:ComboBox;

		private var proLbl:Label;
		private var contributLbl:Label;
		private var contribut2Lbl:Label;
		private var lvLbl:Label;
		private var nameLbl:Label;

		private var descTxt:TextArea;
		private var editBtn:ImgLabelButton;
		private var confirmBtn:NormalButton;
		private var cancelBtn:NormalButton;

		private var editState:Boolean=false;

		private var data:Array=[];

		public function GuildMemMessager() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildMemMessage.xml"));
			this.init();
			this.hideBg();
//			this.clsBtn.y-=10;
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.officeCb=this.getUIbyID("officeCb") as ComboBox;

			this.proLbl=this.getUIbyID("proLbl") as Label;
			this.contributLbl=this.getUIbyID("contributLbl") as Label;
			this.contribut2Lbl=this.getUIbyID("contribut2Lbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.descTxt=this.getUIbyID("descTxt") as TextArea;
			this.editBtn=this.getUIbyID("editBtn") as ImgLabelButton;

			this.confirmBtn=this.getUIbyID("confirmBtn") as NormalButton;
			this.cancelBtn=this.getUIbyID("cancelBtn") as NormalButton;

//			this.editBtn.addEventListener(MouseEvent.CLICK, onClick);

			data=[{label: PropUtils.getStringById(36), uid: 1}, {label: PropUtils.getStringById(37), uid: 2}, {label: PropUtils.getStringById(38), uid: 3}, {label: PropUtils.getStringById(39), uid: 4}];
//			this.officeCb.addEventListener(DropMenuEvent.Item_Selected, onChangeOffice);

			this.confirmBtn.addEventListener(MouseEvent.CLICK, onSaveClick);
			this.cancelBtn.addEventListener(MouseEvent.CLICK, onSaveClick);

//			this.descTxt.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
//			this.descTxt.addEventListener(Event.CHANGE,onKeyDown);
//			this.descTxt.addEventListener(MouseEvent.CLICK,onLbL);

//			this.descTxt.setText("");
//			this.descTxt.mouseChildren=this.descTxt.mouseEnabled=false;

//			this.descTxt.tf.type=TextFieldType.DYNAMIC;
		}

		private function onLbL(e:Event):void {
			this.stage.focus=this.descTxt.tf;
		}

		private function onKeyUp(e:KeyboardEvent):void {
			e.stopImmediatePropagation();
		}

		private function onSaveClick(e:MouseEvent):void {

			if (e.target.name == "confirmBtn") {
				if (this.nameLbl.text != "" && this.visible)
					Cmd_Guild.cm_GuildOffice(this.nameLbl.text, int(this.officeCb.list.value.uid));
			} else {
				this.hide();
			}
		}


		private function onClick(e:MouseEvent):void {
			if (this.editState) {
				if (this.descTxt.text != "")
					Cmd_Guild.cm_GuildDesc(this.nameLbl.text, this.descTxt.text);
				else
					Cmd_Guild.cm_GuildDesc(this.nameLbl.text, PropUtils.getStringById(1594));

				this.editBtn.text=PropUtils.getStringById(1741);
				this.descTxt.mouseChildren=this.descTxt.mouseEnabled=false;
				this.descTxt.tf.type=TextFieldType.DYNAMIC;
				this.descTxt.editable=false;

			} else {

				this.editBtn.text=PropUtils.getStringById(1742);
				this.descTxt.mouseChildren=this.descTxt.mouseEnabled=true;
				this.descTxt.tf.type=TextFieldType.INPUT;
				this.descTxt.editable=true;
				this.stage.focus=this.descTxt.tf;
			}

			this.editState=!this.editState;
		}

		private function onChangeOffice(e:Event):void {

			if (this.nameLbl.text != "" && this.visible)
				Cmd_Guild.cm_GuildOffice(this.nameLbl.text, int(this.officeCb.list.value.uid));

//			this.editBtn.text=PropUtils.getStringById(1742);
//			this.descTxt.mouseChildren=this.descTxt.mouseEnabled=true;
//			this.editState=true;
		}

		/**
		 * @param info
		 */
		public function showPanel(info:Array):void {

			if (UIManager.getInstance().guildWnd.guildWarc == 0) {
				data=[{label: PropUtils.getStringById(36), uid: 1}, {label: PropUtils.getStringById(37), uid: 2}, {label: PropUtils.getStringById(38), uid: 3}, {label: PropUtils.getStringById(39), uid: 4}];
			} else {
				data=[{label: PropUtils.getStringById(2341), uid: 1}, {label: PropUtils.getStringById(2342), uid: 2}, {label: PropUtils.getStringById(2343), uid: 3}, {label: PropUtils.getStringById(2344), uid: 4}];
			}

			if (info[5] <= UIManager.getInstance().guildWnd.memberJob) {

				this.officeCb.list.addRends(data);
				this.officeCb.list.selectByUid(info[5]);
				this.officeCb.mouseChildren=this.officeCb.mouseEnabled=false;

			} else {

				this.officeCb.list.addRends(data.slice(UIManager.getInstance().guildWnd.memberJob));
				this.officeCb.list.selectByUid(info[5]);
				this.officeCb.mouseChildren=this.officeCb.mouseEnabled=true;

			}

			this.proLbl.text="" + PlayerUtil.getPlayerRaceByIdx(info[2]);
			this.contributLbl.text="" + info[4];
			this.contribut2Lbl.text="" + info[3];
			this.lvLbl.text="" + info[1];
			this.nameLbl.text="" + info[0];

//			if (info[6] != "")
//				this.descTxt.setText("" + info[6]);
//			else
//				this.descTxt.setText("");

			this.show();

//			this.editState=false;
//			this.editBtn.text=PropUtils.getStringById(1741);
//			this.descTxt.mouseChildren=this.descTxt.mouseEnabled=false;
		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(true, $layer);

			if (this.parent == null)
				LayerManager.getInstance().windowLayer.addChild(this);
		}

		override public function hide():void {
			super.hide();

//			this.editBtn.text=PropUtils.getStringById(1741);
//			this.descTxt.mouseChildren=this.descTxt.mouseEnabled=false;
//			this.descTxt.tf.type=TextFieldType.DYNAMIC;
//			this.descTxt.editable=false;
		}

	}
}

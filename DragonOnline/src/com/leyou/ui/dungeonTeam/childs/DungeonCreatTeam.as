package com.leyou.ui.dungeonTeam.childs {
	import com.ace.config.Core;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TDungeon_Base;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.dropMenu.children.ComboBox;
	import com.ace.ui.dropMenu.event.DropMenuEvent;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.utils.StringUtil;
	import com.leyou.net.cmd.Cmd_CpTm;
	import com.leyou.utils.PropUtils;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class DungeonCreatTeam extends AutoWindow {

		private var copyListCb:ComboBox;

		private var powerCb:CheckBox;
		private var powerLbl:TextInput;

		private var autoStartCb:CheckBox;
		private var autoStartCbb:ComboBox;

		private var passwardCb:CheckBox;
		private var passwardLbl:TextInput;

		private var confirmBtn:NormalButton;

		private var cpList:Array=[];

		private var cpid:int=-1;

		public function DungeonCreatTeam() {
			super(LibManager.getInstance().getXML("config/ui/dungeonTeam/dungeonCreatTeam.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;

//			this.scrollRect=new Rectangle(0, 0, 456, 446);
		}

		private function init():void {

			this.copyListCb=this.getUIbyID("copyListCb") as ComboBox;

			this.powerCb=this.getUIbyID("powerCb") as CheckBox;
			this.powerLbl=this.getUIbyID("powerLbl") as TextInput;

			this.autoStartCb=this.getUIbyID("autoStartCb") as CheckBox;
			this.autoStartCbb=this.getUIbyID("autoStartCbb") as ComboBox;

			this.passwardCb=this.getUIbyID("passwardCb") as CheckBox;
			this.passwardLbl=this.getUIbyID("passwardLbl") as TextInput;

			this.passwardLbl.restrict="0-9";
			this.powerLbl.restrict="0-9";

			this.confirmBtn=this.getUIbyID("confirmBtn") as NormalButton;

			this.copyListCb.addEventListener(DropMenuEvent.Item_Selected, onItemClick);

			var data:Array=[];
			data.push({label: StringUtil.substitute(PropUtils.getStringById(101413), [2]), uid: 2});
			data.push({label: StringUtil.substitute(PropUtils.getStringById(101413), [3]), uid: 3});
			data.push({label: StringUtil.substitute(PropUtils.getStringById(101413), [4]), uid: 4});

			this.autoStartCbb.list.removeRenders();
			this.autoStartCbb.list.addRends(data);

//			this.powerLbl.mouseChildren=false;
//			this.powerLbl.mouseEnabled=false;
			this.passwardLbl.mouseChildren=false;
			this.passwardLbl.mouseEnabled=false;

			this.powerCb.addEventListener(MouseEvent.CLICK, onClick);
			this.autoStartCb.addEventListener(MouseEvent.CLICK, onClick);
			this.passwardCb.addEventListener(MouseEvent.CLICK, onClick);
			this.confirmBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.autoStartCb.turnOn();

			this.powerLbl.addEventListener(Event.CHANGE, onKeyUp);
			this.passwardLbl.addEventListener(Event.CHANGE, onKeyUp);

			this.clsBtn.y=5;
		}

		private function onKeyUp(e:Event):void {

			if (e.currentTarget == this.powerLbl) {

				if (int(this.powerLbl.text) > UIManager.getInstance().roleWnd.getPower())
					this.powerLbl.text="" + UIManager.getInstance().roleWnd.getPower();

				this.powerLbl.text="" + this.powerLbl.text.substring(0, 8);
			} else if (e.currentTarget == this.passwardLbl) {

				this.passwardLbl.text="" + this.passwardLbl.text.substring(0, 10);
			}

		}

		private function onItemClick(e:Event):void {
			var cpInfo:TDungeon_Base=TableManager.getInstance().getGuildCopyInfo(this.copyListCb.list.value.uid);
			if (cpInfo == null)
				return;

			this.powerLbl.text="" + cpInfo.DBN_FC
		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "powerCb":
					this.powerLbl.mouseChildren=this.powerCb.isOn;
					this.powerLbl.mouseEnabled=this.powerCb.isOn;
					break;
				case "autoStartCb":
					this.autoStartCbb.mouseChildren=this.autoStartCbb.mouseEnabled=this.autoStartCb.isOn;
					break;
				case "passwardCb":
					this.passwardLbl.mouseChildren=this.passwardCb.isOn;
					this.passwardLbl.mouseEnabled=this.passwardCb.isOn;

					break;
				case "confirmBtn":

					if (this.powerCb.isOn && int(this.powerLbl.text) > UIManager.getInstance().roleWnd.getPower()) {
						NoticeManager.getInstance().broadcastById(6607);
						return;
					}

					Cmd_CpTm.cmTeamCopyCreate(this.copyListCb.list.value.uid, (this.powerCb.isOn ? int(this.powerLbl.text) : 1000), (this.autoStartCb.isOn ? this.autoStartCbb.list.value.uid : 0), (this.passwardCb.isOn ? this.passwardLbl.text : ""));
					break;
			}
		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);

			this.powerLbl.mouseChildren=true;
			this.powerLbl.mouseEnabled=true;
			this.passwardLbl.mouseChildren=false;
			this.passwardLbl.mouseEnabled=false;

			this.powerCb.turnOn();
			this.autoStartCb.turnOn();
			this.autoStartCbb.mouseChildren=this.autoStartCbb.mouseEnabled=true;
			
			this.passwardCb.turnOff();

//			this.copyListCb.list.removeRenders();
//			this.copyListCb.list.addRends(this.cpList);

//			this.powerLbl.text="";
			this.passwardLbl.text="";

		}

		public function updateList(o:Array):void {

			this.cpList=[];

			var tcopyinfo:TDungeon_Base;
			for (var i:int=0; i < o.length; i++) {
				tcopyinfo=TableManager.getInstance().getGuildCopyInfo(o[i][0])
				if (Core.me.info.level < tcopyinfo.Key_Level || o[i][1] <= 0)
					continue;

				this.cpList.push({label: "" + tcopyinfo.Dungeon_Name, uid: o[i][0]});
			}

			this.copyListCb.list.removeRenders();
			this.copyListCb.list.addRends(this.cpList);

			var cpInfo:TDungeon_Base=TableManager.getInstance().getGuildCopyInfo(o[0][0]);
			if (cpInfo == null)
				return;

			this.powerLbl.text="" + cpInfo.DBN_FC
		}

		public function setSelectItem(cid:int):void {

			this.copyListCb.list.selectByUid(cid + "");

		}

	}
}

package com.leyou.ui.guild.child {

	import com.ace.enum.UIEnum;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.dropMenu.children.ComboBox;
	import com.ace.ui.dropMenu.event.DropMenuEvent;
	import com.ace.ui.tabbar.TabbarModel;
	import com.leyou.net.cmd.Cmd_Guild;

	import flash.events.Event;
	import flash.events.MouseEvent;

	public class GuildPowManager extends AutoWindow {

		private var jobCb:ComboBox;
		private var saveBtn:NormalButton;
		private var cancelBtn:NormalButton;

		private var cbVec:Vector.<CheckBox>;
		private var cbName:Array=["新加成员", "开除成员", "行会升级", "行会宣战", "成员管理"];

		private var info:Array=[];

		public function GuildPowManager() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildPowMessage.xml"));
			this.init();
			this.hideBg();
			this.clsBtn.y-=10;
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {
			this.jobCb=this.getUIbyID("jobCb") as ComboBox;
			this.saveBtn=this.getUIbyID("saveBtn") as NormalButton;
			this.cancelBtn=this.getUIbyID("cancelBtn") as NormalButton;

			this.jobCb.list.addRends([{label: "会长", uid: 1}, {label: "副会长", uid: 2}, {label: "长老", uid: 3}, {label: "会员", uid: 4}]);
			this.jobCb.addEventListener(DropMenuEvent.Item_Selected, onItemClick);

			this.saveBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.cancelBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.cbVec=new Vector.<CheckBox>();

			var cb:CheckBox;
			for (var i:int=0; i < cbName.length; i++) {

				cb=new CheckBox();
				cb.text="" + cbName[i];
				this.cbVec.push(cb);

				this.addToPane(cb);

				cb.x=40 + ((i % 2) * (cb.width + 60));
				cb.y=80 + (int(i / 2) * 35);
			}
		}

		private function onItemClick(e:Event):void {
			if (e.target is ComboBox)
				Cmd_Guild.cm_GuildAuth(int(this.jobCb.list.value.uid));
		}

		public function updateInfo(info:Array):void {
			 
			for (var i:int=0; i < info.length; i++) {
				if (int(this.jobCb.list.value.uid) == 1)
					this.cbVec[i].setActive(false);
				else
					this.cbVec[i].setActive(true);
				
				if (info[i] == 1)
					this.cbVec[i].turnOn();
				else
					this.cbVec[i].turnOff();
			}

		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "saveBtn":
					Cmd_Guild.cm_GuildAuthSet(int(this.jobCb.list.value.uid), this.cbVec[0].isOn ? 1 : 0, this.cbVec[1].isOn ? 1 : 0, this.cbVec[2].isOn ? 1 : 0, this.cbVec[3].isOn ? 1 : 0, this.cbVec[4].isOn ? 1 : 0);
					break;
				case "cancelBtn":
					this.hide();
					break;
			}

		}


		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(true, $layer);

			Cmd_Guild.cm_GuildAuth(int(this.jobCb.list.value.uid));

			if (this.parent == null)
				LayerManager.getInstance().windowLayer.addChild(this);
		}

		override public function hide():void {
			super.hide();
		}

	}
}

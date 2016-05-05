package com.leyou.ui.guild {

	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.leyou.manager.TimerManager;
	import com.leyou.net.cmd.Cmd_Guild;
	import com.leyou.utils.GuildUtil;
	import com.leyou.utils.PlayerUtil;
	import com.leyou.utils.PropUtils;
	
	import flash.events.MouseEvent;

	public class GuildInviteWnd extends AutoWindow {

		private var playNameLbl:Label;
		private var lvLbl:Label;
		private var proLbl:Label;
		private var timeLbl:Label;
		private var fightLbl:Label;
		private var titleNameLbl:Label;
		private var invLbl:Label;

		private var proTxt:Label;
		private var fightTxt:Label;
		private var playNameTxt:Label;
		
		private var accBtn:NormalButton;
		private var noBtn:NormalButton;

		private var viewDataBtn:ImgLabelButton;
		
		private var playName:String;

		private var type:int=0;
		private var time:int=0;

		public function GuildInviteWnd() {
			super(LibManager.getInstance().getXML("config/ui/guild/guildInviteWnd.xml"));
			this.init();
			this.hideBg();
//			this.clsBtn.y-=10;
		}

		private function init():void {

			this.playNameTxt=this.getUIbyID("playNameTxt") as Label;
			this.playNameLbl=this.getUIbyID("playNameLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.proLbl=this.getUIbyID("proLbl") as Label;
			this.proTxt=this.getUIbyID("proTxt") as Label;
			this.timeLbl=this.getUIbyID("timeLbl") as Label;
			this.fightLbl=this.getUIbyID("fightLbl") as Label;
			this.fightTxt=this.getUIbyID("fightTxt") as Label;
			this.titleNameLbl=this.getUIbyID("titleNameLbl") as Label;
			this.invLbl=this.getUIbyID("invLbl") as Label;

			this.accBtn=this.getUIbyID("accBtn") as NormalButton;
			this.noBtn=this.getUIbyID("noBtn") as NormalButton;
			this.viewDataBtn=this.getUIbyID("viewDataBtn") as ImgLabelButton;

			this.accBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.noBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.viewDataBtn.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "accBtn":
					if (type == 1)
						Cmd_Guild.cm_GuildInviteSelect(1, this.playName);
					else {
						Cmd_Guild.cm_GuildApplySelect(1, this.playName);
					}

					this.hide();
					break;
				case "noBtn":
					if (type == 1)
						Cmd_Guild.cm_GuildInviteSelect(0, this.playName);
					else
						Cmd_Guild.cm_GuildApplySelect(0, this.playName);

					this.hide();
					break;
				case "viewDataBtn":
					UIManager.getInstance().otherPlayerWnd.showPanel(this.playName);
					break;
			}

		}

		public function showPanel(info:Array, type:int=0):void {

			this.show();

			this.type=type;
			
			this.lvLbl.text="" + info[2];

			if (info.length >= 4)
				this.fightLbl.text="" + info[3];
			else
				this.fightLbl.text="";

			if (type == 1) {
				this.titleNameLbl.text=PropUtils.getStringById(1754);
				this.invLbl.text=PropUtils.getStringById(1755);
				
				this.fightTxt.visible=false;
				this.proTxt.visible=false;
				this.viewDataBtn.visible=false;
				this.proLbl.text="";
				
				this.playNameTxt.text=PropUtils.getStringById(1756);
				this.playNameLbl.text="" + info[1];
			} else {
				
				this.titleNameLbl.text=PropUtils.getStringById(1757);
				this.invLbl.text=PropUtils.getStringById(1758);
				
				this.fightTxt.visible=true;
				this.proTxt.visible=true;
				this.viewDataBtn.visible=true;
				
				this.playNameTxt.text=PropUtils.getStringById(1759);
				this.proLbl.text=""+PlayerUtil.getPlayerRaceByIdx(info[1]);
				this.playNameLbl.text="" + info[0];
			}

			this.playName=info[0];
			this.timeLbl.text="";

			time=30;
			TimerManager.getInstance().add(exeTime);
		}

		private function exeTime(i:int):void {

			if (time-i > 0) {
				this.timeLbl.text="(" + (time-i) + ")";
			} else {
				this.closeData();
			}
 
		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show();

			if (this.parent == null)
				LayerManager.getInstance().windowLayer.addChild(this);
		}

		override public function hide():void {
			super.hide();

			TimerManager.getInstance().remove(exeTime);
			time=0;
		}

		private function closeData():void {
			super.hide();

			if (this.visible)
				Cmd_Guild.cm_GuildApplySelect(0, this.playNameLbl.text);

			TimerManager.getInstance().remove(exeTime);
			time=0;
		}



	}
}

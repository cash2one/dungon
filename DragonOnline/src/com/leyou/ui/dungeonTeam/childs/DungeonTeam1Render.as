package com.leyou.ui.dungeonTeam.childs {

	import com.ace.config.Core;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.RadioButton;
	import com.leyou.net.cmd.Cmd_CpTm;

	import flash.events.MouseEvent;

	public class DungeonTeam1Render extends AutoSprite {

		private var listRd:RadioButton;
		private var myRd:RadioButton;

		private var teamRender:DungeonTeam1Team;
		private var playRender:DungeonTeam1Player;

		public var cpid:int=-1;
		public var level:int=-1;
		public var count:int=-1;

		public var myTeam:Boolean=false;
		public var myBoss:Boolean=false;

		public function DungeonTeam1Render() {
			super(LibManager.getInstance().getXML("config/ui/dungeonTeam/dungeonTeam1Render.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;

//			this.scrollRect=new Rectangle(0, 0, 456, 446);
		}

		private function init():void {

			this.listRd=this.getUIbyID("listRd") as RadioButton;
			this.myRd=this.getUIbyID("myRd") as RadioButton;

			this.listRd.addEventListener(MouseEvent.CLICK, onClick);
			this.myRd.addEventListener(MouseEvent.CLICK, onClick);

			this.teamRender=new DungeonTeam1Team();
			this.addChild(this.teamRender);

			this.playRender=new DungeonTeam1Player();
			this.addChild(this.playRender);

			this.listRd.turnOn();
			this.teamRender.visible=true;
			this.playRender.visible=false;
		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "listRd":
					this.teamRender.visible=true;
					this.playRender.visible=false;

					if (this.cpid != -1)
						Cmd_CpTm.cmTeamCopyTeam(this.cpid);
					break;
				case "myRd":
					this.teamRender.visible=false;
					this.playRender.visible=true;

					Cmd_CpTm.cmTeamCopyMy();
					break;
			}

		}

		public function updateTeamList(o:Object):void {
			this.teamRender.updateInfo(o, this.myTeam, count,level);
		}

		public function updatePlayList(o:Object):void {

			if (o.hasOwnProperty("team")) {
				this.myRd.setActive(true,1,true);
				
				this.myTeam=true;

				if (o.team[0][0] == MyInfoManager.getInstance().name || this.getOk(o.team))
					this.myBoss=true;
				else
					this.myBoss=false;

				this.myRd.turnOn();
				this.teamRender.visible=false;
				this.playRender.visible=true;

			} else {

				this.myRd.setActive(false,.6,true);
				
				this.listRd.turnOn()
				this.teamRender.visible=true;
				this.playRender.visible=false;
				this.myTeam=false;
			}

			this.playRender.updateInfo(o, Core.me.info.level >= level, count > 0);
		}

		private function getOk(o:Array):Boolean {
			for (var i:int=0; i < o.length; i++) {
				if (o[i][0] == MyInfoManager.getInstance().name && o[i][5] == 1)
					return true;
			}

			return false;
		}

	}
}

package com.leyou.ui.dungeonTeam.childs {

	import com.ace.enum.CursorEnum;
	import com.ace.enum.FontEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TDungeon_Base;
	import com.ace.manager.CursorManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.ButtonModel;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.button.event.ButtonEvent;
	import com.ace.ui.lable.Label;
	import com.leyou.manager.PopupManager;
	import com.leyou.manager.TimerManager;
	import com.leyou.net.cmd.Cmd_CpTm;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class DungeonTeam1Player extends AutoSprite {

		private var enterBtn:NormalButton;
		private var quitBtn:NormalButton;
		private var autoStartCb:CheckBox;
		private var searchLbl:Label;
		private var cpNameLbl:Label;

		private var itemsList:Vector.<DungeonTeam1PlayerBar>;

		private var auto:int=0;

		private var etime:int=0;

		public function DungeonTeam1Player() {
			super(LibManager.getInstance().getXML("config/ui/dungeonTeam/dungeonTeam1Player.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;

//			this.scrollRect=new Rectangle(0, 0, 456, 446);
		}

		private function init():void {

			this.enterBtn=this.getUIbyID("enterBtn") as NormalButton;
			this.quitBtn=this.getUIbyID("quitBtn") as NormalButton;
			this.autoStartCb=this.getUIbyID("autoStartCb") as CheckBox;
			this.searchLbl=this.getUIbyID("searchLbl") as Label;
			this.cpNameLbl=this.getUIbyID("cpNameLbl") as Label;

			this.enterBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.quitBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.autoStartCb.addEventListener(MouseEvent.CLICK, onClick);
//			this.autoStartCb.addEventListener(ButtonEvent.Switch_Change, onCkClick);
			this.searchLbl.addEventListener(MouseEvent.CLICK, onClick);
			this.searchLbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.searchLbl.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.searchLbl.mouseEnabled=true;
			
			this.itemsList=new Vector.<DungeonTeam1PlayerBar>();

			var playBar:DungeonTeam1PlayerBar;
			for (var i:int=0; i < 4; i++) {
				playBar=new DungeonTeam1PlayerBar();

				this.addChild(playBar);
				this.itemsList.push(playBar);

				playBar.x=14;
				playBar.y=48 + 78 * i;

				playBar.visible=false;
			}
		}

		private function onMouseOver(e:MouseEvent):void {
			CursorManager.getInstance().updataCursor(CursorEnum.CURSOR_HAND);
		}

		private function onMouseOut(e:MouseEvent):void {
			CursorManager.getInstance().resetGameCursor();
		}

		private function onCkClick(e:Event):void {
//			Cmd_CpTm.cmTeamCopyTeamAutoAdd((this.autoStartCb.isOn ? 1 : 0));
		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "enterBtn":
					Cmd_CpTm.cmTeamCopyTeamEnter();
					break;
				case "quitBtn":
					PopupManager.showConfirm(TableManager.getInstance().getSystemNotice(6609).content, function():void {
						Cmd_CpTm.cmTeamCopyQuit();
						UIManager.getInstance().teamCopyWnd.updateTeamCurrentList();
					}, null, false, "teamCopyQuit");
					break;
				case "autoStartCb":
					Cmd_CpTm.cmTeamCopyTeamAutoAdd((this.auto == 0 ? 1 : 0));
					break;
				case "searchLbl":
					Cmd_CpTm.cmTeamCopyTeamFind();
					this.etime=30;
					this.searchLbl.mouseEnabled=false;
					TimerManager.getInstance().add(exeTime);
					break;
			}

		}

		private function exeTime(i:int):void {

			if (this.etime - i > 0) {
				this.searchLbl.htmlText="<font color='#cccccc'>发送寻求队友(" + (this.etime - i) + ")</font>";
			} else {
				TimerManager.getInstance().remove(exeTime);
				this.searchLbl.styleSheet=FontEnum.DEFAULT_LINK_STYLE;
				this.searchLbl.text="发送寻求队友";
				this.searchLbl.mouseEnabled=true;
			}

//			this.searchLbl.styleSheet=FontEnum.DEFAULT_LINK_STYLE;
		}

		public function updateInfo(o:Object, lv:Boolean, count:Boolean):void {

			if (o.hasOwnProperty("auto")) {
				if (o.auto == 1)
					this.autoStartCb.turnOn();
				else
					this.autoStartCb.turnOff();

				this.auto=o.auto;
			} else {
				this.autoStartCb.turnOff();
			}

			var team:Array;
			var bossName:String;

			if (o.hasOwnProperty("team")) {
				team=o.team;
				this.autoStartCb.visible=true;
				this.quitBtn.visible=true;
				this.searchLbl.visible=true;

				var cinfo:TDungeon_Base=TableManager.getInstance().getGuildCopyInfo(o.cpid);
				if (cinfo == null)
					return;

				this.cpNameLbl.text="" + cinfo.Dungeon_Name;

			} else {
				
				this.autoStartCb.visible=false;
				this.quitBtn.visible=false;
				this.searchLbl.visible=false;
			}


			for (var i:int=0; i < 4; i++) {
				if (i == 0 && team != null)
					bossName=team[0][0];

				if (bossName == null || i >= team.length)
					this.itemsList[i].visible=false;
				else {

					if (i < team.length)
						this.itemsList[i].visible=true;

					this.itemsList[i].updateInfo(team[i], bossName);

				}
			}

			if (bossName == MyInfoManager.getInstance().name) {
				this.enterBtn.visible=true;
				this.autoStartCb.mouseChildren=this.autoStartCb.mouseEnabled=true;
				this.quitBtn.x=172;

				if (team.length < 2 || !lv || !count)
					this.enterBtn.setActive(false, .6, true);
				else
					this.enterBtn.setActive(true, 1, true);

				this.searchLbl.visible=true;

			} else {

				this.searchLbl.visible=false;
				this.autoStartCb.mouseChildren=this.autoStartCb.mouseEnabled=false;
				this.enterBtn.visible=false;
				this.quitBtn.x=this.enterBtn.x;
			}

		}



	}
}

package com.leyou.ui.dungeonTeam {

	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.ace.utils.StringUtil;
	import com.leyou.manager.LastTimeImageManager;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.NetGate;
	import com.leyou.net.cmd.Cmd_CpTm;
	import com.leyou.net.cmd.Cmd_Ucp;
	import com.leyou.ui.dungeonTeam.childs.DungeonTGuildRender;
	import com.leyou.ui.dungeonTeam.childs.DungeonTeamBtn;
	import com.leyou.ui.dungeonTeam.childs.DungeonTeamCopy;
	import com.leyou.ui.guild.child.GuildDungeon;
	import com.leyou.utils.StringUtil_II;

	import flash.events.Event;
	import flash.events.MouseEvent;

	public class DungeonTeamWnd extends AutoWindow {

		private var dungeonTeamTabbar:TabBar;
		private var guildCopy:DungeonTGuildRender;

		private var teamCopy:DungeonTeamCopy;

		public var teamStart:DungeonTeamStart;

		private var currentIndex:int=0;

		public var myTeamName:String;

		public var leftBtn:DungeonTeamBtn;

		public function DungeonTeamWnd() {
			super(LibManager.getInstance().getXML("config/ui/dungeonTeamWnd.xml"));
			this.init();
			this.hideBg()
			this.mouseChildren=true;
			this.mouseEnabled=true;

//			this.scrollRect=new Rectangle(0, 0, 456, 446);
		}

		private function init():void {
			this.dungeonTeamTabbar=this.getUIbyID("dungeonTeamTabbar") as TabBar;

			this.teamCopy=new DungeonTeamCopy();
			this.dungeonTeamTabbar.addToTab(this.teamCopy, 0);

			this.guildCopy=new DungeonTGuildRender();
			this.dungeonTeamTabbar.addToTab(this.guildCopy, 1);

			this.teamStart=new DungeonTeamStart();

			this.dungeonTeamTabbar.addEventListener(TabbarModel.changeTurnOnIndex, onChange);

			this.leftBtn=new DungeonTeamBtn();
			LayerManager.getInstance().windowLayer.addChild(this.leftBtn);

			this.leftBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.leftBtn.visible=false;
		}

		private function onClick(e:MouseEvent):void {
			if (!TableManager.getInstance().getGuildCopyExistBySceneIDAndType(int(MapInfoManager.getInstance().sceneId), 7))
				UILayoutManager.getInstance().open_II(WindowEnum.DUNGEON_TEAM);
		}

		private function onChange(e:Event):void {

			if (this.dungeonTeamTabbar.turnOnIndex == 1) {
				PopupManager.closeConfirm("teamCopyPassword");
			}

		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
		}

		override public function sendOpenPanelProtocol(... parameters):void {
			this.dataModel=parameters;

			Cmd_Ucp.cm_GuildCpInit();
//			NetGate.getInstance().send("cptm|G");
			Cmd_CpTm.cmTeamCopyMy();
			Cmd_CpTm.cmTeamCopyOpen();

			this.dungeonTeamTabbar.turnToTab(0);
		}

		/**
		 * 副本列表
		 * @param o
		 *
		 */
		public function updateTeamCopy(o:Object):void {
			UIManager.getInstance().showPanelCallback(WindowEnum.DUNGEON_TEAM);
			this.teamCopy.updateInfo(o);
		}

		/**
		 * 队伍列表
		 * @param o
		 *
		 */
		public function updateTeamCopyList(o:Object):void {
			this.teamCopy.updateList(o);
		}

		/**
		 * 我的队伍
		 * @param o
		 *
		 */
		public function updateTeamCopyMy(o:Object):void {
			if (o.hasOwnProperty("team")) {
				this.myTeamName=o.team[0][0];
				UIManager.getInstance().hideWindow(WindowEnum.DUNGEON_TEAM_CREATE);

				this.leftBtn.setParams(this.myTeamName, o.team.length);

				if (!this.leftBtn.visible) {
					this.resize();
					this.leftBtn.visible=true;
				}

			} else {
				this.myTeamName="";
				this.leftBtn.visible=false;
			}

			this.teamCopy.updateMy(o);
		}

		public function setTabIndex(i:int):void {
			this.dungeonTeamTabbar.turnToTab(i);
		}

		public function updateGuildCopy(o:Object):void {
			if (o.cl[0].hasOwnProperty("st")) {
				this.dungeonTeamTabbar.setTabVisible(1, true);
				this.guildCopy.updateInfo(o);
			} else {
				this.dungeonTeamTabbar.setTabVisible(1, false);
			}
		}

		public function updateTeamCurrentList():void {
			this.teamCopy.updateCurrentList();
		}

		public function viewCopyOn():Boolean {
			return this.guildCopy.isOn;
		}

		override public function hide():void {
			super.hide();

			PopupManager.closeConfirm("teamCopyQuit");
			PopupManager.closeConfirm("teamCopyChange");
			PopupManager.closeConfirm("teamCopyPassword");

			UIManager.getInstance().hideWindow(WindowEnum.DUNGEON_TEAM_CREATE);

		}

		public function resize():void {

			this.x=UIEnum.WIDTH - this.width >> 1;
			this.y=UIEnum.HEIGHT - this.height >> 1;

			this.leftBtn.x=0;
			this.leftBtn.y=UIEnum.HEIGHT / 2 - 100

		}

		override public function get width():Number {
			return 788;
		}

		override public function get height():Number {
			return 496
		}

	}
}

package com.leyou.ui.dungeonTeam {

	import com.ace.config.Core;
	import com.ace.enum.SceneEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.greensock.TweenLite;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_BCP;
	import com.leyou.net.cmd.Cmd_CpTm;
	import com.leyou.net.cmd.Cmd_SCP;
	import com.leyou.net.cmd.Cmd_Ucp;
	import com.leyou.ui.boss.children.BossCopyRender;
	import com.leyou.ui.copy.StoryCopyWnd;
	import com.leyou.ui.dungeonTeam.childs.DungeonTGuildRender;
	import com.leyou.ui.dungeonTeam.childs.DungeonTeamBtn;
	import com.leyou.ui.dungeonTeam.childs.DungeonTeamCopy;
	import com.leyou.ui.expCopy.ExpCopyWnd;
	
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

		//------------------------------------------------------------
		// WFH添加

		public var storyCopy:StoryCopyWnd;

		public var bossCopy:BossCopyRender;

		public var expCopy:ExpCopyWnd;

		//------------------------------------------------------------

		public function DungeonTeamWnd() {
			super(LibManager.getInstance().getXML("config/ui/dungeonTeamWnd.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;

//			this.scrollRect=new Rectangle(0, 0, 456, 446);
		}

		private function init():void {
			this.dungeonTeamTabbar=this.getUIbyID("dungeonTeamTabbar") as TabBar;

			this.teamCopy=new DungeonTeamCopy();
			this.dungeonTeamTabbar.addToTab(this.teamCopy, 2);

			this.guildCopy=new DungeonTGuildRender();
			this.dungeonTeamTabbar.addToTab(this.guildCopy, 3);

			this.teamStart=new DungeonTeamStart();

			this.dungeonTeamTabbar.addEventListener(TabbarModel.changeTurnOnIndex, onChange);

//			this.dungeonTeamTabbar.getTabButton(0).addEventListener(MouseEvent.MOUSE_OVER
//			this.dungeonTeamTabbar.getTabButton(0).addEventListener(MouseEvent.MOUSE_OUT

			this.leftBtn=new DungeonTeamBtn();
			LayerManager.getInstance().windowLayer.addChild(this.leftBtn);

			this.leftBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.leftBtn.visible=false;

			//------------------------------------------------------------
			// WFH添加
			storyCopy=new StoryCopyWnd();
			dungeonTeamTabbar.addToTab(storyCopy, 0);
			bossCopy=new BossCopyRender();
			dungeonTeamTabbar.addToTab(bossCopy, 1);
			expCopy=new ExpCopyWnd();
			dungeonTeamTabbar.addToTab(expCopy, 4);

			dungeonTeamTabbar.setTabVisible(1, false);
			dungeonTeamTabbar.setTabVisible(4, false);
			if (Core.me.info.level >= ConfigEnum.BossCopyOpenLevel) {
				dungeonTeamTabbar.setTabVisible(1, true);
			}
			if (Core.me.info.level >= ConfigEnum.ExpCopyOpenLevel) {
				dungeonTeamTabbar.setTabVisible(4, true);
			}
			//------------------------------------------------------------
		}

		private function onClick(e:MouseEvent):void {
			if (!TableManager.getInstance().getGuildCopyExistBySceneIDAndType(int(MapInfoManager.getInstance().sceneId), 7))
				UILayoutManager.getInstance().open_II(WindowEnum.DUNGEON_TEAM);

			TweenLite.delayedCall(0.6, function():void {
				setTabIndex(2);
			});
		}

		private function onChange(e:Event):void {

			if (this.dungeonTeamTabbar.turnOnIndex != 2) {
				PopupManager.closeConfirm("teamCopyPassword");
			} else
				GuideManager.getInstance().removeGuide(117);

			//------------------------------------------------------------
			// WFH添加
			switch (dungeonTeamTabbar.turnOnIndex) {
				case 0:
					Cmd_SCP.cm_SCP_I();
					break;
				case 1:
					Cmd_BCP.cm_BCP_I();
					GuideManager.getInstance().removeGuide(116);
					break;
				case 4:
					GuideManager.getInstance().removeGuide(118);
					break;
			}

			//------------------------------------------------------------
		}

		//------------------------------------------------------------
		// WFH添加
		public function updatePage():void {
			dungeonTeamTabbar.setTabVisible(1, false);
			dungeonTeamTabbar.setTabVisible(4, false);
			if (Core.me.info.level >= ConfigEnum.BossCopyOpenLevel) {
				dungeonTeamTabbar.setTabVisible(1, true);
			}
			if (Core.me.info.level >= ConfigEnum.ExpCopyOpenLevel) {
				dungeonTeamTabbar.setTabVisible(4, true);
			}
		}

		//------------------------------------------------------------

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
			Cmd_SCP.cm_SCP_I();
			//------------------------------------------------------------
			// WFH添加
//			storyCopy.showGuide();
//			bossCopy.removeGuide();
//			expCopy.removeGuide();
//			GuideManager.getInstance().showGuide(116, dungeonTeamTabbar.getTabButton(1));
//			GuideManager.getInstance().showGuide(118, dungeonTeamTabbar.getTabButton(4));
			//------------------------------------------------------------

			if (Core.me.info.level >= ConfigEnum.TeamDungeon1) {
				this.dungeonTeamTabbar.setTabVisible(2, true)
				GuideManager.getInstance().showGuide(117, this.dungeonTeamTabbar.getTabButton(2));
			} else {
				this.dungeonTeamTabbar.setTabVisible(2, false)
			}

			this.dungeonTeamTabbar.setTabVisible(3, false);

			GuideManager.getInstance().removeGuide(111);
			this.dungeonTeamTabbar.turnToTab(0);
			
			if (!MyInfoManager.getInstance().isTaskOk && MyInfoManager.getInstance().currentTaskId == 29)
				TweenLite.delayedCall(ConfigEnum.autoTask3, this.autoTaskComplete);
		}
		
		private function autoTaskComplete():void {
			if (this.dungeonTeamTabbar.turnOnIndex == 0 && this.visible)
				this.storyCopy.dispatAutoTaskEvent();
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

					if (MapInfoManager.getInstance().type == SceneEnum.SCENE_TYPE_PTCJ)
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
				this.dungeonTeamTabbar.setTabVisible(3, false);
				this.guildCopy.updateInfo(o);
			} else {
				this.dungeonTeamTabbar.setTabVisible(3, false);
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

			expCopy.removeGuide();
			bossCopy.removeGuide();
			storyCopy.removeGuide();

			GuideManager.getInstance().removeGuide(117);
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
			return 544;
		}

	}
}

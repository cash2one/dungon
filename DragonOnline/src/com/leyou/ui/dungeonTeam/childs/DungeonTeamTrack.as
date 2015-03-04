package com.leyou.ui.dungeonTeam.childs {

	import com.ace.config.Core;
	import com.ace.enum.EventEnum;
	import com.ace.enum.FontEnum;
	import com.ace.enum.SceneEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.scene.MapInfo;
	import com.ace.manager.EventManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.map.MapWnd;
	import com.leyou.manager.PopupManager;
	import com.leyou.manager.TimerManager;
	import com.leyou.net.cmd.Cmd_CpTm;
	import com.leyou.utils.TimeUtil;

	public class DungeonTeamTrack extends AutoSprite {

		private var timeTxt:Label;
		private var timeLbl:Label;

		private var lbarr:Array=[];

		private var time:int=0;

		public function DungeonTeamTrack() {
			super(LibManager.getInstance().getXML("config/ui/dungeonTeamTrack.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {
			this.timeTxt=this.getUIbyID("timeTxt") as Label;
			this.timeLbl=this.getUIbyID("timeLbl") as Label;

			EventManager.getInstance().addEvent(EventEnum.COPY_QUIT, onClick);
		}

		private function onClick():void {

			if (TableManager.getInstance().getGuildCopyExistBySceneIDAndType(int(MapInfoManager.getInstance().sceneId), 7)) {
				PopupManager.showConfirm(TableManager.getInstance().getSystemNotice(4603).content, function():void {
					Cmd_CpTm.cmTeamCopyTeamExit();
				}, null, false, "teamCopyExit");
			}

		}


		public function updateInfo(m:Array):void {
			var lb:Label;
			for each (lb in this.lbarr) {
				this.removeChild(lb);
			}

			this.lbarr.length=0;

			var len:int=0;
			for (var i:int=0; i < m.length; i++) {
				lb=new Label();

				lb.text="击杀:" + TableManager.getInstance().getLivingInfo(m[i].mid).name

				this.addChild(lb);

				lb.x=10;
				lb.y=26 + i * 20;

				this.lbarr.push(lb);

				len=lb.x + lb.width;

				lb=new Label();

				if (m[i].cc == m[i].mc) {
					lb.defaultTextFormat=FontEnum.getTextFormat("Green12");
				} else
					lb.defaultTextFormat=FontEnum.getTextFormat("Red12");

				lb.text="(" + m[i].cc + "/" + m[i].mc + ")";

				this.addChild(lb);

				lb.x=len + 2;
				lb.y=26 + i * 20;

				this.lbarr.push(lb);
			}

			this.timeTxt.y=lb.y + 20;
			this.timeLbl.y=lb.y + 20;
		}

		public function showPanel(o:Object):void {
			if(!this.visible)
			Core.me.onAutoMonster();
			
			this.show();
			this.resize();

			UIManager.getInstance().smallMapWnd.switchToType(2);
			UIManager.getInstance().rightTopWnd.hideBar(1);
			MapWnd.getInstance().hideSwitch();

			UIManager.getInstance().taskTrack.hide();
			UIManager.getInstance().hideWindow(WindowEnum.DUNGEON_TEAM);
			UIManager.getInstance().hideWindow(WindowEnum.STORYCOPY);
			UIManager.getInstance().hideWindow(WindowEnum.COPYTRACK);

			

			this.updateInfo(o.m);

			this.time=o.rt;

			this.timeLbl.text="" + TimeUtil.getIntToTime(this.time);

			TimerManager.getInstance().remove(exeTime);
			TimerManager.getInstance().add(exeTime);

		}

		private function exeTime(i:int):void {

			if (this.time - i > 0) {
				this.timeLbl.text="" + TimeUtil.getIntToTime(this.time - i);
			} else {
				this.timeLbl.text="00:00";
				this.time=0;
				TimerManager.getInstance().remove(exeTime);
			}

		}


		public function resize():void {
			this.x=UIEnum.WIDTH - this.width;
			this.y=UIEnum.HEIGHT - this.height >> 1;
		}


	}
}

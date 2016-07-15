package com.leyou.ui.crossServer.children {
	import com.ace.gameData.manager.DataManager;

	import flash.display.Sprite;

	public class CrossServerMissionRender extends Sprite {
		private var missionProgressRender:CrossServerMissionProgressRender;

		private var missionReleaseRender:CrossServerMissionReleaseRender;

		public function CrossServerMissionRender() {
			missionProgressRender=new CrossServerMissionProgressRender();
			missionReleaseRender=new CrossServerMissionReleaseRender();
			addChild(missionProgressRender);
			addChild(missionReleaseRender);
		}

		public function updateInfo():void {
			if (0 == DataManager.getInstance().crossServerData.taskId) {
				missionProgressRender.visible=false;
				missionReleaseRender.visible=true;
				missionReleaseRender.updateInfo();
				missionProgressRender.removeTimer();
			} else {
				missionProgressRender.visible=true;
				missionReleaseRender.visible=false;
				missionProgressRender.updateInfo();
				missionProgressRender.addTimer();
			}
		}
	}
}

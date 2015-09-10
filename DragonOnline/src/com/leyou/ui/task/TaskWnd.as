package com.leyou.ui.task {

	import com.ace.config.Core;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.TweenManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.TaskEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.ui.task.child.MissionDailyRender;
	import com.leyou.ui.task.child.MissionMainRender;
	import com.leyou.utils.StringUtil_II;

	import flash.events.Event;

	public class TaskWnd extends AutoWindow {

		private var taskTabBar:TabBar;

		private var mainRender:MissionMainRender;
		private var dailyRender:MissionDailyRender;

		public function TaskWnd() {
			super(LibManager.getInstance().getXML("config/ui/TaskWnd.xml"));
			this.init();
			this.mouseChildren=this.mouseEnabled=true;
		}

		private function init():void {
			this.taskTabBar=this.getUIbyID("taskTabBar") as TabBar;

			this.mainRender=new MissionMainRender();
			this.dailyRender=new MissionDailyRender();

			this.addToPane(this.mainRender);
			this.addToPane(this.dailyRender);

			this.mainRender.x=18;
			this.mainRender.y=68;

			this.dailyRender.x=18;
			this.dailyRender.y=68;

			this.dailyRender.visible=false;
			this.taskTabBar.addEventListener(TabbarModel.changeTurnOnIndex, onChangeIndex);
		}

		private function onChangeIndex(e:Event):void {

			switch (this.taskTabBar.turnOnIndex) {
				case 0:
					this.mainRender.visible=true;
					this.dailyRender.visible=false;
					break;
				case 1:
					this.mainRender.visible=false;
					this.dailyRender.visible=true;
					GuideManager.getInstance().removeGuide(17);
					GuideManager.getInstance().removeGuide(18);
					GuideManager.getInstance().removeGuide(121);
					break;
			}

		}

		public function setVipLvState(lv:int=0):void {
			this.dailyRender.setonKeySuccState(lv);
			UIManager.getInstance().taskTrack.setDailyTaskVip(lv)
		}


		/**
		 * 更新主线数据
		 */
		public function updateData(o:Object):void {

			var tr:Array=o.tr;

			tr.sortOn("type", Array.CASEINSENSITIVE | Array.NUMERIC);
			this.mainRender.updateOtherTaskList(tr[0]);

			if (tr.length > 1) {
				this.taskTabBar.setTabVisible(1, true);
				this.dailyRender.updateInfo(tr[1]);
			}

			//广告
//			UIManager.getInstance().adWnd.showPanel();
		}

		/**
		 *
		 * @param i 0:主线; 1:日常;
		 *
		 */
		public function changeTab(i:int):void {
			this.taskTabBar.turnToTab(i)
		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);

			this.taskTabBar.setTabVisible(1, (Core.me.info.level >= ConfigEnum.taskDailyOpenLv))

			GuideManager.getInstance().removeGuide(17);
			UIManager.getInstance().taskTrack.setGuideViewhide(TaskEnum.taskType_TodayTaskSuccessNum);

			if (Core.me.info.level == ConfigEnum.taskDailyOpenLv) {
				GuideManager.getInstance().showGuide(121, this.taskTabBar.getTabButton(1));
			}

		}

		override public function sendOpenPanelProtocol(... parameters):void {
			this.dataModel=parameters;

			UIManager.getInstance().showPanelCallback(WindowEnum.TASK);
		}

		public function resize():void {

			this.x=UIEnum.WIDTH - this.width >> 1;
			this.y=UIEnum.HEIGHT - this.height >> 1;
		}

		override public function hide():void {
			super.hide();

			PopupManager.closeConfirm("onKeySuccToday");
			PopupManager.closeConfirm("loopSuccToday");

			this.taskTabBar.turnToTab(0);

			TweenManager.getInstance().lightingCompnent(UIManager.getInstance().toolsWnd.missionBtn);

			UIManager.getInstance().taskTrack.setGuideView(TaskEnum.taskType_TodayTaskSuccessNum);
		}

	}
}

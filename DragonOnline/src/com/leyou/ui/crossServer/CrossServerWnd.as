package com.leyou.ui.crossServer {
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.lable.Label;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.leyou.net.cmd.Cmd_Across;
	import com.leyou.ui.crossServer.children.CrossServerLvRender;
	import com.leyou.ui.crossServer.children.CrossServerMissionRender;
	import com.leyou.ui.crossServer.children.CrossServerOpenRender;
	import com.leyou.ui.crossServer.children.CrossServerTaskCarRender;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class CrossServerWnd extends AutoWindow {
		private var crossServerTab:TabBar;

		private var lvRender:CrossServerLvRender;

		private var missionRender:CrossServerMissionRender;

		private var taskCarRender:CrossServerTaskCarRender;

		private var openRender:CrossServerOpenRender;

		private var gxLbl:Label;

		private var gxSpt:Sprite;

		public function CrossServerWnd() {
			super(LibManager.getInstance().getXML("config/ui/crossServer/kfdtWnd.xml"));
			init();
		}

		private function init():void {
			hideBg();
			gxLbl=getUIbyID("gxLbl") as Label;
			crossServerTab=getUIbyID("crossServerTab") as TabBar;
			crossServerTab.addEventListener(TabbarModel.changeTurnOnIndex, onTabChange);

			lvRender=new CrossServerLvRender();
			missionRender=new CrossServerMissionRender();
			taskCarRender=new CrossServerTaskCarRender();
			openRender=new CrossServerOpenRender();
			crossServerTab.addToTab(lvRender, 0);
			crossServerTab.addToTab(missionRender, 1);
			crossServerTab.addToTab(taskCarRender, 2);
			crossServerTab.addToTab(openRender, 3);
			lvRender.x=-18;
			lvRender.y=10;
			missionRender.x=-18;
			missionRender.y=10;
			taskCarRender.x=-18;
			taskCarRender.y=10;
			openRender.x=-18;
			openRender.y=10;
//			clsBtn.x+=5;
			clsBtn.y+=30;
			gxSpt=new Sprite();
			gxSpt.addChild(getUIbyID("ryImg0"));
			pane.addChild(gxSpt);
			gxSpt.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
//			crossServerTab.setTabVisible(2, false);
		}

		protected function onMouseOver(event:MouseEvent):void {
			var content:String=TableManager.getInstance().getSystemNotice(9612).content;
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
		}

		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
			gxLbl.text=UIManager.getInstance().backpackWnd.gx + "";
		}

		public function changeTabIdx(idx:int):void {
			crossServerTab.turnToTab(idx);
		}

		protected function onTabChange(event:Event):void {
			switch (crossServerTab.turnOnIndex) {
				case 0:
					break;
				case 1:
					Cmd_Across.cm_ACROSS_T();
					break;
				case 2:
					Cmd_Across.cm_ACROSS_T();
					break;
			}
		}

		public override function get width():Number {
			return 738;
		}

		public override function get height():Number {
			return 559;
		}

		public function updateServerLvPage():void {
			lvRender.updateInfo();
		}

		public function updateServerTaskPage():void {
			missionRender.updateInfo();
		}

		public function updateServerCarPage():void {
			taskCarRender.updateInfo();
		}

		public function setMoudle(v:Boolean):void {
			crossServerTab.setTabVisible(0, v);
			crossServerTab.setTabVisible(1, v);
			crossServerTab.setTabVisible(2, v);
			crossServerTab.setTabVisible(3, !v);
			if (v) {
				crossServerTab.turnToTab(0);
			} else {
				crossServerTab.turnToTab(3);
			}
		}

		public function updateServerOpenPage():void {
			openRender.updateInfo();
		}
	}
}

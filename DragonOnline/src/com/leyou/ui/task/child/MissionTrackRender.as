package com.leyou.ui.task.child {

	import com.ace.config.Core;
	import com.ace.enum.CursorEnum;
	import com.ace.enum.FontEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.PriorityEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.SettingManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TPointInfo;
	import com.ace.manager.CursorManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.TaskEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Arena;
	import com.leyou.net.cmd.Cmd_Go;
	import com.leyou.net.cmd.Cmd_Qa;
	import com.leyou.net.cmd.Cmd_Tsk;
	import com.leyou.utils.FilterUtil;

	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;

	public class MissionTrackRender extends AutoSprite {

		private var taskTypeLbl:Label;
		private var taskNameLbl:Label;
		private var taskTargetLbl:Label;
		private var taskStateLbl:Label;

		private var trbtn:ImgButton;
		private var ybsuccBtn:ImgButton;
		private var yboneKeyBtn:ImgButton;

		public var flyFunc:Function;
		public var taskType:int=0;
		public var taskDtype:int=0;
		public var cloop:int=0;

		/**
		 *其他
		 */
		public var otherCallBack:Function;

		public var lastHpLbl:Label;

		public function MissionTrackRender() {
			super(LibManager.getInstance().getXML("config/ui/task/missionTrackRender.xml"));
			this.init();
			this.mouseChildren=true
			this.cacheAsBitmap=true;
		}

		private function init():void {

			this.taskTypeLbl=this.getUIbyID("taskTypeLbl") as Label;
			this.taskNameLbl=this.getUIbyID("taskNameLbl") as Label;
			this.taskTargetLbl=this.getUIbyID("taskTargetLbl") as Label;
			this.taskStateLbl=this.getUIbyID("taskStateLbl") as Label;

			this.taskNameLbl.addEventListener(TextEvent.LINK, onLink);
			this.taskNameLbl.mouseEnabled=true;
			this.taskNameLbl.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

			this.taskTargetLbl.addEventListener(TextEvent.LINK, onLink);
			this.taskTargetLbl.mouseEnabled=true;
			this.taskTargetLbl.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

			this.lastHpLbl=new Label();
			this.lastHpLbl.x=this.taskTargetLbl.x;
			this.lastHpLbl.y=this.taskTargetLbl.y + this.taskTargetLbl.height;

//			this.lastHpLbl.defaultTextFormat=FontEnum.getTextFormat("Label");
//			this.lastHpLbl.setTextFormat(FontEnum.getTextFormat("Label"));

			this.lastHpLbl.addEventListener(TextEvent.LINK, onLink);
			this.lastHpLbl.mouseEnabled=true;
			this.lastHpLbl.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

			this.addChild(this.lastHpLbl);

			this.taskNameLbl.styleSheet=FontEnum.DEFAULT_LINK_STYLE;
			this.taskTargetLbl.styleSheet=FontEnum.DEFAULT_LINK_STYLE;
			this.lastHpLbl.styleSheet=FontEnum.DEFAULT_LINK_STYLE;

			this.trbtn=new ImgButton("ui/mission/mission_quick.png", PriorityEnum.FIVE);
			this.addChild(this.trbtn);
			this.trbtn.addEventListener(MouseEvent.CLICK, onTrBtn);
			this.trbtn.addEventListener(MouseEvent.MOUSE_OVER, onTrOverBtn);
			this.trbtn.doubleClickEnabled=false;

			this.yboneKeyBtn=new ImgButton("ui/common/btn_ib.png", PriorityEnum.FIVE);
			this.addChild(this.yboneKeyBtn);
			this.yboneKeyBtn.addEventListener(MouseEvent.CLICK, onyboneKeyBtn);
			this.yboneKeyBtn.addEventListener(MouseEvent.MOUSE_OVER, onTrOverBtn);
			this.yboneKeyBtn.doubleClickEnabled=false;

			this.ybsuccBtn=new ImgButton("ui/common/btn_ib.png", PriorityEnum.FIVE);
			this.addChild(this.ybsuccBtn);
			this.ybsuccBtn.addEventListener(MouseEvent.CLICK, onybBtn);
			this.ybsuccBtn.doubleClickEnabled=false;

			this.ybsuccBtn.setToolTip(StringUtil.substitute(TableManager.getInstance().getSystemNotice(2301).content, [ConfigEnum.taskDailyCost1]));

			this.yboneKeyBtn.visible=false;
			this.ybsuccBtn.visible=false;

			this.x=10;
		}

		private function onTrOverBtn(e:MouseEvent):void {

			if (e.target == this.yboneKeyBtn) {
				this.yboneKeyBtn.setToolTip(StringUtil.substitute(TableManager.getInstance().getSystemNotice(2302).content, [(ConfigEnum.taskDailySum - int(cloop) + 1) * ConfigEnum.taskDailyCost1, DataManager.getInstance().vipData.taskPrivilegeVipLv()]));
			} else {
				var count:int=MyInfoManager.getInstance().VipLastTransterCount;
				if (count < 0)
					this.trbtn.setToolTip(StringUtil.substitute(TableManager.getInstance().getSystemNotice(9937).content, ["无限"]));
				else
					this.trbtn.setToolTip(StringUtil.substitute(TableManager.getInstance().getSystemNotice(9937).content, [count]));
			}

		}

		private function onTrOutBtn(e:MouseEvent):void {



		}

		public function taskTypeTxt(v:String):void {
			this.taskTypeLbl.text=v + "";
			this.taskTypeLbl.filters=[FilterUtil.showBorder(0x000000)];
		}

		public function taskNameTxt(v:String):void {
			this.taskNameLbl.text="";
			this.taskNameLbl.htmlText=v + "";
			this.taskNameLbl.filters=[FilterUtil.showBorder(0x000000)];

			if (this.taskType == TaskEnum.taskLevel_switchLine) {
				this.yboneKeyBtn.x=this.taskNameLbl.x + this.taskNameLbl.textWidth + 5;
				this.yboneKeyBtn.y=this.taskNameLbl.y;

//				if (this.cloop == ConfigEnum.taskDailySum)
//					this.yboneKeyBtn.visible=false;
//				else
//					this.yboneKeyBtn.visible=true;
			}

			this.trbtn.x=this.taskNameLbl.x + this.taskNameLbl.textWidth + 5;
		}

		public function setYbOnKeyVisible(v:Boolean):void {

//			if (this.cloop == ConfigEnum.taskDailySum)                                                                          )
//				this.yboneKeyBtn.visible=false;
//			else

			this.ybsuccBtn.visible=true;

			if (!v || this.taskStateLbl.text.indexOf("已完成") > -1) {
				this.yboneKeyBtn.visible=false;
				this.ybsuccBtn.visible=false;
			} else {
				this.yboneKeyBtn.visible=true;
			}
		}

		public function taskLastHpTxt(v:String):void {
			this.lastHpLbl.text="";
			this.lastHpLbl.text=v + "";
			this.lastHpLbl.filters=[FilterUtil.showBorder(0x000000)];

			this.lastHpLbl.y=this.taskTargetLbl.y + this.taskTargetLbl.height;
		}

		public function get targetVisible():Label {
			return this.taskTargetLbl;
		}

		public function setlastVisible():Label {
			return this.lastHpLbl;
		}

		public function setTrBtnVisible(v:Boolean):void {
			this.trbtn.visible=v;
		}

		public function get flyBtn():ImgButton {
			return this.trbtn;
		}

		private function onyboneKeyBtn(e:MouseEvent):void {
			PopupManager.showConfirm(StringUtil.substitute(TableManager.getInstance().getSystemNotice(2305).content, [(ConfigEnum.taskDailySum - this.cloop + 1) * ConfigEnum.taskDailyCost1]), function():void {
				Cmd_Tsk.cmTaskDailySuccess(2);
			}, null, false, "onKeySuccToday");

		}

		private function onybBtn(e:MouseEvent):void {
			PopupManager.showConfirm(StringUtil.substitute(TableManager.getInstance().getSystemNotice(2306).content, [ConfigEnum.taskDailyCost1]), function():void {
				Cmd_Tsk.cmTaskDailySuccess();
			}, null, false, "loopSuccToday");
		}

		private function onTrBtn(e:MouseEvent):void {
			if (flyFunc != null) {
				flyFunc(this.taskType);
			}
		}

		public function taskTargetTxt(v:String):void {
			this.taskTargetLbl.text="";
			this.taskTargetLbl.htmlText=v + "";
			this.taskTargetLbl.filters=[FilterUtil.showBorder(0x000000)];

			this.trbtn.x=this.taskTargetLbl.x + this.taskTargetLbl.textWidth + 5;
			this.trbtn.y=this.taskTargetLbl.y;

			if (this.taskType == TaskEnum.taskLevel_switchLine) {
				this.ybsuccBtn.x=this.trbtn.x + this.trbtn.width + 5;
				this.ybsuccBtn.y=this.taskTargetLbl.y;

//				if (this.cloop == ConfigEnum.taskDailySum)
//					this.ybsuccBtn.visible=false;
//				else
				this.ybsuccBtn.visible=true;
			}
		}

		public function taskStateTxt(v:String):void {
			this.taskStateLbl.text="";
			this.taskStateLbl.htmlText=v + "";
			this.taskStateLbl.filters=[FilterUtil.showBorder(0x000000)];
		}

		public function autoAstar(link:String):void {
			this.taskTargetLbl.dispatchEvent(new TextEvent(TextEvent.LINK, false, false, link));
		}


		private function onMouseMove(e:MouseEvent):void {

			var lb:Label=Label(e.target);
			var i:int=lb.getCharIndexAtPoint(e.localX, e.localY);
			var xmltxt:XML=XML(lb.getXMLText(i, i + 1));

			var url:String=xmltxt.textformat.@url;

//			if (url.indexOf("box") > -1 || url.indexOf("npc") > -1 || url.indexOf("monster") > -1) {
			if (url != null && url != "") {
				CursorManager.getInstance().updataCursor(CursorEnum.CURSOR_HAND);

				if (this.taskType == TaskEnum.taskLevel_switchLine && UIManager.getInstance().taskTrack.taskInfo != null) {
					ToolTipManager.getInstance().show(TipEnum.TYPE_TODAYTASK, UIManager.getInstance().taskTrack.taskInfo, new Point(e.stageX, e.stageY));
				}

			} else {
				CursorManager.getInstance().resetGameCursor();
				ToolTipManager.getInstance().hide()
			}
		}

		/**
		 * @param e
		 */
		private function onLink(e:TextEvent):void {

			var ctx:String=e.text;
			var str:Array=ctx.split("--");
			var lv:int=Core.me.info.level;

			if (this.taskType == TaskEnum.taskLevel_switchLine) {
				GuideManager.getInstance().removeGuide(104);
			}

			if (this.taskType == TaskEnum.taskLevel_switchLine && this.taskDtype == TaskEnum.taskType_Exchange) {
				UILayoutManager.getInstance().show(WindowEnum.SHOP);
				UIManager.getInstance().buyWnd.updateTask(int(str[1]), int(taskTargetLbl.text.split("/")[1].replace(")", "")));

				TweenLite.delayedCall(.5, function():void {
					UIManager.getInstance().buyWnd.show();
				});

			} else if (str[0].indexOf("monster") > -1 || str[0].indexOf("box") > -1) {
				var info:TPointInfo=TableManager.getInstance().getPointInfo(int(str[1]));

				if (info == null)
					return;

				//跨场景寻路
				Core.me.gotoMap(new Point(info.tx, info.ty), info.sceneId);
				Core.me.pInfo.currentTaskType=str[0].indexOf("monster") > -1 ? PlayerEnum.TASK_MONSTER : PlayerEnum.TASK_COLLECT;

				SettingManager.getInstance().assitInfo.startAutoTask();

			} else if (str[0].indexOf("npc") > -1) {
				Cmd_Go.cmGo(str[1]);
			} else if (str[0].indexOf("dungeon") > -1) {
				UILayoutManager.getInstance().open(WindowEnum.PKCOPY);
			} else if (str[0].indexOf("enterquest") > -1) {
				Cmd_Qa.cmQaEnter();
			} else if (str[0].indexOf("accpetArena") > -1) { //竞技场
				Cmd_Arena.cm_ArenaReward();
			} else if (str[0].indexOf("copysuccess") > -1) {

				if (lv < ConfigEnum.StoryCopyOpenLevel) {
					NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.StoryCopyOpenLevel]);
					return;
				}

				UILayoutManager.getInstance().open(WindowEnum.STORYCOPY);
//				GuideManager.getInstance().removeGuide(29);

			} else if (str[0].indexOf("equip") > -1) {
				if (lv < ConfigEnum.EquipIntensifyOpenLv) {
					NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.EquipIntensifyOpenLv]);
					return;
				}

				UILayoutManager.getInstance().open_II(WindowEnum.EQUIP)
//				GuideManager.getInstance().removeGuide(62);

			} else if (str[0].indexOf("badge") > -1) {

				if (lv < ConfigEnum.BadgeOpenLv) {
					NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.BadgeOpenLv]);
					return;
				}

				UILayoutManager.getInstance().open_II(WindowEnum.BADAGE);
//				GuideManager.getInstance().removeGuide(13);

			} else if (str[0].indexOf("elements") > -1) {

				if (lv < ConfigEnum.ElementOpenLv) {
					NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.ElementOpenLv]);
					return;
				}

				if (UIManager.getInstance().isCreate(WindowEnum.ROLE) && UIManager.getInstance().roleWnd.visible) {
					return;
				}
				
				UILayoutManager.getInstance().open_II(WindowEnum.ROLE);
				TweenLite.delayedCall(.3, UIManager.getInstance().roleWnd.setTabIndex, [3]);
//				GuideManager.getInstance().removeGuide(10);

			} else if (str[0].indexOf("mount") > -1) {

				if (lv < ConfigEnum.MountOpenLv) {
					NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.MountOpenLv]);
					return;
				}

				if (UIManager.getInstance().isCreate(WindowEnum.ROLE) && UIManager.getInstance().roleWnd.visible) {
					return;
				}

				UILayoutManager.getInstance().open_II(WindowEnum.ROLE);

				TweenLite.delayedCall(0.3, function():void {
					UILayoutManager.getInstance().show_II(WindowEnum.ROLE, WindowEnum.MOUTLVUP, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y);
					UIManager.getInstance().roleWnd.setTabIndex(1);
				});

//				GuideManager.getInstance().removeGuide(4);
				GuideManager.getInstance().removeGuide(2);
				GuideManager.getInstance().removeGuide(1);

			} else if (str[0].indexOf("todayTask") > -1) {

				if (lv < ConfigEnum.taskDailyOpenLv) {
					NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.taskDailyOpenLv]);
					return;
				}

				UILayoutManager.getInstance().open_II(WindowEnum.TASK);
				UIManager.getInstance().taskWnd.changeTab(1);
//				GuideManager.getInstance().removeGuide(18);

			} else if (str[0].indexOf("arena") > -1) {

				if (lv < ConfigEnum.ArenaOpenLv) {
					NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.ArenaOpenLv]);
					return;
				}

				UILayoutManager.getInstance().open_II(WindowEnum.ARENA);
//				GuideManager.getInstance().removeGuide(32);
			} else if (str[0].indexOf("other") > -1) {

				if (otherCallBack != null) {
					if (str[1] != "") {
						this.otherCallBack(str[1]);
					} else
						this.otherCallBack();
				}

			}


		}

		override public function get height():Number {
			return 40;
		}

	}
}

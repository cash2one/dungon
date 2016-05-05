package com.leyou.ui.task.child {

	import com.ace.config.Core;
	import com.ace.enum.CursorEnum;
	import com.ace.enum.FontEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.PriorityEnum;
	import com.ace.enum.SceneEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.proxy.ModuleProxy;
	import com.ace.game.proxy.SceneProxy;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.SettingManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TMissionDate;
	import com.ace.gameData.table.TPointInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.CursorManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.TaskEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Arena;
	import com.leyou.net.cmd.Cmd_Go;
	import com.leyou.net.cmd.Cmd_Qa;
	import com.leyou.net.cmd.Cmd_Tsk;
	import com.leyou.net.cmd.Cmd_Yct;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.TaskUtil;
	
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;

	public class missionTrackRender3 extends AutoSprite {

		private var taskTypeLbl:Label;
		private var taskNameLbl:Label;
		private var TaskStateLbl:Label;
		private var taskTargetLbl:Label;

		private var taskTypeLbl0:Label;
		private var taskNameLbl0:Label;
		private var TaskStateLbl0:Label;
		private var taskTargetLbl0:Label;

		private var taskTypeLbl1:Label;
		private var taskNameLbl1:Label;
		private var TaskStateLbl1:Label;
		private var taskTargetLbl1:Label;

		private var taskTypeLbl2:Label;
		private var taskNameLbl2:Label;
		private var TaskStateLbl2:Label;
		private var taskTargetLbl2:Label;

		private var TaskStateLbl3:Label;

		private var rewardStarArr:Array=[];

		private var renderStateBtn:TaskTrackBtn;
		private var dailyrenderStateBtn:TaskTrackBtn;
		public var rewardBtn:ImgButton;

		private var firstLogin:Boolean=true;
		public var firstAutoAstar:Boolean=true;

		/**
		 * 当前任务类型 ---
		 */
		public var currentTaskType:int=1;

		/**
		 *主线任务类型
		 */
		public var mainTaskType:int=1;

		/**
		 * taskid
		 */
		public var taskID:int=0;

		public var taskOneInfo:Object;
		public var taskLoopInfo:Object;
		private var linkArr:Array=[];
		private var taskList:Array=[];

		private var _taskInfo:Object;

		public var taskType:int=0;
		public var taskDtype:int=0;

		private var cloop:int=0;

		private var rewardStarEffect:SwfLoader;

		private var currentStar:int=0;
		private var currentTaskId:int=-1;

		private var trbtn:ImgButton;
		private var trbtn1:ImgButton;
		private var trbtn2:ImgButton;
		private var trbtn3:ImgButton;

		private var yboneKeyBtn:ImgButton;
		private var ybsuccBtn:ImgButton;

		public var mercenaryClose:int=0;
		public var mercenaryExp:int=0;
		public var mercenaryCount:int=0;

		public function missionTrackRender3() {
			super(LibManager.getInstance().getXML("config/ui/task/missionTrackRender3.xml"));
			this.init();
			this.mouseChildren=true
		}

		private function init():void {

			this.taskTypeLbl=this.getUIbyID("taskTypeLbl") as Label;
			this.taskNameLbl=this.getUIbyID("taskNameLbl") as Label;
			this.TaskStateLbl=this.getUIbyID("TaskStateLbl") as Label;
			this.taskTargetLbl=this.getUIbyID("taskTargetLbl") as Label;

			this.taskTypeLbl0=this.getUIbyID("taskTypeLbl0") as Label;
			this.taskNameLbl0=this.getUIbyID("taskNameLbl0") as Label;
			this.TaskStateLbl0=this.getUIbyID("TaskStateLbl0") as Label;
			this.taskTargetLbl0=this.getUIbyID("taskTargetLbl0") as Label;

			this.taskTypeLbl1=this.getUIbyID("taskTypeLbl1") as Label;
			this.taskNameLbl1=this.getUIbyID("taskNameLbl1") as Label;
			this.TaskStateLbl1=this.getUIbyID("TaskStateLbl1") as Label;
			this.taskTargetLbl1=this.getUIbyID("taskTargetLbl1") as Label;

			this.taskTypeLbl2=this.getUIbyID("taskTypeLbl2") as Label;
			this.taskNameLbl2=this.getUIbyID("taskNameLbl2") as Label;
			this.TaskStateLbl2=this.getUIbyID("TaskStateLbl2") as Label;
			this.taskTargetLbl2=this.getUIbyID("taskTargetLbl2") as Label;

			this.TaskStateLbl3=this.getUIbyID("TaskStateLbl3") as Label;

			this.rewardStarArr.push(this.getUIbyID("rewardStar0") as Image);
			this.rewardStarArr.push(this.getUIbyID("rewardStar1") as Image);
			this.rewardStarArr.push(this.getUIbyID("rewardStar2") as Image);
			this.rewardStarArr.push(this.getUIbyID("rewardStar3") as Image);
			this.rewardStarArr.push(this.getUIbyID("rewardStar4") as Image);

			this.rewardBtn=(this.getUIbyID("rewardBtn") as ImgButton);
			this.rewardBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.rewardStarEffect=new SwfLoader(99919);
			this.addChild(this.rewardStarEffect);

			this.rewardStarEffect.visible=false;
			this.rewardStarEffect.x=this.rewardStarArr[0].x - 30;
			this.rewardStarEffect.y=this.rewardStarArr[0].y - 30;

			this.taskTargetLbl.styleSheet=FontEnum.DEFAULT_LINK_STYLE;
			this.taskTargetLbl0.styleSheet=FontEnum.DEFAULT_LINK_STYLE;
			this.taskTargetLbl1.styleSheet=FontEnum.DEFAULT_LINK_STYLE;
			this.taskTargetLbl2.styleSheet=FontEnum.DEFAULT_LINK_STYLE;

			this.linkArr[TaskEnum.taskLevel_mainLine]=[];
			this.linkArr[TaskEnum.taskLevel_switchLine]=[];
			this.linkArr[TaskEnum.taskLevel_mercenaryExpLine]=[];
			this.linkArr[TaskEnum.taskLevel_mercenaryCloseLine]=[];

			/**
			this.renderStateBtn=new TaskTrackBtn();
			this.addChild(this.renderStateBtn);

			this.renderStateBtn.x=29;
			this.renderStateBtn.y=48;

			this.renderStateBtn.visible=false;

			this.dailyrenderStateBtn=new TaskTrackBtn();
			this.addChild(this.dailyrenderStateBtn);

			this.dailyrenderStateBtn.visible=false;
//			this.renderStateBtn.addEventListener(MouseEvent.CLICK, onClick);
//			this.dailyrenderStateBtn.addEventListener(MouseEvent.CLICK, onClick);
**/

			this.TaskStateLbl3.addEventListener(MouseEvent.CLICK, ontaskClick);
			this.TaskStateLbl3.mouseEnabled=true;

			this.TaskStateLbl3.visible=false;

			this.taskTargetLbl.addEventListener(TextEvent.LINK, onLink);
			this.taskTargetLbl.mouseEnabled=true;
//			this.taskTargetLbl.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

			this.taskTargetLbl0.addEventListener(TextEvent.LINK, onLink);
			this.taskTargetLbl0.mouseEnabled=true;
			this.taskTargetLbl0.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

			this.taskTargetLbl1.addEventListener(TextEvent.LINK, onLink);
			this.taskTargetLbl1.mouseEnabled=true;
//			this.taskTargetLbl0.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

			this.taskTargetLbl2.addEventListener(TextEvent.LINK, onLink);
			this.taskTargetLbl2.mouseEnabled=true;
//			this.taskTargetLbl0.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

			this.rewardBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.rewardBtn.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);

			this.trbtn=new ImgButton("ui/mission/mission_quick.png", PriorityEnum.FIVE);
			this.addChild(this.trbtn);
			this.trbtn.addEventListener(MouseEvent.CLICK, onFly);
			this.trbtn.addEventListener(MouseEvent.MOUSE_OVER, onTrOverBtn);
			this.trbtn.doubleClickEnabled=false;

			this.trbtn1=new ImgButton("ui/mission/mission_quick.png", PriorityEnum.FIVE);
			this.addChild(this.trbtn1);
			this.trbtn1.addEventListener(MouseEvent.CLICK, onFly);
			this.trbtn1.addEventListener(MouseEvent.MOUSE_OVER, onTrOverBtn);
			this.trbtn1.doubleClickEnabled=false;

			this.trbtn2=new ImgButton("ui/mission/mission_quick.png", PriorityEnum.FIVE);
			this.addChild(this.trbtn2);
			this.trbtn2.addEventListener(MouseEvent.CLICK, onFly);
			this.trbtn2.addEventListener(MouseEvent.MOUSE_OVER, onTrOverBtn);
			this.trbtn2.doubleClickEnabled=false;

			this.trbtn3=new ImgButton("ui/mission/mission_quick.png", PriorityEnum.FIVE);
			this.addChild(this.trbtn3);
			this.trbtn3.addEventListener(MouseEvent.CLICK, onFly);
			this.trbtn3.addEventListener(MouseEvent.MOUSE_OVER, onTrOverBtn);
			this.trbtn3.doubleClickEnabled=false;

			this.yboneKeyBtn=new ImgButton("ui/common/btn_ib.png", PriorityEnum.FIVE);
			this.addChild(this.yboneKeyBtn);
			this.yboneKeyBtn.addEventListener(MouseEvent.CLICK, onyboneKeyBtn);
			this.yboneKeyBtn.addEventListener(MouseEvent.MOUSE_OVER, onTrOverBtn);
			this.yboneKeyBtn.doubleClickEnabled=false;

			this.ybsuccBtn=new ImgButton("ui/common/btn_ib.png", PriorityEnum.FIVE);
			this.addChild(this.ybsuccBtn);
			this.ybsuccBtn.addEventListener(MouseEvent.CLICK, onybBtn);
			this.ybsuccBtn.doubleClickEnabled=false;

			if (Core.isSF)
				this.ybsuccBtn.setToolTip(StringUtil.substitute(TableManager.getInstance().getSystemNotice(30002).content, [ConfigEnum.taskDailyCost1.split("|")[0]]));
			else
				this.ybsuccBtn.setToolTip(StringUtil.substitute(TableManager.getInstance().getSystemNotice(2301).content, [ConfigEnum.taskDailyCost1.split("|")[0]]));

			this.yboneKeyBtn.visible=false;
			this.ybsuccBtn.visible=false;

			this.trbtn2.visible=false;
			this.trbtn3.visible=false;
		}

		private function onyboneKeyBtn(e:MouseEvent):void {
			var str:String;
			if (Core.isSF) {
				str=StringUtil.substitute(TableManager.getInstance().getSystemNotice(30004).content, [(ConfigEnum.taskDailySum - this.cloop + 1) * int(ConfigEnum.taskDailyCost1.split("|")[0])])
			} else {
				str=StringUtil.substitute(TableManager.getInstance().getSystemNotice(2305).content, [(ConfigEnum.taskDailySum - this.cloop + 1) * int(ConfigEnum.taskDailyCost1.split("|")[0])])
			}

			var i1:int=int(ConfigEnum.taskDailyCost1.split("|")[0]);
			var i2:int=int(ConfigEnum.taskDailyCost1.split("|")[1]);
			PopupManager.showRadioConfirm(str, ((ConfigEnum.taskDailySum - this.cloop + 1) * i1) + "", ((ConfigEnum.taskDailySum - this.cloop + 1) * i2) + "", function(i:int):void {
				Cmd_Tsk.cmTaskDailySuccess(2, (i == 0 ? 1 : 0));
			}, null, false, "onKeySuccToday");

		}

		private function onybBtn(e:MouseEvent):void {
			var str:String;
			if (Core.isSF) {
				str=StringUtil.substitute(TableManager.getInstance().getSystemNotice(30005).content, [ConfigEnum.taskDailyCost1.split("|")[0]])
			} else {
				str=StringUtil.substitute(TableManager.getInstance().getSystemNotice(2306).content, [ConfigEnum.taskDailyCost1.split("|")[0]])
			}

			PopupManager.showRadioConfirm(str, ConfigEnum.taskDailyCost1.split("|")[0] + "", ConfigEnum.taskDailyCost1.split("|")[1] + "", function(i:int):void {
				Cmd_Tsk.cmTaskDailySuccess(1, (i == 0 ? 1 : 0));
			}, null, false, "loopSuccToday");
		}

		private function onTrOverBtn(e:MouseEvent):void {

			if (e.target == this.yboneKeyBtn) {

				if (Core.isSF)
					this.yboneKeyBtn.setToolTip(StringUtil.substitute(TableManager.getInstance().getSystemNotice(30003).content, [(ConfigEnum.taskDailySum - int(cloop) + 1) * int(ConfigEnum.taskDailyCost1.split("|")[0]), DataManager.getInstance().vipData.taskPrivilegeVipLv()]));
				else
					this.yboneKeyBtn.setToolTip(StringUtil.substitute(TableManager.getInstance().getSystemNotice(2302).content, [(ConfigEnum.taskDailySum - int(cloop) + 1) * int(ConfigEnum.taskDailyCost1.split("|")[0]), DataManager.getInstance().vipData.taskPrivilegeVipLv()]));

			} else {

				var count:int=MyInfoManager.getInstance().VipLastTransterCount;
				if (count < 0) {
					this.trbtn.setToolTip(StringUtil.substitute(TableManager.getInstance().getSystemNotice(9937).content, [PropUtils.getStringById(1890)]));
					this.trbtn1.setToolTip(StringUtil.substitute(TableManager.getInstance().getSystemNotice(9937).content, [PropUtils.getStringById(1890)]));
				} else {
					this.trbtn.setToolTip(StringUtil.substitute(TableManager.getInstance().getSystemNotice(9937).content, [count]));
					this.trbtn1.setToolTip(StringUtil.substitute(TableManager.getInstance().getSystemNotice(9937).content, [count]));
				}
			}
		}

		private function onMouseOver(e:MouseEvent):void {
			if (int(ConfigEnum.taskDailyCost2) <= UIManager.getInstance().backpackWnd.jb)
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(2303).content, [ConfigEnum.taskDailyCost2]), new Point(e.stageX, e.stageY));
			else
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(2304).content, new Point(e.stageX, e.stageY));
		}

		private function onMouseOut(e:MouseEvent):void {
			ToolTipManager.getInstance().hide();
		}

		private function onLink(e:TextEvent):void {

			if (!this.visible || MapInfoManager.getInstance().type != SceneEnum.SCENE_TYPE_PTCJ)
				return;

			var ctx:String=e.text;
			var str:Array=ctx.split("--");
			var lv:int=Core.me.info.level;

//			ModuleProxy.showChatMsg("30后+++++模拟触发下一个任务---text>>>" + ctx);
//			trace("30后+++++模拟触发下一个任务---text>>>" + ctx);
			
			if (this.taskTargetLbl0 == e.target) {
				GuideManager.getInstance().removeGuide(159);
			}

			if (str[0].indexOf("mercenary") > -1) {

				if (this.taskDtype == TaskEnum.taskType_Mercenary)
					UIOpenBufferManager.getInstance().open(WindowEnum.PET);
				else if (str[1].indexOf("close") > -1) {
					UIOpenBufferManager.getInstance().open(WindowEnum.PET);

					TweenLite.delayedCall(.3, function():void {
						UIManager.getInstance().petWnd.updateQmd(DataManager.getInstance().petData.qmdPetId);
					});
				} else if (str[1].indexOf("exp") > -1) {
					UIOpenBufferManager.getInstance().open(WindowEnum.PET);

					TweenLite.delayedCall(.3, function():void {
						UIManager.getInstance().petWnd.updateLv(DataManager.getInstance().petData.lvPetId);
					});
				}

			} else if (this.taskTargetLbl0 == e.target && this.taskDtype == TaskEnum.taskType_Exchange) {
				UILayoutManager.getInstance().show(WindowEnum.SHOP);
				UIManager.getInstance().buyWnd.updateTask(int(str[1]), int(taskTargetLbl0.text.split("/")[1].replace(")", "")));

				TweenLite.delayedCall(.3, function():void {
					UIManager.getInstance().buyWnd.show();
				});

			} else if (str[0].indexOf("monster") > -1 || str[0].indexOf("box") > -1) {
				var info:TPointInfo=TableManager.getInstance().getPointInfo(int(str[1]));

				if (info == null)
					return;

//				ModuleProxy.showChatMsg("30后+++++模拟触发下一个任务--monster>>>" + str);
//				trace("30后+++++模拟触发下一个任务--monster>>>" + str);
				//跨场景寻路
				Core.me.gotoMap(new Point(info.tx, info.ty), info.sceneId);
				Core.me.pInfo.currentTaskType=str[0].indexOf("monster") > -1 ? PlayerEnum.TASK_MONSTER : PlayerEnum.TASK_COLLECT;

				SettingManager.getInstance().assitInfo.startAutoTask();

			} else if (str[0].indexOf("npc") > -1) {
//				ModuleProxy.showChatMsg("30后+++++模拟触发下一个任务--npc>>>" + str);
//				trace("30后+++++模拟触发下一个任务--npc>>>" + str);
				Cmd_Go.cmGo(str[1]);
//				TweenLite.delayedCall(0.3, Cmd_Go.cmGo, [str[1]]);
				GuideManager.getInstance().removeGuide(8);
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

				UILayoutManager.getInstance().open_II(WindowEnum.DUNGEON_TEAM);
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

				if (!UIManager.getInstance().isCreate(WindowEnum.ELEMENT) || !UIManager.getInstance().getWindow(WindowEnum.ELEMENT).visible)
					UIOpenBufferManager.getInstance().open(WindowEnum.ELEMENT);

				TweenLite.delayedCall(0.3, function():void {
					if (DataManager.getInstance().elementData.ctype != 0) {
						UILayoutManager.getInstance().show(WindowEnum.ELEMENT, WindowEnum.ELEMENT_UPGRADE);
					}
				});

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

//				if (lv < ConfigEnum.taskDailyOpenLv) {
//					NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.taskDailyOpenLv]);
//					return;
//				}
//
//				UILayoutManager.getInstance().open_II(WindowEnum.TASK);
//				UIManager.getInstance().taskWnd.changeTab(1);


			} else if (str[0].indexOf("arena") > -1) {

				if (lv < ConfigEnum.ArenaOpenLv) {
					NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.ArenaOpenLv]);
					return;
				}

				UILayoutManager.getInstance().open_II(WindowEnum.ARENA);
//				GuideManager.getInstance().removeGuide(32);
			} else if (str[0].indexOf("link") > -1) {
				this.autoComplete();
			}


		}

		private function onMouseMove(e:MouseEvent):void {

			var lb:Label=Label(e.target);
			var i:int=lb.getCharIndexAtPoint(e.localX, e.localY);
			var xmltxt:XML=XML(lb.getXMLText(i, i + 1));

			var url:String=xmltxt.textformat.@url;

//			if (url.indexOf("box") > -1 || url.indexOf("npc") > -1 || url.indexOf("monster") > -1) {
			if (url != null && url != "") {
				CursorManager.getInstance().updataCursor(CursorEnum.CURSOR_HAND);

				if (this.taskInfo != null) {
					ToolTipManager.getInstance().show(TipEnum.TYPE_TODAYTASK, this.taskInfo, new Point(e.stageX, e.stageY));
				}

			} else {
				CursorManager.getInstance().resetGameCursor();
				ToolTipManager.getInstance().hide()
			}
		}

		private function onClick(e:MouseEvent):void {
			Cmd_Tsk.cmTaskDailyStar();
		}

		/**
		 * @param count
		 */
		public function updateStar(count:int):void {
			for (var i:int=0; i < 5; i++) {
				if (i < count) {
					this.rewardStarArr[i].updateBmp("ui/equip/equip_star.png");
				} else {
					this.rewardStarArr[i].updateBmp("ui/equip/equip_star2.png");
				}
			}
		}

		/**
		 *
		 * @param v
		 *
		 */
		private function setStarVisible(v:Boolean):void {
			for (var i:int=0; i < this.rewardStarArr.length; i++) {
				this.rewardStarArr[i].visible=v;
			}
		}

		public function updateInfo(o:Object):void {
			this.updateTaskItem(o);

			this.firstAutoAstar=false;
		}

		private function updateTaskItem(o:Object):void {

			if (this.taskOneInfo != null && this.taskOneInfo.tid == o.tid && this.taskOneInfo.st == o.st && this.taskOneInfo["var"] == o["var"]) {
//				this.taskCount=100;
				return;
			}

			if (int(o.type) == TaskEnum.taskLevel_mercenaryCloseLine || int(o.type) == TaskEnum.taskLevel_mercenaryExpLine) {
				this.setMercenary(1, true);
				this.setMercenary(2, true);
			} else {
				this.setMercenary(1, false);
				this.setMercenary(2, false);
			}

			var minfo:TMissionDate;
			var item:MissionTrackRender;

			if (o.hasOwnProperty("tid")) {

				//目标字段
				minfo=TableManager.getInstance().getMissionDataByID(o.tid);


//				if (o.tid == 23)
//					GuideManager.getInstance().showGuide(67, item.flyBtn);

//				if (o.tid == 1) {
//					UIManager.getInstance().showWindow(WindowEnum.FIRST_LOGIN);
//				} else {
//					if (this.taskOneInfo == null)
//						UIManager.getInstance().postWnd.updateLoade();
//				}

				var tartxt:String;
				this.linkArr[int(minfo.type)].length=0;
				this.taskType=minfo.type;
				this.taskDtype=minfo.dtype;

				//如果没完成
				if (o.st != 1) {

					tartxt=TaskEnum.taskTypeDesc[int(minfo.dtype) - 1];
					var tarval:Array=TaskEnum.taskTypeNpcField[int(minfo.dtype) - 1];
					var i:int=0;

					var bname:String;
					var bid:String;

					while (tartxt.indexOf("##") > -1) {

						if (int(minfo.dtype) == TaskEnum.taskType_Mercenary) {
							tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:mercenary'>" + TableManager.getInstance().getPetInfo(minfo[tarval[i]]).name + "</a></u></font>");
						} else if (tarval[i].indexOf("num") > -1 || tarval[i].indexOf("Num") > -1 || tarval[i].indexOf("number") > -1) {
							tartxt=tartxt.replace("##", "<font color='#ff0000'>(" + o["var"] + "/" + minfo[tarval[i]] + ")</font>");
						} else if (tarval[i].indexOf("lv") > -1) {
							tartxt=tartxt.replace("##", "<font color='#ff0000'>(" + minfo[tarval[i]] + ")</font>");
						} else {

							if (int(minfo.dtype) == TaskEnum.taskType_upgrade) {
								tartxt=tartxt.replace("##", "<font color='#ff0000'>" + minfo[tarval[i]] + "</font>");
							} else {

								bname=String(tarval[i]).split("_")[0] + "_id";

								if (tarval[i].indexOf("Y_Currency") > -1) { // || bname.indexOf("box") > -1) {
									tartxt=tartxt.replace("##", "<font color='#ff0000'>" + minfo[tarval[i]] + "</font>");
								} else if (int(minfo.dtype) == TaskEnum.taskType_Delivery) {
									this.linkArr[int(minfo.type)].push(tarval[0]);
									tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:" + tarval[0] + "'>" + TaskUtil.getTaskTargetName("npc_id", 47) + "</a></u></font>");
								} else if (bname.indexOf("npc") > -1) { // || bname.indexOf("box") > -1) {
									this.linkArr[int(minfo.type)].push(bname + "--" + minfo[bname]);
									tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:" + bname + "--" + minfo[bname] + "'>" + TaskUtil.getTaskTargetName(tarval[i], minfo[tarval[i]]) + "</a></u></font>");
								} else {
									this.linkArr[int(minfo.type)].push(bname + "--" + minfo.target_point);

									if (int(minfo.dtype) == TaskEnum.taskType_killBossDrop)
										tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:" + String(tarval[0]).split("_")[0] + "_id" + "--" + minfo.target_point + "'>" + TaskUtil.getTaskTargetName(tarval[i], minfo[tarval[i]]) + "</a></u></font>");
									else if (int(minfo.dtype) == TaskEnum.taskType_collect)
										tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:" + String(tarval[0]).split("_")[0] + "_id" + "--" + minfo.target_point + "'>" + TaskUtil.getTaskTargetName(tarval[i], minfo[tarval[i]]) + "</a></u></font>");
									else if (int(minfo.dtype) == TaskEnum.taskType_Exchange) {
										tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:" + bname + "--" + minfo.item_id + "'>" + TaskUtil.getTaskTargetName(tarval[i], minfo[tarval[i]]) + "</a></u></font>");
										this.linkArr[int(minfo.type)][0]=bname + "--" + minfo.item_id;
									} else if (int(minfo.dtype) == TaskEnum.taskType_CopySuccess) {
										tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:copysuccess'>" + TableManager.getInstance().getCopyInfo(minfo[tarval[i]]).name + "</a></u></font>");
									} else if (int(minfo.dtype) == TaskEnum.taskType_ElementFlagNum) {
										tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:elements'>" + minfo[tarval[i]] + "</a></u></font>");
									} else
										tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:" + bname + "--" + minfo.target_point + "'>" + TaskUtil.getTaskTargetName(tarval[i], minfo[tarval[i]]) + "</a></u></font>");
								}
							}

						}

						i++;
					}

//					if (o.st == -1) {
//						this.renderStateBtn.updateIcon(0);
//					} else {
//						this.renderStateBtn.updateIcon(1);
//					}

				} else if (o.st == 1) {

					if (int(minfo.type) == TaskEnum.taskLevel_mainLine) {
//						this.renderStateBtn.updateIcon(2);
//						item.targetVisible.visible=true;
						this.linkArr[int(minfo.type)].push("npc_id--" + minfo["dnpc"]);
						tartxt=StringUtil.substitute(PropUtils.getStringById(1894), ["<font color='#00ff00'><u><a href='event:" + this.linkArr[int(minfo.type)][0] + "'>" + TaskUtil.getTaskTargetName("npc_id", minfo.dnpc) + "</a></u></font>"]);
					} else if (int(minfo.type) == TaskEnum.taskLevel_mercenaryCloseLine || int(minfo.type) == TaskEnum.taskLevel_mercenaryExpLine) {
//						tartxt=StringUtil.substitute(PropUtils.getStringById(1894), ["<font color='#00ff00'><u><a href='event:" + this.linkArr[int(minfo.type)][0] + "'>" + TaskUtil.getTaskTargetName("npc_id", minfo.dnpc) + "</a></u></font>"]);
					}

				} else if (o.st == -1) {


				}
				

				var stateTxt:String;
				if (int(o.st) == 0 && o["var"] == 0) {
					stateTxt="ee2211";

					if (int(minfo.type) == TaskEnum.taskLevel_mainLine) {
						if (this.linkArr[int(minfo.type)][0] != null && !this.firstAutoAstar)
							this.autoAstar(this.linkArr[int(minfo.type)][0]);
					}

				} else if (int(o.st) == 1) {
					stateTxt="00ff9c";

					if (int(minfo.type) == TaskEnum.taskLevel_mainLine) {
						if (this.linkArr[int(minfo.type)][this.linkArr[int(minfo.type)].length - 1] != null && !this.firstAutoAstar)
							this.autoAstar(this.linkArr[int(minfo.type)][this.linkArr[int(minfo.type)].length - 1]);
					}
				}


				if (int(minfo.type) == TaskEnum.taskLevel_mainLine) {

					taskID=o.tid;
					this.mainTaskType=int(minfo.dtype);

					MyInfoManager.getInstance().isTaskOk=(o.st == 1);
					MyInfoManager.getInstance().currentTaskId=taskID=o.tid;

//					this.renderStateBtn.y=item.height + 10;
//					this.renderStateBtn.x=50;

//					this.renderStateBtn.addEventListener(MouseEvent.CLICK, ontaskClick);
//					this.taskCount+=(this.renderStateBtn.height + 20);

//					if (o.tid == 96)
//						GuideManager.getInstance().showGuide(104, this); //.getWidget("expCopyBtn"));

//					if (o.tid == TableManager.getInstance().getGuideInfo(83).act_con) {
//						GuideManager.getInstance().showGuide(83, UIManager.getInstance().rightTopWnd.getWidget("teamCopyBtn"));
//					} else
//						GuideManager.getInstance().removeGuide(83);

					this.taskNameLbl.htmlText="" + (minfo.name);

					if (o.st == 0) {

						var dc:Number=.3;
						var lv:int=Core.me.info.level;

						if (this.mainTaskType == TaskEnum.taskType_EquitTopLv) {

							if (lv < ConfigEnum.EquipIntensifyOpenLv) {
								NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.EquipIntensifyOpenLv]);

							}

							if (!UIManager.getInstance().isCreate(WindowEnum.EQUIP) || !UIManager.getInstance().equipWnd.visible)
								UILayoutManager.getInstance().show_II(WindowEnum.EQUIP)
						} else if (this.mainTaskType == TaskEnum.taskType_BadgeNodeNum) {

							if (lv < ConfigEnum.BadgeOpenLv) {
								NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.BadgeOpenLv]);
							}

							if (!UIManager.getInstance().isCreate(WindowEnum.BADAGE) || !UIManager.getInstance().badgeWnd.visible)

								UILayoutManager.getInstance().show_II(WindowEnum.BADAGE);
						} else if (this.mainTaskType == TaskEnum.taskType_MountLv) {

							if (lv < ConfigEnum.MountOpenLv) {
								NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.MountOpenLv]);
							}

							if (!UIManager.getInstance().isCreate(WindowEnum.ROLE) || !UIManager.getInstance().roleWnd.visible)
								UILayoutManager.getInstance().show_II(WindowEnum.ROLE);

							TweenLite.delayedCall(.3, function():void {
								UIManager.getInstance().roleWnd.setTabIndex(1);
							});

							if (this.taskOneInfo == null)
								dc=2;

							TweenLite.delayedCall(dc, function():void {
								UILayoutManager.getInstance().show_II(WindowEnum.ROLE, WindowEnum.MOUTLVUP);
							});

						} else if (this.mainTaskType == TaskEnum.taskType_CopySuccess) {

							if (lv < ConfigEnum.StoryCopyOpenLevel) {
								NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.StoryCopyOpenLevel]);

							}

							if (!UIManager.getInstance().teamCopyWnd || !UIManager.getInstance().teamCopyWnd.visible)
								UILayoutManager.getInstance().open_II(WindowEnum.DUNGEON_TEAM);
						} else if (this.mainTaskType == TaskEnum.taskType_TodayTaskSuccessNum) {

//							if (lv < ConfigEnum.taskDailyOpenLv) {
//								NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.taskDailyOpenLv]);
//							}
//
//							if (!UIManager.getInstance().isCreate(WindowEnum.TASK) || !UIManager.getInstance().taskWnd.visible)
//								UILayoutManager.getInstance().show_II(WindowEnum.TASK);
//
//							TweenLite.delayedCall(0.3, UIManager.getInstance().taskWnd.changeTab, [1]);
//							TweenLite.delayedCall(0.3, GuideManager.getInstance().showGuide, [104, UIManager.getInstance().taskWnd]);
							
//							GuideManager.getInstance().showGuide(159);
							
						} else if (this.mainTaskType == TaskEnum.taskType_ElementFlagNum) {
							if (lv < ConfigEnum.ElementOpenLv) {
								NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.ElementOpenLv]);
							}

							//							if (!UIManager.getInstance().isCreate(WindowEnum.ROLE) || !UIManager.getInstance().roleWnd.visible)

							if (!UIManager.getInstance().isCreate(WindowEnum.ELEMENT) || !UIManager.getInstance().getWindow(WindowEnum.ELEMENT).visible)
								UIOpenBufferManager.getInstance().open(WindowEnum.ELEMENT);

							if (this.taskOneInfo == null)
								dc=2;

							TweenLite.delayedCall(dc, function():void {
								if (DataManager.getInstance().elementData.ctype != 0) {
									UILayoutManager.getInstance().show(WindowEnum.ELEMENT, WindowEnum.ELEMENT_UPGRADE);
								}
							});
								//							
								//
								//							TweenLite.delayedCall(dc, UIManager.getInstance().roleWnd.setTabIndex, [3]);
						} else if (this.mainTaskType == TaskEnum.taskType_ArenaPkNum) {
							if (lv < ConfigEnum.ArenaOpenLv) {
								NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.ArenaOpenLv]);
							}

							if (!UIManager.getInstance().isCreate(WindowEnum.ARENA) || !UIManager.getInstance().arenaWnd.visible)
								UILayoutManager.getInstance().show_II(WindowEnum.ARENA);
						} else if (this.mainTaskType == TaskEnum.taskType_Mercenary) {

							if (UIManager.getInstance().isCreate(WindowEnum.PET) && UIManager.getInstance().petWnd.visible) {
								return;
							}

							UIOpenBufferManager.getInstance().open(WindowEnum.PET);
								//							TweenLite.delayedCall(0.6, GuideManager.getInstance().showGuide, [123, UIManager.getInstance().petWnd.getBuyBtn()]);
//							TweenLite.delayedCall(0.6, GuideManager.getInstance().showGuide, [123, UIManager.getInstance().petWnd]);
						} else if (this.mainTaskType == TaskEnum.taskType_UpgradeMainSkill) {

							if (UIManager.getInstance().isCreate(WindowEnum.SKILL) && UIManager.getInstance().skillWnd.visible) {
								return;
							}

							UILayoutManager.getInstance().show_II(WindowEnum.SKILL);
							TweenLite.delayedCall(0.3, UIManager.getInstance().skillWnd.setTabIndex, [0]);
						} else if (this.mainTaskType == TaskEnum.taskType_UpgradePassivitySkill) {

							if (UIManager.getInstance().isCreate(WindowEnum.SKILL) && UIManager.getInstance().skillWnd.visible) {
								return;
							}

							UILayoutManager.getInstance().show_II(WindowEnum.SKILL);
							TweenLite.delayedCall(0.3, UIManager.getInstance().skillWnd.setTabIndex, [1]);

						} else if (this.mainTaskType == TaskEnum.taskType_Delivery) {

							//							if (UIManager.getInstance().deliveryWnd.visible) {
							//								return;
							//							}
							//
							//							UIManager.getInstance().deliveryWnd(WindowEnum.DELIVERY);
						} else if (this.mainTaskType == TaskEnum.taskType_Gem) {

							if (UIManager.getInstance().isCreate(WindowEnum.ROLE) && UIManager.getInstance().roleWnd.visible) {
								return;
							}

							UILayoutManager.getInstance().show_II(WindowEnum.ROLE);

							TweenLite.delayedCall(1.2, function():void {
								UIManager.getInstance().roleWnd.setTabIndex(2);
							});
						} else if (this.mainTaskType == TaskEnum.taskType_UpgradeGem) {

							if (UIManager.getInstance().isCreate(WindowEnum.GEM_LV) && UIManager.getInstance().gemLvWnd.visible) {
								return;
							}

							UILayoutManager.getInstance().show(WindowEnum.GEM_LV);
						} else if (this.mainTaskType == TaskEnum.taskType_Guild) {

							if (UIManager.getInstance().isCreate(WindowEnum.GUILD) && UIManager.getInstance().guildWnd.visible) {
								return;
							}

							UILayoutManager.getInstance().show_II(WindowEnum.GUILD);
						} else if (this.mainTaskType == TaskEnum.taskType_Fram) {

							if (UIManager.getInstance().isCreate(WindowEnum.FARM) && UIManager.getInstance().farmWnd.visible) {
								return;
							}

							UIOpenBufferManager.getInstance().open(WindowEnum.FARM);
						} else if (this.mainTaskType == TaskEnum.taskType_EquipUpgrade) {

							if (UIManager.getInstance().isCreate(WindowEnum.EQUIP) && UIManager.getInstance().equipWnd.visible) {
								return;
							}

							UILayoutManager.getInstance().show(WindowEnum.EQUIP);
							TweenLite.delayedCall(0.3, function():void {
								UIManager.getInstance().equipWnd.changeTable(5);

								var info:Array=MyInfoManager.getInstance().getBagItemArrByid(6015);
								if (info != null && info.length >= 2) {
									UIManager.getInstance().equipWnd.LvupRender.setDownItemII(info[0]);
									UIManager.getInstance().equipWnd.LvupRender.setDownItemII(info[1]);
								}
							});
						} else if (this.mainTaskType == TaskEnum.taskType_SaveElement) {

							if (UIManager.getInstance().isCreate(WindowEnum.ELEMENT) && UIManager.getInstance().elementWnd.visible) {
								return;
							}

							if (!UIManager.getInstance().isCreate(WindowEnum.ELEMENT) || !UIManager.getInstance().getWindow(WindowEnum.ELEMENT).visible)
								UIOpenBufferManager.getInstance().open(WindowEnum.ELEMENT);
						}

					}


					if (o.st != 1) {
//						GuideManager.getInstance().showGuide(19, this.renderStateBtn);

					} else if (o.st == 1) {

						if (this.mainTaskType == TaskEnum.taskType_BadgeNodeNum || this.mainTaskType == TaskEnum.taskType_MountLv || this.mainTaskType == TaskEnum.taskType_CopySuccess || this.mainTaskType == TaskEnum.taskType_TodayTaskSuccessNum || this.mainTaskType == TaskEnum.taskType_ElementFlagNum || this.mainTaskType == TaskEnum.taskType_ArenaPkNum || this.mainTaskType == TaskEnum.taskType_EquitTopLv || this.mainTaskType == TaskEnum.taskType_killBoss || this.mainTaskType == TaskEnum.taskType_killBossDrop || this.mainTaskType == TaskEnum.taskType_collect) {
							if (this.firstLogin) {
								this.firstLogin=false;
							} else
								SceneProxy.onTaskComplete();
						}

//						this.setGuideView(this.mainTaskType);
//						this.setGuideViewhide(this.mainTaskType);
//						GuideManager.getInstance().removeGuide(19);

						if (Core.me != null)
							Core.me.clearTarget();
					}

					if (o.st != 1 && (this.mainTaskType == TaskEnum.taskType_upgrade || this.mainTaskType >= TaskEnum.taskType_TodayTaskSuccessNum))
						this.trbtn.visible=false;
					else
						this.trbtn.visible=true;

					this.taskTargetLbl.htmlText="" + tartxt;
					this.TaskStateLbl.htmlText="<font color='#" + stateTxt + "'>" + TaskUtil.getStringByState(int(o.st)) + "</font>";
					this.taskTypeLbl.htmlText="[" + TaskUtil.getStringByType(int(minfo.type)) + "]";

					/**特殊处理*/
					if (o.st == 0) {
						if ([17, 11, 12, 13, 14, 10, 23, 16, 18, 24, 25, 15, 21, 20].indexOf(this.mainTaskType) > -1) {
							this.taskTargetLbl.htmlText="<font color='#00ff00'><u><a href='event:link--link'>" + this.taskTargetLbl.text + "</a></u></font>";
						}
					}

				} else if (int(minfo.type) == TaskEnum.taskLevel_switchLine) {
					this.cloop=int(o.cloop);
					this.taskNameLbl0.htmlText=PropUtils.getStringById(2470) + "";
					this.TaskStateLbl0.htmlText="<font color='#ff0000'>(" + o.cloop + "/20)</font>";
					this.taskTargetLbl0.htmlText="" + tartxt;

					if (o.st == 1)
						SceneProxy.onTaskComplete();

					if (o.st != 1 && int(minfo.dtype) == TaskEnum.taskType_Exchange)
						this.trbtn1.visible=(false);
					else
						this.trbtn1.visible=(true);

					this.setYbOnKeyVisible(Core.me.info.vipLv >= DataManager.getInstance().vipData.taskPrivilegeVipLv());
//					UIManager.getInstance().taskWnd.setVipLvState(Core.me.info.vipLv);
//					this.setStarVisible(true);
//					this.rewardBtn.visible=true;
				} else if (int(minfo.type) == TaskEnum.taskLevel_mercenaryCloseLine) {
					this.taskTypeLbl1.text=PropUtils.getStringById(2460) + "";
					this.taskNameLbl1.htmlText=PropUtils.getStringById(2461) + "";
					this.TaskStateLbl1.text="(" + MyInfoManager.getInstance().mercenaryClose + "/" + MyInfoManager.getInstance().mercenaryCount + ")";

					if (o.st == 1) {
//						if (item.targetVisible.visible) {
						SceneProxy.onTaskComplete();
//							this.taskNameLbl1.htmlText=(minfo.name + " <font color='#00ff00'><u><a href='event:mercenary--'>领取奖励</a></u></font>");
//							item.setTrBtnVisible(false);
//						}

						this.taskTargetLbl1.htmlText="<font color='#00ff00'><u><a href='event:mercenary--close'>" + PropUtils.getStringById(1575) + "</a></u></font>";
						this.trbtn2.visible=false;
					} else {
//						item.setTrBtnVisible(true);
						this.taskTargetLbl1.htmlText="" + tartxt;
						this.trbtn2.visible=true;
					}


//					this.setMercenary(1, true);
				} else if (int(minfo.type) == TaskEnum.taskLevel_mercenaryExpLine) {
					this.taskTypeLbl2.text=PropUtils.getStringById(2460) + "";
					this.taskNameLbl2.htmlText=PropUtils.getStringById(2469) + "";
					this.TaskStateLbl2.text="(" + MyInfoManager.getInstance().mercenaryExp + "/" + MyInfoManager.getInstance().mercenaryCount + ")";

					if (o.st == 1) {

//						if (item.targetVisible.visible) {
						SceneProxy.onTaskComplete();
//							this.taskNameLbl2.htmlText=(minfo.name + " <font color='#00ff00'><u><a href='event:mercenary--'>领取奖励</a></u></font>");
//							item.setTrBtnVisible(false);
//							item.targetVisible.visible=false;
//						}
						this.taskTargetLbl2.htmlText="<font color='#00ff00'><u><a href='event:mercenary--exp'>" + PropUtils.getStringById(1575) + "</a></u></font>";
						this.trbtn3.visible=false;
					} else {
//						item.setTrBtnVisible(true);
						this.taskTargetLbl2.htmlText="" + tartxt;
						this.trbtn3.visible=true;
					}

//					this.setMercenary(2, true);
				}

//				this.renderVec[int(minfo.type)]=item;

				if (int(minfo.type) == TaskEnum.taskLevel_mainLine) {
					/**
					 * 自动打怪
					 */
					if (Core.me.info.level > 30 && this.taskOneInfo != null && this.taskOneInfo.tid == o.tid && this.taskOneInfo.st == o.st && this.taskOneInfo["var"] != o["var"]) {
//						this.autoComplete();
					}

					this.taskOneInfo=o;
				} else if (int(minfo.type) == TaskEnum.taskLevel_switchLine) {

					if (this.taskLoopInfo != null) {

						if (int(o.st) == 0 && o["var"] == 0 && this.taskLoopInfo.tid != o.tid) {
							if (this.linkArr[int(minfo.type)][0] != null) {
								this.autoAstar(this.linkArr[int(minfo.type)][0]);
							}
						}
					}

					this.taskLoopInfo=o;

				}

			} else if (o.hasOwnProperty("award")) {

				this.cloop=20;
				this.taskNameLbl0.htmlText=PropUtils.getStringById(2470); // + " <font color='#00ff00'>(20/20)</font>";
				this.taskTargetLbl0.htmlText="" + StringUtil.substitute(PropUtils.getStringById(2471), [20]);
				this.taskTypeLbl0.htmlText="[" + TaskUtil.getStringByType(2) + "]";

				this.TaskStateLbl0.htmlText="<font color='#00ff9c'>" + TaskUtil.getStringByState(1) + "</font>";

				this.trbtn1.visible=(false);
				this.setYbOnKeyVisible(false);

//				UIManager.getInstance().taskWnd.setVipLvState();

//				this.setStarVisible(false);
//				this.rewardBtn.visible=false;

				if (o.award == 0) {
					this.TaskStateLbl3.visible=true;
//					this.dailyrenderStateBtn.visible=true;
//					this.dailyrenderStateBtn.y=this.taskNameLbl0.y + this.taskNameLbl0.height + 5;
//					this.dailyrenderStateBtn.x=29;
//
//					this.dailyrenderStateBtn.updateIcon(3);
//					this.dailyrenderStateBtn.addEventListener(MouseEvent.CLICK, ontaskClick);

//					this.taskCount+=this.dailyrenderStateBtn.height + 5;
				} else {
					this.TaskStateLbl3.visible=false;
//					this.dailyrenderStateBtn.visible=false;
//					this.taskCount-=10;
				}

//				this.renderVec[TaskEnum.taskLevel_switchLine]=item;
			} else {

				if (int(o.type) == TaskEnum.taskLevel_mercenaryCloseLine) {
					this.taskTypeLbl1.text=PropUtils.getStringById(2460) + "";
					this.taskNameLbl1.htmlText=(PropUtils.getStringById(2461) + "");
					this.TaskStateLbl1.text="(" + MyInfoManager.getInstance().mercenaryClose + "/" + MyInfoManager.getInstance().mercenaryCount + ")";
					this.taskType=o.type;

					if (o.st == 1) {
//						SceneProxy.onTaskComplete();
						this.taskTargetLbl1.htmlText="<font color='#00ff00'><u><a href='event:mercenary--close'>" + PropUtils.getStringById(2472) + "</a></u></font>";
					} else {
						this.taskTargetLbl1.htmlText="<font color='#00ff00'><u><a href='event:mercenary--close'>" + PropUtils.getStringById(2473) + "</a></u></font>";
					}

					this.trbtn2.visible=false;
//					this.setMercenary(1, true);
				} else if (int(o.type) == TaskEnum.taskLevel_mercenaryExpLine) {
					this.taskTypeLbl2.text=PropUtils.getStringById(2460) + "";
					this.taskNameLbl2.htmlText=PropUtils.getStringById(2469) + "";
					this.TaskStateLbl2.text="(" + MyInfoManager.getInstance().mercenaryExp + "/" + MyInfoManager.getInstance().mercenaryCount + ")";

					this.taskType=o.type;

					if (o.st == 1) {
						this.taskTargetLbl2.htmlText="<font color='#00ff00'><u><a href='event:mercenary--exp'>" + PropUtils.getStringById(2472) + "</a></u></font>";
					} else {
						this.taskTargetLbl2.htmlText="<font color='#00ff00'><u><a href='event:mercenary--exp'>" + PropUtils.getStringById(2473) + "</a></u></font>";
					}

					this.trbtn3.visible=false;
//					this.setMercenary(2, true);
				}
			}
//			item.flyFunc=execultFly;
//			this.gridList.addToPane(item);

			this.trbtn.x=this.taskTargetLbl.x + this.taskTargetLbl.textWidth + 10;
			this.trbtn.y=this.taskTargetLbl.y;

			this.trbtn1.x=this.taskTargetLbl0.x + this.taskTargetLbl0.textWidth + 10;
			this.trbtn1.y=this.taskTargetLbl0.y;

			this.trbtn2.x=this.taskTargetLbl1.x + this.taskTargetLbl1.textWidth + 10;
			this.trbtn2.y=this.taskTargetLbl1.y;

			this.trbtn3.x=this.taskTargetLbl2.x + this.taskTargetLbl2.textWidth + 10;
			this.trbtn3.y=this.taskTargetLbl2.y;

			this.yboneKeyBtn.x=this.TaskStateLbl0.x + this.TaskStateLbl0.textWidth + 5;
			this.yboneKeyBtn.y=this.TaskStateLbl0.y;

			this.ybsuccBtn.x=this.trbtn1.x + 20;
			this.ybsuccBtn.y=this.trbtn1.y;

		}

		private function ontaskClick(e:MouseEvent):void {

			if (e.target == this.TaskStateLbl3)
				Cmd_Tsk.cmTaskDailyReward();
//			else if (e.target == this.renderStateBtn)
//				this.autoComplete();
		}

		public function setYbOnKeyVisible(v:Boolean):void {

			//			if (this.cloop == ConfigEnum.taskDailySum)                                                                          )
			//				this.yboneKeyBtn.visible=false;
			//			else

			this.ybsuccBtn.visible=true;

			if (!v || this.TaskStateLbl0.text.indexOf(PropUtils.getStringById(1584)) > -1) {

				if (!v) {
					this.yboneKeyBtn.setActive(false, 0.6, true);
				}

				if (this.TaskStateLbl0.text.indexOf(PropUtils.getStringById(1584)) > -1) {
					this.yboneKeyBtn.visible=false;
					this.ybsuccBtn.visible=false;
				}

			} else {
				this.yboneKeyBtn.visible=true;
				this.yboneKeyBtn.setActive(true, 1, true);
//				this.yboneKeyBtn.visible=true;
			}
		}

		public function setMercenary(it:int, v:Boolean):void {
			if (it == 1) {
				this.taskTypeLbl1.visible=v;
				this.taskNameLbl1.visible=v;
				this.taskTargetLbl1.visible=v;
				this.TaskStateLbl1.visible=v;
			} else {
				this.taskTypeLbl2.visible=v;
				this.taskNameLbl2.visible=v;
				this.taskTargetLbl2.visible=v;
				this.TaskStateLbl2.visible=v;
			}
		}

		public function autoComplete(autoLv30:int=0):void {

			var stateTxt:String;
			if (int(this.taskOneInfo.st) == 0) {

				var lv:int=Core.me.info.level;

				if (this.mainTaskType == TaskEnum.taskType_EquitTopLv) {

					if (lv < ConfigEnum.EquipIntensifyOpenLv) {
						NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.EquipIntensifyOpenLv]);
						return;
					}

					if (UIManager.getInstance().isCreate(WindowEnum.EQUIP) && UIManager.getInstance().equipWnd.visible) {
						return;
					}

					UILayoutManager.getInstance().show_II(WindowEnum.EQUIP)
				} else if (this.mainTaskType == TaskEnum.taskType_BadgeNodeNum) {

					if (lv < ConfigEnum.BadgeOpenLv) {
						NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.BadgeOpenLv]);
						return;
					}

					if (UIManager.getInstance().isCreate(WindowEnum.BADAGE) && UIManager.getInstance().badgeWnd.visible) {
						return;
					}

					UILayoutManager.getInstance().show_II(WindowEnum.BADAGE);
				} else if (this.mainTaskType == TaskEnum.taskType_MountLv) {

					if (lv < ConfigEnum.MountOpenLv) {
						NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.MountOpenLv]);
						return;
					}

					if (UIManager.getInstance().isCreate(WindowEnum.ROLE) && UIManager.getInstance().roleWnd.visible) {
						return;
					}

					UILayoutManager.getInstance().show_II(WindowEnum.ROLE);

					TweenLite.delayedCall(0.3, function():void {
						UILayoutManager.getInstance().show(WindowEnum.ROLE, WindowEnum.MOUTLVUP, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y);
						UIManager.getInstance().roleWnd.setTabIndex(1);
					});

				} else if (this.mainTaskType == TaskEnum.taskType_CopySuccess) {

					if (lv < ConfigEnum.StoryCopyOpenLevel) {
						NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.StoryCopyOpenLevel]);
						return;
					}

//					if (UIManager.getInstance().isCreate(WindowEnum.DUNGEON_TEAM) && UIManager.getInstance().storyCopyWnd.visible) {
//						return;
//					}

					UILayoutManager.getInstance().open_II(WindowEnum.DUNGEON_TEAM);
				} else if (this.mainTaskType == TaskEnum.taskType_TodayTaskSuccessNum) {

//					if (lv < ConfigEnum.taskDailyOpenLv) {
//						NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.taskDailyOpenLv]);
//						return;
//					}
//
//					if (UIManager.getInstance().isCreate(WindowEnum.TASK) && UIManager.getInstance().taskWnd.visible) {
//						return;
//					}
//
//					UILayoutManager.getInstance().show_II(WindowEnum.TASK);
//					TweenLite.delayedCall(0.3, UIManager.getInstance().taskWnd.changeTab, [1]);
//					TweenLite.delayedCall(0.3, GuideManager.getInstance().showGuide, [104, UIManager.getInstance().taskWnd]);
				} else if (this.mainTaskType == TaskEnum.taskType_ElementFlagNum) {
					if (lv < ConfigEnum.ElementOpenLv) {
						NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.ElementOpenLv]);
						return;
					}

					if (!UIManager.getInstance().isCreate(WindowEnum.ELEMENT) || !UIManager.getInstance().getWindow(WindowEnum.ELEMENT).visible)
						UIOpenBufferManager.getInstance().open(WindowEnum.ELEMENT);

					if (DataManager.getInstance().elementData.ctype != 0)
						TweenLite.delayedCall(0.3, UILayoutManager.getInstance().show, [WindowEnum.ELEMENT, WindowEnum.ELEMENT_UPGRADE]);
//					if (UIManager.getInstance().isCreate(WindowEnum.ROLE) && UIManager.getInstance().roleWnd.visible) {
//						return;
//					}
//
//					UILayoutManager.getInstance().show_II(WindowEnum.ROLE);
//					TweenLite.delayedCall(0.3, UIManager.getInstance().roleWnd.setTabIndex, [3]);
				} else if (this.mainTaskType == TaskEnum.taskType_ArenaPkNum) {
					if (lv < ConfigEnum.ArenaOpenLv) {
						NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.ArenaOpenLv]);
						return;
					}

					if (UIManager.getInstance().isCreate(WindowEnum.ARENA) && UIManager.getInstance().arenaWnd.visible) {
						return;
					}

					UILayoutManager.getInstance().show_II(WindowEnum.ARENA);
				} else if (this.mainTaskType == TaskEnum.taskType_Mercenary) {
					//					if (lv < ConfigEnum.) {
					//						NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.ArenaOpenLv]);
					//						return;
					//					}

					if (UIManager.getInstance().isCreate(WindowEnum.PET) && UIManager.getInstance().petWnd.visible) {
						return;
					}

					UIOpenBufferManager.getInstance().open(WindowEnum.PET);
//					TweenLite.delayedCall(0.6, GuideManager.getInstance().showGuide, [123, UIManager.getInstance().petWnd.getBuyBtn()]);
//					TweenLite.delayedCall(0.6, GuideManager.getInstance().showGuide, [123, UIManager.getInstance().petWnd]);
				} else if (this.mainTaskType == TaskEnum.taskType_UpgradeMainSkill) {

					if (UIManager.getInstance().isCreate(WindowEnum.SKILL) && UIManager.getInstance().skillWnd.visible) {
						return;
					}

					UILayoutManager.getInstance().show_II(WindowEnum.SKILL);
					TweenLite.delayedCall(0.3, UIManager.getInstance().skillWnd.setTabIndex, [0]);
				} else if (this.mainTaskType == TaskEnum.taskType_UpgradePassivitySkill) {

					if (UIManager.getInstance().isCreate(WindowEnum.SKILL) && UIManager.getInstance().skillWnd.visible) {
						return;
					}

					UILayoutManager.getInstance().show_II(WindowEnum.SKILL);
					TweenLite.delayedCall(0.3, UIManager.getInstance().skillWnd.setTabIndex, [1]);
						//				} else if (this.mainTaskType == TaskEnum.taskType_Delivery) {

						//					if (UIManager.getInstance().isCreate(WindowEnum.DELIVERY) && UIManager.getInstance().deliveryWnd.visible) {
						//						return;
						//					}
						//
						//					UILayoutManager.getInstance().show_II(WindowEnum.DELIVERY);
				} else if (this.mainTaskType == TaskEnum.taskType_Gem) {

					if (UIManager.getInstance().isCreate(WindowEnum.ROLE) && UIManager.getInstance().roleWnd.visible) {
						return;
					}

					UILayoutManager.getInstance().show_II(WindowEnum.ROLE);

					TweenLite.delayedCall(0.3, function():void {
						UIManager.getInstance().roleWnd.setTabIndex(2);
					});
				} else if (this.mainTaskType == TaskEnum.taskType_UpgradeGem) {

					if (UIManager.getInstance().isCreate(WindowEnum.GEM_LV) && UIManager.getInstance().gemLvWnd.visible) {
						return;
					}

					UILayoutManager.getInstance().show(WindowEnum.GEM_LV);
				} else if (this.mainTaskType == TaskEnum.taskType_Guild) {

					if (UIManager.getInstance().isCreate(WindowEnum.GUILD) && UIManager.getInstance().guildWnd.visible) {
						return;
					}

					UILayoutManager.getInstance().show_II(WindowEnum.GUILD);
				} else if (this.mainTaskType == TaskEnum.taskType_Fram) {

					if (UIManager.getInstance().isCreate(WindowEnum.FARM) && UIManager.getInstance().farmWnd.visible) {
						return;
					}

					UIOpenBufferManager.getInstance().open(WindowEnum.FARM);
				} else if (this.mainTaskType == TaskEnum.taskType_EquipUpgrade) {

					if (UIManager.getInstance().isCreate(WindowEnum.EQUIP) && UIManager.getInstance().equipWnd.visible) {
						return;
					}

					UILayoutManager.getInstance().show(WindowEnum.EQUIP);
					TweenLite.delayedCall(0.3, function():void {
						UIManager.getInstance().equipWnd.changeTable(5);
					});
				} else if (this.mainTaskType == TaskEnum.taskType_SaveElement) {

					if (UIManager.getInstance().isCreate(WindowEnum.ELEMENT) && UIManager.getInstance().elementWnd.visible) {
						return;
					}


					if (!UIManager.getInstance().isCreate(WindowEnum.ELEMENT) || !UIManager.getInstance().getWindow(WindowEnum.ELEMENT).visible)
						UIOpenBufferManager.getInstance().open(WindowEnum.ELEMENT);

				} else {
					stateTxt="ee2211";

					//&& this.taskInfo["var"] == 0
					if (this.linkArr[TaskEnum.taskLevel_mainLine][0] != null)
						this.autoAstar(this.linkArr[TaskEnum.taskLevel_mainLine][0]);
				}

			} else if (int(this.taskOneInfo.st) == 1) {
				stateTxt="00ff9c";

				if (int(this.taskOneInfo.st) == 1 && this.linkArr[TaskEnum.taskLevel_mainLine][this.linkArr[TaskEnum.taskLevel_mainLine].length - 1] != null)
					this.autoAstar(this.linkArr[TaskEnum.taskLevel_mainLine][this.linkArr[TaskEnum.taskLevel_mainLine].length - 1]);

			} else if (int(this.taskOneInfo.st) == -1) {
				var minfo:TMissionDate=TableManager.getInstance().getMissionDataByID(this.taskOneInfo.tid);
				this.autoAstar("npc_id--" + minfo.anpc);
			}

//			GuideManager.getInstance().removeGuide(19);
//			this.autoAstar=true;
		}

		private function autoAstar(link:String):void {
			this.taskTargetLbl.dispatchEvent(new TextEvent(TextEvent.LINK, false, false, link));
		}

		public function updateDailyInfo(o:Object):void {

			if (o.hasOwnProperty("star")) {

				if (this.currentTaskId == o.tid && this.currentStar != 0 && this.currentStar != o.star) {
					this.rewardStarEffect.visible=true;
					this.rewardStarEffect.playAct(PlayerEnum.ACT_STAND, -1, false, function():void {
						updateStar(o.star);
						rewardStarEffect.visible=false;
					});
				} else {
					this.updateStar(o.star);
				}

				if (int(o.star) == 5)
					this.rewardBtn.setActive(false, .6, true);
				else
					this.rewardBtn.setActive(true, 1, true);

				this.currentStar=o.star;
			}

			this.currentTaskId=o.tid;

		}

		private function onFly(e:MouseEvent):void {
			if (e.target == this.trbtn)
				this.execultFly(TaskEnum.taskLevel_mainLine);
			else if (e.target == this.trbtn1)
				this.execultFly(TaskEnum.taskLevel_switchLine);
			else if (e.target == this.trbtn2)
				this.execultFly(TaskEnum.taskLevel_mercenaryCloseLine);
			else if (e.target == this.trbtn3)
				this.execultFly(TaskEnum.taskLevel_mercenaryExpLine);
		}

		private function execultFly(_type:int):void {

			if (_type != TaskEnum.taskLevel_deliveryLine && this.linkArr[_type][0] == null)
				return;

			GuideManager.getInstance().removeGuide(67);

			if (ConfigEnum.MarketOpenLevel <= Core.me.info.level) {
				var tinfo:TItemInfo=TableManager.getInstance().getItemInfo(ConfigEnum.traveItem);

				if (MyInfoManager.getInstance().VipLastTransterCount == 0 && MyInfoManager.getInstance().getBagItemNumByName(tinfo.name) <= 0) {

					if (!UIManager.getInstance().quickBuyWnd.isAutoBuy(ConfigEnum.traveItem, ConfigEnum.traveBindItem)) {
						UILayoutManager.getInstance().show(WindowEnum.ROLE, WindowEnum.QUICK_BUY, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y + 40);
						UIManager.getInstance().quickBuyWnd.pushItem(ConfigEnum.traveItem, ConfigEnum.traveBindItem);
						return;
					} else {
						UIManager.getInstance().quickBuyWnd.getItemNotShow(ConfigEnum.traveItem, ConfigEnum.traveBindItem);
					}

				}
			}


			var delayTime:Number=0.3;
			var info:TPointInfo;
			if (_type == TaskEnum.taskLevel_switchLine) {

				if (this.linkArr[_type][0].indexOf("monster") > -1) {

					info=TableManager.getInstance().getPointInfo(int(this.linkArr[_type][0].split("--")[1]));
					Cmd_Go.cmGoPoint(int(info.sceneId), info.tx, info.ty);
					Core.me.pInfo.currentTaskType=this.linkArr[_type][0].indexOf("monster") > -1 ? PlayerEnum.TASK_MONSTER : PlayerEnum.TASK_COLLECT;

						//					TweenLite.delayedCall(delayTime, function():void {
						//						if (linkArr[_type][0] != null)
						//							renderVec[_type].autoAstar(linkArr[_type][0]);
						//					});

				} else if (this.linkArr[_type][0] != null) {

					Cmd_Go.cmGoNpc(this.linkArr[_type][0].split("--")[1]);

//					TweenLite.delayedCall(delayTime, function():void {
//						if (linkArr[_type][0] != null)
//							renderVec[_type].autoAstar(linkArr[_type][0]);
//					});

				}

			} else if (_type == TaskEnum.taskLevel_mercenaryCloseLine || _type == TaskEnum.taskLevel_mercenaryExpLine) {

				info=TableManager.getInstance().getPointInfo(int(this.linkArr[_type][0].split("--")[1]));
				Cmd_Go.cmGoPoint(int(info.sceneId), info.tx, info.ty);
			} else {

				if (int(this.taskOneInfo.st) == 0) {

					if (this.linkArr[_type][0].indexOf("monster") > -1 || this.linkArr[_type][0].indexOf("box") > -1) {
						info=TableManager.getInstance().getPointInfo(int(this.linkArr[_type][0].split("--")[1]));
						Cmd_Go.cmGoPoint(int(info.sceneId), info.tx, info.ty);

						Core.me.pInfo.currentTaskType=this.linkArr[_type][0].indexOf("monster") > -1 ? PlayerEnum.TASK_MONSTER : PlayerEnum.TASK_COLLECT;

					} else if (this.linkArr[_type][0] != null) {
						Cmd_Go.cmGoNpc(this.linkArr[_type][0].split("--")[1]);

						TweenLite.delayedCall(delayTime, function():void {
							if (linkArr[TaskEnum.taskLevel_mainLine][0] != null)
								autoAstar(linkArr[TaskEnum.taskLevel_mainLine][0]);
						});

					}

				} else if (int(this.taskOneInfo.st) == 1) {

					if (int(this.taskOneInfo.st) == 1 && this.linkArr[_type][this.linkArr[_type].length - 1] != null) {
						Cmd_Go.cmGoNpc(this.linkArr[_type][this.linkArr[_type].length - 1].split("--")[1]);

						TweenLite.delayedCall(delayTime, function():void {
							if (linkArr[TaskEnum.taskLevel_mainLine][0] != null)
								autoAstar(linkArr[TaskEnum.taskLevel_mainLine][0]);
						});
					}

				} else if (int(this.taskOneInfo.st) == -1) {

					var minfo:TMissionDate=TableManager.getInstance().getMissionDataByID(this.taskOneInfo.tid);
					Cmd_Go.cmGoNpc(int(minfo.anpc));

					TweenLite.delayedCall(delayTime, function():void {
						if (linkArr[TaskEnum.taskLevel_mainLine][0] != null)
							autoAstar(linkArr[TaskEnum.taskLevel_mainLine][0]);
					});
				}
			}
		}

		public function get taskInfo():Object {
			return this._taskInfo;
		}

		public function set taskInfo(o:Object):void {
			this._taskInfo=o;
		}

	}
}

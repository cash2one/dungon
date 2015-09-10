package com.leyou.ui.task {

	import com.ace.config.Core;
	import com.ace.delayCall.DelayCallManager;
	import com.ace.enum.EventEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.proxy.SceneProxy;
	import com.ace.game.utils.SceneUtil;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TMissionDate;
	import com.ace.gameData.table.TPointInfo;
	import com.ace.manager.EventManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.SoundManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.TaskEnum;
	import com.leyou.manager.TimerManager;
	import com.leyou.net.cmd.Cmd_Go;
	import com.leyou.net.cmd.Cmd_Qa;
	import com.leyou.net.cmd.Cmd_Tsk;
	import com.leyou.net.cmd.Cmd_Yct;
	import com.leyou.ui.task.child.MissionSoulBar;
	import com.leyou.ui.task.child.MissionTrackRender;
	import com.leyou.ui.task.child.TaskTrackBtn;
	import com.leyou.util.DateUtil;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.TaskUtil;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class TaskTrack extends AutoSprite {

		private var gridList:ScrollPane;
		private var renderVec:Array=[];
		private var renderStateBtn:TaskTrackBtn;
		private var dailyrenderStateBtn:TaskTrackBtn;
		private var deliveryrenderStateBtn:TaskTrackBtn;
		private var questionrenderStateBtn:TaskTrackBtn;
		private var bgImg:Image;

		private var missionSoulBar:MissionSoulBar;
		private var arrowBtn:ImgButton;
		private var arrowIcon:Image;

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
		private var linkArr:Array=[];
		private var taskList:Array=[];

		/**
		 *总位置
		 */
		private var taskCount:int=0;

		/**
		 *日常位置
		 */
		private var todayCount:int=0;

		private var _taskInfo:Object;

		private var questtime:int=0;

		public function TaskTrack() {
			super(LibManager.getInstance().getXML("config/ui/task/missionTrack.xml"));
			this.init();
			this.mouseChildren=true;
			this.resize();
		}

		private function init():void {

			this.bgImg=this.getUIbyID("bgImg") as Image;
			this.gridList=this.getUIbyID("gridList") as ScrollPane;
			this.renderStateBtn=new TaskTrackBtn();
			this.gridList.addToPane(this.renderStateBtn);

			this.gridList.mouseChildren=true;

			this.missionSoulBar=new MissionSoulBar();
			this.addChild(this.missionSoulBar);
			this.missionSoulBar.y=-this.missionSoulBar.height;

			this.arrowIcon=new Image("ui/mission/rwzz_bg.png");
//			this.arrowIcon.y=this.arrowBtn.y+this.arrowBtn.height;
			this.addChild(this.arrowIcon);
			this.arrowIcon.visible=false;

			this.arrowBtn=new ImgButton("ui/funForcast/btn_right.png");
			this.addChild(this.arrowBtn);

			this.arrowBtn.x=this.width - this.arrowBtn.width;
			this.arrowBtn.y=2;

			this.arrowBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.dailyrenderStateBtn=new TaskTrackBtn();
			this.gridList.addToPane(this.dailyrenderStateBtn);
			this.dailyrenderStateBtn.visible=false;

			this.deliveryrenderStateBtn=new TaskTrackBtn();
			this.gridList.addToPane(this.deliveryrenderStateBtn);
			this.deliveryrenderStateBtn.visible=false;

			this.questionrenderStateBtn=new TaskTrackBtn();
			this.gridList.addToPane(this.questionrenderStateBtn);
			this.questionrenderStateBtn.visible=false;

			this.linkArr[TaskEnum.taskLevel_mainLine]=[];
			this.linkArr[TaskEnum.taskLevel_switchLine]=[];
			this.linkArr[TaskEnum.taskLevel_mercenaryExpLine]=[];
			this.linkArr[TaskEnum.taskLevel_mercenaryCloseLine]=[];

			this.taskList[TaskEnum.taskLevel_questLine]=updateQuestion;
			this.taskList[TaskEnum.taskLevel_deliveryLine]=updateDelivery;
			this.taskList[TaskEnum.taskLevel_arenaLine]=updateArena;
			this.taskList[TaskEnum.taskLevel_dragonLine]=updateDungeon;

			this.addEventListener(MouseEvent.CLICK, onMouseClick);

			EventManager.getInstance().addEvent(EventEnum.FIRST_LOGIN_CLICK, onComplete);
		}

		private function onComplete():void {
			this.autoComplete();
		}

		private function onMouseClick(e:MouseEvent):void {

			if (e.target is TaskTrackBtn || e.target is ImgButton)
				return;

			var globalPoint:Point=new Point(e.stageX, e.stageY);
			var screenPoint:Point=UIManager.getInstance().gameScene.foreground.globalToLocal(globalPoint);
			var targetPoint:Point=SceneUtil.screenToTile(screenPoint.x, screenPoint.y);

			if (e.currentTarget is TaskTrack) {
				var target:DisplayObject=e.target as DisplayObject;

				if (target is Label) {

					var t:Label=target as Label;
					var clickPoint:Point=t.globalToLocal(globalPoint);
					var index:int=t.getCharIndexAtPoint(clickPoint.x, clickPoint.y);

					if (-1 == index) {
						Core.me.gotoMap(targetPoint, "", false);
					}

				} else {
					Core.me.gotoMap(targetPoint, "", false);
				}

			}
		}

		public function updateHallows(_i:int, _p:Number, st:Boolean):void {
			this.missionSoulBar.updateInfo(_i, _p, st);
		}

		public function completeHallow():void {
			this.missionSoulBar.onCompleteHallow()
		}

		private function onClick(e:MouseEvent):void {

			var w:int=this.width;
			var i:int=w - 30;

			if (this.missionSoulBar.visible) {

				TweenLite.to(this, 1, {x: UIEnum.WIDTH - 20, onComplete: function():void {
					missionSoulBar.visible=gridList.visible=false;
					arrowBtn.updataBmd("ui/funForcast/btn_left.png");
					arrowIcon.visible=true;
					bgImg.visible=false;
				}});

				TweenLite.to(this.arrowBtn, 1, {x: 2});

			} else {

				bgImg.visible=true;
				missionSoulBar.visible=gridList.visible=true;
				arrowIcon.visible=false;
				TweenLite.to(this, 1, {x: UIEnum.WIDTH - this.width + 7, onComplete: function():void {
					arrowBtn.updataBmd("ui/funForcast/btn_right.png");
				}});

				TweenLite.to(this.arrowBtn, 1, {x: this.width - this.arrowBtn.width - 15});
			}
		}

		private function updateTaskItem(o:Object):void {

			if (this.taskOneInfo != null && this.taskOneInfo.tid == o.tid && this.taskOneInfo.st == o.st && this.taskOneInfo["var"] == o["var"]) {
				this.taskCount=100;
				return;
			}

			var minfo:TMissionDate;
			var item:MissionTrackRender;

			if (o.hasOwnProperty("tid")) {

				//目标字段
				minfo=TableManager.getInstance().getMissionDataByID(o.tid);

				if (this.renderVec[int(minfo.type)] == null) {
					item=new MissionTrackRender();
				} else{
					item=this.renderVec[minfo.type];
					item.visible=true;
				}
				
				item.y=this.taskCount;
				this.taskCount+=item.height;

//				if (o.tid == 23)
//					GuideManager.getInstance().showGuide(67, item.flyBtn);

				if (o.tid == 1) {
					UIManager.getInstance().showWindow(WindowEnum.FIRST_LOGIN);
				} else {
					if (this.taskOneInfo == null)
						UIManager.getInstance().postWnd.updateLoade();
				}

				var tartxt:String;

				this.linkArr[int(minfo.type)].length=0;
				item.taskType=minfo.type;
				item.taskDtype=minfo.dtype;

				//如果没完成
				if (o.st != 1) {

					tartxt=TaskEnum.taskTypeDesc[int(minfo.dtype) - 1];
					var tarval:Array=TaskEnum.taskTypeNpcField[int(minfo.dtype) - 1];
					var i:int=0;

					var bname:String;
					var bid:String;

					while (tartxt.indexOf("##") > -1) {

						if (tarval[i].indexOf("num") > -1 || tarval[i].indexOf("Num") > -1 || tarval[i].indexOf("number") > -1) {
							tartxt=tartxt.replace("##", "<font color='#ff0000'>(" + o["var"] + "/" + minfo[tarval[i]] + ")</font>");
						} else if (tarval[i].indexOf("lv") > -1) {
							tartxt=tartxt.replace("##", "<font color='#ff0000'>(" + minfo[tarval[i]] + ")</font>");
						} else {

							if (int(minfo.dtype) == TaskEnum.taskType_upgrade) {
								tartxt=tartxt.replace("##", "<font color='#ff0000'>" + minfo[tarval[i]] + "</font>");
							} else {

								bname=String(tarval[i]).split("_")[0] + "_id";

								if (bname.indexOf("npc") > -1) { // || bname.indexOf("box") > -1) {
									this.linkArr[int(minfo.type)].push(bname + "--" + minfo[bname]);
									tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:" + bname + "--" + minfo[bname] + "'>" + TaskUtil.getTaskTargetName(tarval[i], minfo[tarval[i]]) + "</a></u></font>");
								} else {
									this.linkArr[int(minfo.type)].push(bname + "--" + minfo.target_point);

									if (int(minfo.dtype) == TaskEnum.taskType_killBossDrop)
										tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:" + String(tarval[0]).split("_")[0] + "_id" + "--" + minfo.target_point + "'>" + TaskUtil.getTaskTargetName(tarval[i], minfo[tarval[i]]) + "</a></u></font>");
									else if (int(minfo.dtype) == TaskEnum.taskType_collect)
										tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:" + String(tarval[0]).split("_")[0] + "_id" + "--" + minfo.target_point + "'>" + TaskUtil.getTaskTargetName(tarval[i], minfo[tarval[i]]) + "</a></u></font>");
									else if (int(minfo.dtype) == TaskEnum.taskType_Exchange)
										tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:" + bname + "--" + minfo.item_id + "'>" + TaskUtil.getTaskTargetName(tarval[i], minfo[tarval[i]]) + "</a></u></font>");
									else if (int(minfo.dtype) == TaskEnum.taskType_CopySuccess) {
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

					if (o.st == -1) {
						this.renderStateBtn.updateIcon(0);
					} else {
						this.renderStateBtn.updateIcon(1);
					}

				} else if (o.st == 1) {

					if (int(minfo.type) == TaskEnum.taskLevel_mainLine) {
						this.renderStateBtn.updateIcon(2);
						item.targetVisible.visible=true;
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
							item.autoAstar(this.linkArr[int(minfo.type)][0]);
					}

				} else if (int(o.st) == 1) {
					stateTxt="00ff9c";

					if (int(minfo.type) == TaskEnum.taskLevel_mainLine) {
						if (this.linkArr[int(minfo.type)][this.linkArr[int(minfo.type)].length - 1] != null && !this.firstAutoAstar)
							item.autoAstar(this.linkArr[int(minfo.type)][this.linkArr[int(minfo.type)].length - 1]);
					}
				}

				item.taskNameTxt(minfo.name);

				if (int(minfo.type) == TaskEnum.taskLevel_mainLine) {

					taskID=o.tid;
					this.mainTaskType=int(minfo.dtype);

					this.renderStateBtn.y=item.height + 10;
					this.renderStateBtn.x=50;

					this.renderStateBtn.addEventListener(MouseEvent.CLICK, ontaskClick);
					this.taskCount+=(this.renderStateBtn.height + 20);

					if (o.tid == 96)
						GuideManager.getInstance().showGuide(104, this); //.getWidget("expCopyBtn"));

					if (o.tid == 110) {
						GuideManager.getInstance().showGuide(83, UIManager.getInstance().rightTopWnd.getWidget("teamCopyBtn"));
					} else
						GuideManager.getInstance().removeGuide(83);


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
								UILayoutManager.getInstance().show_II(WindowEnum.ROLE, WindowEnum.MOUTLVUP, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y);
							});

						} else if (this.mainTaskType == TaskEnum.taskType_CopySuccess) {

							if (lv < ConfigEnum.StoryCopyOpenLevel) {
								NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.StoryCopyOpenLevel]);

							}

							if (!UIManager.getInstance().teamCopyWnd || !UIManager.getInstance().teamCopyWnd.visible)
								UILayoutManager.getInstance().open_II(WindowEnum.DUNGEON_TEAM);
						} else if (this.mainTaskType == TaskEnum.taskType_TodayTaskSuccessNum) {

							if (lv < ConfigEnum.taskDailyOpenLv) {
								NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.taskDailyOpenLv]);
							}

							if (!UIManager.getInstance().isCreate(WindowEnum.TASK) || !UIManager.getInstance().taskWnd.visible)
								UILayoutManager.getInstance().show_II(WindowEnum.TASK);
							TweenLite.delayedCall(0.3, UIManager.getInstance().taskWnd.changeTab, [1]);
						} else if (this.mainTaskType == TaskEnum.taskType_ElementFlagNum) {
							if (lv < ConfigEnum.ElementOpenLv) {
								NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.ElementOpenLv]);
							}

							if (!UIManager.getInstance().isCreate(WindowEnum.ROLE) || !UIManager.getInstance().roleWnd.visible)
								UILayoutManager.getInstance().show_II(WindowEnum.ROLE);

							if (this.taskOneInfo == null)
								dc=2;

							TweenLite.delayedCall(dc, UIManager.getInstance().roleWnd.setTabIndex, [3]);
						} else if (this.mainTaskType == TaskEnum.taskType_ArenaPkNum) {
							if (lv < ConfigEnum.ArenaOpenLv) {
								NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.ArenaOpenLv]);
							}

							if (!UIManager.getInstance().isCreate(WindowEnum.ARENA) || !UIManager.getInstance().arenaWnd.visible)
								UILayoutManager.getInstance().show_II(WindowEnum.ARENA);
						}
					}


					if (o.st != 1) {
						GuideManager.getInstance().showGuide(19, this.renderStateBtn);

					} else if (o.st == 1) {

						if (this.mainTaskType == TaskEnum.taskType_BadgeNodeNum || this.mainTaskType == TaskEnum.taskType_MountLv || this.mainTaskType == TaskEnum.taskType_CopySuccess || this.mainTaskType == TaskEnum.taskType_TodayTaskSuccessNum || this.mainTaskType == TaskEnum.taskType_ElementFlagNum || this.mainTaskType == TaskEnum.taskType_ArenaPkNum || this.mainTaskType == TaskEnum.taskType_EquitTopLv || this.mainTaskType == TaskEnum.taskType_killBoss || this.mainTaskType == TaskEnum.taskType_killBossDrop || this.mainTaskType == TaskEnum.taskType_collect) {
							if (this.firstLogin) {
								this.firstLogin=false;
							} else
								SceneProxy.onTaskComplete();
						}

						this.setGuideView(this.mainTaskType);
						this.setGuideViewhide(this.mainTaskType);
						GuideManager.getInstance().removeGuide(19);
						//
						if (Core.me != null)
							Core.me.clearTarget();
					}

					if (o.st != 1 && (this.mainTaskType == TaskEnum.taskType_upgrade || this.mainTaskType >= TaskEnum.taskType_TodayTaskSuccessNum))
						item.setTrBtnVisible(false);
					else
						item.setTrBtnVisible(true);


				} else if (int(minfo.type) == TaskEnum.taskLevel_switchLine) {
					item.cloop=int(o.cloop);
					item.taskNameTxt(PropUtils.getStringById(1895) + " <font color='#ff0000'>(" + o.cloop + "/20)</font>");

					if (o.st == 1)
						SceneProxy.onTaskComplete();

					if (o.st != 1 && int(minfo.dtype) == TaskEnum.taskType_Exchange)
						item.setTrBtnVisible(false);
					else
						item.setTrBtnVisible(true);

					item.setYbOnKeyVisible(Core.me.info.vipLv >= DataManager.getInstance().vipData.taskPrivilegeVipLv());
					UIManager.getInstance().taskWnd.setVipLvState(Core.me.info.vipLv)
				} else if (int(minfo.type) == TaskEnum.taskLevel_mercenaryCloseLine || int(minfo.type) == TaskEnum.taskLevel_mercenaryExpLine) {

					if (o.st == 1) {
						SceneProxy.onTaskComplete();

						item.taskNameTxt(minfo.name + " <font color='#00ff00'><u><a href='event:mercenary--'>领取奖励</a></u></font>");
						item.setTrBtnVisible(false);
						item.targetVisible.visible=false;
						taskCount-=20;
					} else{
						item.setTrBtnVisible(true);
						item.targetVisible.visible=true;
					}
				}

				item.taskTargetTxt(tartxt);
				item.taskStateTxt("<font color='#" + stateTxt + "'>" + TaskUtil.getStringByState(int(o.st)) + "</font>");
				item.taskTypeTxt("[" + TaskUtil.getStringByType(int(minfo.type)) + "]");

				this.renderVec[int(minfo.type)]=item;

				if (int(minfo.type) == TaskEnum.taskLevel_mainLine) {
					/**
					 * 自动打怪
					 */
					if (Core.me.info.level > 30 && this.taskOneInfo != null && this.taskOneInfo.tid == o.tid && this.taskOneInfo.st == o.st && this.taskOneInfo["var"] != o["var"]) {
//						this.autoComplete();
					}

					this.taskOneInfo=o;
				}

			} else if (o.hasOwnProperty("award")) {

				if (this.renderVec[TaskEnum.taskLevel_switchLine] == null) {
					item=new MissionTrackRender();
				} else
					item=this.renderVec[TaskEnum.taskLevel_switchLine];

				item.y=this.taskCount;
				this.taskCount+=item.height - 10;

				item.cloop=20;
				item.taskNameTxt(PropUtils.getStringById(1895) + " <font color='#00ff00'>(20/20)</font>");
				item.taskTargetTxt("");
				item.taskTypeTxt("[" + TaskUtil.getStringByType(2) + "]");

				item.taskStateTxt("<font color='#00ff9c'>" + TaskUtil.getStringByState(1) + "</font>");

				item.setTrBtnVisible(false);
				item.setYbOnKeyVisible(false);

				
				UIManager.getInstance().taskWnd.setVipLvState();

				if (o.award == 0) {
					this.dailyrenderStateBtn.visible=true;
					this.dailyrenderStateBtn.y=this.taskCount;
					this.dailyrenderStateBtn.x=50;

					this.dailyrenderStateBtn.updateIcon(3);
					this.dailyrenderStateBtn.addEventListener(MouseEvent.CLICK, ontaskClick);

					this.taskCount+=this.dailyrenderStateBtn.height + 5;
				} else {
					this.dailyrenderStateBtn.visible=false;
					this.taskCount-=10;
				}

				this.renderVec[TaskEnum.taskLevel_switchLine]=item;
			}

			item.flyFunc=execultFly;
			this.gridList.addToPane(item);
		}

		public function setDailyTaskVip(vip:int):void {
			if (this.renderVec[TaskEnum.taskLevel_switchLine] != null)
				this.renderVec[TaskEnum.taskLevel_switchLine].setYbOnKeyVisible(vip >= DataManager.getInstance().vipData.taskPrivilegeVipLv());

		}

		/**
		 *设置引导任务 开启状态
		 * @param id
		 *
		 */
		public function setGuideView(id:int):void {
			if (Core.me != null && Core.me.info != null && this.taskOneInfo != null) {

				if (this.taskOneInfo.st == 0) {
					if (this.mainTaskType == id && this.mainTaskType == TaskEnum.taskType_BadgeNodeNum) {
						GuideManager.getInstance().showGuide(13, this);
					} else if (this.mainTaskType == TaskEnum.taskType_MountLv && this.mainTaskType == id) {
						GuideManager.getInstance().showGuide(4, this);
					} else if (this.mainTaskType == TaskEnum.taskType_CopySuccess && this.mainTaskType == id) {
						GuideManager.getInstance().showGuide(29, this);
					} else if (this.mainTaskType == TaskEnum.taskType_TodayTaskSuccessNum && this.mainTaskType == id) {
						GuideManager.getInstance().showGuide(18, this);
					} else if (this.mainTaskType == TaskEnum.taskType_ElementFlagNum && this.mainTaskType == id) {
						GuideManager.getInstance().showGuide(10, this);
					} else if (this.mainTaskType == TaskEnum.taskType_ArenaPkNum && this.mainTaskType == id) {
						GuideManager.getInstance().showGuide(32, this);
					} else if (this.mainTaskType == TaskEnum.taskType_EquitTopLv && this.mainTaskType == id) {
						GuideManager.getInstance().showGuide(62, this);
					}

				} else if (this.taskOneInfo.st == 1) {

					if (this.mainTaskType == id && this.mainTaskType == TaskEnum.taskType_BadgeNodeNum) {
						GuideManager.getInstance().removeGuide(13);
					} else if (this.mainTaskType == TaskEnum.taskType_MountLv && this.mainTaskType == id) {
						GuideManager.getInstance().removeGuide(4);
					} else if (this.mainTaskType == TaskEnum.taskType_CopySuccess && this.mainTaskType == id) {
						GuideManager.getInstance().removeGuide(29);
					} else if (this.mainTaskType == TaskEnum.taskType_TodayTaskSuccessNum && this.mainTaskType == id) {
						GuideManager.getInstance().removeGuide(18);
					} else if (this.mainTaskType == TaskEnum.taskType_ElementFlagNum && this.mainTaskType == id) {
						GuideManager.getInstance().removeGuide(10);
					} else if (this.mainTaskType == TaskEnum.taskType_ArenaPkNum && this.mainTaskType == id) {
						GuideManager.getInstance().removeGuide(32);
					} else if (this.mainTaskType == TaskEnum.taskType_EquitTopLv && this.mainTaskType == id) {
						GuideManager.getInstance().removeGuide(62);
					}
				}

			}

		}

		public function setGuideViewhide(id:int):void {
			if (Core.me != null && Core.me.info != null && this.taskOneInfo != null) {

				if (this.mainTaskType == id && this.mainTaskType == TaskEnum.taskType_BadgeNodeNum) {
					GuideManager.getInstance().removeGuide(13);
				} else if (this.mainTaskType == TaskEnum.taskType_MountLv && this.mainTaskType == id) {
					GuideManager.getInstance().removeGuide(4);
				} else if (this.mainTaskType == TaskEnum.taskType_CopySuccess && this.mainTaskType == id) {
					GuideManager.getInstance().removeGuide(29);
				} else if (this.mainTaskType == TaskEnum.taskType_TodayTaskSuccessNum && this.mainTaskType == id) {
					GuideManager.getInstance().removeGuide(18);
				} else if (this.mainTaskType == TaskEnum.taskType_ElementFlagNum && this.mainTaskType == id) {
					GuideManager.getInstance().removeGuide(10);
				} else if (this.mainTaskType == TaskEnum.taskType_ArenaPkNum && this.mainTaskType == id) {
					GuideManager.getInstance().removeGuide(32);
				} else if (this.mainTaskType == TaskEnum.taskType_EquitTopLv && this.mainTaskType == id) {
					GuideManager.getInstance().removeGuide(62);
				}

			}

		}

		public function updateList(o:Object):void {

//			var item:MissionTrackRender;
//			for each (item in this.renderVec) {
//				this.gridList.delFromPane(item);
//			}

//			this.renderVec.length=0;
//			this.renderVec=[];

			if (Core.me == null)
				return;

			this.taskCount=0;
			this._taskInfo=o;

			var tr:Array=o.tr;
			tr.sortOn("type", Array.CASEINSENSITIVE | Array.NUMERIC);

			if(this.renderVec[TaskEnum.taskLevel_mercenaryCloseLine]!=null)
				this.renderVec[TaskEnum.taskLevel_mercenaryCloseLine].visible=false;
			
			if(this.renderVec[TaskEnum.taskLevel_mercenaryExpLine]!=null)
				this.renderVec[TaskEnum.taskLevel_mercenaryExpLine].visible=false;
			
			var tritem:Object;
			for each (tritem in tr) {
				if (tritem != null) {
					if (o.hasOwnProperty("award") && o.award == 1) {

					} else {
						this.updateTaskItem(tritem);
					}
				}
			}
			
			
			

			this.firstAutoAstar=false;

			this.todayCount=this.taskCount;
			this.updateListPos();

//			//答题
//			this.updateQuestion();
//			//护镖
//			this.updateDelivery();
//			//竞技场
//			this.updateArena();
		}

		/**
		 * 押镖
		 * @param o
		 *
		 */
		public function updateDelivery(o:Object=null):void {

			if (Core.me != null && ConfigEnum.delivery19 > Core.me.info.level)
				return;

			var item:MissionTrackRender;

			if (o != null) {

				if (this.renderVec[TaskEnum.taskLevel_deliveryLine] == null) {

					item=new MissionTrackRender();

					item.taskType=TaskEnum.taskLevel_deliveryLine;

					this.gridList.addToPane(item);

					item.flyFunc=execultFly;

					item.y=this.taskCount;
					this.taskCount+=item.height;

				} else
					item=this.renderVec[TaskEnum.taskLevel_deliveryLine];

				item.taskTypeTxt(PropUtils.getStringById(1896));
				if (o.ynum == o.zynum) {
					item.taskNameTxt(PropUtils.getStringById(1897) + " <font color='#00ff00'>(" + o.ynum + "/" + o.zynum + ")</font>");
				} else
					item.taskNameTxt(PropUtils.getStringById(1897) + " <font color='#ff0000'>(" + o.ynum + "/" + o.zynum + ")</font>");

				switch (o.yst) {
					case 0:
						item.taskStateTxt("<font color='#ee2211'>" + PropUtils.getStringById(1898) + "</font>");
						item.taskTargetTxt(StringUtil.substitute(PropUtils.getStringById(1899), ["<font color='#00ff00'><u><a href='event:npc_id--" + ConfigEnum.delivery21 + "'>" + TableManager.getInstance().getLivingInfo(ConfigEnum.delivery21).name + "</a></u></font>"]));
						item.taskLastHpTxt("");
						item.setTrBtnVisible(true);

						if (this.deliveryrenderStateBtn.visible) {
							this.deliveryrenderStateBtn.visible=false;
						}

						break;
					case 1:
						item.taskStateTxt("<font color='#ee2211'>" + PropUtils.getStringById(1900) + "</font>");

						item.taskTargetTxt("");
						item.taskLastHpTxt("");

						this.deliveryrenderStateBtn.visible=false;

						item.setTrBtnVisible(false);

						if (!UIManager.getInstance().isCreate(WindowEnum.DELIVERYPANEL))
							UIManager.getInstance().creatWindow(WindowEnum.DELIVERYPANEL);

						if (!UIManager.getInstance().deliveryPanel.visible && this.visible)
							UIManager.getInstance().deliveryPanel.show();

						UIManager.getInstance().deliveryPanel.updateInfo(o);
						break;
					case 2:
						item.taskStateTxt("<font color='#00ff9c'>" + PropUtils.getStringById(1584) + "</font>");
						item.taskTargetTxt("");
						item.taskLastHpTxt("");
						item.setTrBtnVisible(false);

						this.deliveryrenderStateBtn.visible=false;
						UIManager.getInstance().hideWindow(WindowEnum.DELIVERYPANEL);
						break;
				}

				this.renderVec[TaskEnum.taskLevel_deliveryLine]=item;
				this.updateListPos();

			} else {

				item=this.renderVec[TaskEnum.taskLevel_deliveryLine];

				if (item != null) {
					item.y=this.taskCount;
					if (item.flyBtn.visible)
						this.taskCount+=item.height;
					else
						this.taskCount+=item.height - 20;

					GuideManager.getInstance().showGuide(8, item, true);
				}

				if (this.deliveryrenderStateBtn.visible) {
					this.taskCount+=30;
					this.deliveryrenderStateBtn.y=this.taskCount;
					this.taskCount+=deliveryrenderStateBtn.height;
				}
			}

			this.gridList.scrollTo(this.gridList.scrollBar_Y.progress);
			DelayCallManager.getInstance().add(this, this.gridList.updateUI, "updateUI", 4);
		}

		/**
		 *竞技场
		 * @param o
		 *
		 */
		public function updateArena(o:Object=null):void {

			if (Core.me == null || Core.me.info == null || ConfigEnum.ArenaOpenLv > Core.me.info.level)
				return;

			var item:MissionTrackRender;

			item=this.renderVec[TaskEnum.taskLevel_arenaLine];

			if (o != null) {

				if (this.renderVec[TaskEnum.taskLevel_arenaLine] == null) {
					item=new MissionTrackRender();

					item.setTrBtnVisible(false);
					this.gridList.addToPane(item);

					item.y=this.taskCount;
					this.taskCount+=item.height;
				}

				item.taskTypeTxt(PropUtils.getStringById(1902));

				if (o.sfight == o.zfight) {
					item.taskNameTxt(StringUtil.substitute(PropUtils.getStringById(1903), ["<font color='#00ff00'><u><a href='event:arena'>"]) + "</a></u></font>");
				} else
					item.taskNameTxt(StringUtil.substitute(PropUtils.getStringById(1904), [" <font color='#ff0000'>(" + o.sfight + "/" + o.zfight + ")</font><font color='#00ff00'><u><a href='event:arena'>"]) + "</a></u></font>");

				item.taskStateTxt("");

				if (o.jlst == 0)
					item.taskTargetTxt(StringUtil.substitute(PropUtils.getStringById(1905), [" <font color='#00ff00'><u><a href='event:accpetArena--aa'>"]) + "</a></u></font>");
				else {
					item.taskTargetTxt("");
					this.taskCount-=20;
				}

				this.renderVec[TaskEnum.taskLevel_arenaLine]=item;
				this.updateListPos();

			} else {
				if (item != null) {
					item.y=this.taskCount;
					if (item.targetVisible.text != "")
						this.taskCount+=item.height;
					else
						this.taskCount+=item.height - 20;
				}
			}

			this.gridList.scrollTo(this.gridList.scrollBar_Y.progress);
			DelayCallManager.getInstance().add(this, this.gridList.updateUI, "updateUI", 4);
		}

		/**
		 * 时光龙穴
		 * @return
		 *
		 */
		public function updateDungeon(o:Object=null):void {

			var item:MissionTrackRender;

			if (o != null) {

				if (o.cm == ConfigEnum.Exp_Fb4) {

					if (this.renderVec[TaskEnum.taskLevel_dragonLine] != null) {
						this.gridList.delFromPane(this.renderVec[TaskEnum.taskLevel_dragonLine]);
						this.renderVec[TaskEnum.taskLevel_dragonLine]=null;
					}

				} else {

					if (this.renderVec[TaskEnum.taskLevel_dragonLine] == null) {
						item=new MissionTrackRender();
						item.setTrBtnVisible(false);

						this.gridList.addToPane(item);

						item.y=this.taskCount;
						this.taskCount+=item.height;
					} else
						item=this.renderVec[TaskEnum.taskLevel_dragonLine];

					item.taskTypeTxt(PropUtils.getStringById(1906));
					var str:String="";

					if (o.vars == 0) {
						str=PropUtils.getStringById(1907);
						str+="<font color='#00ff00'><u><a href='event:dungeon'>" + PropUtils.getStringById(1908) + "</a></u></font>";
					} else {
						str=PropUtils.getStringById(1909) + " <font color='#ff0000'>(" + (o.cm - o.vars) + "/" + (o.cm) + ")</font>";
						str+="<font color='#00ff00'><u><a href='event:dungeon'>" + PropUtils.getStringById(1908) + "</a></u></font>";
					}

					item.taskNameTxt(str);
					this.renderVec[TaskEnum.taskLevel_dragonLine]=item;
				}

				this.updateListPos();

			} else {
				item=this.renderVec[TaskEnum.taskLevel_dragonLine];

				if (item != null) {
					item.y=this.taskCount;
					this.taskCount+=item.height - 20;
				}
			}

			this.gridList.scrollTo(this.gridList.scrollBar_Y.progress);
			DelayCallManager.getInstance().add(this, this.gridList.updateUI, "updateUI", 4);
		}

		/**
		 *答题
		 */
		public function updateQuestion(o:Object=null):void {

			if (Core.me == null || ConfigEnum.question1 > Core.me.info.level)
				return;

			var item:MissionTrackRender;

			if (o != null) {

				questtime=o.rtime;

				if (this.renderVec[TaskEnum.taskLevel_questLine] == null) {
					item=new MissionTrackRender();
					item.setTrBtnVisible(false);

					this.gridList.addToPane(item);
					this.renderVec[TaskEnum.taskLevel_questLine]=item;
				} else
					item=this.renderVec[TaskEnum.taskLevel_questLine];

				item.taskTypeTxt(PropUtils.getStringById(1910));
				item.taskStateTxt("");
				item.taskTargetTxt("");

				if (questtime > 0) {

					item.taskNameTxt(StringUtil.substitute(PropUtils.getStringById(1911), [" <font color='#00ff00'><u><a href='event:enterquest--'>"]) + "</a></u></font> ");
					TimerManager.getInstance().remove(questExeTime);
					TimerManager.getInstance().add(questExeTime);

//					if (!this.questionrenderStateBtn.visible) {
//						this.questionrenderStateBtn.visible=true;
//						this.questionrenderStateBtn.x=50;
//
//						this.questionrenderStateBtn.updateIcon(5);
//						this.questionrenderStateBtn.addEventListener(MouseEvent.CLICK, ontaskClick);
//					}

				} else if (questtime == 0) {

					item.taskNameTxt(StringUtil.substitute(PropUtils.getStringById(1912), [" <font color='#00ff00'><u><a href='event:enterquest--'>"]) + "</a></u></font> ");

//					if (!this.questionrenderStateBtn.visible) {
//
//						this.questionrenderStateBtn.visible=true;
//						this.questionrenderStateBtn.y=this.taskCount;
//						this.questionrenderStateBtn.x=50;
//
//						this.questionrenderStateBtn.updateIcon(5);
//						this.questionrenderStateBtn.addEventListener(MouseEvent.CLICK, ontaskClick);
//
//						SoundManager.getInstance().play(26);
//						this.taskCount+=questionrenderStateBtn.height;
//					}

				} else if (questtime < 0) {

					if (this.renderVec[TaskEnum.taskLevel_questLine] != null) {
//						this.taskCount-=item.height;
						this.gridList.delFromPane(this.renderVec[TaskEnum.taskLevel_questLine]);
						this.renderVec[TaskEnum.taskLevel_questLine]=null;
					}

//					UIManager.getInstance().rightTopWnd.deactive("questBtn")
					this.questionrenderStateBtn.visible=false;
					SoundManager.getInstance().play(26);
//					this.updateListPos(1);
				}

				this.updateListPos();
			} else {

				item=this.renderVec[TaskEnum.taskLevel_questLine];

				if (item != null) {
					item.y=this.taskCount;

//					if (questtime == 0)
					this.taskCount+=item.height - 18;
//					else
//						this.taskCount+=item.height;
				}

				if (this.questionrenderStateBtn.visible) {
					this.questionrenderStateBtn.y=this.taskCount;
					this.taskCount+=questionrenderStateBtn.height;
				}
			}


			this.gridList.scrollTo(this.gridList.scrollBar_Y.progress);
			DelayCallManager.getInstance().add(this, this.gridList.updateUI, "updateUI", 4);
		}

		private function questExeTime(i:int):void {

			var tstr:String;

			if (questtime - i > 0) {
				tstr=DateUtil.formatTime((questtime - i) * 1000, 3);

				this.renderVec[TaskEnum.taskLevel_questLine].taskNameTxt(StringUtil.substitute(PropUtils.getStringById(1913), [" <font color='#00ff00'>" + tstr + "</font> <font color='#00ff00'><u><a href='event:enterquest--'>"]) + "</a></u></font>");

				if (!UIManager.getInstance().isCreate(WindowEnum.QUESTION))
					UIManager.getInstance().creatWindow(WindowEnum.QUESTION);

				if (UIManager.getInstance().questionWnd.visible)
					UIManager.getInstance().questionWnd.updateStartLastTime(tstr);

			} else {
				questtime=0;
				TimerManager.getInstance().remove(questExeTime);
					//					item.taskNameTxt("答题活动即将开启: <font color='#00ff00'>" + tstr + "</font>");
			}


		}

		/**
		 *
		 * @param type
		 * @return
		 *
		 */
		public function getTaskItemRender(type:int):MissionTrackRender {
			return this.renderVec[type];
		}

		/**
		 * 状态按钮
		 * @param e
		 *
		 */
		private function ontaskClick(e:MouseEvent):void {

			if (e.target == this.dailyrenderStateBtn)
				Cmd_Tsk.cmTaskDailyReward();
			else if (e.target == this.renderStateBtn)
				this.autoComplete();
			else if (e.target == this.deliveryrenderStateBtn)
				Cmd_Yct.cm_DeliveryTrackCart();
			else if (e.target == this.questionrenderStateBtn)
				Cmd_Qa.cmQaEnter();

		}

		/**
		 *更新位置
		 * @param i
		 *
		 */
		private function updateListPos(i:int=0):void {

			if (i == 0)
				this.taskCount=this.todayCount;

			var _i:int=0;
			for (; _i < this.taskList.length; _i++) {

				if (this.taskList[_i] != null) {
					if (this.taskList[_i] == this.updateOtherCopy)
						this.taskList[_i](_i);
					else
						this.taskList[_i]();
				}

			}

		}

		/**
		 * 传送
		 *
		 */
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


			var delayTime:Number=0.5;
			var info:TPointInfo;
			if (_type == TaskEnum.taskLevel_switchLine) {

				if (this.linkArr[_type][0].indexOf("monster") > -1) {

					info=TableManager.getInstance().getPointInfo(int(this.linkArr[_type][0].split("--")[1]));
					Cmd_Go.cmGoPoint(int(info.sceneId), info.tx, info.ty);

				} else if (this.linkArr[_type][0] != null) {

					Cmd_Go.cmGoNpc(this.linkArr[_type][0].split("--")[1]);

					TweenLite.delayedCall(delayTime, function():void {
						if (linkArr[_type][0] != null)
							renderVec[_type].autoAstar(linkArr[_type][0]);
					});

				}

			} else if (_type == TaskEnum.taskLevel_deliveryLine) {

				if (this.deliveryrenderStateBtn.visible) {

					Cmd_Yct.cm_DeliveryTrackCart(2);
				} else {
//					this.renderVec[_type].autoAstar("npc_id--" + ConfigEnum.delivery21);
					Cmd_Go.cmGoNpc(ConfigEnum.delivery21);

					TweenLite.delayedCall(delayTime, function():void {
						Cmd_Go.cmGo(ConfigEnum.delivery21);
					});
				}

			} else if (_type == TaskEnum.taskLevel_mercenaryCloseLine || _type == TaskEnum.taskLevel_mercenaryExpLine) {

				info=TableManager.getInstance().getPointInfo(int(this.linkArr[_type][0].split("--")[1]));
				Cmd_Go.cmGoPoint(int(info.sceneId), info.tx, info.ty);

			} else {

				if (int(this.taskOneInfo.st) == 0) {

					if (this.linkArr[_type][0].indexOf("monster") > -1 || this.linkArr[_type][0].indexOf("box") > -1) {
						info=TableManager.getInstance().getPointInfo(int(this.linkArr[_type][0].split("--")[1]));
						Cmd_Go.cmGoPoint(int(info.sceneId), info.tx, info.ty);

					} else if (this.linkArr[_type][0] != null) {
						Cmd_Go.cmGoNpc(this.linkArr[_type][0].split("--")[1]);

						TweenLite.delayedCall(delayTime, function():void {
							if (linkArr[TaskEnum.taskLevel_mainLine][0] != null)
								renderVec[TaskEnum.taskLevel_mainLine].autoAstar(linkArr[TaskEnum.taskLevel_mainLine][0]);
						});

					}

				} else if (int(this.taskOneInfo.st) == 1) {

					if (int(this.taskOneInfo.st) == 1 && this.linkArr[_type][this.linkArr[_type].length - 1] != null) {
						Cmd_Go.cmGoNpc(this.linkArr[_type][this.linkArr[_type].length - 1].split("--")[1]);

						TweenLite.delayedCall(delayTime, function():void {
							if (linkArr[TaskEnum.taskLevel_mainLine][0] != null)
								renderVec[TaskEnum.taskLevel_mainLine].autoAstar(linkArr[TaskEnum.taskLevel_mainLine][0]);
						});
					}

				} else if (int(this.taskOneInfo.st) == -1) {

					var minfo:TMissionDate=TableManager.getInstance().getMissionDataByID(this.taskOneInfo.tid);
					Cmd_Go.cmGoNpc(int(minfo.anpc));

					TweenLite.delayedCall(delayTime, function():void {
						if (linkArr[TaskEnum.taskLevel_mainLine][0] != null)
							renderVec[TaskEnum.taskLevel_mainLine].autoAstar(linkArr[TaskEnum.taskLevel_mainLine][0]);
					});
				}
			}
		}


		/**
		 *自动完成
		 */
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

					TweenLite.delayedCall(0.6, function():void {
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

					if (lv < ConfigEnum.taskDailyOpenLv) {
						NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.taskDailyOpenLv]);
						return;
					}

					if (UIManager.getInstance().isCreate(WindowEnum.TASK) && UIManager.getInstance().taskWnd.visible) {
						return;
					}

					UILayoutManager.getInstance().show_II(WindowEnum.TASK);
					TweenLite.delayedCall(0.3, UIManager.getInstance().taskWnd.changeTab, [1]);
				} else if (this.mainTaskType == TaskEnum.taskType_ElementFlagNum) {
					if (lv < ConfigEnum.ElementOpenLv) {
						NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.ElementOpenLv]);
						return;
					}

					if (UIManager.getInstance().isCreate(WindowEnum.ROLE) && UIManager.getInstance().roleWnd.visible) {
						return;
					}

					UILayoutManager.getInstance().show_II(WindowEnum.ROLE);
					TweenLite.delayedCall(0.3, UIManager.getInstance().roleWnd.setTabIndex, [3]);
				} else if (this.mainTaskType == TaskEnum.taskType_ArenaPkNum) {
					if (lv < ConfigEnum.ArenaOpenLv) {
						NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.ArenaOpenLv]);
						return;
					}

					if (UIManager.getInstance().isCreate(WindowEnum.ARENA) && UIManager.getInstance().arenaWnd.visible) {
						return;
					}

					UILayoutManager.getInstance().show_II(WindowEnum.ARENA);
				} else {
					stateTxt="ee2211";

					//&& this.taskInfo["var"] == 0
					if (this.linkArr[TaskEnum.taskLevel_mainLine][0] != null)
						this.renderVec[TaskEnum.taskLevel_mainLine].autoAstar(this.linkArr[TaskEnum.taskLevel_mainLine][0]);
				}

			} else if (int(this.taskOneInfo.st) == 1) {
				stateTxt="00ff9c";

				if (int(this.taskOneInfo.st) == 1 && this.linkArr[TaskEnum.taskLevel_mainLine][this.linkArr[TaskEnum.taskLevel_mainLine].length - 1] != null)
					this.renderVec[TaskEnum.taskLevel_mainLine].autoAstar(this.linkArr[TaskEnum.taskLevel_mainLine][this.linkArr[TaskEnum.taskLevel_mainLine].length - 1]);

			} else if (int(this.taskOneInfo.st) == -1) {
				var minfo:TMissionDate=TableManager.getInstance().getMissionDataByID(this.taskOneInfo.tid);
				this.renderVec[TaskEnum.taskLevel_mainLine].autoAstar("npc_id--" + minfo.anpc);
			}

			GuideManager.getInstance().removeGuide(19);
//			this.autoAstar=true;
		}

		public function resize():void {
			if (this.missionSoulBar.visible) {
				this.x=(UIEnum.WIDTH - 271); //933=真实宽度
				this.y=((UIEnum.HEIGHT - 246) >> 1); //107=真实高度
			} else {
				this.x=(UIEnum.WIDTH - 20);
				this.y=((UIEnum.HEIGHT - 246) >> 1); //107=真实高度
			}
		}

		override public function hide():void {
			super.hide();

			GuideManager.getInstance().removeGuide(19);

			if (UIManager.getInstance().deliveryPanel != null)
				UIManager.getInstance().deliveryPanel.closehide();
		}

		override public function show():void {

			var sv:Boolean=UIManager.getInstance().isCreate(WindowEnum.COPYTRACK) && UIManager.getInstance().copyTrack.visible;
			sv=sv || (UIManager.getInstance().isCreate(WindowEnum.EXP_COPY_TRACK) && UIManager.getInstance().expCopyTrack.visible);
			sv=sv || (UIManager.getInstance().isCreate(WindowEnum.QUESTION) && UIManager.getInstance().questionWnd.visible);

			if (!sv) {

				super.show();

				if (Core.me != null && Core.me.info.isTransport)
					UIManager.getInstance().showWindow(WindowEnum.DELIVERYPANEL);
			}

		}

		public function get taskInfo():Object {
			return this._taskInfo;
		}


		/************************************************************************************************************************************************/


		/**
		 *
		 * @param type: TaskEnum
		 * @param arr: 内容
		 * <pre>
		 * arr=[
		 * 		0:类型; 如:[答题]
		 * 		1:名字
		 * 		2:内容;
		 * 		3:内容;
		 * 		4:单击回调 超链接回调处理:href中用 other_xxx--xxx;
		 * 		5:状态;
		 * 		6:小飞鞋回调 ,默认会放入任务类型; 如: TaskEnum.taskLevel_fieldbossCopyLine
		 * ];
		 * </pre>
		 */
		public function updateOhterTrack(type:int, arr:Array):void {

			if (this.taskList[type] == null) {
				this.taskList[type]=this.updateOtherCopy;
			}


			this.taskList[type](type, arr);
		}

		/**
		 * @param type
		 */
		public function delOtherTrack(type:int):void {
			this.taskList[type]=null;

			if (this.renderVec[type] != null) {
				this.gridList.delFromPane(this.renderVec[type]);
				this.renderVec[type]=null;
			}

			this.updateListPos();
		}

		/**
		 * @param arr
		 * <pre>
		 * arr=[
		 * 		0:类型
		 * 		1:名字
		 * 		2:内容;
		 * 		3:内容;
		 * 		4:单击回调 超链接回调处理: href中用 other_xxx--xxx;
		 * 		5:状态;
		 * 		6:小飞鞋回调 ,默认会放入任务类型
		 * ];
		 * </pre>
		 */
		private function updateOtherCopy(type:int, arr:Array=null):void {

			var item:MissionTrackRender;

			if (arr != null) {

				if (this.renderVec[type] == null) {

					item=new MissionTrackRender();
					item.taskType=type;

					this.gridList.addToPane(item);

//					item.flyFunc=execultFly;
					item.y=this.taskCount;
					this.taskCount+=item.height;

				} else
					item=this.renderVec[type];

				item.taskTypeTxt(arr[0] + "");
				item.taskNameTxt(arr[1] + "");

				if (arr[2] != null && arr[2] != "") {
					item.targetVisible.visible=true;
					item.taskTargetTxt(arr[2] + "");
				} else
					item.targetVisible.visible=false;

				if (arr[3] != null && arr[3] != "") {
					item.lastHpLbl.visible=true;
					item.taskLastHpTxt(arr[3] + "");
				} else {
					item.lastHpLbl.visible=false;
				}

				item.otherCallBack=arr[4];

				if (arr[5] != null && arr[5] != "")
					item.taskStateTxt(arr[5] + "");
				else
					item.taskStateTxt("");

				if (arr[6] != null) {
					item.flyFunc=arr[6];
					item.setTrBtnVisible(true);
				} else
					item.setTrBtnVisible(false);

				this.renderVec[type]=item;
				this.updateListPos();

			} else {

				item=this.renderVec[type];

				if (item != null) {

					item.y=this.taskCount;

					if (item.lastHpLbl.visible)
						this.taskCount+=item.height + 20;
					else if (item.targetVisible.visible)
						this.taskCount+=item.height;
					else
						this.taskCount+=item.height - 20;

				}

			}

			this.gridList.scrollTo(this.gridList.scrollBar_Y.progress);
			DelayCallManager.getInstance().add(this, this.gridList.updateUI, "updateUI", 4);
		}


	}
}

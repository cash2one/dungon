package com.leyou.ui.task {
	import com.ace.config.Core;
	import com.ace.enum.CursorEnum;
	import com.ace.enum.EventEnum;
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
	import com.ace.gameData.table.THallows;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TMissionDate;
	import com.ace.gameData.table.TPointInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.CursorManager;
	import com.ace.manager.EventManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LayerManager;
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
	import com.greensock.TweenMax;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.TaskEnum;
	import com.leyou.net.cmd.Cmd_Arena;
	import com.leyou.net.cmd.Cmd_Go;
	import com.leyou.net.cmd.Cmd_Qa;
	import com.leyou.net.cmd.Cmd_Tsk;
	import com.leyou.ui.task.child.MissionTrackRender;
	import com.leyou.ui.task.child.TaskTrackBtn;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.TaskUtil;

	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;

	public class TaskTrack2 extends AutoSprite {

		private var taskIcon:Image;
		private var mainIcon:Image;

		private var acceptTaskBtn:ImgButton;
//		private var arrowBtn:ImgButton;

		private var hallowLbl:Label;
		private var taskDescLbl:Label;
		private var progressLbl:Label;
		private var taskTargetLbl:Label;
		private var taskNameLbl:Label;

		private var arrowBtn:ImgButton;
		private var arrowIcon:Image;
		private var twn:TweenMax;

		private var trbtn:ImgButton;

		public var taskOneInfo:Object;
		public var taskLoopInfo:Object;
		private var linkArr:Array=[];
		private var taskList:Array=[];

		/**
		 *
		 */
		private var firstAutoAstar:Boolean=true;
		private var firstLogin:Boolean=true;

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

		private var renderStateBtn:TaskTrackBtn;
		private var effSwf:SwfLoader;

		private var hallowsVec:Array=[];

		private var hallowCurrentTopIndex:int;

		private var hallowCurrentIndex:int;

		private var progress:int;

		public var taskType:int=0;
		public var taskDtype:int=0;

		private var viewState:Boolean=true;

		public function TaskTrack2() {
			super(LibManager.getInstance().getXML("config/ui/task/missionTrack2.xml"));
			this.init();
//			this.hideBg();
//			this.clsBtn.visible=false;
			this.mouseChildren=true;
			this.resize();
		}

		private function init():void {

			this.taskIcon=this.getUIbyID("taskIcon") as Image;
			this.mainIcon=this.getUIbyID("mainIcon") as Image;

			this.acceptTaskBtn=this.getUIbyID("acceptTaskBtn") as ImgButton;
			this.arrowBtn=this.getUIbyID("arrowBtn") as ImgButton;

			this.hallowLbl=this.getUIbyID("hallowLbl") as Label;
			this.taskDescLbl=this.getUIbyID("taskDescLbl") as Label;
			this.progressLbl=this.getUIbyID("progressLbl") as Label;
			this.taskTargetLbl=this.getUIbyID("taskTargetLbl") as Label;
			this.taskNameLbl=this.getUIbyID("taskNameLbl") as Label;

//			this.acceptTaskBtn.addEventListener(MouseEvent.CLICK, onClick);
//			this.arrowBtn.addEventListener(MouseEvent.CLICK, onArrowClick);

			this.taskDescLbl.height=76;
			this.taskDescLbl.width=251;
			this.taskDescLbl.wordWrap=true;
			this.taskDescLbl.multiline=true;

			this.taskTargetLbl.addEventListener(TextEvent.LINK, onLink);
			this.taskTargetLbl.mouseEnabled=true;
			this.taskTargetLbl.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

			this.renderStateBtn=new TaskTrackBtn();
			this.addChild(this.renderStateBtn);

			this.renderStateBtn.x=42;
			this.renderStateBtn.y=257;

			this.renderStateBtn.addEventListener(MouseEvent.CLICK, onRenderClick);

			this.addToUILib("accTaskLbl", this.renderStateBtn);

			this.effSwf=new SwfLoader(99972);
			this.addChild(this.effSwf);

			this.addChild(this.mainIcon);

			this.effSwf.x=this.mainIcon.x;
			this.effSwf.y=this.mainIcon.y + 1;

			this.arrowIcon=new Image("ui/mission/rwzz_bg.png");
//			this.arrowIcon.y=this.arrowBtn.y+this.arrowBtn.height;
			this.addChild(this.arrowIcon);
			this.arrowIcon.visible=false;

			LayerManager.getInstance().mainLayer.addChild(this.arrowIcon);

			this.arrowBtn=new ImgButton("ui/funForcast/btn_right.png");
			LayerManager.getInstance().mainLayer.addChild(this.arrowBtn);

			this.arrowBtn.x=UIEnum.WIDTH - this.arrowBtn.width;
			this.arrowBtn.y=2;

			this.arrowBtn.addEventListener(MouseEvent.CLICK, onArrowClick);

			this.trbtn=new ImgButton("ui/mission/mission_quick.png", PriorityEnum.FIVE);
			this.addChild(this.trbtn);
			this.trbtn.addEventListener(MouseEvent.CLICK, onTrBtn);
			this.trbtn.addEventListener(MouseEvent.MOUSE_OVER, onTrOverBtn);
			this.trbtn.doubleClickEnabled=false;

			this.trbtn.x=this.taskNameLbl.x + this.taskNameLbl.textWidth + 10;
			this.trbtn.y=this.taskNameLbl.y

			this.linkArr[TaskEnum.taskLevel_mainLine]=[];

			EventManager.getInstance().addEvent(EventEnum.FIRST_LOGIN_CLICK, onCompleteII);
		}

		private function onCompleteII():void {
			this.autoComplete();
		}

		private function onRenderClick(e:MouseEvent):void {
			this.autoComplete();
		}

		private function onTrBtn(e:MouseEvent):void {
			this.execultFly(1);
		}

		private function onTrOverBtn(e:MouseEvent):void {

			var count:int=MyInfoManager.getInstance().VipLastTransterCount;
			if (count < 0)
				this.trbtn.setToolTip(StringUtil.substitute(TableManager.getInstance().getSystemNotice(9937).content, [PropUtils.getStringById(1890)]));
			else
				this.trbtn.setToolTip(StringUtil.substitute(TableManager.getInstance().getSystemNotice(9937).content, [count]));
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

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "acceptTaskBtn":
					this.autoComplete();
					break;
				case "arrowBtn":

					break;
			}

		}


		private function onArrowClick(e:MouseEvent):void {

			var w:int=this.width;
			var i:int=w - 30;

			if (viewState) {

				TweenLite.to(this, 1, {x: UIEnum.WIDTH - 20, onComplete: function():void {
					arrowBtn.updataBmd("ui/funForcast/btn_left.png");
					arrowIcon.visible=true;
					visible=false;
					viewState=false;
				}});

//				TweenLite.to(this.arrowBtn, 1, {x: 2});

			} else {

				visible=true;
				arrowIcon.visible=false;
				TweenLite.to(this, 1, {x: UIEnum.WIDTH - 265 + 20, onComplete: function():void {
					arrowBtn.updataBmd("ui/funForcast/btn_right.png");
					viewState=true;
				}});

//				TweenLite.to(this.arrowBtn, 1, {x: this.width - this.arrowBtn.width - 15});
			}

		}

		public function setScalePanelState(v:Boolean):void {
			if (Core.me == null)
				return;

			if (Core.me != null && Core.me.info.level > 30)
				return;

			var w:int=this.width;
			var i:int=w - 30;


			if (!v) {

				TweenLite.to(this, 1, {x: UIEnum.WIDTH - 20, onComplete: function():void {
					arrowBtn.updataBmd("ui/funForcast/btn_left.png");
					arrowIcon.visible=true;
					visible=false;
					viewState=v;
				}});

					//				TweenLite.to(this.arrowBtn, 1, {x: 2});

			} else {
				visible=true;
				arrowIcon.visible=false;
				TweenLite.to(this, 1, {x: UIEnum.WIDTH - this.width + 20, onComplete: function():void {
					arrowBtn.updataBmd("ui/funForcast/btn_right.png");
					viewState=v;
				}});

					//				TweenLite.to(this.arrowBtn, 1, {x: this.width - this.arrowBtn.width - 15});
			}

		}

		private function onLink(e:TextEvent):void {

			var ctx:String=e.text;
			var str:Array=ctx.split("--");
			var lv:int=Core.me.info.level;

//			ModuleProxy.showChatMsg("30前+++++模拟触发下一个任务---text>>>" + ctx);
//			trace("30前+++++模拟触发下一个任务---text>>>" + ctx);

			if (this.taskType == TaskEnum.taskLevel_switchLine) {
				GuideManager.getInstance().removeGuide(104);
			}


			if (str[0].indexOf("mercenary") > -1) {
				if (int(this.taskType) == TaskEnum.taskLevel_mercenaryCloseLine || int(this.taskType) == TaskEnum.taskLevel_mercenaryExpLine || this.taskDtype == TaskEnum.taskType_Mercenary)
					UIOpenBufferManager.getInstance().open(WindowEnum.PET);
			} else if (this.taskType == TaskEnum.taskLevel_switchLine && this.taskDtype == TaskEnum.taskType_Exchange) {
				UILayoutManager.getInstance().show(WindowEnum.SHOP);
				UIManager.getInstance().buyWnd.updateTask(int(str[1]), int(taskTargetLbl.text.split("/")[1].replace(")", "")));

				TweenLite.delayedCall(.5, function():void {
					UIManager.getInstance().buyWnd.show();
				});

			} else if (str[0].indexOf("monster") > -1 || str[0].indexOf("box") > -1) {
				var info:TPointInfo=TableManager.getInstance().getPointInfo(int(str[1]));

				if (info == null)
					return;
//				ModuleProxy.showChatMsg("30前+++++模拟触发下一个任务--monster>>>"+str);
//				trace("30前+++++模拟触发下一个任务--monster>>>"+str);
				//跨场景寻路
				Core.me.gotoMap(new Point(info.tx, info.ty), info.sceneId);
				Core.me.pInfo.currentTaskType=str[0].indexOf("monster") > -1 ? PlayerEnum.TASK_MONSTER : PlayerEnum.TASK_COLLECT;

				SettingManager.getInstance().assitInfo.startAutoTask();

			} else if (str[0].indexOf("npc") > -1) {
//				ModuleProxy.showChatMsg("30前+++++模拟触发下一个任务--npc>>>"+str);
//				trace("30前+++++模拟触发下一个任务--npc>>>"+str)
				Cmd_Go.cmGo(str[1]);
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

				if (DataManager.getInstance().elementData.ctype != 0)
					TweenLite.delayedCall(0.3, UILayoutManager.getInstance().show, [WindowEnum.ELEMENT, WindowEnum.ELEMENT_UPGRADE]);

			} else if (str[0].indexOf("mount") > -1) {

				if (lv < ConfigEnum.MountOpenLv) {
					NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.MountOpenLv]);
					return;
				}

				if (UIManager.getInstance().isCreate(WindowEnum.ROLE) && UIManager.getInstance().roleWnd.visible) {
					return;
				}

				UILayoutManager.getInstance().open_II(WindowEnum.ROLE);

				TweenLite.delayedCall(0.6, function():void {
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
//				GuideManager.getInstance().removeGuide(18);

			} else if (str[0].indexOf("arena") > -1) {

				if (lv < ConfigEnum.ArenaOpenLv) {
					NoticeManager.getInstance().broadcastById(9963, [ConfigEnum.ArenaOpenLv]);
					return;
				}

				UILayoutManager.getInstance().open_II(WindowEnum.ARENA);
					//				GuideManager.getInstance().removeGuide(32);
			}


		}

		private function updateTaskItem(o:Object):void {

			if (this.taskOneInfo != null && this.taskOneInfo.tid == o.tid && this.taskOneInfo.st == o.st && this.taskOneInfo["var"] == o["var"]) {
//				this.taskCount=100;
				return;
			}

			var minfo:TMissionDate;
			var item:MissionTrackRender;

			if (o.hasOwnProperty("tid")) {

				//目标字段
				minfo=TableManager.getInstance().getMissionDataByID(o.tid);


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

					if (o.st == -1) {
						this.renderStateBtn.updateIcon(0);
					} else {
						this.renderStateBtn.updateIcon(1);
					}

				} else if (o.st == 1) {

					if (int(minfo.type) == TaskEnum.taskLevel_mainLine) {
						this.renderStateBtn.updateIcon(2);
//						item.targetVisible.visible=true;
						this.linkArr[int(minfo.type)].push("npc_id--" + minfo["dnpc"]);
						tartxt=StringUtil.substitute(PropUtils.getStringById(1894), ["<font color='#00ff00'><u><a href='event:" + this.linkArr[int(minfo.type)][0] + "'>" + TaskUtil.getTaskTargetName("npc_id", minfo.dnpc) + "</a></u></font>"]);
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

				this.taskNameLbl.htmlText="" + (minfo.name);

				if (int(minfo.type) == TaskEnum.taskLevel_mainLine) {

					MyInfoManager.getInstance().isTaskOk=(o.st == 1);
					MyInfoManager.getInstance().currentTaskId=o.tid;

					taskID=o.tid;
					this.mainTaskType=int(minfo.dtype);

//					if (o.tid == 96)
//						GuideManager.getInstance().showGuide(104, this); //.getWidget("expCopyBtn"));

//					if (o.tid == TableManager.getInstance().getGuideInfo(83).act_con) {
//						GuideManager.getInstance().showGuide(83, UIManager.getInstance().rightTopWnd.getWidget("teamCopyBtn"));
//					} else
//						GuideManager.getInstance().removeGuide(83);


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
								//							if (this.taskOneInfo == null)
								//								dc=2;
								//
								//			TweenLite.delayedCall(dc, UIManager.getInstance().roleWnd.setTabIndex, [3]);
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
							TweenLite.delayedCall(0.6, function():void {
								UIManager.getInstance().equipWnd.changeTable(5);
							});
						} else if (this.mainTaskType == TaskEnum.taskType_SaveElement) {

							if (UIManager.getInstance().isCreate(WindowEnum.ELEMENT) && UIManager.getInstance().elementWnd.visible) {
								return;
							}

							if (!UIManager.getInstance().isCreate(WindowEnum.ELEMENT) || !UIManager.getInstance().getWindow(WindowEnum.ELEMENT).visible)
								UIOpenBufferManager.getInstance().open(WindowEnum.ELEMENT);
						}
					}


//					if (o.st != 1) {
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

//				if (o.st != 1 && (this.mainTaskType == TaskEnum.taskType_upgrade || this.mainTaskType >= TaskEnum.taskType_TodayTaskSuccessNum))
//					item.setTrBtnVisible(false);
//				else
//					item.setTrBtnVisible(true);

			}

			this.taskTargetLbl.htmlText=(tartxt);
			this.taskDescLbl.text="" + minfo.describ;
			this.taskNameLbl.htmlText+="   <font color='#" + stateTxt + "'>" + TaskUtil.getStringByState(int(o.st)) + "</font>"
//			item.taskTypeTxt("[" + TaskUtil.getStringByType(int(minfo.type)) + "]");

			if (int(minfo.type) == TaskEnum.taskLevel_mainLine) {
				/**
				 * 自动打怪
				 */
				if (Core.me.info.level > 30 && this.taskOneInfo != null && this.taskOneInfo.tid == o.tid && this.taskOneInfo.st == o.st && this.taskOneInfo["var"] != o["var"]) {
//						this.autoComplete();
				}

				this.taskOneInfo=o;
			}

			this.trbtn.x=this.taskTargetLbl.x + this.taskTargetLbl.textWidth + 10;
			this.trbtn.y=this.taskTargetLbl.y

//			item.flyFunc=execultFly;
		}

		private function execultFly(_type:int):void {

			if (_type != TaskEnum.taskLevel_deliveryLine && this.linkArr[_type][0] == null)
				return;

//			GuideManager.getInstance().removeGuide(67);

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


			var delayTime:Number=0.6;
			var info:TPointInfo;


			if (int(this.taskOneInfo.st) == 0) {

				if (this.linkArr[_type][0].indexOf("monster") > -1 || this.linkArr[_type][0].indexOf("box") > -1) {
					info=TableManager.getInstance().getPointInfo(int(this.linkArr[_type][0].split("--")[1]));
					Cmd_Go.cmGoPoint(int(info.sceneId), info.tx, info.ty);

					Core.me.pInfo.currentTaskType=this.linkArr[_type][0].indexOf("monster") > -1 ? PlayerEnum.TASK_MONSTER : PlayerEnum.TASK_COLLECT;

				} else if (this.linkArr[_type][0] != null) {
					Cmd_Go.cmGoNpc(this.linkArr[_type][0].split("--")[1]);

//					TweenLite.delayedCall(delayTime, function():void {
//						if (linkArr[TaskEnum.taskLevel_mainLine][0] != null)
//							renderVec[TaskEnum.taskLevel_mainLine].autoAstar(linkArr[TaskEnum.taskLevel_mainLine][0]);
//					});

				}

			} else if (int(this.taskOneInfo.st) == 1) {

				if (int(this.taskOneInfo.st) == 1 && this.linkArr[_type][this.linkArr[_type].length - 1] != null) {
					Cmd_Go.cmGoNpc(this.linkArr[_type][this.linkArr[_type].length - 1].split("--")[1]);

//					TweenLite.delayedCall(delayTime, function():void {
//						if (linkArr[TaskEnum.taskLevel_mainLine][0] != null)
//							renderVec[TaskEnum.taskLevel_mainLine].autoAstar(linkArr[TaskEnum.taskLevel_mainLine][0]);
//					});
				}

			} else if (int(this.taskOneInfo.st) == -1) {

				var minfo:TMissionDate=TableManager.getInstance().getMissionDataByID(this.taskOneInfo.tid);
				Cmd_Go.cmGoNpc(int(minfo.anpc));

//				TweenLite.delayedCall(delayTime, function():void {
//					if (linkArr[TaskEnum.taskLevel_mainLine][0] != null)
//						renderVec[TaskEnum.taskLevel_mainLine].autoAstar(linkArr[TaskEnum.taskLevel_mainLine][0]);
//				});
			}

		}

		public function updateInfo(o:Object):void {

//			trace(Core.me, Core.me.info.level)


			if (Core.me != null && Core.me.info.level >= 30) {
				if (this.arrowBtn.visible)
					Cmd_Tsk.cmTaskQuest();

				UIManager.getInstance().taskTrack.setFirstAutoStarState(false);
				UIManager.getInstance().taskTrack.viewState=true;

				this.hide();
				this.arrowBtn.visible=false;
				this.arrowIcon.visible=false;

				this.viewState=false;
				return;
			} else {

				if (!this.visible && MapInfoManager.getInstance().type != SceneEnum.SCENE_TYPE_PTCJ) {
					this.arrowBtn.visible=false;
					return;
				} else
					this.arrowBtn.visible=true;
//				this.arrowIcon.visible=true;
			}

			var tr:Array=o.tr;
			tr.sortOn("type", Array.CASEINSENSITIVE | Array.NUMERIC);

			var tritem:Object;
			for each (tritem in tr) {
				if (tritem != null) {
					if (o.hasOwnProperty("award") && o.award == 1) {

					} else {
						if (tritem.hasOwnProperty("cloop"))
							continue;

						this.updateTaskItem(tritem);
					}
				}
			}


			this.updateOtherTaskList(tr[0]);
			this.firstAutoAstar=false;
		}

		public function updateOtherTaskList(o:Object):void {

			if (Core.me == null)
				return;

			//      	保留待意
			//			this.updateMainNpcIcon();

			this.hallowsVec.length=0;

			var hvec:Vector.<THallows>=TableManager.getInstance().getHallowslistByid(Core.me.info.profession);
			var info:THallows;

			for each (info in hvec) {
				if (this.hallowsVec.indexOf(info.Hallows_TeamID) == -1)
					this.hallowsVec.push(info.Hallows_TeamID);
			}


			this.hallowCurrentTopIndex=this.hallowCurrentIndex=this.hallowsVec.indexOf(TableManager.getInstance().getMissionDataByID(o.tid).Hallows_TeamID);

			this.mainIcon.updateBmp("ui/mission/mission_icon" + (this.hallowCurrentIndex + 1) + "_big.png", onComplete);

			var teamid:String;
			var mvec:Vector.<TMissionDate>=TableManager.getInstance().getMissionDataByHallowTeamId(this.hallowsVec[this.hallowCurrentIndex]);
			var minfo:TMissionDate;

			this.progress=0;

			var isextis:Boolean=false;
			var p:int=0;

			//可接列表
			for each (minfo in mvec) {
				if (minfo.id == o.tid) {
					isextis=true;
				} else {
					if (!isextis) {
						this.progress++;
					}
				}
				p++;
			}

			if (this.hallowCurrentIndex == this.hallowCurrentTopIndex) {
				this.progressLbl.text=PropUtils.getStringById(2420) + int(progress / mvec.length * 100) + "%";
			} else {
				this.progressLbl.text=PropUtils.getStringById(2420) + "100%";
			}

			this.hallowLbl.text="" + TableManager.getInstance().getHallowslistByProfressAndTeamId(Core.me.info.profession, this.hallowsVec[this.hallowCurrentIndex]).Hallows_Name;
		}

		private function onComplete(e:Image):void {

			if (this.twn == null) {
				this.twn=TweenMax.to(this.mainIcon, .5, {y: this.mainIcon.y + 4, yoyo: true, repeat: -1});
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

					TweenLite.delayedCall(1.2, function():void {
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
					TweenLite.delayedCall(1.2, function():void {
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

		override public function show():void {

			if (MapInfoManager.getInstance().type != SceneEnum.SCENE_TYPE_PTCJ) {
				this.hide();
				return;
			}

			this.arrowBtn.visible=true;

			if (viewState) {
				this.arrowIcon.visible=false;
				super.show();
			} else
				this.arrowIcon.visible=true;

//			if (Core.me != null && Core.me.info.level > 30) {
//				this.hide();
//				UIManager.getInstance().taskTrack.show();
//			} 
		}

		override public function hide():void {
			super.hide();

			this.arrowBtn.visible=false;
			this.arrowIcon.visible=false;

//			if (Core.me != null && Core.me.info.level > 30) {
//				UIManager.getInstance().taskTrack.hide();
//			}

		}

		public function resize():void {
			if (!viewState) {
				this.x=(UIEnum.WIDTH); //933=真实宽度
				this.y=((UIEnum.HEIGHT - 246) >> 1); //107=真实高度
			} else {
				this.x=(UIEnum.WIDTH - 265); //933=真实宽度
				this.y=((UIEnum.HEIGHT - 246) >> 1); //107=真实高度
			}

			this.arrowBtn.x=UIEnum.WIDTH - this.arrowBtn.width;
			this.arrowBtn.y=this.y; // + 20;

			this.arrowIcon.x=UIEnum.WIDTH - this.arrowIcon.width;
			this.arrowIcon.y=this.arrowBtn.y - 5 + arrowBtn.height;

			LayerManager.getInstance().mainLayer.addChild(this.arrowBtn);
			LayerManager.getInstance().mainLayer.addChild(this.arrowIcon);
		}



	}
}

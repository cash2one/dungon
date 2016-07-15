package com.leyou.ui.task.child {

	import com.ace.config.Core;
	import com.ace.delayCall.DelayCallManager;
	import com.ace.enum.WindowEnum;
	import com.ace.game.proxy.SceneProxy;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TMissionDate;
	import com.ace.gameData.table.TPointInfo;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.SoundManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.TaskEnum;
	import com.leyou.manager.TimerManager;
	import com.leyou.net.cmd.Cmd_Go;
	import com.leyou.net.cmd.Cmd_Yct;
	import com.leyou.util.DateUtil;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.TaskUtil;

	public class MissionTrackRender2 extends AutoSprite {

		private var gridList:ScrollPane;
		private var renderVec:Array=[];

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
		public var taskLoopInfo:Object;
		private var linkArr:Array=[];
		private var taskList:Array=[];

		/**
		 *总位置
		 */
		private var taskCount:int=0;

		/**
		 *日常位置
		 */
		private var todayCount:int=25;

		private var _taskInfo:Object;

		private var questtime:int=0;

		public function MissionTrackRender2() {
			super(LibManager.getInstance().getXML("config/ui/task/missionTrackRender2.xml"));
			this.init();
			this.mouseChildren=true
		}

		private function init():void {
			this.gridList=this.getUIbyID("itemList") as ScrollPane;

			this.linkArr[TaskEnum.taskLevel_mercenaryExpLine]=[];
			this.linkArr[TaskEnum.taskLevel_mercenaryCloseLine]=[];

			this.taskList[TaskEnum.taskLevel_questLine]=updateQuestion;
			this.taskList[TaskEnum.taskLevel_deliveryLine]=updateDelivery;
			this.taskList[TaskEnum.taskLevel_arenaLine]=updateArena;
			this.taskList[TaskEnum.taskLevel_dragonLine]=updateDungeon;


		}

		public function updateInfo(o:Object):void {

//			this.taskCount=0;
//
//			if (this.renderVec[TaskEnum.taskLevel_mercenaryCloseLine] != null) {
//				this.renderVec[TaskEnum.taskLevel_mercenaryCloseLine].visible=false;
//				this.todayCount=20;
//			} else
//				this.todayCount=0;
//
//			if (this.renderVec[TaskEnum.taskLevel_mercenaryExpLine] != null) {
//				this.renderVec[TaskEnum.taskLevel_mercenaryExpLine].visible=false;
//			}
//
//			this.updateTaskItem(o);
		}

		private function updateTaskItem(o:Object):void {

			if (this.taskOneInfo != null && this.taskOneInfo.tid == o.tid && this.taskOneInfo.st == o.st && this.taskOneInfo["var"] == o["var"]) {
				this.taskCount=100;
				return;
			}

			var minfo:TMissionDate;
			var item:MissionTrackLable;

			if (o.hasOwnProperty("tid")) {

				//目标字段
				minfo=TableManager.getInstance().getMissionDataByID(o.tid);

				if (this.renderVec[int(minfo.type)] == null) {
					item=new MissionTrackLable();
				} else {
					item=this.renderVec[minfo.type];
					item.visible=true;
				}

//				item.y=this.taskCount;
				this.taskCount+=item.height;

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

				}

				item.taskNameTxt("<a href='event:mercenary--'>" + minfo.name + "</a>");

//				if (int(minfo.type) == TaskEnum.taskLevel_mercenaryCloseLine || int(minfo.type) == TaskEnum.taskLevel_mercenaryExpLine) {
//
//					if (o.st == 1) {
//
//						if (item.targetVisible.visible) {
//							SceneProxy.onTaskComplete();
//
//							item.taskNameTxt(minfo.name + " <font color='#00ff00'><u><a href='event:mercenary--'>领取奖励</a></u></font>");
//							item.setTrBtnVisible(false);
//							item.targetVisible.visible=false;
//						}
//
//						taskCount-=20;
//					} else {
//						item.setTrBtnVisible(true);
//						item.targetVisible.visible=true;
//					}
//				}
//
//				var stateTxt:String;
//				if (int(o.st) == 0 && o["var"] == 0) {
//					stateTxt="ee2211";
//				} else if (int(o.st) == 1) {
//					stateTxt="00ff9c";
//				}
//
//				item.taskTargetTxt(tartxt);
//				item.taskStateTxt("<font color='#" + stateTxt + "'>" + TaskUtil.getStringByState(int(o.st)) + "</font>");
//				item.taskTypeTxt("[" + TaskUtil.getStringByType(int(minfo.type)) + "]");
//
//				this.renderVec[int(minfo.type)]=item;
			}

			item.flyFunc=execultFly;
			this.gridList.addToPane(item);
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
			if (_type == TaskEnum.taskLevel_deliveryLine) {
//				if (this.deliveryrenderStateBtn.visible) {
//					Cmd_Yct.cm_DeliveryTrackCart(2);
//				} else {
//					this.renderVec[_type].autoAstar("npc_id--" + ConfigEnum.delivery21);
				Cmd_Go.cmGoNpc(ConfigEnum.delivery21);

				TweenLite.delayedCall(delayTime, function():void {
					Cmd_Go.cmGo(ConfigEnum.delivery21);
				});
//				}

			} else if (_type == TaskEnum.taskLevel_mercenaryCloseLine || _type == TaskEnum.taskLevel_mercenaryExpLine) {

				info=TableManager.getInstance().getPointInfo(int(this.linkArr[_type][0].split("--")[1]));
				Cmd_Go.cmGoPoint(int(info.sceneId), info.tx, info.ty);

			}
		}

		/**
		 *更新位置
		 * @param i
		 *
		 */
		private function updateListPos(i:int=0):void {

			if (i == 0) {

				if (this.renderVec[TaskEnum.taskLevel_mercenaryCloseLine] != null && this.renderVec[TaskEnum.taskLevel_mercenaryCloseLine].visible) {
					this.todayCount=25;
				} else
					this.todayCount=0;

				this.taskCount=this.todayCount;
			}

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
		 * 押镖
		 * @param o
		 *
		 */
		public function updateDelivery(o:Object=null):void {

			if (Core.me != null && ConfigEnum.delivery19 > Core.me.info.level)
				return;

			var item:MissionTrackLable;

			if (o != null) {

				if (this.renderVec[TaskEnum.taskLevel_deliveryLine] == null) {

					item=new MissionTrackLable();
					item.taskType=TaskEnum.taskLevel_deliveryLine;
					this.gridList.addToPane(item);

					item.flyFunc=execultFly;
					item.y=this.taskCount;
					this.taskCount+=item.height;

				} else
					item=this.renderVec[TaskEnum.taskLevel_deliveryLine];

				item.taskTypeTxt(PropUtils.getStringById(2425));
				//if (o.ynum == o.zynum) {
				item.taskNameTxt("<a href='event:npc_id--" + ConfigEnum.delivery21 + "'>" + PropUtils.getStringById(2442) + "</a>");
				//} else
				//	item.taskNameTxt("<a href='event:npc_id--" + ConfigEnum.delivery21 + "'>" +PropUtils.getStringById(2442) + " <font color='#ff0000'>(" + o.ynum + "/" + o.zynum + ")</font>");

				switch (o.yst) {
					case 0:
						item.taskStateTxt(PropUtils.getStringById(2425) + "");
						item.taskTargetTxt(StringUtil.substitute(PropUtils.getStringById(2448), [o.zynum - o.ynum]));
						item.taskLastHpTxt("");
						item.setTrBtnVisible(true);

//						if (this.deliveryrenderStateBtn.visible) {
//							this.deliveryrenderStateBtn.visible=false;
//						}

						break;
					case 1:
						item.taskStateTxt("<font color='#ee2211'>" + PropUtils.getStringById(1900) + "</font>");

						item.taskTargetTxt(StringUtil.substitute(PropUtils.getStringById(2448), [o.zynum - o.ynum]));
						item.taskLastHpTxt("");

//						this.deliveryrenderStateBtn.visible=false;

						item.setTrBtnVisible(false);

						if (!UIManager.getInstance().isCreate(WindowEnum.DELIVERYPANEL))
							UIManager.getInstance().creatWindow(WindowEnum.DELIVERYPANEL);

						if (!UIManager.getInstance().deliveryPanel.visible)
							UIManager.getInstance().deliveryPanel.show();

						UIManager.getInstance().deliveryPanel.updateInfo(o);
						break;
					case 2:
						item.taskStateTxt("<font color='#00ff9c'>" + PropUtils.getStringById(1584) + "</font>");
						item.taskTargetTxt(StringUtil.substitute(PropUtils.getStringById(2448), [o.zynum - o.ynum]));
						item.taskLastHpTxt("");
						item.setTrBtnVisible(false);

//						this.deliveryrenderStateBtn.visible=false;
						UIManager.getInstance().hideWindow(WindowEnum.DELIVERYPANEL);
						break;
				}

				this.renderVec[TaskEnum.taskLevel_deliveryLine]=item;
				this.updateListPos();

			} else {

				item=this.renderVec[TaskEnum.taskLevel_deliveryLine];

				if (item != null) {
					item.y=this.taskCount;
//					if (item.flyBtn.visible)
						this.taskCount+=item.height;
//					else
//						this.taskCount+=item.height - 20;

//					GuideManager.getInstance().showGuide(8, item, true);
				}

//				if (this.deliveryrenderStateBtn.visible) {
//					this.taskCount+=30;
//					this.deliveryrenderStateBtn.y=this.taskCount;
//					this.taskCount+=deliveryrenderStateBtn.height;
//				}
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

			var item:MissionTrackLable;

			item=this.renderVec[TaskEnum.taskLevel_arenaLine];

			if (o != null) {

				if (this.renderVec[TaskEnum.taskLevel_arenaLine] == null) {
					item=new MissionTrackLable();

					item.setTrBtnVisible(false);
					this.gridList.addToPane(item);

					item.y=this.taskCount;
					this.taskCount+=item.height;
				}

				item.taskTypeTxt(PropUtils.getStringById(2424));

//				if (o.sfight == o.zfight) {
//					item.taskNameTxt(StringUtil.substitute(PropUtils.getStringById(1903), ["<font color='#00ff00'><u><a href='event:arena'>"]) + "</a></u></font>");
//				} else
				
				item.taskNameTxt("<a href='event:arena'>" + PropUtils.getStringById(2440) + "</a>");
				item.taskStateTxt("");

//				if (o.jlst == 0)
					item.taskTargetTxt(StringUtil.substitute(PropUtils.getStringById(2448), [o.zfight - o.sfight]));
//				else {
//					item.taskTargetTxt("");
//					this.taskCount-=20;
//				}

				this.renderVec[TaskEnum.taskLevel_arenaLine]=item;
				this.updateListPos();

			} else {
				if (item != null) {
					item.y=this.taskCount;
//					if (item.targetVisible.text != "")
						this.taskCount+=item.height;
//					else
//						this.taskCount+=item.height - 20;
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

			var item:MissionTrackLable;

			if (o != null) {

				if (o.cm == ConfigEnum.Exp_Fb4) {

					if (this.renderVec[TaskEnum.taskLevel_dragonLine] != null) {
						this.gridList.delFromPane(this.renderVec[TaskEnum.taskLevel_dragonLine]);
						this.renderVec[TaskEnum.taskLevel_dragonLine]=null;
					}

				} else {

					if (this.renderVec[TaskEnum.taskLevel_dragonLine] == null) {
						item=new MissionTrackLable();
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
					this.taskCount+=item.height; // - 20;
				}
			}

			this.gridList.scrollTo(this.gridList.scrollBar_Y.progress);
			DelayCallManager.getInstance().add(this, this.gridList.updateUI, "updateUI", 4);
		}

		/**
		 *答题
		 */
		public function updateQuestion(o:Object=null):void {

			if (Core.me == null || ConfigEnum.question1 > Core.me.info.level || MapInfoManager.getInstance().type == 18)
				return;

			var item:MissionTrackLable;

			if (o != null) {

				questtime=o.rtime;

				if (this.renderVec[TaskEnum.taskLevel_questLine] == null) {
					item=new MissionTrackLable();
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
//					this.questionrenderStateBtn.visible=false;
					SoundManager.getInstance().play(26);
//					this.updateListPos(1);
				}

				this.updateListPos();
			} else {

				item=this.renderVec[TaskEnum.taskLevel_questLine];

				if (item != null) {
					item.y=this.taskCount;

					//					if (questtime == 0)
					this.taskCount+=item.height; // - 18;
						//					else
						//						this.taskCount+=item.height;
				}

//				if (this.questionrenderStateBtn.visible) {
//					this.questionrenderStateBtn.y=this.taskCount;
//					this.taskCount+=questionrenderStateBtn.height;
//				}
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
			
			this.gridList.scrollTo(0);
			DelayCallManager.getInstance().add(this, this.gridList.updateUI, "updateUI", 4);
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

			var item:MissionTrackLable;

			if (arr != null) {

				if (this.renderVec[type] == null) {

					item=new MissionTrackLable();
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

//					if (item.lastHpLbl.visible)
//						this.taskCount+=item.height + 20;
//					else if (item.targetVisible.visible)
					this.taskCount+=item.height;
//					else
//						this.taskCount+=item.height - 20;

				}

			}

			this.gridList.scrollTo(this.gridList.scrollBar_Y.progress);
			DelayCallManager.getInstance().add(this, this.gridList.updateUI, "updateUI", 4);
		}

	}
}

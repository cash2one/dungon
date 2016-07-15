package com.leyou.ui.task {


	import com.ace.config.Core;
	import com.ace.enum.FontEnum;
	import com.ace.enum.SceneEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.greensock.TweenLite;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.ui.task.child.MissionTrackRender2;
	import com.leyou.ui.task.child.missionTrackRender3;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class TaskTrack3 extends AutoSprite {

		private var arrowIcon:Image;

		private var arrowBtn:ImgButton;
		private var taskBtn:ImgButton;
		private var scheduleBtn:ImgButton;
		private var txLbl:Label;

		private var taskMainAndDaily:missionTrackRender3;
		private var taskOther:MissionTrackRender2;

		private var missionContainer:Sprite;

		public var viewState:Boolean=true;

		public function TaskTrack3() {
			super(LibManager.getInstance().getXML("config/ui/task/missionTrack3.xml"));
			this.init();
//			this.hideBg();
//			this.clsBtn.visible=false;
			this.mouseChildren=true;
		}

		private function init():void {

//			this.taskIcon=this.getUIbyID("taskIcon") as Image;

//			this.arrowBtn=this.getUIbyID("arrowBtn") as ImgButton;
			this.taskBtn=this.getUIbyID("taskBtn") as ImgButton;
			this.scheduleBtn=this.getUIbyID("scheduleBtn") as ImgButton;
			this.txLbl=this.getUIbyID("txLbl") as Label;

//			this.arrowBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.taskBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.scheduleBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.taskMainAndDaily=new missionTrackRender3();
			this.addChild(this.taskMainAndDaily);

			this.taskMainAndDaily.x=10;
			this.taskMainAndDaily.y=40;

			this.taskOther=new MissionTrackRender2();
			this.addChild(this.taskOther);

			this.taskOther.x=10;
			this.taskOther.y=40;

			this.taskOther.visible=false;

			this.arrowIcon=new Image("ui/mission/rwzz_bg.png");
//			this.arrowIcon.y=this.arrowBtn.y+this.arrowBtn.height;
			this.addChild(this.arrowIcon);
			this.arrowIcon.visible=false;

			this.txLbl.styleSheet=FontEnum.DEFAULT_LINK_STYLE;
			this.txLbl.htmlText="<a href='event:#'>" + this.txLbl.text + "</a>";
			this.txLbl.addEventListener(MouseEvent.CLICK, ontaskClick);
			this.txLbl.mouseEnabled=true;

//			this.txLbl.visible=false;

			LayerManager.getInstance().mainLayer.addChild(this.arrowIcon);

			this.arrowBtn=new ImgButton("ui/funForcast/btn_right.png");
//			this.addChild(this.arrowBtn);
			LayerManager.getInstance().mainLayer.addChild(this.arrowBtn);

			this.arrowBtn.x=UIEnum.WIDTH - this.arrowBtn.width;
			this.arrowBtn.y=2;

			this.arrowBtn.addEventListener(MouseEvent.CLICK, onArrowClick);

			this.missionContainer=new Sprite();
			this.addChild(this.missionContainer);

			this.hide();
//			this.allowDrag=false;
			this.resize();

			this.taskBtn.turnOn();
		}

		private function ontaskClick(e:MouseEvent):void {
			if (e.target == this.txLbl) {
				UILayoutManager.getInstance().open(WindowEnum.INTROWND);
			}
		}

		private function onClick(e:MouseEvent):void {
			if (e.target.name == "taskBtn") {
				this.taskMainAndDaily.visible=true;
				this.taskOther.visible=false;
				this.taskBtn.turnOn();
				this.scheduleBtn.turnOff();
			} else if (e.target.name == "scheduleBtn") {
				this.taskMainAndDaily.visible=false;
				this.taskOther.visible=true;

				this.taskBtn.turnOff();
				this.scheduleBtn.turnOn();
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
				TweenLite.to(this, 1, {x: UIEnum.WIDTH - 267, onComplete: function():void {
					arrowBtn.updataBmd("ui/funForcast/btn_right.png");
					viewState=true;
				}});

//				TweenLite.to(this.arrowBtn, 1, {x: this.width - this.arrowBtn.width - 15});
			}

		}

		public function setScalePanelState(v:Boolean):void {
			if (Core.me == null)
				return;

			if (Core.me != null && Core.me.info.level < 30 || !this.arrowBtn.visible)
				return;


			var w:int=this.width;
			var i:int=w - 30;

			if (!v) {

				TweenLite.to(this, 1, {x: UIEnum.WIDTH - 20, onComplete: function():void {
					arrowBtn.updataBmd("ui/funForcast/btn_left.png");
					arrowIcon.visible=true;
					visible=false;
				}});

//				TweenLite.to(this.arrowBtn, 1, {x: 2});

			} else {
				visible=true;
				arrowIcon.visible=false;
				TweenLite.to(this, 1, {x: UIEnum.WIDTH - 267, onComplete: function():void {
					arrowBtn.updataBmd("ui/funForcast/btn_right.png");
				}});

//				TweenLite.to(this.arrowBtn, 1, {x: this.width - this.arrowBtn.width - 15});
			}

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
				this.resize();
			} else
				this.arrowIcon.visible=true;
		}

		public function updateMainTask(o:Object):void {
			this.taskMainAndDaily.updateInfo(o);
		}

		override public function hide():void {
			super.hide();

			this.arrowBtn.visible=false;
			this.arrowIcon.visible=false;
		}

		public function updateList(o:Object):void {

			if (Core.me == null)
				return;


			if (Core.me != null && Core.me.info.level < ConfigEnum.common9) {
				this.arrowBtn.visible=false;
				this.arrowIcon.visible=false;
				this.viewState=false;
				return;
			} else {

				if (!this.visible && MapInfoManager.getInstance().type != SceneEnum.SCENE_TYPE_PTCJ) {
					this.arrowBtn.visible=false;
					return;
				} else {
					this.arrowBtn.visible=true;
				}
//				this.arrowIcon.visible=true;
			}


//			if (Core.isDvt) {
//				this.gridList.visible=false;
//				this.arrowIcon.visible=false;
//				this.bgImg.visible=false;
//				this.arrowBtn.visible=false;
//			} else {
//				this.gridList.visible=true;
//				this.arrowIcon.visible=true;
//				this.bgImg.visible=true;
//				this.arrowBtn.visible=true;
//			}

//			this.taskCount=0;
//			this._taskInfo=o;
			this.taskMainAndDaily.taskInfo=o;

			var tr:Array=o.tr;

			/**
						var tritem:Object;
						var qmd:Boolean=false;
						var exp:Boolean=false;
						var i:int=0;
						for (i=0; i < tr.length; i++) {
							if (tr[i] != null) {
								if (tr[i].type == 8 || tr[i].type == 7) {
									tr[i]=null;
									delete tr[i];
								}

			//					if (tritem.type == 7)
			//						exp=true;
							}
						}
			**/

//			trace(MapInfoManager.getInstance().type,MapInfoManager.getInstance().sceneId,MapInfoManager.getInstance().sceneName);
			if (o.count != 0) {

				var qmd:Boolean=false;
				var exp:Boolean=false;
				var tritem:Object;
				for each (tritem in tr) {
					if (tritem != null) {
						if (tritem.type == 8)
							qmd=true;

						if (tritem.type == 7)
							exp=true;
					}
				}


				if (!qmd) {
					if (o.count == o.qmd_c)
						tr.push({st: 1, type: 8});
					else
						tr.push({st: 0, type: 8});
				}

				if (!exp) {
					if (o.count == o.exp_c)
						tr.push({st: 1, type: 7});
					else
						tr.push({st: 0, type: 7});
				}
			}


			tr.sortOn("type", Array.CASEINSENSITIVE | Array.NUMERIC);

			for each (tritem in tr) {
				if (tritem != null) {
					if (o.hasOwnProperty("award") && o.award == 1) {

					} else {
						this.taskMainAndDaily.updateInfo(tritem);

					}
				}
			}

			this.taskMainAndDaily.ref_yb=o.ref_yb;
			this.taskMainAndDaily.updateDailyInfo(tr[1]);
//			this.firstAutoAstar=false;

			if (!MyInfoManager.getInstance().isTaskOk && MyInfoManager.getInstance().currentTaskId == 89)
				TweenLite.delayedCall(ConfigEnum.autoTask3, this.autoTaskComplete);
		}

		private function autoTaskComplete():void {
			if (this.visible) {
				this.autoCompleteLoop();
			}
		}

		public function get taskID():int {
			var tid:int=this.taskMainAndDaily.taskID;
			if (tid == 0)
				tid=UIManager.getInstance().taskTrack2.taskID;
			return tid;
		}

		public function get taskOneInfo():Object {

			var to:Object=this.taskMainAndDaily.taskOneInfo;
			if (to == null)
				to=UIManager.getInstance().taskTrack2.taskOneInfo;
			return to;
		}

		public function setFirstAutoStarState(v:Boolean):void {
			this.taskMainAndDaily.firstAutoAstar=v;
		}

		public function updateDailyInfo(o:Object):void {
//			this.taskMainAndDaily.updateDailyInfo(o);
		}

		/**
		 * 添加其他容器
		 * @param dis
		 *
		 */
		public function setSoulContainerAddOther(dis:DisplayObjectContainer):void {
//			this.missionSoulBar.visible=false;
			dis.x=0
			dis.y=-84
			this.missionContainer.addChild(dis);
		}

		/**
		 * 删除其他容器
		 * @param dis
		 */
		public function setSoulContainerRemoveOther(dis:DisplayObjectContainer):void {
//			this.missionSoulBar.visible=true;
			if (missionContainer.contains(dis)) {
				this.missionContainer.removeChild(dis);
			}
		}

		public function resize():void {
			if (!viewState) {
				this.x=(UIEnum.WIDTH - 4); //933=真实宽度
				this.y=((UIEnum.HEIGHT - 316) >> 1); //107=真实高度
			} else {
				this.x=(UIEnum.WIDTH - 267); //933=真实宽度
				this.y=((UIEnum.HEIGHT - 316) >> 1); //107=真实高度
			}

			this.arrowBtn.x=UIEnum.WIDTH - this.arrowBtn.width;
			this.arrowBtn.y=this.y + 5;

			this.arrowIcon.x=UIEnum.WIDTH - this.arrowIcon.width;
			this.arrowIcon.y=this.arrowBtn.y + arrowBtn.height;

			LayerManager.getInstance().mainLayer.addChild(this.arrowBtn);
			LayerManager.getInstance().mainLayer.addChild(this.arrowIcon);
		}

		public function setGuideView(id:int):void {
//			if (Core.me != null && Core.me.info != null && this.taskOneInfo != null) {
//				
//				if (this.taskOneInfo.st == 0) {
//					if (this.mainTaskType == id && this.mainTaskType == TaskEnum.taskType_BadgeNodeNum) {
//						GuideManager.getInstance().showGuide(13, this);
//					} else if (this.mainTaskType == TaskEnum.taskType_MountLv && this.mainTaskType == id) {
//						GuideManager.getInstance().showGuide(4, this);
//					} else if (this.mainTaskType == TaskEnum.taskType_CopySuccess && this.mainTaskType == id) {
//						GuideManager.getInstance().showGuide(29, this);
//					} else if (this.mainTaskType == TaskEnum.taskType_TodayTaskSuccessNum && this.mainTaskType == id) {
//						GuideManager.getInstance().showGuide(18, this);
//					} else if (this.mainTaskType == TaskEnum.taskType_ElementFlagNum && this.mainTaskType == id) {
//						GuideManager.getInstance().showGuide(10, this);
//					} else if (this.mainTaskType == TaskEnum.taskType_ArenaPkNum && this.mainTaskType == id) {
//						GuideManager.getInstance().showGuide(32, this);
//					} else if (this.mainTaskType == TaskEnum.taskType_EquitTopLv && this.mainTaskType == id) {
//						GuideManager.getInstance().showGuide(62, this);
//					}
//					
//				} else if (this.taskOneInfo.st == 1) {
//					
//					if (this.mainTaskType == id && this.mainTaskType == TaskEnum.taskType_BadgeNodeNum) {
//						GuideManager.getInstance().removeGuide(13);
//					} else if (this.mainTaskType == TaskEnum.taskType_MountLv && this.mainTaskType == id) {
//						GuideManager.getInstance().removeGuide(4);
//					} else if (this.mainTaskType == TaskEnum.taskType_CopySuccess && this.mainTaskType == id) {
//						GuideManager.getInstance().removeGuide(29);
//					} else if (this.mainTaskType == TaskEnum.taskType_TodayTaskSuccessNum && this.mainTaskType == id) {
//						GuideManager.getInstance().removeGuide(18);
//					} else if (this.mainTaskType == TaskEnum.taskType_ElementFlagNum && this.mainTaskType == id) {
//						GuideManager.getInstance().removeGuide(10);
//					} else if (this.mainTaskType == TaskEnum.taskType_ArenaPkNum && this.mainTaskType == id) {
//						GuideManager.getInstance().removeGuide(32);
//					} else if (this.mainTaskType == TaskEnum.taskType_EquitTopLv && this.mainTaskType == id) {
//						GuideManager.getInstance().removeGuide(62);
//					}
//				}
//				
//			}

		}

		public function setGuideViewhide(id:int):void {
//			if (Core.me != null && Core.me.info != null && this.taskOneInfo != null) {
//				
//				if (this.mainTaskType == id && this.mainTaskType == TaskEnum.taskType_BadgeNodeNum) {
//					GuideManager.getInstance().removeGuide(13);
//				} else if (this.mainTaskType == TaskEnum.taskType_MountLv && this.mainTaskType == id) {
//					GuideManager.getInstance().removeGuide(4);
//				} else if (this.mainTaskType == TaskEnum.taskType_CopySuccess && this.mainTaskType == id) {
//					GuideManager.getInstance().removeGuide(29);
//				} else if (this.mainTaskType == TaskEnum.taskType_TodayTaskSuccessNum && this.mainTaskType == id) {
//					GuideManager.getInstance().removeGuide(18);
//				} else if (this.mainTaskType == TaskEnum.taskType_ElementFlagNum && this.mainTaskType == id) {
//					GuideManager.getInstance().removeGuide(10);
//				} else if (this.mainTaskType == TaskEnum.taskType_ArenaPkNum && this.mainTaskType == id) {
//					GuideManager.getInstance().removeGuide(32);
//				} else if (this.mainTaskType == TaskEnum.taskType_EquitTopLv && this.mainTaskType == id) {
//					GuideManager.getInstance().removeGuide(62);
//				}
//				
//			}

		}

		public function autoComplete():void {
			if (this.taskMainAndDaily.taskID == 0)
				UIManager.getInstance().taskTrack2.autoComplete();
			else
				this.taskMainAndDaily.autoComplete()
		}

		public function autoCompleteLoop():void {
			if (this.taskMainAndDaily.taskID != 0)
				this.taskMainAndDaily.autoCompleteLoop();
		}


		public function setDailyTaskVip(vip:int):void {
			this.taskMainAndDaily.setYbOnKeyVisible(vip >= DataManager.getInstance().vipData.taskPrivilegeVipLv());
		}

		public function get taskInfo():Object {
			if (this.taskMainAndDaily.taskID == 0)
				return UIManager.getInstance().taskTrack2.taskOneInfo;
			else
				return this.taskMainAndDaily.taskInfo;
		}

		public function updateDelivery(o:Object=null):void {
			this.taskOther.updateDelivery(o);
		}

		/**
		 *竞技场
		 * @param o
		 *
		 */
		public function updateArena(o:Object=null):void {
			this.taskOther.updateArena(o);
		}

		/**
		 * 时光龙穴
		 * @return
		 *
		 */
		public function updateDungeon(o:Object=null):void {
			this.taskOther.updateDungeon(o);
		}

		/**
		 *答题
		 */
		public function updateQuestion(o:Object=null):void {
			this.taskOther.updateQuestion(o);
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
		public function updateOtherTrack(type:int, arr:Array):void {
			this.taskOther.updateOhterTrack(type, arr);
		}

		/**
		 * @param type
		 */
		public function delOtherTrack(type:int):void {
			this.taskOther.delOtherTrack(type);
		}

	}
}

package com.leyou.ui.task {

	import com.ace.config.Core;
	import com.ace.enum.CursorEnum;
	import com.ace.enum.SceneEnum;
	import com.ace.enum.UIEnum;
	import com.ace.game.core.SceneCore;
	import com.ace.game.manager.CutSceneManager;
	import com.ace.game.scene.player.part.LivingBase;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.scene.child.SDecorateInfo;
	import com.ace.gameData.table.TMissionDate;
	import com.ace.gameData.table.TSceneInfo;
	import com.ace.manager.CursorManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.lable.Label;
	import com.ace.ui.lable.children.TextArea;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.TaskEnum;
	import com.leyou.manager.TimerManager;
	import com.leyou.net.cmd.Cmd_Go;
	import com.leyou.net.cmd.Cmd_Tsk;
	import com.leyou.ui.task.child.MissionGrid;
	import com.leyou.ui.task.child.TaskTrackBtn;
	import com.leyou.utils.FilterUtil;
	import com.leyou.utils.TaskUtil;

	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;

	/**
	 * npc 任务面板
	 * @author Administrator
	 */
	public class MissionAcceptWnd extends AutoWindow {

		private var taskContentLbl:TextArea;
		private var taskReplyLbl:Label;
		private var taskTargetLbl:Label;
		private var accTaskBtn:TaskTrackBtn;

		private var taskTargetNpcLbl:Label;
		private var targetMapLbl:Label;
		private var taskNameLbl:Label;

		private var taskRewardVec:Vector.<MissionGrid>
		private var currentMissionData:TMissionDate;

		private var taskid:int=0;

		public var taskNpc:int=0;

		public var effectCount:Array=[];

		/**
		 * 延迟完成
		 */
		private var timer:int=30;

		/**
		 * 0,接受,1完成
		 */
		private var taskState:int=0;

		public var taskConfirmSucc:Boolean=false;

		public function MissionAcceptWnd() {
			super(LibManager.getInstance().getXML("config/ui/task/missionAcceptWnd.xml"));
			this.init();
			this.hideBg();
		}

		private function init():void {

//			this.taskContentLbl=new TextField();
			this.taskContentLbl=this.getUIbyID("taskContentLbl") as TextArea;
			this.taskReplyLbl=this.getUIbyID("taskReplyLbl") as Label;
			this.taskTargetLbl=this.getUIbyID("taskTargetLbl") as Label;
			//this.taskTargetNpcLbl=this.getUIbyID("taskTargetNpcLbl") as Label;
			this.targetMapLbl=this.getUIbyID("targetMapLbl") as Label;
			this.taskNameLbl=this.getUIbyID("taskNameLbl") as Label;
//			this.accTaskBtn=this.getUIbyID("accTaskBtn") as NormalButton;

			this.accTaskBtn=new TaskTrackBtn();
			this.addChild(this.accTaskBtn);

			this.accTaskBtn.x=this.width - this.accTaskBtn.width >> 1;
			this.accTaskBtn.y=this.height - 50;

			this.accTaskBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.clsBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.taskRewardVec=new Vector.<MissionGrid>();

			this.taskTargetLbl.addEventListener(TextEvent.LINK, onLink);
			this.taskTargetLbl.mouseEnabled=true;

			this.taskReplyLbl.addEventListener(TextEvent.LINK, onReLink);
			this.taskReplyLbl.mouseEnabled=true;

			this.taskTargetLbl.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.taskReplyLbl.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			//this.taskContentLbl.wordWrap=true;
			//this.taskContentLbl.multiline=true;

			this.taskContentLbl.visibleOfBg=false;
			this.taskContentLbl.filters=FilterUtil.blackStrokeFilters;
//			this.taskContentLbl.width=240;
//			this.taskContentLbl.height=172;

			this.effectCount[0]=false;
			this.addToUILib("accTaskLbl",this.accTaskBtn);
		}

		/**
		 * 接受任务
		 * @param e
		 *
		 */
		private function onClick(e:MouseEvent):void {

			if (this.taskState == 0) {
				Cmd_Tsk.cmTaskKAccept(int(this.currentMissionData.id));
				this.taskConfirmSucc=false;
			} else if (this.taskState == 1) {
				Cmd_Tsk.cmTaskKSucc(int(this.currentMissionData.id));
				this.taskConfirmSucc=true;

				if (int(this.currentMissionData.id) == 9 && this.currentMissionData.ef_id > 0)
					CutSceneManager.getInstance().start(this.currentMissionData.ef_id);

				GuideManager.getInstance().removeGuide(20);
			}

			this.hide();
		}


		public function showPanel(o:Object):void {
			super.show();

			this.resize();

			this.updateData(o);
			this.updateRewardList();

			//是自己接的  else 服务器主动推的
			if (o.hasOwnProperty("mk")) {

				if (o.mk == "A") {
//					this.accTaskBtn.text="领取任务";
					this.accTaskBtn.updateIcon(0);
					this.taskState=0;
					this.taskConfirmSucc=false;
				} else if (o.mk == "D") {

					//完成特效
					if (this.currentMissionData != null) {
						var xml:XML=LibManager.getInstance().getXML("config/table/scene_ef.xml");

						var xmlItem:XML;
						for each (xmlItem in xml.data) {
							if (xmlItem.@EF_ID == this.currentMissionData.ef_id)
								break;
						}

						var info:SDecorateInfo
						switch (int(xmlItem.@EF_OBJ)) {
							case 1:
								if (this.effectCount[o.tid] != null) {
									break;
								}

								info=new SDecorateInfo();
								info.tileX=xmlItem.@EF_X;
								info.tileY=xmlItem.@EF_Y;
								info.tId=xmlItem.@EF_ID1;
								SceneCore.sceneModel.addDecorate(info);

								this.effectCount[o.tid]=xmlItem.@EF_ID1;
								break;
							case 2:

								SceneCore.sceneModel.removeDecorate(xmlItem.@EF_ID2);

								info=new SDecorateInfo();
								info.tileX=xmlItem.@EF_X;
								info.tileY=xmlItem.@EF_Y;
								info.tId=xmlItem.@EF_ID1;
								SceneCore.sceneModel.addDecorate(info);
								break;
							case 3:
								SceneCore.sceneModel.removeDecorate(xmlItem.@EF_ID2);
								break;
						}
					}

//					this.accTaskBtn.text="完成任务";
					this.accTaskBtn.updateIcon(2);
					this.taskState=1;
					this.timer=ConfigEnum.autoTask3;
					this.accTaskBtn.setNum("(" + (timer) + ")");
					TimerManager.getInstance().add(exeTime);
					this.timer--;

					GuideManager.getInstance().showGuide(20, this.accTaskBtn);
				}

			} else {


			}

		}

		/**
		 *奖励物品飞入背包
		 *
		 */
		public function rewardFlyBag():void {
//			if(!this.visible)
//				return ;

			var exphun:Array=[0, 0];
			var flyArr:Array=[[], []];
			var mgrid:MissionGrid;
			for each (mgrid in this.taskRewardVec) {
//				if (mgrid != null && mgrid.dataId != 65533 && mgrid.dataId != 65534 && mgrid.dataId != 65535) {
				if (mgrid != null) {
					if (mgrid.dataId == 65534) {
						exphun[0]=mgrid.parent.localToGlobal(new Point(mgrid.x, mgrid.y));
						exphun[1]=mgrid.getNum();
					} else if (mgrid.dataId == 65533) {
						exphun[2]=mgrid.parent.localToGlobal(new Point(mgrid.x, mgrid.y));
						exphun[3]=mgrid.getNum();
					} else {
						flyArr[0].push(mgrid.dataId);
						flyArr[1].push(mgrid.parent.localToGlobal(new Point(mgrid.x, mgrid.y)));
					}
				}
			}

			FlyManager.getInstance().flyBags(flyArr[0], flyArr[1]);

//			for (var i:int=0; i < exphun.length; i++) {
			if (exphun[0] != 0)
				FlyManager.getInstance().flyExpOrHonour(1, exphun[1], 1, exphun[0]);

			if (exphun[2] != 0)
				FlyManager.getInstance().flyExpOrHonour(1, exphun[3], 2, exphun[2]);
//			}
			this.taskConfirmSucc=false;
		}

		private function exeTime(i:int):void {

			if (timer - i < 0) {
				this.accTaskBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				TimerManager.getInstance().remove(exeTime);
				timer=0;
			} else {
//				this.accTaskBtn.text="" + timer;

				this.accTaskBtn.setNum("(" + (timer - i) + ")");

			}

		}

		public function updateData(o:Object):void {

//			if (!this.visible)
//				super.show();

			this.taskid=o.tid;
			var minfo:TMissionDate;
			this.currentMissionData=minfo=TableManager.getInstance().getMissionDataByID(o.tid);

			var tartxt:String=TaskEnum.taskTypeDesc[int(minfo.dtype) - 1];
			var tarval:Array=TaskEnum.taskTypeNpcField[int(minfo.dtype) - 1];
			var i:int=0;

			var bname:String;
			while (tartxt.indexOf("##") > -1) {

				if (int(minfo.dtype) == TaskEnum.taskType_Mercenary) {
					tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:mercenary'>" + TableManager.getInstance().getPetInfo(minfo[tarval[i]]).name + "</a></u></font>");
				} else if (tarval[i].indexOf("num") > -1 || tarval[i].indexOf("Num") > -1 || tarval[i].indexOf("lv") > -1 || tarval[i].indexOf("number") > -1) {

					if (o.mk == "A") {
						tartxt=tartxt.replace("##", "<font color='#ff0000'>(0" + minfo[tarval[i]] + ")</font>个");
					} else if (o.mk == "D") {
						tartxt=tartxt.replace("##", "<font color='#00ff00'>(" + minfo[tarval[i]] + "/" + minfo[tarval[i]] + ")</font>");
					}

				} else {

					if (int(minfo.dtype) == TaskEnum.taskType_upgrade) {
						tartxt=tartxt.replace("##", "<font color='#00ff00'>" + minfo[tarval[i]] + "</font>");
					} else {
						bname=String(tarval[i]).split("_")[0] + "_id";

						if (tarval[i].indexOf("Y_Currency") > -1) { // || bname.indexOf("box") > -1) {
							tartxt=tartxt.replace("##", "<font color='#ff0000'>" + minfo[tarval[i]] + "</font>");
						} else if (int(minfo.dtype) == TaskEnum.taskType_Delivery) {
							tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:" + tarval[0] + "'>" + TaskUtil.getTaskTargetName("npc_id", 47) + "</a></u></font>");
						} else if (int(minfo.dtype) == TaskEnum.taskType_killBossDrop || int(minfo.dtype) == TaskEnum.taskType_collect)
							tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:" + String(tarval[0]).split("_")[0] + "_id" + "--" + minfo.target_point + "'>" + TaskUtil.getTaskTargetName(tarval[i], minfo[tarval[i]]) + "</a></u></font>");
						else if (int(minfo.dtype) == TaskEnum.taskType_Exchange)
							tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:" + bname + "--" + minfo.item_id + "'>" + TaskUtil.getTaskTargetName(tarval[i], minfo[tarval[i]]) + "</a></u></font>");
						else if (int(minfo.dtype) == TaskEnum.taskType_CopySuccess) {
							tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:#'>" + TableManager.getInstance().getCopyInfo(minfo[tarval[i]]).name + "</a></u></font>");
						} else if (int(minfo.dtype) == TaskEnum.taskType_ElementFlagNum) {
							tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:#'>" + minfo[tarval[i]] + "</a></u></font>");
						} else
							tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:" + bname + "--" + minfo[bname] + "'>" + TaskUtil.getTaskTargetName(tarval[i], minfo[tarval[i]]) + "</a></u></font>");
					}
				}

				i++;
			}
//
			if (o.hasOwnProperty("say"))
				this.taskContentLbl.setText(minfo.npc_say);
			else {
				if (o.mk == "A") {
					this.taskContentLbl.setText(minfo.anpcText);
				} else if (o.mk == "D") {
					this.taskContentLbl.setText(minfo.dnpcText);
				}
			}

			this.titleLbl.text="";

			this.taskNameLbl.text="" + minfo.name;
			this.taskNameLbl.x=this.width - this.taskNameLbl.textWidth >> 1;
			this.taskTargetLbl.htmlText="" + tartxt;
			this.taskReplyLbl.htmlText="<font color='#00ff00'><a href='event:npc_id--" + minfo.dnpc + "'>" + TaskUtil.getTaskTargetName("npc_id", minfo.dnpc) + "</a></font>";

			this.targetMapLbl.text="" + minfo.tag;
//			if (int(minfo.dtype) != TaskEnum.taskType_upgrade) {
//				var sinfo:TSceneInfo=TableManager.getInstance().getSceneInfo(int(int(minfo.target_point) / 1000) + "");
//				if (sinfo != null)
//					this.targetMapLbl.text="" + sinfo.name;
//			}

			if (this.currentMissionData.type == TaskEnum.taskLevel_mainLine) {
//				this.accTaskBtn.text="完成任务";
				this.accTaskBtn.updateIcon(2);
			} else
//				this.accTaskBtn.text="领取任务";
				this.accTaskBtn.updateIcon(0);
		}

		/**
		 * 目标执行
		 * @param e
		 *
		 */
		private function onLink(e:TextEvent):void {

//			UIManager.getInstance().taskTrack.autoAstar=true;
//			trace(e.text);
			var ctx:String=e.text;
			var str:Array=ctx.split("--");

			if (str[0].indexOf("monster") > -1) {

				var ptable:XML=LibManager.getInstance().getXML("config/table/pointTable.xml");
				var plist:XMLList=ptable.data;

				var xml:XML;
				for each (xml in plist) {
					if (xml.@id == this.currentMissionData.target_point) {
						//跨场景寻路
						Core.me.recordTargetTile(new Point(xml.@pointX, xml.@pointY));
						break;
					}
				}

			} else if (str[0].indexOf("npc") > -1) {
				Cmd_Go.cmGo(str[1]);
			}

		}


		private function onReLink(e:TextEvent):void {

//			UIManager.getInstance().taskTrack.autoAstar=true;
			var str:String=String(e.text).split("--")[1];
			Cmd_Go.cmGo(int(str));
		}

		private function onMouseMove(e:MouseEvent):void {

			var i:int=this.taskTargetLbl.getCharIndexAtPoint(e.localX, e.localY);
			var xmltxt:XML=XML(this.taskTargetLbl.getXMLText(i, i + 1));

			var url:String=xmltxt.textformat.@url;

			if (url.indexOf("box") > -1 || url.indexOf("npc") > -1 || url.indexOf("monster") > -1) {
				CursorManager.getInstance().updataCursor(CursorEnum.CURSOR_HAND);
			} else {
				CursorManager.getInstance().resetGameCursor();
			}

		}

		public function updateRewardList():void {

			var mgrid:MissionGrid;
			for each (mgrid in this.taskRewardVec) {
				if (mgrid != null)
					mgrid.die();
				this.removeChild(mgrid);
			}

			this.taskRewardVec.length=0;
			var item:Object;

			var _x:int=20;
			var _y:int=369;

			if (this.currentMissionData.exp > 0) {
				mgrid=new MissionGrid();

				item=TableManager.getInstance().getItemInfo(65534);

				mgrid.updataInfo(item);
				mgrid.setTipsNum(int(this.currentMissionData.exp));

//				if (int(this.currentMissionData.exp) >= 10000)
//					mgrid.setNum(Math.floor(int(this.currentMissionData.exp) / 10000) + "万");
//				else
				mgrid.setNum((this.currentMissionData.exp) + "");

				mgrid.x=_x + this.taskRewardVec.length * (mgrid.width + 3);
				mgrid.y=_y;

				this.addChild(mgrid);
				this.taskRewardVec.push(mgrid);
			}

			if (this.currentMissionData.money > 0) {
				mgrid=new MissionGrid();

				item=TableManager.getInstance().getItemInfo(65535);

				mgrid.updataInfo(item);
				mgrid.setTipsNum(int(this.currentMissionData.money));

//				if (int(this.currentMissionData.money) >= 10000)
//					mgrid.setNum(Math.floor(int(this.currentMissionData.money) / 10000) + "万");
//				else
				mgrid.setNum((this.currentMissionData.money) + "");

				mgrid.x=_x + this.taskRewardVec.length * (mgrid.width + 3);
				mgrid.y=_y;

				this.addChild(mgrid);
				this.taskRewardVec.push(mgrid);
			}

			if (this.currentMissionData.energy > 0) {
				mgrid=new MissionGrid();

				item=TableManager.getInstance().getItemInfo(65533);

				mgrid.updataInfo(item);
				mgrid.setTipsNum(int(this.currentMissionData.energy));

//				if (int(this.currentMissionData.energy) >= 10000)
//					mgrid.setNum(Math.floor(int(this.currentMissionData.energy) / 10000) + "万");
//				else
				mgrid.setNum((this.currentMissionData.energy) + "");

				mgrid.x=_x + this.taskRewardVec.length * (mgrid.width + 3);
				mgrid.y=_y;

				this.addChild(mgrid);
				this.taskRewardVec.push(mgrid);
			}

			var reward:String;
			for (var i:int=0; i < 4; i++) {

				if (this.currentMissionData["item" + (i + 1)] == 0)
					continue;

				mgrid=new MissionGrid();

				reward=String(this.currentMissionData["item" + (i + 1)]);
				if (reward.indexOf("|") > -1) {
					reward=String(this.currentMissionData["item" + (i + 1)]).split("|")[Core.me.info.profession - 1];
				}

				item=TableManager.getInstance().getEquipInfo(int(reward));
				if (item == null)
					item=TableManager.getInstance().getItemInfo(int(reward));

				if (item != null)
					mgrid.updataInfo(item);

				if (int(this.currentMissionData["num" + (i + 1)]) > 1)
					mgrid.setNum(this.currentMissionData["num" + (i + 1)]);

				mgrid.canMove=false;

				mgrid.x=_x + (this.taskRewardVec.length % 5) * (mgrid.width + 3);
				mgrid.y=_y + Math.floor(this.taskRewardVec.length / 5) * (mgrid.height + 3);

				this.addChild(mgrid);
				this.taskRewardVec.push(mgrid);

			}

		}

		override public function hide():void {
			super.hide();

			SceneCore.sceneModel.removeDecorate(this.effectCount[this.taskid]);
			TimerManager.getInstance().remove(exeTime);

			GuideManager.getInstance().removeGuide(20);
		}

		public function taskContentText(v:String):void {
//			this.taskContentLbl.setText(v);
		}

		public function taskTargetText(v:String):void {
			this.taskTargetLbl.text=v;
		}

		public function outClosePanel():void {
			if (!this.visible)
				return;

			if (this.taskState == 0) {

			} else if (this.taskState == 1) {
				if (this.taskNpc > 0) {

					var livingBase:LivingBase=UIManager.getInstance().gameScene.getLivingBase(this.taskNpc);
					if (livingBase == null)
						return;

					if (Core.me.info.nextPt.length - livingBase.nowTilePt().length > 5 * SceneEnum.TILE_WIDTH) {
						this.hide();
					}

				}
			}

		}

		public function resize():void {
			this.x=(UIEnum.WIDTH - 265) - this.width;
			this.y=UIEnum.HEIGHT - this.height >> 1;
		}

		override public function get width():Number {
			return 300;
		}

		override public function get height():Number {
			return 544;
		}

	}
}

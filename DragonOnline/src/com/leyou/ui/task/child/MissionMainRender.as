package com.leyou.ui.task.child {

	import com.ace.config.Core;
	import com.ace.delayCall.DelayCallManager;
	import com.ace.enum.CursorEnum;
	import com.ace.enum.FontEnum;
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.THallows;
	import com.ace.gameData.table.TMissionDate;
	import com.ace.gameData.table.TSceneInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.CursorManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.utils.PnfUtil;
	import com.greensock.TweenMax;
	import com.leyou.enum.TaskEnum;
	import com.leyou.net.cmd.Cmd_Go;
	import com.leyou.utils.FilterUtil;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;
	import com.leyou.utils.TaskUtil;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.globalization.NumberFormatter;

	public class MissionMainRender extends AutoSprite {

		private var mainNpcIcon:Image;
		private var effSwf:SwfLoader;
		private var npcIconVec:Vector.<Image>;

		private var taskTargetLbl:Label;
		private var taskReplyLbl:Label;
		private var targetMapLbl:Label;
		private var taskDescLbl:Label;
		private var taskTargetNpcLbl:Label;
		private var taskItemList:ScrollPane;

		private var leftBtn:ImgLabelButton;
		private var rightBtn:ImgLabelButton;

		private var prop1Lbl:Label;
		private var prop2Lbl:Label;
		private var prop3Lbl:Label;
		private var prop4Lbl:Label;

		private var value1Lbl:Label;
		private var value2Lbl:Label;
		private var value3Lbl:Label;
		private var value4Lbl:Label;

		private var ProgressLbl:Label;

		private var otherTaskList:Array=[];
//		private var otherTaskList:Vector.<MissionRender>;
		private var rewardVec:Vector.<MissionGrid>;

		private var hallowsVec:Array=[];

		/**
		 * 圣器 当前索引; 翻页
		 */
		private var hallowCurrentIndex:int=0;

		/**
		 *圣器 当前索引;
		 */
		private var hallowCurrentTopIndex:int=-1;

		private var currentMissionData:TMissionDate;

		/**
		 * protype
		 */
		private var o:Object;

		private var progress:int=0;

		private var twn:TweenMax;

		public function MissionMainRender() {
			super(LibManager.getInstance().getXML("config/ui/task/missionMainRender.xml"));
			this.init();
			this.mouseChildren=this.mouseEnabled=true;
		}

		private function init():void {
			this.npcIconVec=new Vector.<Image>();
			this.mainNpcIcon=this.getUIbyID("mainImg") as Image;

			this.taskTargetLbl=this.getUIbyID("taskTargetLbl") as Label;
			this.taskReplyLbl=this.getUIbyID("taskReplyLbl") as Label;
			this.taskReplyLbl.styleSheet=FontEnum.DEFAULT_LINK_STYLE;
			this.taskTargetLbl.styleSheet=FontEnum.DEFAULT_LINK_STYLE;

			this.targetMapLbl=this.getUIbyID("targetMapLbl") as Label;
			this.taskDescLbl=this.getUIbyID("taskDescLbl") as Label;
			//this.taskTargetNpcLbl=this.getUIbyID("taskTargetNpcLbl") as Label;
			this.ProgressLbl=this.getUIbyID("ProgressLbl") as Label;
			this.taskItemList=this.getUIbyID("taskItemList") as ScrollPane;

			this.leftBtn=this.getUIbyID("leftBtn") as ImgLabelButton;
			this.rightBtn=this.getUIbyID("rightBtn") as ImgLabelButton;

			this.prop1Lbl=this.getUIbyID("prop1Lbl") as Label;
			this.prop2Lbl=this.getUIbyID("prop2Lbl") as Label;
			this.prop3Lbl=this.getUIbyID("prop3Lbl") as Label;
			this.prop4Lbl=this.getUIbyID("prop4Lbl") as Label;

			this.value1Lbl=this.getUIbyID("value1Lbl") as Label;
			this.value2Lbl=this.getUIbyID("value2Lbl") as Label;
			this.value3Lbl=this.getUIbyID("value3Lbl") as Label;
			this.value4Lbl=this.getUIbyID("value4Lbl") as Label;

			this.leftBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.rightBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.rewardVec=new Vector.<MissionGrid>();
//			this.otherTaskList=new Vector.<MissionRender>();

			this.taskTargetLbl.addEventListener(TextEvent.LINK, onLink);
			this.taskTargetLbl.mouseEnabled=true;

			this.taskReplyLbl.addEventListener(TextEvent.LINK, onReLink);
			this.taskReplyLbl.mouseEnabled=true;

			this.taskTargetLbl.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.taskReplyLbl.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

			this.effSwf=new SwfLoader(99972);
			this.addChild(this.effSwf);
			this.effSwf.mouseChildren=this.effSwf.mouseEnabled=false;

//			this.effSwf.mc.mouseChildren=this.effSwf.mc.mouseEnabled=false;

			this.effSwf.x=this.mainNpcIcon.x + 1;
			this.effSwf.y=this.mainNpcIcon.y + 1;

			this.addChild(this.mainNpcIcon);

			var iconTips:Sprite=new Sprite();
			iconTips.graphics.beginFill(0x000000);
			iconTips.graphics.drawRect(0, 0, 60, 60);
			iconTips.graphics.endFill();

			this.addChild(iconTips);

			iconTips.alpha=0;
			iconTips.x=this.mainNpcIcon.x + 2;
			iconTips.y=this.mainNpcIcon.y + 2;

			iconTips.addEventListener(MouseEvent.MOUSE_MOVE, onTipsMouseMove);
			iconTips.addEventListener(MouseEvent.MOUSE_OUT, onTipsMouseOut);

			this.mainNpcIcon.y=this.mainNpcIcon.y - 2;

			this.taskReplyLbl.filters=[FilterUtil.showBorder(0x000000)];
			this.taskTargetLbl.filters=[FilterUtil.showBorder(0x000000)];
			this.targetMapLbl.filters=[FilterUtil.showBorder(0x000000)];
			this.taskDescLbl.filters=[FilterUtil.showBorder(0x000000)];
		}

		private function onTipsMouseMove(e:MouseEvent):void {
			ToolTipManager.getInstance().show(TipEnum.TYPE_HALLOWS, [this.hallowsVec[this.hallowCurrentIndex], this.ProgressLbl.text, this.o.tid], new Point(this.stage.mouseX, this.stage.mouseY));
		}

		private function onTipsMouseOut(e:MouseEvent):void {
			ToolTipManager.getInstance().hide();
		}

		/**
		 * 可接任务列表
		 * @param list
		 *
		 */
		public function updateOtherTaskList(o:Object):void {

			if (Core.me == null || this.o == o || (this.o != null && this.o.tid == o.tid && this.o.st == o.st && this.o["var"] == o["var"]))
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

//			if (this.hallowCurrentIndex == 0 && this.hallowCurrentTopIndex == -1) {
//				this.hallowCurrentTopIndex=this.hallowCurrentIndex=this.hallowsVec.indexOf(TableManager.getInstance().getMissionDataByID(o.tid).Hallows_TeamID);
//			}

			this.mainNpcIcon.updateBmp("ui/mission/mission_icon" + (this.hallowCurrentIndex + 1) + "_big.png", onComplete);

			//记录
			this.o=o;
//			this.hallowCurrentTopIndex=-1;
//			this.hallowCurrentIndex=0;
			this.updateHallowList();
		}

		private function updateHallowList():void {
			this.updateItemTask(o.tid);
		}

		private function updateItemTask(tid:int):void {

			var mrender:MissionRender;
			for each (mrender in this.otherTaskList) {
				if (mrender.parent != null)
					this.taskItemList.delFromPane(mrender);
			}

//			this.otherTaskList.length=0;

			this.taskItemList.scrollBar_Y.addProgress(0);
			this.taskItemList.scrollTo(0);
			DelayCallManager.getInstance().add(this, this.taskItemList.updateUI, "updateUI", 4);

			var teamid:String;
			var mvec:Vector.<TMissionDate>=TableManager.getInstance().getMissionDataByHallowTeamId(this.hallowsVec[this.hallowCurrentIndex]);
			var minfo:TMissionDate;

			this.progress=0;

			var isextis:Boolean=false;
			var p:int=0;

			//可接列表
			for each (minfo in mvec) {

				if (this.otherTaskList[int(minfo.id)] == null) {
					mrender=new MissionRender();
					mrender.tid=int(minfo.id);
				} else {
					mrender=this.otherTaskList[int(minfo.id)];
				}

				mrender.taskNameText(minfo.name);
//				mrender.addEventListener(MouseEvent.CLICK, onItemClick);

				if (minfo.id == o.tid) {

					mrender.taskStateText(TaskUtil.getStringByState(o.st));

//					this.hallowCurrentTopIndex=this.hallowCurrentIndex;
//					this.leftBtn.visible=false;
					isextis=true;
					mrender.setChangeState();
				} else {

					if (!isextis) {
						this.progress++;
					}

					if (minfo.id < o.tid) {
						mrender.taskStateText(TaskUtil.getStringByState(1));
						mrender.setChangeState(1);
					} else {
						mrender.taskStateText(PropUtils.getStringById(1889));
						mrender.setChangeState(2);
					}
				}

//				if (this.hallowCurrentIndex != this.hallowCurrentTopIndex) {
//					progress++;
//				}

				this.taskItemList.addToPane(mrender);
				mrender.y=p * (26);
				this.otherTaskList[int(minfo.id)]=(mrender);

				p++;
			}

			this.taskItemList.scrollTo(0);
			DelayCallManager.getInstance().add(this, this.taskItemList.updateUI, "updateUI", 4);

			if (Number(progress / mvec.length) != 1) {
				this.taskItemList.scrollBar_Y.addProgress(Number(progress / mvec.length));
				this.taskItemList.scrollTo(Number(progress / mvec.length));
			}

			if (this.hallowCurrentIndex == this.hallowCurrentTopIndex) {

				this.ProgressLbl.text=int(progress / mvec.length * 100) + "%";
				this.rightBtn.visible=false;

				if (this.hallowCurrentIndex == 0)
					this.leftBtn.visible=false;
				else
					this.leftBtn.visible=true;

				UIManager.getInstance().taskTrack.updateHallows(this.hallowsVec[this.hallowCurrentIndex], progress / mvec.length, (progress == mvec.length - 1));

			} else {

				if (this.hallowCurrentIndex == 0)
					this.leftBtn.visible=false;
				else
					this.leftBtn.visible=true;

				this.rightBtn.visible=true;
				this.ProgressLbl.text="100%";
			}

//			if (this.hallowCurrentIndex >= this.hallowsVec[this.hallowCurrentIndex].length)
//				this.hallowCurrentIndex=this.hallowsVec[this.hallowCurrentIndex].length - 1;

			this.updateList(tid);
		}

		private function onMouseMove(e:MouseEvent):void {

			var i:int=Label(e.target).getCharIndexAtPoint(e.localX, e.localY);
			var xmltxt:XML=XML(Label(e.target).getXMLText(i, i + 1));

			var url:String=xmltxt.textformat.@url;

			if (url.indexOf("box") > -1 || url.indexOf("npc") > -1 || url.indexOf("monster") > -1) {
				CursorManager.getInstance().updataCursor(CursorEnum.CURSOR_HAND);
			} else {
				CursorManager.getInstance().resetGameCursor();
			}

		}

		private function updateList(tid:int):void {

			var minfo:TMissionDate;
			//目标字段
			currentMissionData=minfo=TableManager.getInstance().getMissionDataByID(int(tid));

			//基础属性
			this.setProp();

			var tartxt:String=TaskEnum.taskTypeDesc[int(minfo.dtype) - 1];
			var tarval:Array=TaskEnum.taskTypeNpcField[int(minfo.dtype) - 1];
			var i:int=0;

			var bname:String;

			while (tartxt.indexOf("##") > -1) {

				if (tarval[i].indexOf("num") > -1 || tarval[i].indexOf("Num") > -1 || tarval[i].indexOf("number") > -1) {
					if (this.o.st == 0)
						tartxt=tartxt.replace("##", "<font color='#ff0000'>(" + o["var"] + "/" + minfo[tarval[i]] + ")</font>");
					else
						tartxt=tartxt.replace("##", "<font color='#00ff00'>(" + o["var"] + "/" + minfo[tarval[i]] + ")</font>");
				} else if (tarval[i].indexOf("lv") > -1) {
					if (this.o.st == 0)
						tartxt=tartxt.replace("##", "<font color='#ff0000'>(" + minfo[tarval[i]] + ")</font>");
					else
						tartxt=tartxt.replace("##", "<font color='#00ff00'>(" + minfo[tarval[i]] + ")</font>");
				} else {

					if (int(minfo.dtype) == TaskEnum.taskType_upgrade) {
						if (this.o.st == 0)
							tartxt=tartxt.replace("##", "<font color='#ff0000'>" + minfo[tarval[i]] + "</font>");
						else
							tartxt=tartxt.replace("##", "<font color='#00ff00'>" + minfo[tarval[i]] + "</font>");

					} else {

						bname=String(tarval[i]).split("_")[0] + "_id";

						if (bname.indexOf("npc") > -1) { // || bname.indexOf("box") > -1) {
							tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:" + bname + "--" + minfo[bname] + "'>" + minfo[tarval[i]] + "</a></u></font>");
						} else {

							if (int(minfo.dtype) == TaskEnum.taskType_killBossDrop)
								tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:" + String(tarval[0]).split("_")[0] + "_id" + "--" + minfo.target_point + "'>" + minfo[tarval[i]] + "</a></u></font>");
							else if (int(minfo.dtype) == TaskEnum.taskType_collect)
								tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:" + String(tarval[0]).split("_")[0] + "_id" + "--" + minfo.target_point + "'>" + minfo[tarval[i]] + "</a></u></font>");
							else if (int(minfo.dtype) == TaskEnum.taskType_Exchange)
								tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:" + bname + "--" + minfo.item_id + "'>" + minfo[tarval[i]] + "</a></u></font>");
							else if (int(minfo.dtype) == TaskEnum.taskType_CopySuccess) {
								tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:#'>" + TableManager.getInstance().getCopyInfo(minfo[tarval[i]]).name + "</a></u></font>");
							} else if (int(minfo.dtype) == TaskEnum.taskType_ElementFlagNum) {
								tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:#'>" + minfo[tarval[i]] + "</a></u></font>");
							} else
								tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:" + bname + "--" + minfo.target_point + "'>" + minfo[tarval[i]] + "</a></u></font>");
						}
					}

				}

				i++;
			}

			this.taskTargetLbl.htmlText="" + tartxt;
			this.taskReplyLbl.htmlText="<font color='#00ff00'><a href='event:npc_id--" + minfo.dnpc + "'>" + minfo.dnpcname + "</a></font>";

			this.taskDescLbl.text="" + StringUtil_II.getBreakLineStringByCharIndex(minfo.describ, 20);
			this.targetMapLbl.text="" + minfo.tag;

//			if (int(minfo.dtype) != TaskEnum.taskType_upgrade) {
//				var sinfo:TSceneInfo=TableManager.getInstance().getSceneInfo(int(int(minfo.target_point) / 1000) + "");
//				if (sinfo != null)
//					this.targetMapLbl.text="" + sinfo.name;
//			}

			this.updateReward();
		}

		private function onItemClick(e:MouseEvent):void {

			var render:MissionRender=e.target as MissionRender;

//			trace(render.tid)
			if (render != null && render.tid != -1)
				this.updateList(render.tid);
		}

		/**
		 * 目标执行
		 * @param e
		 *
		 */
		private function onLink(e:TextEvent):void {
//			trace(e.text);

//			UIManager.getInstance().taskTrack.autoAstar=true;

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

		/**
		 * 任务奖励
		 *
		 */
		public function updateReward():void {

			var mgrid:MissionGrid;
			for each (mgrid in this.rewardVec) {
				if (mgrid != null)
					mgrid.die();

				this.removeChild(mgrid);
			}

			this.rewardVec.length=0;
			var item:Object;

			if (this.currentMissionData.exp > 0) {
				mgrid=new MissionGrid();

				item=TableManager.getInstance().getItemInfo(65534);

				mgrid.updataInfo(item);
				mgrid.setTipsNum(int(this.currentMissionData.exp));

//				if (int(this.currentMissionData.exp) >= 10000)
//					mgrid.setNum(Math.floor(int(this.currentMissionData.exp) / 10000) + "万");
//				else
				mgrid.setNum((this.currentMissionData.exp) + "");

				mgrid.x=220 + (this.rewardVec.length % 5) * (mgrid.width + 3);
				mgrid.y=150 + Math.floor(this.rewardVec.length / 5) * (mgrid.height + 3);

				this.addChild(mgrid);
				this.rewardVec.push(mgrid);
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

				mgrid.x=220 + (this.rewardVec.length % 5) * (mgrid.width + 3);
				mgrid.y=150 + Math.floor(this.rewardVec.length / 5) * (mgrid.height + 3);

				this.addChild(mgrid);
				this.rewardVec.push(mgrid);
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

				mgrid.x=220 + (this.rewardVec.length % 5) * (mgrid.width + 3);
				mgrid.y=150 + Math.floor(this.rewardVec.length / 5) * (mgrid.height + 3);

				this.addChild(mgrid);
				this.rewardVec.push(mgrid);
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

				mgrid.x=220 + (this.rewardVec.length % 5) * (mgrid.width + 3);
				mgrid.y=150 + Math.floor(this.rewardVec.length / 5) * (mgrid.height + 3);

				this.addChild(mgrid);
				this.rewardVec.push(mgrid);

			}

		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "leftBtn":
					hallowCurrentIndex--;
					break;
				case "rightBtn":
					hallowCurrentIndex++;
					break;
			}

			if (hallowCurrentIndex < 0)
				hallowCurrentIndex=0;

			if (hallowCurrentIndex > this.hallowsVec.length - 1)
				hallowCurrentIndex=this.hallowsVec.length - 1;

			this.mainNpcIcon.updateBmp("ui/mission/mission_icon" + (this.hallowCurrentIndex + 1) + "_big.png", onComplete);
//			this.updateOtherTaskList(this.o);
			this.updateHallowList();
		}

		private function setProp():void {

			var hallows:THallows=TableManager.getInstance().getHallowslistByProfressAndTeamId(Core.me.info.profession, this.hallowsVec[this.hallowCurrentIndex]);

			if (hallows == null)
				return;

			for (var i:int=1; i <= 4; i++) {
				this["prop" + i + "Lbl"].text="" + PropUtils.propArr[hallows["H_property_" + i] - 1];
				this["value" + i + "Lbl"].text="" + hallows["Property_Amount_" + i];
			}

		}

		public function updateMainNpcIcon(v:String):void {
			this.mainNpcIcon.updateBmp("ui/mission/mission_icon1_big.png");
		}

		private function onComplete(e:Image):void {

			if (this.twn == null) {
				this.twn=TweenMax.to(this.mainNpcIcon, .5, {y: this.mainNpcIcon.y + 4, yoyo: true, repeat: -1});
			}

		}

		/**
		 * 回环任务npcicon
		 * @param v
		 *
		 */
		public function updateNpcIcon(v:String):void {
			for (var i:int=1; i < 11; i++) {
				this.npcIconVec[i].updateBmp("");
			}
		}

		public function taskTargetText(v:String):void {
			this.taskTargetLbl.text=v;
		}

		public function taskReplyText(v:String):void {
			this.taskReplyLbl.text=v;
		}

		public function targetMapText(v:String):void {
			this.targetMapLbl.text=v;
		}

		public function taskDescText(v:String):void {
			this.taskDescLbl.text=v;
		}

	}
}

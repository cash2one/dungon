package com.leyou.ui.task.child {

	import com.ace.config.Core;
	import com.ace.enum.CursorEnum;
	import com.ace.enum.FontEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.SettingManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TDailytask;
	import com.ace.gameData.table.TMissionDate;
	import com.ace.gameData.table.TPointInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.CursorManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.LoadUtil;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.TaskEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Go;
	import com.leyou.net.cmd.Cmd_Tsk;
	import com.leyou.utils.FilterUtil;
	
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;

	public class MissionDailyRender extends AutoSprite {

		private var taskTargeNpctLbl:Label;
		private var taskTargetLbl:Label;
		private var targetMapLbl:Label;
		private var mapTxtLbl:Label;
		private var targetTxtLbl:Label;

		private var loopAddBtn:ImgLabelButton;
		private var oneKeySuccBtn:NormalButton;
		private var rewardBtn:ImgLabelButton;
		private var accpetAwardBtn:NormalButton;

		private var rewardStarVec:Vector.<Image>;
		private var loopNumImgVec:Vector.<Image>;
		private var rewardStarEffect:SwfLoader;

		private var taskLoopProgress:ScaleBitmap;

		private var loopRewardVec:Vector.<MissionGrid>;
		private var rewardVec:Vector.<MissionGrid>;

		private var currentMissionData:TMissionDate;

		private var currentLoop:int=0;
		private var currentStar:int=0;
		private var currentTaskId:int=-1;

		public var isComplete:Boolean=false;

		public function MissionDailyRender() {
			super(LibManager.getInstance().getXML("config/ui/task/missionDailyRender.xml"));
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {

			this.taskTargeNpctLbl=this.getUIbyID("taskTargeNpctLbl") as Label;
			this.taskTargetLbl=this.getUIbyID("taskTargetLbl") as Label;
			this.targetMapLbl=this.getUIbyID("targetMapLbl") as Label;

			this.taskTargeNpctLbl.styleSheet=FontEnum.DEFAULT_LINK_STYLE;
			this.taskTargetLbl.styleSheet=FontEnum.DEFAULT_LINK_STYLE;

			this.mapTxtLbl=this.getUIbyID("mapTxtLbl") as Label;
			this.targetTxtLbl=this.getUIbyID("targetTxtLbl") as Label;

			this.loopAddBtn=this.getUIbyID("loopAddBtn") as ImgLabelButton;
			this.oneKeySuccBtn=this.getUIbyID("oneKeySuccBtn") as NormalButton;
			this.rewardBtn=this.getUIbyID("rewardBtn") as ImgLabelButton;
			this.accpetAwardBtn=this.getUIbyID("accpetAwardBtn") as NormalButton;

			this.rewardStarVec=new Vector.<Image>();
			this.rewardStarVec.push(this.getUIbyID("rewardStar0") as Image);
			this.rewardStarVec.push(this.getUIbyID("rewardStar1") as Image);
			this.rewardStarVec.push(this.getUIbyID("rewardStar2") as Image);
			this.rewardStarVec.push(this.getUIbyID("rewardStar3") as Image);
			this.rewardStarVec.push(this.getUIbyID("rewardStar4") as Image);

			this.rewardStarEffect=new SwfLoader(99919);
			this.addChild(this.rewardStarEffect);

			this.rewardStarEffect.visible=false;
			this.rewardStarEffect.x=this.rewardStarVec[0].x - 30;
			this.rewardStarEffect.y=this.rewardStarVec[0].y - 30;

			this.loopNumImgVec=new Vector.<Image>();
			this.loopNumImgVec.push(this.getUIbyID("loopNum1Img") as Image);
			this.loopNumImgVec.push(this.getUIbyID("loopNum2Img") as Image);

			this.taskLoopProgress=this.getUIbyID("taskLoopProgress") as ScaleBitmap;

			this.rewardBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.rewardBtn.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
//			this.rewardBtn.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.loopAddBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.oneKeySuccBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.accpetAwardBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.accpetAwardBtn.visible=false;

			this.loopRewardVec=new Vector.<MissionGrid>();
			this.rewardVec=new Vector.<MissionGrid>();

			this.taskTargetLbl.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.taskTargetLbl.addEventListener(TextEvent.LINK, onLinkClick);
			this.taskTargetLbl.mouseEnabled=true;

			this.loopAddBtn.setToolTip(StringUtil.substitute(TableManager.getInstance().getSystemNotice(2301).content, [ConfigEnum.taskDailyCost1]));

			this.taskTargeNpctLbl.filters=[FilterUtil.showBorder(0x000000)];
			this.taskTargetLbl.filters=[FilterUtil.showBorder(0x000000)];
			this.targetMapLbl.filters=[FilterUtil.showBorder(0x000000)];
		}

		private function onMouseOver(e:MouseEvent):void {
			if (15000 <= UIManager.getInstance().backpackWnd.jb)
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(2303).content, new Point(e.stageX, e.stageY));
			else
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(2304).content, new Point(e.stageX, e.stageY));
		}

		private function onMouseOut(e:MouseEvent):void {
			ToolTipManager.getInstance().hide();
		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "accpetAwardBtn":
					Cmd_Tsk.cmTaskDailyReward();
					break;
				case "rewardBtn":
					Cmd_Tsk.cmTaskDailyStar();
					break;
				case "loopAddBtn":
					PopupManager.showConfirm(StringUtil.substitute(TableManager.getInstance().getSystemNotice(2306).content, [ConfigEnum.taskDailyCost1]), function():void {
						Cmd_Tsk.cmTaskDailySuccess();
					}, null, false, "loopSuccToday");
					break;
				case "oneKeySuccBtn":
					PopupManager.showConfirm(StringUtil.substitute(TableManager.getInstance().getSystemNotice(2305).content, [(ConfigEnum.taskDailySum - this.currentLoop + 1) * ConfigEnum.taskDailyCost1]), function():void {
						Cmd_Tsk.cmTaskDailySuccess(2);
					}, null, false, "onKeySuccToday");
					break;
			}

		}

		private function onLinkClick(e:TextEvent):void {

//			UIManager.getInstance().taskTrack.autoAstar=true;

			var ctx:String=e.text;
			var str:Array=ctx.split("--");

			if (this.currentMissionData.type == TaskEnum.taskLevel_switchLine && this.currentMissionData.dtype == TaskEnum.taskType_Exchange) {

				UILayoutManager.getInstance().show(WindowEnum.SHOP);
				UIManager.getInstance().buyWnd.updateTask(int(str[1]), int(taskTargetLbl.text.split("/")[1].replace(")", "")));

				TweenLite.delayedCall(.5, function():void {
					UIManager.getInstance().buyWnd.show();
				});

			} else if (str[0].indexOf("monster") > -1) {
				var info:TPointInfo=TableManager.getInstance().getPointInfo(int(str[1]));

				//跨场景寻路
				Core.me.gotoMap(new Point(info.tx, info.ty), info.sceneId);
				SettingManager.getInstance().assitInfo.startAutoTask();

			} else if (str[0].indexOf("npc") > -1 || str[0].indexOf("box") > -1) {
				Cmd_Go.cmGo(str[1]);
			}

//			var str:String=String(e.text).split("--")[1];
//			Cmd_Go.cmGo(int(str));
		}


		public function updateInfo(o:Object):void {
//			trace(o);

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

			if (o.hasOwnProperty("cloop")) {
				this.updateLoopNum(o.cloop);
//				this.taskLoopProgress.scaleX=Number(int(o.cloop) / ConfigEnum.taskDailySum);
				this.taskLoopProgress.setSize(Number(int(o.cloop) / ConfigEnum.taskDailySum) * 173, 10);
				this.currentLoop=o.cloop;

				if (ConfigEnum.taskDailySum == this.currentLoop) {
					this.oneKeySuccBtn.setToolTip("");
					this.loopAddBtn.setToolTip("");
				} else
					this.oneKeySuccBtn.setToolTip(StringUtil.substitute(TableManager.getInstance().getSystemNotice(2302).content, [(ConfigEnum.taskDailySum - int(o.cloop) + 1) * ConfigEnum.taskDailyCost1, DataManager.getInstance().vipData.taskPrivilegeVipLv()]));
			}

			if (o.hasOwnProperty("award")) {

				this.oneKeySuccBtn.setActive(false, .6, true);
				this.loopAddBtn.setActive(false, .6, true);

				if (o.award == 0 && !o.hasOwnProperty("tid"))
					this.accpetAwardBtn.visible=true;
				else
					this.accpetAwardBtn.visible=false;

			} else {

				this.accpetAwardBtn.visible=false;
				this.oneKeySuccBtn.setActive(true, 1, true);
				this.loopAddBtn.setActive(true, 1, true);

			}

			this.updateList(o);
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

		private function updateList(o:Object):void {

			if (o.hasOwnProperty("tid")) {
				var minfo:TMissionDate;
				//目标字段
				currentMissionData=minfo=TableManager.getInstance().getMissionDataByID(int(o.tid));

				var tartxt:String=TaskEnum.taskTypeDesc[int(minfo.dtype) - 1];
				var tarval:Array=TaskEnum.taskTypeNpcField[int(minfo.dtype) - 1];
				var i:int=0;

				var bname:String;

				while (tartxt.indexOf("##") > -1) {

					if (tarval[i].indexOf("num") > -1 || tarval[i].indexOf("number") > -1) {

						if (int(o["var"]) == int(minfo[tarval[i]]))
							tartxt=tartxt.replace("##", "<font color='#00ff00'>(" + o["var"] + "/" + minfo[tarval[i]] + ")</font>");
						else
							tartxt=tartxt.replace("##", "<font color='#ff0000'>(" + o["var"] + "/" + minfo[tarval[i]] + ")</font>");

					} else {

						if (int(minfo.dtype) == TaskEnum.taskType_upgrade) {
							tartxt=tartxt.replace("##", "<font color='#00ff00'>" + minfo[tarval[i]] + "</font>");
						} else {
							bname=String(tarval[i]).split("_")[0] + "_id";

							if (int(minfo.dtype) == TaskEnum.taskType_killBossDrop)
								tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:" + String(tarval[0]).split("_")[0] + "_id" + "--" + minfo.target_point + "'>" + minfo[tarval[i]] + "</a></u></font>");
							else if (int(minfo.dtype) == TaskEnum.taskType_collect)
								tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:" + String(tarval[0]).split("_")[0] + "_id" + "--" + minfo.box_id + "'>" + minfo[tarval[i]] + "</a></u></font>");
							else if (int(minfo.dtype) == TaskEnum.taskType_Exchange)
								tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:" + bname + "--" + minfo.item_id + "'>" + minfo[tarval[i]] + "</a></u></font>");
							else
								tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:" + bname + "--" + minfo.target_point + "'>" + minfo[tarval[i]] + "</a></u></font>");
						}
					}

					i++;
				}

				this.taskTargetLbl.htmlText="" + tartxt;
				this.taskTargeNpctLbl.htmlText="<font color='#00ff00'><a href='event:npc_id--" + minfo.dnpc + "'>" + minfo.dnpcname + "</a></font>";

				this.targetMapLbl.text="" + minfo.tag;

//				if (int(minfo.dtype) != TaskEnum.taskType_upgrade) {
//					var sinfo:TSceneInfo=TableManager.getInstance().getSceneInfo(int(int(minfo.target_point) / 1000) + "");
//					if (sinfo != null)
//						this.targetMapLbl.text="" + sinfo.name;
//				}

				this.updateReward(o);
				this.rewardBtn.visible=true;

				this.targetTxtLbl.visible=true;
				this.mapTxtLbl.visible=true;
				this.setStarVisible(true);

				this.oneKeySuccBtn.setActive(true, 1, true);
				this.loopAddBtn.setActive(true, 1, true);

			} else if (o.hasOwnProperty("award")) {

				if (o.award == 1) {
					this.setStarVisible(false);
					this.oneKeySuccBtn.setActive(false, .6, true);
					this.loopAddBtn.setActive(false, .6, true);

					if (this.visible && !this.isComplete) {

						var flyArr:Array=[[], []];
						for each (mgrid in this.loopRewardVec) {
							if (mgrid != null) {
								flyArr[0].push(mgrid.dataId);
								flyArr[1].push(mgrid.parent.localToGlobal(new Point(mgrid.x, mgrid.y)));
							}
						}

						FlyManager.getInstance().flyBags(flyArr[0], flyArr[1]);
					}

					this.isComplete=true;
				}

				this.targetTxtLbl.visible=false;
				this.mapTxtLbl.visible=false;

				this.taskTargetLbl.text="";
				this.taskTargeNpctLbl.text="";
				this.targetMapLbl.text="";

				this.rewardBtn.visible=false;

				var mgrid:MissionGrid;
				for each (mgrid in this.rewardVec) {
					this.removeChild(mgrid);
				}

				this.rewardVec.length=0;

			}

			if (this.loopRewardVec.length == 0)
				updateLoopReward();
		}

		/**
		 *设置star 显示/隐藏
		 * @param v
		 *
		 */
		private function setStarVisible(v:Boolean):void {
			for (var i:int=0; i < this.rewardStarVec.length; i++) {
				this.rewardStarVec[i].visible=v;
			}
		}

		public function setonKeySuccState(lv:int=0):void {

			var _lv:int=DataManager.getInstance().vipData.taskPrivilegeVipLv();
 
			if (lv >= _lv && !this.isComplete){
				this.oneKeySuccBtn.setActive(true, 1, true);
			}else{
				this.oneKeySuccBtn.setActive(false, .6, true);
			}
			
		}

		/**
		 * 更新回合奖励
		 *
		 */
		public function updateLoopReward():void {
			var mgrid:MissionGrid;
			for each (mgrid in this.loopRewardVec) {
				if (mgrid != null)
					mgrid.die();
				this.removeChild(mgrid);
			}

			this.loopRewardVec.length=0;

			var dxml:XML=LibManager.getInstance().getXML("config/table/dailytask.xml");
			var xml:XML;

			for each (xml in dxml.data) {
				if (Core.me.info.level >= xml.@lv_min && Core.me.info.level < int(xml.@lv_min) + 10)
					break;
			}

			var dinfo:TDailytask=new TDailytask(xml);
			var item:Object;
			if (dinfo.exp != "" && dinfo.exp != null) {
				mgrid=new MissionGrid();

				item=TableManager.getInstance().getItemInfo(65534);

				mgrid.updataInfo(item);
				mgrid.setTipsNum(int(dinfo.exp));

//				if (int(dinfo.exp) >= 10000)
//					mgrid.setNum(Math.floor(int(dinfo.exp) / 10000) + "万");
//				else
				mgrid.setNum((dinfo.exp));

				mgrid.x=210 + (this.loopRewardVec.length % 5) * (mgrid.width + 3);
				mgrid.y=318 + Math.floor(this.loopRewardVec.length / 5) * (mgrid.height + 3);

				this.addChild(mgrid);
				this.loopRewardVec.push(mgrid);
			}

			if (dinfo.money != "" && dinfo.money != null) {
				mgrid=new MissionGrid();

				item=TableManager.getInstance().getItemInfo(65535);

				mgrid.updataInfo(item);
				mgrid.setTipsNum(int(dinfo.money));

//				if (int(dinfo.money) >= 10000)
//					mgrid.setNum(Math.floor(int(dinfo.money) / 10000) + "万");
//				else
				mgrid.setNum((dinfo.money));

				mgrid.x=210 + (this.loopRewardVec.length % 5) * (mgrid.width + 3);
				mgrid.y=318 + Math.floor(this.loopRewardVec.length / 5) * (mgrid.height + 3);

				this.addChild(mgrid);
				this.loopRewardVec.push(mgrid);
			}


			if (dinfo.energy != "" && dinfo.energy != null) {
				mgrid=new MissionGrid();

				item=TableManager.getInstance().getItemInfo(65533);

				mgrid.updataInfo(item);
				mgrid.setTipsNum(int(dinfo.energy));

//				if (int(dinfo.energy) >= 10000)
//					mgrid.setNum(Math.floor(int(dinfo.energy) / 10000) + "万");
//				else
				mgrid.setNum((dinfo.energy));

				mgrid.x=210 + (this.loopRewardVec.length % 5) * (mgrid.width + 3);
				mgrid.y=318 + Math.floor(this.loopRewardVec.length / 5) * (mgrid.height + 3);

				this.addChild(mgrid);
				this.loopRewardVec.push(mgrid);
			}

			if (dinfo.bg != "" && dinfo.bg != null) {
				mgrid=new MissionGrid();

				item=TableManager.getInstance().getItemInfo(65531);

				mgrid.updataInfo(item);
				mgrid.setTipsNum(int(dinfo.bg));

//				if (int(dinfo.bg) >= 10000)
//					mgrid.setNum(Math.floor(int(dinfo.bg) / 10000) + "万");
//				else
				mgrid.setNum((dinfo.bg));

				mgrid.x=210 + (this.loopRewardVec.length % 5) * (mgrid.width + 3);
				mgrid.y=318 + Math.floor(this.loopRewardVec.length / 5) * (mgrid.height + 3);

				this.addChild(mgrid);
				this.loopRewardVec.push(mgrid);
			}

			if (dinfo.Bd_Yb != "" && dinfo.Bd_Yb != null) {
				mgrid=new MissionGrid();

				item=TableManager.getInstance().getItemInfo(65532);

				mgrid.updataInfo(item);
				mgrid.setTipsNum(int(dinfo.Bd_Yb));

//				if (int(dinfo.Bd_Yb) >= 10000)
//					mgrid.setNum(Math.floor(int(dinfo.Bd_Yb) / 10000) + "万");
//				else
				mgrid.setNum((dinfo.Bd_Yb));

				mgrid.x=210 + (this.loopRewardVec.length % 5) * (mgrid.width + 3);
				mgrid.y=318 + Math.floor(this.loopRewardVec.length / 5) * (mgrid.height + 3);

				this.addChild(mgrid);
				this.loopRewardVec.push(mgrid);
			}

			if (dinfo.liveness != "" && dinfo.liveness != null) {
				mgrid=new MissionGrid();

				item=TableManager.getInstance().getItemInfo(65530);

				mgrid.updataInfo(item);
				mgrid.setTipsNum(int(dinfo.liveness));

//				if (int(dinfo.liveness) >= 10000)
//					mgrid.setNum(Math.floor(int(dinfo.liveness) / 10000) + "万");
//				else
				mgrid.setNum((dinfo.liveness));

				mgrid.x=210 + (this.loopRewardVec.length % 5) * (mgrid.width + 3);
				mgrid.y=318 + Math.floor(this.loopRewardVec.length / 5) * (mgrid.height + 3);

				this.addChild(mgrid);
				this.loopRewardVec.push(mgrid);
			}

			var reward:String;

			for (var i:int=0; i < 4; i++) {
				mgrid=new MissionGrid();

				if (dinfo["item" + (i + 1)] == "" || dinfo["item" + (i + 1)] == null)
					continue;

				this.addChild(mgrid);

				reward=String(dinfo["item" + (i + 1)]); //.split("|")[Core.me.info.profession - 1];
				if (reward.indexOf("|") > -1) {
					reward=String(dinfo["item" + (i + 1)]).split("|")[Core.me.info.profession - 1];
				}
				
				item=TableManager.getInstance().getEquipInfo(int(reward));
				if (item == null)
					item=TableManager.getInstance().getItemInfo(int(reward));
				
				if (item != null)
				mgrid.updataInfo(item);

				if (int(dinfo["num" + (i + 1)]) > 1)
					mgrid.setNum(dinfo["num" + (i + 1)]);

				mgrid.canMove=false;

				mgrid.x=210 + (this.loopRewardVec.length % 5) * (45);
				mgrid.y=318 + Math.floor(this.loopRewardVec.length / 5) * (mgrid.height + 3);

				this.loopRewardVec.push(mgrid);
			}
		}

		/**
		 * 更新普通奖励
		 *
		 */
		public function updateReward(o:Object):void {
			var mgrid:MissionGrid;
			for each (mgrid in this.rewardVec) {
				if (mgrid != null && mgrid.parent == this) {
					mgrid.die();
					this.removeChild(mgrid);
				}
			}

			this.rewardVec.length=0;

			var _x:int=210;
			var _y:int=166;

			var rate:Number=Number(ConfigEnum["taskDailyStar" + o.star]);

			if (this.currentMissionData.exp > 0) {
				mgrid=new MissionGrid();

				item=TableManager.getInstance().getItemInfo(65534);

				mgrid.updataInfo(item);
				mgrid.setTipsNum(Math.floor(int(this.currentMissionData.exp) * rate));

//				if (int(this.currentMissionData.exp) * rate >= 10000)
//					mgrid.setNum(Math.floor(int(this.currentMissionData.exp) * rate / 10000) + "万");
//				else
				mgrid.setNum(Math.floor(int(this.currentMissionData.exp) * rate) + "");

				mgrid.x=_x + (this.rewardVec.length % 5) * (mgrid.width + 3);
				mgrid.y=166 + Math.floor(this.rewardVec.length / 5) * (mgrid.height + 3);

				this.addChild(mgrid);
				this.rewardVec.push(mgrid);
			}

			if (this.currentMissionData.money > 0) {
				mgrid=new MissionGrid();

				item=TableManager.getInstance().getItemInfo(65535);

				mgrid.updataInfo(item);
				mgrid.setTipsNum(Math.floor(int(this.currentMissionData.money) * rate));

//				if (int(this.currentMissionData.money) * rate >= 10000)
//					mgrid.setNum(Math.floor(int(this.currentMissionData.money) * rate / 10000) + "万");
//				else
				mgrid.setNum(Math.floor(int(this.currentMissionData.money) * rate) + "");

				mgrid.x=_x + (this.rewardVec.length % 5) * (mgrid.width + 3);
				mgrid.y=166 + Math.floor(this.rewardVec.length / 5) * (mgrid.height + 3);

				this.addChild(mgrid);
				this.rewardVec.push(mgrid);
			}

			if (this.currentMissionData.energy > 0) {
				mgrid=new MissionGrid();

				item=TableManager.getInstance().getItemInfo(65533);

				mgrid.updataInfo(item);
				mgrid.setTipsNum(Math.floor(int(this.currentMissionData.energy) * rate));

//				if (int(this.currentMissionData.energy) >= 10000)
//					mgrid.setNum(Math.floor(int(this.currentMissionData.energy) / 10000) + "万");
//				else
				mgrid.setNum(Math.floor(int(this.currentMissionData.energy) * rate) + "");

				mgrid.x=_x + (this.rewardVec.length % 5) * (mgrid.width + 3);
				mgrid.y=166 + Math.floor(this.rewardVec.length / 5) * (mgrid.height + 3);

				this.addChild(mgrid);
				this.rewardVec.push(mgrid);
			}

			if (this.currentMissionData.bg > 0) {
				mgrid=new MissionGrid();

				item=TableManager.getInstance().getItemInfo(65531);

				mgrid.updataInfo(item);
				mgrid.setTipsNum(Math.floor(int(this.currentMissionData.bg)));

//				if (int(this.currentMissionData.bg) >= 10000)
//					mgrid.setNum(Math.floor(int(this.currentMissionData.bg) / 10000) + "万");
//				else
				mgrid.setNum(Math.floor(int(this.currentMissionData.bg)) + "");

				mgrid.x=_x + (this.rewardVec.length % 5) * (mgrid.width + 3);
				mgrid.y=166 + Math.floor(this.rewardVec.length / 5) * (mgrid.height + 3);

				this.addChild(mgrid);
				this.rewardVec.push(mgrid);
			}

			var item:Object;
			var reward:String;

			for (var i:int=0; i < 4; i++) {

				if (this.currentMissionData["item" + (i + 1)] == 0)
					continue;

				reward=String(this.currentMissionData["item" + (i + 1)]); //.split("|")[Core.me.info.profession - 1];

				if (reward.length == 4)
					item=TableManager.getInstance().getEquipInfo(int(reward));
				else
					item=TableManager.getInstance().getItemInfo(int(reward));

				mgrid.updataInfo(item);

				if (int(this.currentMissionData["num" + (i + 1)]) > 1)
					mgrid.setNum(this.currentMissionData["num" + (i + 1)]);

				mgrid.canMove=false;

				mgrid.x=_x + (this.rewardVec.length % 5) * (mgrid.width + 3);
				mgrid.y=166 + Math.floor(this.rewardVec.length / 5) * (mgrid.height + 3);

				this.addChild(mgrid);
				this.rewardVec.push(mgrid);

			}

		}

		/**
		 * 更新星奖励
		 * @param count
		 *
		 */
		public function updateStar(count:int):void {
			for (var i:int=0; i < 5; i++) {
				if (i < count) {
					this.rewardStarVec[i].updateBmp("ui/mission/mission_icon_star1.png");
				} else {
					this.rewardStarVec[i].updateBmp("ui/mission/mission_icon_star2.png");
				}
			}
		}

		public function updateLoopNum(num:int):void {

			var _num:String=num.toString();
			if (_num.length == 1) {

				if (_num.charAt(0) > "0") {
					this.loopNumImgVec[1].updateBmp("ui/mission/mission_Num_" + _num.charAt(0) + ".png");
				} else {
					this.loopNumImgVec[1].updateBmp("ui/mission/mission_Num_0.png");
				}

				this.loopNumImgVec[0].updateBmp("ui/mission/mission_Num_0.png");

			} else {

				if (_num.charAt(0) > "0") {
					this.loopNumImgVec[0].updateBmp("ui/mission/mission_Num_" + _num.charAt(0) + ".png");
				} else {
					this.loopNumImgVec[0].updateBmp("ui/mission/mission_Num_0.png");
				}

				if (_num.charAt(1) > "0") {
					this.loopNumImgVec[1].updateBmp("ui/mission/mission_Num_" + _num.charAt(1) + ".png");
				} else {
					this.loopNumImgVec[1].updateBmp("ui/mission/mission_Num_0.png");
				}
			}
		}

		public function taskTargetText(v:String):void {
			this.taskTargetLbl.text=v;
		}


	}
}

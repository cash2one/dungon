package com.leyou.ui.tips {

	import com.ace.ICommon.ITip;
	import com.ace.config.Core;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TDailytask;
	import com.ace.gameData.table.TMissionDate;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.TaskEnum;
	import com.leyou.ui.task.child.MissionGrid;

	public class TipsDMissonWnd extends AutoSprite implements ITip {

		private var targetLbl:Label;
		private var loopNumLbl:Label;

		private var starImg:Array=[];

		private var rewardVec:Array=[];
		private var loopRewardVec:Array=[];
		private var currentMissionData:TMissionDate;

		public function TipsDMissonWnd() {
			super(LibManager.getInstance().getXML("config/ui/tips/TipsDMissonWnd.xml"));
			this.init();
		}

		private function init():void {
			this.targetLbl=this.getUIbyID("targetLbl") as Label;
			this.loopNumLbl=this.getUIbyID("loopNumLbl") as Label;

			this.starImg.push(this.getUIbyID("star0img") as Image);
			this.starImg.push(this.getUIbyID("star1img") as Image);
			this.starImg.push(this.getUIbyID("star2img") as Image);
			this.starImg.push(this.getUIbyID("star3img") as Image);
			this.starImg.push(this.getUIbyID("star4img") as Image);

		}

		public function updateInfo(info:Object):void {

			var arr:Array=info.tr as Array;
			if (arr.length < 2) {
				this.hide();
				return;
			}

			arr.sortOn("type", Array.CASEINSENSITIVE | Array.NUMERIC);
			var o:Object=arr[1];

			//目标字段
			var minfo:TMissionDate;
			this.currentMissionData=minfo=TableManager.getInstance().getMissionDataByID(o.tid);

			var tartxt:String=TaskEnum.taskTypeDesc[int(minfo.dtype) - 1];
			var tarval:Array=TaskEnum.taskTypeNpcField[int(minfo.dtype) - 1];
			var i:int=0;

			var bname:String;
			var bid:String;

			while (tartxt.indexOf("##") > -1) {

				if (tarval[i].indexOf("num") > -1 || tarval[i].indexOf("number") > -1) {
					tartxt=tartxt.replace("##", "<font color='#ff0000'>(" + o["var"] + "/" + minfo[tarval[i]] + ")</font>");
				} else {

					if (int(minfo.dtype) == TaskEnum.taskType_upgrade) {
						tartxt=tartxt.replace("##", "<font color='#ff0000'>" + minfo[tarval[i]] + "</font>");
					} else {

						bname=String(tarval[i]).split("_")[0] + "_id";

						if (bname.indexOf("npc") > -1 || bname.indexOf("box") > -1) {

							//							this.linkArr[int(minfo.type)].push(bname + "--" + minfo[bname]);
							tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:" + bname + "--" + minfo[bname] + "'>" + minfo[tarval[i]] + "</a></u></font>");
						} else {
							//							this.linkArr[int(minfo.type)].push(bname + "--" + minfo.target_point);

							if (int(minfo.dtype) == TaskEnum.taskType_killBossDrop)
								tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:" + String(tarval[0]).split("_")[0] + "_id" + "--" + minfo.target_point + "'>" + minfo[tarval[i]] + "</a></u></font>");
							else if (int(minfo.dtype) == TaskEnum.taskType_collect)
								tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:" + String(tarval[0]).split("_")[0] + "_id" + "--" + minfo.box_id + "'>" + minfo[tarval[i]] + "</a></u></font>");
							else if (int(minfo.dtype) == TaskEnum.taskType_Exchange)
								tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:" + bname + "--" + minfo.dnpc + "'>" + minfo[tarval[i]] + "</a></u></font>");
							else
								tartxt=tartxt.replace("##", "<font color='#00ff00'><u><a href='event:" + bname + "--" + minfo.target_point + "'>" + minfo[tarval[i]] + "</a></u></font>");
						}
					}

				}

				i++;
			}


			this.loopNumLbl.text=" " + o.cloop + "/" + ConfigEnum.taskDailySum;
			this.targetLbl.htmlText="" + tartxt;

			this.updateLoopReward();
			this.updateReward(o);
			this.updateStar(o.star);
		}

		public function updateStar(count:int):void {
			for (var i:int=0; i < 5; i++) {
				if (i < count)
					this.starImg[i].updateBmp("ui/mission/mission_icon_star1.png");
				else
					this.starImg[i].updateBmp("ui/mission/mission_icon_star2.png");
			}
		}

		public function updateReward(o:Object):void {
			var mgrid:MissionGrid;
			for each (mgrid in this.rewardVec) {
				if (mgrid != null && mgrid.parent == this) {
					this.removeChild(mgrid);
					mgrid.die();
				}
			}

			this.rewardVec.length=0;

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

				mgrid.x=5 + (this.rewardVec.length % 6) * (mgrid.width + 2);
				mgrid.y=85 + Math.floor(this.rewardVec.length / 6) * (mgrid.height + 2);

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

				mgrid.x=5 + (this.rewardVec.length % 6) * (mgrid.width + 2);
				mgrid.y=85 + Math.floor(this.rewardVec.length / 6) * (mgrid.height + 2);

				this.addChild(mgrid);
				this.rewardVec.push(mgrid);
			}

			if (this.currentMissionData.bg > 0) {
				mgrid=new MissionGrid();

				item=TableManager.getInstance().getItemInfo(65531);

				mgrid.updataInfo(item);
				mgrid.setTipsNum(int(this.currentMissionData.bg));

//				if (int(this.currentMissionData.bg) >= 10000)
//					mgrid.setNum(Math.floor(int(this.currentMissionData.bg) * rate / 10000) + "万");
//				else
				mgrid.setNum((int(this.currentMissionData.bg) * rate) + "");

				mgrid.x=5 + (this.rewardVec.length % 6) * (mgrid.width + 2);
				mgrid.y=85 + Math.floor(this.rewardVec.length / 6) * (mgrid.height + 2);

				this.addChild(mgrid);
				this.rewardVec.push(mgrid);
			}

			if (this.currentMissionData.energy > 0) {
				mgrid=new MissionGrid();

				item=TableManager.getInstance().getItemInfo(65533);

				mgrid.updataInfo(item);
				mgrid.setTipsNum(Math.floor(int(this.currentMissionData.energy) * rate));

//				if (int(this.currentMissionData.energy) >= 10000)
//					mgrid.setNum(Math.floor(int(this.currentMissionData.energy) * rate / 10000) + "万");
//				else
				mgrid.setNum(Math.floor(int(this.currentMissionData.energy) * rate) + "");

				mgrid.x=5 + (this.rewardVec.length % 6) * (mgrid.width + 2);
				mgrid.y=85 + Math.floor(this.rewardVec.length / 6) * (mgrid.height + 2);

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

				mgrid.x=5 + (this.rewardVec.length % 6) * (mgrid.width + 2);
				mgrid.y=85 + Math.floor(this.rewardVec.length / 6) * (mgrid.height + 2);

				this.addChild(mgrid);
				this.rewardVec.push(mgrid);

			}

		}

		public function updateLoopReward():void {
			var mgrid:MissionGrid;
			for each (mgrid in this.loopRewardVec) {
				if (mgrid != null && mgrid.parent == this) {
					this.removeChild(mgrid);
					mgrid.die();
				}
			}

			this.loopRewardVec.length=0;

			var dxml:XML=LibManager.getInstance().getXML("config/table/dailytask.xml");
			var xml:XML;

			for each (xml in dxml.data) {
				if (Core.me.info.level >= xml.@lv_min && Core.me.info.level < int(xml.@lv_min) + 10)
					break;
			}

			var dinfo:TDailytask=new TDailytask(xml);

			if (dinfo.exp != "" && dinfo.exp != null) {
				mgrid=new MissionGrid();

				item=TableManager.getInstance().getItemInfo(65534);

				mgrid.updataInfo(item);
				mgrid.setTipsNum(int(dinfo.exp));

//				if (int(dinfo.exp) >= 10000)
//					mgrid.setNum(Math.floor(int(dinfo.exp) / 10000) + "万");
//				else
				mgrid.setNum((dinfo.exp));

				mgrid.x=3 + (this.loopRewardVec.length % 6) * (mgrid.width);
				mgrid.y=180 + Math.floor(this.loopRewardVec.length / 6) * (mgrid.height);

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

				mgrid.x=3 + (this.loopRewardVec.length % 6) * (mgrid.width);
				mgrid.y=180 + Math.floor(this.loopRewardVec.length / 6) * (mgrid.height);

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

				mgrid.x=3 + (this.loopRewardVec.length % 6) * (mgrid.width);
				mgrid.y=180 + Math.floor(this.loopRewardVec.length / 6) * (mgrid.height);

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

				mgrid.x=3 + (this.loopRewardVec.length % 6) * (mgrid.width);
				mgrid.y=180 + Math.floor(this.loopRewardVec.length / 6) * (mgrid.height);

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

				mgrid.x=3 + (this.loopRewardVec.length % 6) * (mgrid.width);
				mgrid.y=180 + Math.floor(this.loopRewardVec.length / 6) * (mgrid.height);

				this.addChild(mgrid);
				this.loopRewardVec.push(mgrid);
			}

			var item:Object;
			var reward:String;

			for (var i:int=0; i < 4; i++) {
				mgrid=new MissionGrid();

				if (dinfo["item" + (i + 1)] == "" || dinfo["item" + (i + 1)] == null)
					continue;

				this.addChild(mgrid);

				reward=String(dinfo["item" + (i + 1)]); //.split("|")[Core.me.info.profession - 1];

				if (reward.length == 4)
					item=TableManager.getInstance().getEquipInfo(int(reward));
				else
					item=TableManager.getInstance().getItemInfo(int(reward));

				mgrid.updataInfo(item);

				if (int(dinfo["num" + (i + 1)]) > 1)
					mgrid.setNum(dinfo["num" + (i + 1)]);

				mgrid.canMove=false;

				mgrid.x=3 + (this.loopRewardVec.length % 6) * (43);
				mgrid.y=180 + Math.floor(this.loopRewardVec.length / 6) * (mgrid.height + 1);

				this.loopRewardVec.push(mgrid);
			}
		}

		public function get isFirst():Boolean {
			// TODO Auto Generated method stub
			return false;
		}
	}
}

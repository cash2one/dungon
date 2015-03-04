package com.leyou.ui.tips {


	import com.ace.ICommon.ITip;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.lable.children.TextArea;
	import com.leyou.enum.PkCopyEnum;

	public class DungeonTZTips extends AutoSprite implements ITip {

		private var mvImg:Image;
		private var titleImg:Image;

		private var descTxt:TextArea;
		private var requirTxt:TextArea;
		private var rewardTxt:TextArea;
		private var timeLbl:Label;

		public function DungeonTZTips() {
			super(LibManager.getInstance().getXML("config/ui/pkCopy/dungeonTZTips.xml"));
			this.init();
		}

		private function init():void {

			this.mvImg=this.getUIbyID("mvImg") as Image;
			this.titleImg=this.getUIbyID("titleImg") as Image;

			this.descTxt=this.getUIbyID("descTxt") as TextArea;
			this.requirTxt=this.getUIbyID("requirTxt") as TextArea;
			this.rewardTxt=this.getUIbyID("rewardTxt") as TextArea;
			this.timeLbl=this.getUIbyID("timeLbl") as Label;

			this.descTxt.visibleOfBg=false;
			this.requirTxt.visibleOfBg=false;
			this.rewardTxt.visibleOfBg=false;
		}

		public function updateInfo(info:Object):void {

			this.descTxt.setText("");
			this.requirTxt.setText("");
			this.rewardTxt.setText("");
			this.timeLbl.text="";

			this.lastTime(info.actid);

			if (info.actid == PkCopyEnum.PKCOPY_DELIVERY) {

				this.titleImg.updateBmp("ui/dungeon/title_ysbc.png");
				this.mvImg.updateBmp("ui/dungeon/dungeon_tz_ysbc.jpg");

				this.descTxt.setText("" + TableManager.getInstance().getSystemNotice(9919).content);
				this.requirTxt.setText("" + TableManager.getInstance().getSystemNotice(9920).content);
				this.rewardTxt.setText("" + TableManager.getInstance().getSystemNotice(9922).content);

			} else if (info.actid == PkCopyEnum.PKCOPY_DRAGON) {

				this.titleImg.updateBmp("ui/dungeon/title_sglx.png");
				this.mvImg.updateBmp("ui/dungeon/dungeon_tz_sglx.jpg");

				this.descTxt.setText("" + TableManager.getInstance().getSystemNotice(9923).content);
				this.requirTxt.setText("" + TableManager.getInstance().getSystemNotice(9924).content);
				this.rewardTxt.setText("" + TableManager.getInstance().getSystemNotice(9926).content);

			} else if (info.actid == PkCopyEnum.PKCOPY_INVADE) {

				this.titleImg.updateBmp("ui/dungeon/title_emrq.png");
				this.mvImg.updateBmp("ui/dungeon/dungeon_tz_emrq.jpg");

				this.descTxt.setText("" + TableManager.getInstance().getSystemNotice(9927).content);
				this.requirTxt.setText("" + TableManager.getInstance().getSystemNotice(9928).content);
				this.rewardTxt.setText("" + TableManager.getInstance().getSystemNotice(9930).content);

			} else if (info.actid == PkCopyEnum.PKCOPY_QUEST) {

				this.titleImg.updateBmp("ui/dungeon/title_yjwd.png");
				this.mvImg.updateBmp("ui/dungeon/dungeon_tz_yjwd.jpg");

				this.descTxt.setText("" + TableManager.getInstance().getSystemNotice(9915).content);
				this.requirTxt.setText("" + TableManager.getInstance().getSystemNotice(9916).content);
				this.rewardTxt.setText("" + TableManager.getInstance().getSystemNotice(9918).content);

			}


		}


		private function lastTime(type:int):void {
			if (type != PkCopyEnum.PKCOPY_QUEST && type != PkCopyEnum.PKCOPY_INVADE) {
				this.timeLbl.text="全天";
				return;
			}

			var xml:XML=LibManager.getInstance().getXML("config/table/timeActivity.xml");

			var starTime:String;
			var endTime:String;

			if (type == PkCopyEnum.PKCOPY_QUEST) {
				starTime=xml.timeActivity[0].@startTime;
				endTime=xml.timeActivity[0].@overTime;
			} else if (type == PkCopyEnum.PKCOPY_INVADE) {
				starTime=xml.timeActivity[1].@startTime;
				endTime=xml.timeActivity[1].@overTime;
			}

			var stimeArr:Array=starTime.split("|");
			var etimeArr:Array=endTime.split("|");

			if (stimeArr.length > 1) {
				this.timeLbl.text="" + stimeArr[0].replace(/\,/g, ":").replace(/\:\d\d$/, "") + "-" + etimeArr[0].replace(/\,/g, ":").replace(/\:\d\d$/, "") + "  " + stimeArr[1].replace(/\,/g, ":").replace(/\:\d\d$/, "") + "-" + etimeArr[1].replace(/\,/g, ":").replace(/\:\d\d$/, "");
			} else {
				this.timeLbl.text="" + stimeArr[0].replace(/\,/g, ":").replace(/\:\d\d$/, "") + "-" + etimeArr[0].replace(/\,/g, ":").replace(/\:\d\d$/, "");
			}

		}

		public function get isFirst():Boolean {
			// TODO Auto Generated method stub
			return false;
		}

	}
}

package com.leyou.ui.ttt {
	import com.ace.enum.EventEnum;
	import com.ace.enum.FontEnum;
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TDungeon_Base;
	import com.ace.manager.EventManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.TimerManager;
	import com.leyou.net.cmd.Cmd_Ttt;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.TimeUtil;

	import flash.events.MouseEvent;

	public class TttTrack extends AutoSprite {

		private var timeLbl:Label;
		private var monster1Lbl:Label;
		private var count1Lbl:Label;
		private var count2Lbl:Label;
		private var monster2Lbl:Label;

		private var pkTimeTxt:Label;
		private var pkTimeLbl:Label;

		private var fullpkTimeTxt:Label;
		private var fullpkTimeLbl:Label;

		private var pkNextBtn:NormalButton;

		private var currentLv:int=0;
		private var time:int=0;

		/**
		 *通关时间
		 */
		private var Ttime:int=0;

		public function TttTrack() {
			super(LibManager.getInstance().getXML("config/ui/ttt/tttTrack.xml"));
			this.init();

			this.mouseChildren=true;
//			this.mouseEnabled=true;

			EventManager.getInstance().addEvent(EventEnum.COPY_QUIT, onClick);
		}

		private function onClick():void {

			var sceneId:int=int(MapInfoManager.getInstance().sceneId);

			if (sceneId >= 701 && sceneId <= 701 + ConfigEnum.Babel2) {
				Cmd_Ttt.cmCopyExit();
			}

		}

		private function init():void {
			this.timeLbl=this.getUIbyID("timeLbl") as Label;
			this.monster1Lbl=this.getUIbyID("monster1Lbl") as Label;
			this.count1Lbl=this.getUIbyID("count1Lbl") as Label;
			this.count2Lbl=this.getUIbyID("count2Lbl") as Label;
			this.monster2Lbl=this.getUIbyID("monster2Lbl") as Label;
			this.pkNextBtn=this.getUIbyID("pkNextBtn") as NormalButton;

			this.pkTimeTxt=this.getUIbyID("pkTimeTxt") as Label;
			this.pkTimeLbl=this.getUIbyID("pkTimeLbl") as Label;

			this.fullpkTimeTxt=this.getUIbyID("fullpkTimeTxt") as Label;
			this.fullpkTimeLbl=this.getUIbyID("fullpkTimeLbl") as Label;

			this.pkNextBtn.addEventListener(MouseEvent.CLICK, onNextClick);
		}


		private function onNextClick(e:MouseEvent):void {
			Cmd_Ttt.cmEnterCopy(this.currentLv);
		}

		/**
		 *下行:bbt|{"mk":"T","cfloor":num,"rt":remainTime, "m":[{"mid":id, "cc":currentCount, "mc":maxCount}...]}
		 * @param o
		 *
		 */
		public function updateInfo(o:Object):void {

			this.show();

			this.monster1Lbl.text=PropUtils.getStringById(1674) + "" + TableManager.getInstance().getLivingInfo(o.m[0].mid).name;
			this.count1Lbl.text="(" + o.m[0].cc + "/" + o.m[0].mc + ")";

			if (o.m[0].cc == o.m[0].mc) {
				this.monster1Lbl.defaultTextFormat=FontEnum.getTextFormat("Green12");
				this.count1Lbl.defaultTextFormat=FontEnum.getTextFormat("Green12");
			} else {
				this.monster1Lbl.defaultTextFormat=FontEnum.getTextFormat("Red12");
				this.count1Lbl.defaultTextFormat=FontEnum.getTextFormat("DefaultFont");
			}

			if (o.m.length > 1) {
				this.count2Lbl.text=PropUtils.getStringById(1674) + "" + TableManager.getInstance().getLivingInfo(o.m[1].mid).name;
				this.monster2Lbl.text="(" + o.m[1].cc + "/" + o.m[1].mc + ")";

				if (o.m[1].cc == o.m[1].mc) {
					this.monster2Lbl.defaultTextFormat=FontEnum.getTextFormat("Green12");
					this.count2Lbl.defaultTextFormat=FontEnum.getTextFormat("Green12");
				} else {
					this.monster2Lbl.defaultTextFormat=FontEnum.getTextFormat("Red12");
					this.count2Lbl.defaultTextFormat=FontEnum.getTextFormat("DefaultFont");
				}

			} else {
				this.count2Lbl.text="";
				this.monster2Lbl.text="";
			}

//			if (this.currentLv == 0) {
//				TimerManager.getInstance().remove(exePkTime);
//				this.pkTimeLbl.text="00:00";
//			}

			this.timeLbl.text="" + com.leyou.utils.TimeUtil.getIntToTime(o.rt);

			this.currentLv=o.cfloor;

			if (o.hasOwnProperty("lt")) {
				this.fullpkTimeTxt.visible=true;
				this.fullpkTimeLbl.visible=true;

//				var lt:String=TimeUtil.getIntToTime(int(o.lt));
//				if (lt == "")
//					this.fullpkTimeLbl.text="00:00";
//				else
//					this.fullpkTimeLbl.text="" + lt
				this.fullpkTimeLbl.text="" + o.lt + "" + PropUtils.getStringById(2146);
			} else {
				this.fullpkTimeTxt.visible=false;
				this.fullpkTimeLbl.visible=false;
			}

			this.reSize();

			if (this.time <= o.rt - 1 || this.time >= o.rt + 1)
				this.time=o.rt;

			this.Ttime=TableManager.getInstance().getTttCopyInfoBySceneId(int(MapInfoManager.getInstance().sceneId)).D_Lasttime;
//			trace(this.time,"7777777777",getTimer(),getTimer()/1000);

			TimerManager.getInstance().remove(exeTime);
			TimerManager.getInstance().add(exeTime);

			this.pkNextBtn.visible=false;

			TimerManager.getInstance().remove(exeBtnTime);

			if (this.currentLv < ConfigEnum.Babel2 && ((o.m.length == 1 && o.m[0].cc == o.m[0].mc) || (o.m.length > 1 && o.m[1].cc == o.m[1].mc))) {
				TimerManager.getInstance().add(exeBtnTime);
				this.pkNextBtn.visible=true;

//				TimerManager.getInstance().remove(exePkTime);
			} else {
//				TimerManager.getInstance().add(exePkTime);
			}

		}

		private function exeBtnTime(i:int):void {

			if (ConfigEnum.Babel6 - i > 0) {
				this.pkNextBtn.text=PropUtils.getStringById(2202) + "(" + TimeUtil.getIntToTime(ConfigEnum.Babel6 - i) + ")";
			} else {
				this.pkNextBtn.text=PropUtils.getStringById(2202) + "";
				TimerManager.getInstance().remove(exeBtnTime);
				Cmd_Ttt.cmEnterCopy(this.currentLv);
			}

		}

		private function exeTime(i:int):void {

			if (this.time - i > 0) {
				this.timeLbl.text="" + TimeUtil.getIntToTime(this.time - i);
				this.pkTimeLbl.text="" + TimeUtil.getIntToTime(this.Ttime - (this.time - i));
			} else {
				this.time=0;
				this.timeLbl.text="00:00";
				this.pkTimeLbl.text="" + TimeUtil.getIntToTime(this.Ttime);
				TimerManager.getInstance().remove(exeTime);
			}

		}


		private function exePkTime(i:int):void {
			if (i > 0)
				this.pkTimeLbl.text="" + TimeUtil.getIntToTime(this.time - i);
		}

		public function reSize():void {
			this.x=UIEnum.WIDTH - 270;
			this.y=UIEnum.HEIGHT - 267 >> 1;

//			this.leaveBtn.x=UIEnum.WIDTH - this.leaveBtn.width;
		}

		override public function hide():void {
			super.hide();
			TimerManager.getInstance().remove(exeTime);
			TimerManager.getInstance().remove(exeBtnTime);
			this.currentLv=0;
		}

	}
}

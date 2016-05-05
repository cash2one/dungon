package com.leyou.ui.welfare.child.page {
	import com.ace.enum.WindowEnum;
	import com.ace.manager.GuideArrowDirectManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.TimeManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Welfare;
	import com.leyou.ui.welfare.child.component.WelfareTimeRender;
	import com.leyou.utils.StringUtil_II;

	import flash.events.DataEvent;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;

	public class WelfareTimePage extends AutoSprite {
		private static const RewardCount:int=5;

		private var receiveBtn:ImgButton;

		private var hoursLbl:Label;

		private var minutesLbl:Label;

		private var secondsLbl:Label;

		private var timeRenders:Vector.<WelfareTimeRender>;

		private var tick:uint;

		private var onlineTime:uint;

		public function WelfareTimePage() {
			super(LibManager.getInstance().getXML("config/ui/welfare/welfareTime.xml"));
			init();
		}

		private function init():void {
			mouseEnabled=true;
			mouseChildren=true;
			hoursLbl=getUIbyID("hoursLbl") as Label;
			minutesLbl=getUIbyID("minutesLbl") as Label;
			secondsLbl=getUIbyID("secondsLbl") as Label;
			receiveBtn=getUIbyID("receiveBtn") as ImgButton;

			timeRenders=new Vector.<WelfareTimeRender>();
			for (var n:int=0; n < RewardCount; n++) {
				var timeRender:WelfareTimeRender=new WelfareTimeRender();
				timeRenders.push(timeRender);
				addChild(timeRender);
				timeRender.x=53 + 150 * n;
				timeRender.y=199;
			}
			receiveBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
		}

		protected function onMouseClick(event:MouseEvent):void {

			GuideArrowDirectManager.getInstance().delArrow(WindowEnum.WELFARE + "");

			var addTime:uint=(getTimer() - tick) / 1000;
			var olt:uint=onlineTime + addTime;
			for (var n:int=0; n < RewardCount; n++) {
				var timeRender:WelfareTimeRender=timeRenders[n];
				if (timeRender.receiveable(olt / 60)) {
					Cmd_Welfare.cm_OL_J(timeRender.timeID);
				}
			}
		}

		public function updateInfo(obj:Object):void {
			tick=getTimer();
			onlineTime=obj.ol_time;
			var rewardArr:Array=ConfigEnum.GiftLot4.split("|");
			var length:int=rewardArr.length;
			for (var n:int=0; n < length; n++) {
				var indexStr:String=rewardArr[n];
				var indexArr:Array=indexStr.split(",");
				var timeRender:WelfareTimeRender=timeRenders[n];
				timeRender.updateInfo(obj[indexArr[0]], indexArr[0]);
			}
			updateTime();
		}

		public function receiveReward(obj:Object):void {
			for (var n:int=0; n < RewardCount; n++) {
				var timeRender:WelfareTimeRender=timeRenders[n];
				var dataArr:Array=obj[timeRender.timeID];
				if (null != dataArr) {
					timeRender.rollToItem(dataArr[0]);
				}
			}
		}

		public function removeTimer():void {
			if (TimeManager.getInstance().hasITick(updateTime)) {
				TimeManager.getInstance().removeITick(updateTime);
			}
		}

		public function addTimer():void {
			if (!TimeManager.getInstance().hasITick(updateTime)) {
				TimeManager.getInstance().addITick(1000, updateTime);
			}
		}

		protected function updateTime():void {
			var addTime:uint=(getTimer() - tick) / 1000;
			var olt:uint=onlineTime + addTime;
			var hours:int=olt / 60 / 60;
			var minutes:int=olt / 60 % 60;
			var seconds:int=olt % 60;
			hoursLbl.text=StringUtil_II.lpad(hours + "", 2, "0");
			minutesLbl.text=StringUtil_II.lpad(minutes + "", 2, "0");
			secondsLbl.text=StringUtil_II.lpad(seconds + "", 2, "0");
			var hReward:Boolean=false;
			for (var n:int=0; n < RewardCount; n++) {
				var timeRender:WelfareTimeRender=timeRenders[n];
				timeRender.updateReceiveStatus(olt / 60);
				if (!hReward) {
					hReward=timeRender.receiveable(olt / 60);
				}
			}
			receiveBtn.setActive(hReward, 1, true);
		}

		public function hasReward():Boolean {
			var addTime:uint=(getTimer() - tick) / 1000;
			var olt:uint=onlineTime + addTime;
			for (var n:int=0; n < RewardCount; n++) {
				var timeRender:WelfareTimeRender=timeRenders[n];
				if (timeRender.receiveable(olt / 60)) {
					return true;
				}
			}
			return false;
		}
	}
}

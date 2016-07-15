package com.leyou.ui.sfirstPay {
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.TimeManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.util.DateUtil;
	import com.leyou.utils.PayUtil;
	import com.leyou.utils.PropUtils;

	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.utils.getTimer;

	public class SuperFirstPayWnd extends AutoWindow {
		private var payLbl:Label;

		private var returnLbl:Label;

		private var status:int;

		private var timeLbl:Label;

		private var remian:int;

		private var tick:uint;

		private var df:TextFormat;

		private var payBtn:ImgButton;

		public function SuperFirstPayWnd() {
			super(LibManager.getInstance().getXML("config/ui/czfzWnd.xml"));
			init();
		}

		private function init():void {
			payLbl=getUIbyID("payLbl") as Label;
			returnLbl=getUIbyID("returnLbl") as Label;
			timeLbl=getUIbyID("timeLbl") as Label;
			payBtn=getUIbyID("payBtn") as ImgButton;
			hideBg();

//			clsBtn.x += 4;
			clsBtn.y += 30;
			df=payLbl.getTextFormat();
			df.leading=6;
			payLbl.defaultTextFormat=df;
			returnLbl.defaultTextFormat=df;
			initPayInfo();

			payBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
		}

		private function initPayInfo():void {
			var config:String;
			if (DataManager.getInstance().serverData.isOpening()) {
				config=ConfigEnum.ReturnCash1;
			} else {
				config=ConfigEnum.ReturnCash4;
			}
			var payList:Array=config.split("|");
			var payStr:String="";
			var retutrnStr:String="";
			for each (var str:String in payList) {
				var data:Array=str.split(",");
				if ("-1" == data[1]) {
					payStr+=StringUtil.substitute(PropUtils.getStringById(1814) + "\n", data[0]);
				} else {
					payStr+=StringUtil.substitute(PropUtils.getStringById(1815) + "\n", data[0], data[1]);
				}
				retutrnStr+=StringUtil.substitute(PropUtils.getStringById(1816) + "\n", data[2]);
			}
			var reg:RegExp=/-\d+/g;
			payStr=payStr.replace(reg, "");
			payLbl.text=payStr;
			returnLbl.text=retutrnStr;
		}

		protected function onBtnClick(event:MouseEvent):void {
			PayUtil.openPayUrl();
		}

		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
			if (!TimeManager.getInstance().hasITick(updateTime)) {
				TimeManager.getInstance().addITick(1000, updateTime);
			}
		}

		public override function hide():void {
			super.hide();
			if (TimeManager.getInstance().hasITick(updateTime)) {
				TimeManager.getInstance().removeITick(updateTime);
			}
		}

		private function updateTime():void {
			var r:int=remian - ((getTimer() - tick) / 1000);
			timeLbl.text=DateUtil.formatTime(r * 1000, 2);
		}

		public function updateInfo(obj:Object):void {
			remian=obj.stime; // 活动剩余时间
			status=obj.ast; // 奖励状态
			tick=getTimer();
			updateTime();
		}
	}
}

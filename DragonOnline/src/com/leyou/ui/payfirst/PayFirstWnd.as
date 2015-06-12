package com.leyou.ui.payfirst {
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.TimeManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_FCZ;
	import com.leyou.util.DateUtil;
	import com.leyou.utils.PayUtil;
	import com.leyou.utils.PropUtils;

	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.utils.getTimer;

	public class PayFirstWnd extends AutoWindow {
//		private var flagBtn:ImgButton;

		private var payLbl:Label;

		private var returnLbl:Label;

		private var status:int;

//		private var payRender:PayFirstRender;

		private var timeLbl:Label;

		private var remian:int;

		private var tick:uint;

		private var df:TextFormat;

		private var rpayLbl:Label;

		private var rreturnLbl:Label;

		private var returnRateLbl:Label;

		private var bgImg:Image;

		public function PayFirstWnd() {
			super(LibManager.getInstance().getXML("config/ui/firstpay/kffzWnd.xml"));
			init();
		}

		private function init():void {
//			flagBtn = getUIbyID("flagBtn") as ImgButton;
			bgImg=getUIbyID("bgImg") as Image;
			payLbl=getUIbyID("payLbl") as Label;
			returnLbl=getUIbyID("returnLbl") as Label;
			timeLbl=getUIbyID("timeLbl") as Label;
			rpayLbl=getUIbyID("rpayLbl") as Label;
			rreturnLbl=getUIbyID("rreturnLbl") as Label;
			returnRateLbl=getUIbyID("returnRateLbl") as Label;
//			flagBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
//			payRender = new PayFirstRender();
//			addChild(payRender);
//			payRender.x = 52;
//			payRender.y = 376;
			hideBg();
//			if(!Core.PAY_OPEN){
//				flagBtn.setActive(false, 1, true);
//			}else{
//				flagBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
//			}
			clsBtn.x+=4;
			clsBtn.y+=15;
			df=payLbl.getTextFormat();
			df.leading=10;
			payLbl.defaultTextFormat=df;
			returnLbl.defaultTextFormat=df;
			initPayInfo();

			var type:int=DataManager.getInstance().serverData.status;
			if (1 == type) {
				bgImg.updateBmp("ui/ttsc/kffz.png");
			} else if (2 == type) {
				bgImg.updateBmp("ui/ttsc/kffz_he.png");
			}
		}

		private function initPayInfo():void {
			var config:String=ConfigEnum.payReward3;
			var payList:Array=config.split("|");
			var payStr:String="";
			var retutrnStr:String="";
			for each (var str:String in payList) {
				var data:Array=str.split(",");
				if ("-1" == data[1]) {
					payStr+=StringUtil.substitute(PropUtils.getStringById(1814) + "\n", data[0]);
				} else {
					payStr+=StringUtil.substitute(PropUtils.getStringById(1815)+"\n", data[0], data[1]);
				}
				retutrnStr+=StringUtil.substitute(PropUtils.getStringById(1816)+"\n", data[2]);
			}
			payLbl.text=payStr;
			returnLbl.text=retutrnStr;
		}

		protected function onBtnClick(event:MouseEvent):void {
			switch (status) {
				case 0:
					PayUtil.openPayUrl();
					break;
				case 1:
					Cmd_FCZ.cm_FCZ_J();
					break;
				case 3:
					break;
			}
		}

		public override function get height():Number {
			return 565;
		}

//		public function switchToType(type:int):void{
//			if(1 == type){
//				bgImg.updateBmp("ui/ttsc/kffz.png");
//			}else if(2 == type){
//				bgImg.updateBmp("ui/ttsc/kffz_he.png");
//			}
//		}

		public function updateInfo(obj:Object):void {
			var cz:int=obj.cz; // 第一笔充值金额
			var fz:int=obj.fz; // 第一笔返回金额
			remian=obj.stime; // 活动剩余时间
			status=obj.st; // 奖励状态
			rpayLbl.text=obj.cz;
			rreturnLbl.text=obj.fz;
			returnRateLbl.visible=false;
			var config:String=ConfigEnum.payReward3;
			var payList:Array=config.split("|");
			var payStr:String="";
			var retutrnStr:String="";
			for each (var str:String in payList) {
				var data:Array=str.split(",");
				if ((cz >= int(data[0])) && (("-1" == data[1]) || (cz <= int(data[1])))) {
					returnRateLbl.visible=true;
					returnRateLbl.text=StringUtil.substitute(PropUtils.getStringById(1817), data[2]);
				}
			}
//			payRender.visible = (0 != status);
//			payRender.updateInfo(cz, fz);
//			var vb:Boolean;
//			switch(status){
//				case 0:
//					vb = true;
//					flagBtn.updataBmd("ui/vip/btn_vip_cz.png");
//					break;
//				case 1:
//					vb = true;
//					flagBtn.updataBmd("ui/vip/btn_vip_lqjl.png");
//					break;
//				case 2:
//					flagBtn.updataBmd("ui/vip/btn_vip_lqjl.png");
//					vb = false;
//					break;
//			}
//			flagBtn.setActive(vb, 1, true);
			tick=getTimer();
			updateTime();
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

		public function flyItem():void {
		}
	}
}

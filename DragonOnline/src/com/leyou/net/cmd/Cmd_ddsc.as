package com.leyou.net.cmd {

	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;
	import com.leyou.ui.firstGift.FirstGiftWnd;


	public class Cmd_ddsc {


		public function Cmd_ddsc() {

		}

		/**
		 *ddsc
上行：ddsc|I
下行：ddsc|{"mk":"I", "jlist":[[item,num],...],"st":num}
jlist -- 奖励列表
st  -- 状态(0不可领取,1可领取,2已领取)
* @param o
   *
		   */
		public static function sm_Ddsc_I(o:Object):void {
			
			MyInfoManager.getInstance().firstItem=o;

			if (!UIManager.getInstance().isCreate(WindowEnum.SELLEXPEFFECT)) {
				UIManager.getInstance().creatWindow(WindowEnum.SELLEXPEFFECT);
			}
			
			UIManager.getInstance().sellExpEffect.updateExp(o);

			// 首冲好礼
			var remianT:int=o.kf_stime;
			var isVip:Boolean=(int(o.vst) == 1);
			var isReceived:Boolean=(int(o.fst) == 2);
//			UIManager.getInstance().leftTopWnd.setFirstGift((remianT > 0) && !isReceived, remianT);
			if (UIManager.getInstance().isCreate(WindowEnum.FIRSTGIFT)) {
				(UIManager.getInstance().creatWindow(WindowEnum.FIRSTGIFT) as FirstGiftWnd).updateInfo(o);
			}
			if (remianT > 0 && !isReceived) {
				if (UIManager.getInstance().isCreate(WindowEnum.FIRSTGIFT) && isReceived) {
					UIManager.getInstance().firstGiftWnd.flyItem();
					return;
				}
				(UIManager.getInstance().creatWindow(WindowEnum.FIRSTGIFT) as FirstGiftWnd).updateInfo(o);
				return;
			} else if ((remianT > 0) && (remianT > 48 * 60 * 60)) {
				return;
			}

			if (UIManager.getInstance().isCreate(WindowEnum.FIRST_PAY)) {
				if (UIManager.getInstance().firstPay.flyItem()) {
//					UIManager.getInstance().rightTopWnd.deactive("areaFirstPayBtn");
					UIManager.getInstance().leftTopWnd.setFirstGift(false);
//					return;
				}
			}

			if (0 == o.vst || ((1 == o.vst) && (1 == o.fst))) {

//				UIManager.getInstance().rightTopWnd.active("areaFirstPayBtn");
				UIManager.getInstance().leftTopWnd.setFirstGift(true);

				if (!UIManager.getInstance().isCreate(WindowEnum.FIRST_PAY)) {
					UIManager.getInstance().creatWindow(WindowEnum.FIRST_PAY);
				}

				UIManager.getInstance().firstPay.updateInfo(o);

				UIManager.getInstance().adWnd.setStateVip((1 == o.vst));
				UIManager.getInstance().adWnd.setStateTtsc(true);

				if (UIManager.getInstance().isCreate(WindowEnum.MARKET)) {
					UIManager.getInstance().marketWnd.setADStateVip((1 == o.vst));
					UIManager.getInstance().marketWnd.setADStateTtsc(true);
				}
			} else {

				UIManager.getInstance().adWnd.setStateVip(true);

				if (UIManager.getInstance().isCreate(WindowEnum.MARKET)) {
					UIManager.getInstance().marketWnd.setADStateVip(true);
				}

//				UIManager.getInstance().rightTopWnd.deactive("areaFirstPayBtn");
				UIManager.getInstance().leftTopWnd.setFirstGift(false);


				if (!o.hasOwnProperty("jlist"))
					return;

				if (!UIManager.getInstance().isCreate(WindowEnum.TOPUP))
					UIManager.getInstance().creatWindow(WindowEnum.TOPUP);

				UIManager.getInstance().topUpWnd.updateInfo(o);

			}
		}

		public static function cm_DdscInit():void {
			NetGate.getInstance().send(CmdEnum.CM_DDSC_I);
		}

		public static function cm_DdscConfirm():void {
			NetGate.getInstance().send(CmdEnum.CM_DDSC_J);
		}

//		public static function cm_Ddsc_F():void{
//			NetGate.getInstance().send(CmdEnum.CM_DDSC_F);
//		}
	}
}

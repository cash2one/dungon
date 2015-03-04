package com.leyou.net.cmd {

	import com.ace.enum.WindowEnum;
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
			
			// 首冲好礼
			var remianT:int = o.kf_stime;
			var isVip:Boolean = (int(o.vst) == 1);
			var isReceived:Boolean = (int(o.fst) == 2);
			UIManager.getInstance().roleHeadWnd.setFirstGift((remianT > 0) && !isReceived);
			if(remianT > 0){
				if(UIManager.getInstance().isCreate(WindowEnum.FIRSTGIFT) && isReceived){
					UIManager.getInstance().firstGiftWnd.flyItem();
					return;
				}
				(UIManager.getInstance().creatWindow(WindowEnum.FIRSTGIFT) as FirstGiftWnd).updateInfo(o);
				return;
			}
			
			if (UIManager.getInstance().isCreate(WindowEnum.FIRST_PAY)) {
				if (UIManager.getInstance().firstPay.flyItem()) {
					UIManager.getInstance().rightTopWnd.deactive("areaFirstPayBtn");
					return;
				}
			}

			if (0 == o.vst || ((1 == o.vst) && (1 == o.fst))) {

				UIManager.getInstance().rightTopWnd.active("areaFirstPayBtn");

				if (!UIManager.getInstance().isCreate(WindowEnum.FIRST_PAY)) {
					UIManager.getInstance().creatWindow(WindowEnum.FIRST_PAY);
				}

				UIManager.getInstance().firstPay.updateInfo(o);

				UIManager.getInstance().adWnd.setStateVip((1 == o.vst));
				UIManager.getInstance().adWnd.setStateTtsc(true);
				
				if(UIManager.getInstance().isCreate(WindowEnum.MARKET)){
					UIManager.getInstance().marketWnd.setADStateVip((1 == o.vst));
					UIManager.getInstance().marketWnd.setADStateTtsc(true);
				}
			} else {
				
				UIManager.getInstance().adWnd.setStateVip(true);
				
				if(UIManager.getInstance().isCreate(WindowEnum.MARKET)){
					UIManager.getInstance().marketWnd.setADStateVip(true);
				}
				 			
				UIManager.getInstance().rightTopWnd.deactive("areaFirstPayBtn");

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

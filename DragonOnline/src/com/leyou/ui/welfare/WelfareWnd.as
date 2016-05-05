package com.leyou.ui.welfare {

	/**
	 * 福利系统界面
	 * @author wfh
	 *
	 */
	public class WelfareWnd extends WelfareView {

		public function WelfareWnd() {
		}

		public function getCost():int {
			return welfareLogin.bprice;
		}

		public function getSignCount():int {
			return welfareLogin.bc;
		}

		public function updateSign(obj:Object):void {
			loginRequest=true;
			welfareLogin.updateInfo(obj);
		}

		public function updateOL(obj:Object):void {
			timeRequest=true;
			welfareTime.updateInfo(obj);
		}

		public function receiveOLReward(obj:Object):void {
			welfareTime.receiveReward(obj);
		}

		public function updateLV(obj:Object):void {
			lvRequest=true;
			welfareLv.updateInfo(obj);
		}

		public function updateOFL(obj:Object):void {
			welfareOutline.updateInfo(obj);
		}

		public function flyItem(page:int, sign:int=0):void {
			switch (page) {
				case 1:
					welfareLogin.flyItem(sign);
					break;
				case 3:
					welfareLv.flyItem();
					break;
			}
		}

		public function updateFBK(obj:Object):void {
			welfareGetBack.updateInfo(obj);
		}
	}
}

package com.leyou.net.cmd {
	import com.ace.config.Core;
	import com.ace.enum.WindowEnum;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.greensock.TweenLite;
	import com.leyou.enum.CmdEnum;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.NetGate;

	public class Cmd_V3Exp {


		public static function smV3_T(o:Object):void {

			if (Core.me == null || ConfigEnum.V3exp37Open > Core.me.info.level) {
				return;
			}

//			UILayoutManager.getInstance().show(WindowEnum.VIP3EXP);

			if (o.jlst == 0) {
				UIManager.getInstance().rightTopWnd.active("v3expBtn");
			} else if (o.jlst == 1) {
				UIManager.getInstance().rightTopWnd.deactive("v3expBtn");

				if (UIManager.getInstance().isCreate(WindowEnum.FIRST_PAY))
					TweenLite.delayedCall(1, UIManager.getInstance().firstPay.hide);

				if (UIManager.getInstance().isCreate(WindowEnum.VIP3EXP)) {
					TweenLite.delayedCall(1, UIManager.getInstance().vip3exp.hide);
				}
			} else
				UILayoutManager.getInstance().open(WindowEnum.VIP3EXP);

			if (o.buffst == 1) {
				if (!UIManager.getInstance().isCreate(WindowEnum.VIP3EXP))
					UIManager.getInstance().creatWindow(WindowEnum.VIP3EXP);

				UIManager.getInstance().vip3exp.setNoGet();
			}
		}

		/**
		 *vip 体验
上行:vip|T
下行:vip|{"mk":T, "jlst":num}
jlst -- (0 可领取 1不可领取)
领取体验buff
上行:vip|B

*
*/
		public static function cmV3expBtn():void {
			NetGate.getInstance().send(CmdEnum.CM_V3_T);
		}

		public static function cmV3expGet():void {
			NetGate.getInstance().send(CmdEnum.CM_V3_B);
		}

	}
}

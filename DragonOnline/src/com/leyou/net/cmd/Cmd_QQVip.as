package com.leyou.net.cmd {
	import com.ace.config.Core;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.UIManager;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;
	import com.leyou.utils.PayUtil;
	import com.leyou.utils.PropUtils;

	import flash.external.ExternalInterface;
	import flash.system.Capabilities;

	public class Cmd_QQVip {
		// 新手礼包
		public static function sm_TX_N(obj:Object):void {
			DataManager.getInstance().qqvipData.loadData_N(obj);
			UIManager.getInstance().qqVipWnd.updateUI_N();
		}

		public static function cm_TX_N():void {
			NetGate.getInstance().send(CmdEnum.CM_TX_N);
		}

		public static function cm_TX_J():void {
			NetGate.getInstance().send(CmdEnum.CM_TX_J);
		}

		// 每日礼包
		public static function sm_TX_D(obj:Object):void {
			DataManager.getInstance().qqvipData.loadData_D(obj);
			UIManager.getInstance().qqVipWnd.updateUI_D();
		}

		public static function cm_TX_D():void {
			NetGate.getInstance().send(CmdEnum.CM_TX_D);
		}

		public static function cm_TX_X(type:int):void {
			NetGate.getInstance().send(CmdEnum.CM_TX_X + type);
		}

		// 升级礼包
		public static function sm_TX_L(obj:Object):void {
			DataManager.getInstance().qqvipData.loadData_L(obj);
			UIManager.getInstance().qqVipWnd.updateUI_L();
		}

		public static function cm_TX_L():void {
			NetGate.getInstance().send(CmdEnum.CM_TX_L);
		}

		public static function cm_TX_Y(level:int):void {
			NetGate.getInstance().send(CmdEnum.CM_TX_Y + level);
		}

		public static function sm_TX_B(obj:Object):void {
			var url:String=obj.rst;
			PayUtil.onBuyIB(url);
		}

		public static function cm_TX_B(type:int):void {
			var count:int=PayUtil.getCountByType(type);
			var goodsmeta:String=StringUtil.substitute(PropUtils.getStringById(1569), count, count);
			var goodsurl:String=PayUtil.getIconUrl(type);
			NetGate.getInstance().send(CmdEnum.CM_TX_B + count + "," + 1 + "," + goodsmeta + "," + goodsurl);
		}

		public static function sm_TX_H(obj:Object):void {
			var token:String=obj.token;
			var actid:String=obj.actid;
			var zoneid:String=obj.zoneid;
			var paytime:int=obj.paytime;
			PayUtil.onPayQQYellowVip(token, actid, zoneid, paytime);
		}

		public static function cm_TX_H(payTime:int):void {
			NetGate.getInstance().send(CmdEnum.CM_TX_H + payTime);
		}

		public static function sm_TX_R(obj:Object):void {
			if ("StandAlone" != Capabilities.playerType) {
				ExternalInterface.call("fusion2.dialog.relogin");
			}
		}

		public static function sm_TX_M(obj:Object):void {
			if (!Core.isTencent) {
				return;
			}
			var st:int=obj.s;
			DataManager.getInstance().qqvipData.actSt=st;
			if (0 == st) {
				UIManager.getInstance().rightTopWnd.active("qqYellowBtn");
			} else {
				UIManager.getInstance().rightTopWnd.deactive("qqYellowBtn");
			}
		}
	}
}

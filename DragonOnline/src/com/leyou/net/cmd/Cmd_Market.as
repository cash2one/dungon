package com.leyou.net.cmd {
	import com.ace.config.Core;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.greensock.TweenLite;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Market {
		public function Cmd_Market() {
		}

		/**
		 * <T>查询页面信息</T>
		 *
		 * @param type 页面类型
		 *
		 */
		public static function cm_Mak_I(type:int):void {
			NetGate.getInstance().send(CmdEnum.CM_MAK_I + type);
		}

		/**
		 * <T>查询折扣排名信息</T>
		 *
		 */
		public static function cm_Mak_L():void {
			NetGate.getInstance().send(CmdEnum.CM_MAK_L);
		}

		/**
		 * <T>申请折扣</T>
		 *
		 * @param itemId 申请物品编号
		 *
		 */
		public static function cm_Mak_A(type:int, itemId:uint):void {
			NetGate.getInstance().send(CmdEnum.CM_MAK_A + type + "," + itemId);
		}

		/**
		 * <T>购买商品</T>
		 * @param type   物品所在页面
		 * @param itemId 物品编号
		 * @param num    物品数量
		 *
		 */
		public static function cm_Mak_B(type:int, itemId:uint, num:int):void {
			NetGate.getInstance().send(CmdEnum.CM_MAK_B + type + "," + itemId + "," + num);
		}

		/**
		 * <T>快速购买查询</T>
		 */
		public static function cm_Mak_F(itemId1:uint, itemId2:uint):void {
			NetGate.getInstance().send(CmdEnum.CM_MAK_F + itemId1 + "," + itemId2);
		}

		/**
		 * <T>查询页面信息回应</T>
		 *
		 * @param o 数据
		 *
		 */
		public static function sm_Mak_I(o:Object):void {
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.MARKET, CmdEnum.SM_MAK_I);
			if (o.hasOwnProperty("list")) {
				UIManager.getInstance().marketWnd.onItemListResponse(o);
			}
		}

		/**
		 * <T>查询折扣排名信息回应</T>
		 *
		 * @param o 数据
		 *
		 */
		public static function sm_Mak_L(o:Object):void {
			if (o.hasOwnProperty("list")) {
//				UIManager.getInstance().marketWnd.onDiscountListResponse(o);
			}
		}

		/**
		 * 商城翅膀
		 *
		 * @param o
		 *
		 */
		public static function sm_Mak_W(o:Object):void {
//			if(null == Core.me){
//				throw new Error("角色尚未初始化");
//				return;
//			}
//			UIManager.getInstance().roleHeadWnd.updateWingInfo(o);
			UIManager.getInstance().leftTopWnd.updateWingInfo(o);
			if (UIManager.getInstance().marketWnd) {
				UIManager.getInstance().marketWnd.setWingInfo(o);
			}
		}

		public static function cm_Mak_W(type:int):void {
			NetGate.getInstance().send(CmdEnum.CM_MAK_W + type);
		}

		/**
		 * <T>申请折扣回应</T>
		 *
		 * @param o 数据
		 *
		 */
		public static function sm_Mak_A(o:Object):void {
			if (o.hasOwnProperty("one")) {
				UIManager.getInstance().marketWnd.onApplyDiscountResponse(o);
			}
		}

		/**
		 * <T>快速购买查询</T>
		 *
		 * @param o 数据
		 *
		 */
		public static function sm_Mak_F(o:Object):void {
			UIManager.getInstance().quickBuyWnd.loadItem(o);
		}

		public static function cm_Mak_G(bid:int, num:int):void {
			NetGate.getInstance().send(CmdEnum.CM_MAK_G + bid + "," + num);
		}

		/**
		 *数值不足
下行: mak|{"mk":"N", "ntype":str}
  ntype -- 类型
	money -- 金币
	  yb    -- 钻石
		byb   -- 绑钻
	  energy -- 魂力
		gx     -- 功勋
	  honour -- 荣誉

		   * @param o
		 *
		 */
		public static function sm_Mak_N(o:Object):void {

			if (MyInfoManager.getInstance().firstItem.fst == 0) {

				if (UIManager.getInstance().firstPay == null || !UIManager.getInstance().firstPay.visible) {
					UILayoutManager.getInstance().open(WindowEnum.FIRST_PAY);
				}

			} else if (MyInfoManager.getInstance().firstItem.st == 0){

				if (UIManager.getInstance().topUpWnd == null || !UIManager.getInstance().topUpWnd.visible) {
					UILayoutManager.getInstance().open_II(WindowEnum.TOPUP);
				}

			}

//			if (Core.me.info.level < 30)
//				return;
//
//			UILayoutManager.getInstance().show(WindowEnum.INTROWND);
//
//			TweenLite.delayedCall(0.6, function():void {
//				switch (o.ntype) {
//					case "money":
//						UIManager.getInstance().introWnd.setTabIndex(7);
//						break;
//					case "yb":
//						UIManager.getInstance().introWnd.setTabIndex(5);
//						break;
//					case "byb":
//						UIManager.getInstance().introWnd.setTabIndex(6);
//						break;
//					case "energy":
//						UIManager.getInstance().introWnd.setTabIndex(8);
//						break;
//					case "gx":
//						UIManager.getInstance().introWnd.setTabIndex(10);
//						break;
//					case "honour":
//						UIManager.getInstance().introWnd.setTabIndex(9);
//						break;
//				}
//			});

		}
	}
}

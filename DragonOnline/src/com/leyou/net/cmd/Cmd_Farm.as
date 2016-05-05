package com.leyou.net.cmd {
	import com.ace.enum.WindowEnum;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.CmdEnum;
	import com.leyou.enum.TaskEnum;
	import com.leyou.net.NetGate;
	import com.leyou.utils.PropUtils;

	public class Cmd_Farm {
		/**
		 * <T>农场信息回应</T>
		 *
		 */
		public static function sm_FAM_I(obj:Object):void {
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.FARM, CmdEnum.SM_FAM_I);
			UIManager.getInstance().creatWindow(WindowEnum.FARM_SHOP);
			UIManager.getInstance().creatWindow(WindowEnum.FARM_LOG);
			UIManager.getInstance().farmWnd.onFamInit(obj);
		}

		/**
		 * <T>请求农场信息</T>
		 * <P>默认查询自己</P>
		 *
		 */
		public static function cm_FAM_I(name:String=""):void {
			var str:String=("" == name) ? CmdEnum.CM_FAM_I : CmdEnum.CM_FAM_I + "," + name;
			NetGate.getInstance().send(str);
		}

		/**
		 * <T>神树等相关信息通知</T>
		 *
		 */
		public static function sm_FAM_T(obj:Object):void {
			UIManager.getInstance().farmWnd.updataT(obj);
		}

		/**
		 * <T>土地信息变更刷新</T>
		 *
		 */
		public static function sm_FAM_RS(obj:Object):void {
			if (UIManager.getInstance().isCreate(WindowEnum.FARM)) {
				if (UIManager.getInstance().farmWnd.visible) {
					UIManager.getInstance().farmWnd.updateFarmLand(obj);
				}
			}
		}

		/**
		 * <T>开启土地</T>
		 *
		 */
		public static function cm_FAM_O(landId:int, type:int):void {
			NetGate.getInstance().send(CmdEnum.CM_FAM_O + "," + landId + "," + type);
		}

		/**
		 * <T>土地升级</T>
		 *
		 */
		public static function cm_FAM_U(landId:int):void {
			NetGate.getInstance().send(CmdEnum.CM_FAM_U + "," + landId);
		}

		/**
		 * <T>刷新种子商店</T>
		 *
		 */
		public static function cm_FAM_F(currency:int):void {
			NetGate.getInstance().send(CmdEnum.CM_FAM_F+","+currency);
		}

		/**
		 * <T>手动刷新种子商店</T>
		 *
		 */
		public static function sm_FAM_F(obj:Object):void {
			if (UIManager.getInstance().isCreate(WindowEnum.FARM_SHOP)) {
				UIManager.getInstance().farmShopWnd.updataInfo(obj.ntb);
				UIManager.getInstance().farmShopWnd.updataVipInfo(obj.ytb);
				UIManager.getInstance().farmShopWnd.updataTime(obj.rt);
			}
		}

		/**
		 * <T>种植作物</T>
		 *
		 */
		public static function cm_FAM_G(landId:int, seedId:int):void {
			NetGate.getInstance().send(CmdEnum.CM_FAM_G + "," + landId + "," + seedId);
		}

		/**
		 * <T>作物加速</T>
		 *
		 */
		public static function cm_FAM_S(landId:int, currency:int):void {
			NetGate.getInstance().send(CmdEnum.CM_FAM_S + "," + currency + "," + landId);
		}

		/**
		 * <T>作物铲除</T>
		 *
		 */
		public static function cm_FAM_C(landId:int):void {
			NetGate.getInstance().send(CmdEnum.CM_FAM_C + "," + landId);
		}

		/**
		 * <T>作物收获</T>
		 *
		 */
		public static function cm_FAM_H(landId:String, friendName:String=""):void {
			var str:String=("" == friendName) ? CmdEnum.CM_FAM_H + "," + landId : CmdEnum.CM_FAM_H + "," + landId + "," + friendName;
			NetGate.getInstance().send(str);
		}

		/**
		 * <T>神树灌溉</T>
		 *
		 */
		public static function sm_FAM_W(obj:Object):void {
		}

		/**
		 * <T>神树灌溉</T>
		 *
		 */
		public static function cm_FAM_W(name:String=""):void {
			var str:String=("" == name) ? CmdEnum.CM_FAM_W : CmdEnum.CM_FAM_W + "," + name;
			NetGate.getInstance().send(str);
		}

		/**
		 * <T>刷新好友列表</T>
		 *
		 */
		public static function sm_FAM_P(obj:Object):void {
			UIManager.getInstance().farmWnd.updateFriends(obj);
		}

		/**
		 * 刷新好友
		 *
		 */
		public static function sm_FAM_US(obj:Object):void {
			UIManager.getInstance().farmWnd.updateFriend(obj);
		}

		/**
		 * 请求好友数据
		 *
		 * @params type 1--好友 2--帮众
		 * @params index 页面索引
		 */
		public static function cm_FAM_P(type:int, index:int):void {
			NetGate.getInstance().send(CmdEnum.CM_FAM_P + "," + type + "," + index);
		}

		/**
		 * <T>宝箱奖励</T>
		 *
		 */
		public static function cm_FAM_R():void {
			NetGate.getInstance().send(CmdEnum.CM_FAM_R);
		}

		/**
		 * <T>日志</T>
		 *
		 */
		public static function cm_FAM_L():void {
			NetGate.getInstance().send(CmdEnum.CM_FAM_L);
		}

		/**
		 * <T>日志</T>
		 *
		 */
		public static function sm_FAM_L(obj:Object):void {
			UIManager.getInstance().farmLogWnd.initLog(obj);
		}

		/**
		 * <T>批量收获协议</T>
		 *
		 */
		public static function cm_FAM_A():void {
			NetGate.getInstance().send(CmdEnum.CM_FAM_A);
		}

		/**
		 * <T>收益提示</T>
		 *
		 */
		public static function sm_FAM_SN(obj:Object):void {
			UIManager.getInstance().farmWnd.onSystemNotice(obj);
		}

		public static function callBack(type:String):void {
			UIOpenBufferManager.getInstance().open(WindowEnum.FARM);
		}

		public static function sm_FAM_UT(obj:Object):void {
			var rt:int=obj.rt;
			var status:int=obj.st;
			var fc1:String=PropUtils.getStringById(1556) + "<font color='#ff00'><u><a href='event:other_farm--farm'>{1}</a></u></font>";
			var fc2:String=PropUtils.getStringById(1557) + "<font color='#ff00'><u><a href='event:other_farm--farm'>{1}</a></u></font>";
			var fc3:String=PropUtils.getStringById(1558) + "<font color='#ff00'><u><a href='event:other_farm--farm'>{1}</a></u></font>";

			// 0--可种植 1--成长中 2--可收获
			if (0 == rt) {
				fc3=StringUtil.substitute(fc3, PropUtils.getStringById(1559));
			} else if (1 == rt) {
				fc3=StringUtil.substitute(fc3, PropUtils.getStringById(1560));
			} else {
				fc3=StringUtil.substitute(fc3, PropUtils.getStringById(1561));
			}

			if (2 == status) {
				fc1=StringUtil.substitute(fc2, PropUtils.getStringById(1562));
			} else if (1 == status) {
				fc1=StringUtil.substitute(fc1, PropUtils.getStringById(1563));
			} else {
				fc1=StringUtil.substitute(fc1, PropUtils.getStringById(1564));
			}

			var arr:Array=[PropUtils.getStringById(1564), fc1, fc3, "", callBack];
//			UIManager.getInstance().taskTrack.updateOtherTrack(TaskEnum.taskLevel_farmLine, arr);
		}
	}
}

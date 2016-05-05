package com.leyou.net.cmd {
	import com.ace.config.Core;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Across {
		public static function sm_ACROSS_I(obj:Object):void {
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.CROSS_SERVER, CmdEnum.SM_ACROSS_I);
			DataManager.getInstance().crossServerData.loadData_I(obj);
			if (UIManager.getInstance().isCreate(WindowEnum.CROSS_SERVER)) {
				UIManager.getInstance().crossServerWnd.setMoudle(DataManager.getInstance().crossServerData.isOpen() || Core.isTaiwan);
				UIManager.getInstance().crossServerWnd.updateServerLvPage();
				UIManager.getInstance().crossServerWnd.updateServerCarPage();
			}
		}

		public static function cm_ACROSS_I():void {
			NetGate.getInstance().send(CmdEnum.CM_ACROSS_I);
		}

		public static function sm_ACROSS_T(obj:Object):void {
			DataManager.getInstance().crossServerData.loadData_T(obj);
			if (UIManager.getInstance().isCreate(WindowEnum.CROSS_SERVER)) {
				UIManager.getInstance().crossServerWnd.updateServerTaskPage();
				UIManager.getInstance().crossServerWnd.updateServerCarPage();
			}

			if (DataManager.getInstance().crossServerData.st && (Core.me.info.level >= ConfigEnum.multiple4)) {
				if (Core.isTaiwan) {
					UIManager.getInstance().rightTopWnd.active("crossServerBtn");
				}
				UIManager.getInstance().taskTrack.setSoulContainerAddOther(UIManager.getInstance().crossServerMissionTrack);
				UIManager.getInstance().crossServerMissionTrack.updateInfo();
				UIManager.getInstance().crossServerSceneTrack.updateInfo();
			} else {
				if (Core.isTaiwan) {
					UIManager.getInstance().rightTopWnd.deactive("crossServerBtn");
				}
				UIManager.getInstance().taskTrack.setSoulContainerRemoveOther(UIManager.getInstance().crossServerMissionTrack);
			}
		}

		public static function sm_ACROSS_S(obj:Object):void {
			DataManager.getInstance().crossServerData.loadData_S(obj);
			if (UIManager.getInstance().isCreate(WindowEnum.CROSS_SERVER)) {
				UIManager.getInstance().crossServerWnd.updateServerTaskPage();
				UIManager.getInstance().crossServerWnd.updateServerCarPage();
			}

			if (DataManager.getInstance().crossServerData.st && (Core.me.info.level >= ConfigEnum.multiple4)) {
				if (Core.isTaiwan) {
					UIManager.getInstance().rightTopWnd.active("crossServerBtn");
				}
				UIManager.getInstance().taskTrack.setSoulContainerAddOther(UIManager.getInstance().crossServerMissionTrack);
				UIManager.getInstance().crossServerMissionTrack.updateInfo();
				UIManager.getInstance().crossServerSceneTrack.updateInfo();
			} else {
				if (Core.isTaiwan) {
					UIManager.getInstance().rightTopWnd.deactive("crossServerBtn");
				}
				UIManager.getInstance().taskTrack.setSoulContainerRemoveOther(UIManager.getInstance().crossServerMissionTrack);
			}
		}

		public static function cm_ACROSS_T():void {
			NetGate.getInstance().send(CmdEnum.CM_ACROSS_T);
		}

		public static function sm_ACROSS_L(obj:Object):void {
			DataManager.getInstance().crossServerData.loadData_L(obj);
			UIManager.getInstance().crossServerMissionRank.updateInfo();
		}

		public static function sm_ACROSS_G(obj:Object):void {
			DataManager.getInstance().crossServerData.loadData_G(obj);
		}

		public static function cm_ACROSS_L():void {
			NetGate.getInstance().send(CmdEnum.CM_ACROSS_R);
		}

		public static function cm_ACROSS_U():void {
			NetGate.getInstance().send(CmdEnum.CM_ACROSS_U);
		}

		private static var gogogo:Function;

		public static function sm_ACROSS_Y(obj:Object):void {
			var roomid:int=obj.roomid;
			var tx:int=obj.x;
			var ty:int=obj.y;
			if (null != gogogo) {
				gogogo(roomid, tx, ty);
			}
		}

		public static function cm_ACROSS_Y(fun:Function):void {
			gogogo=fun;
			NetGate.getInstance().send(CmdEnum.CM_ACROSS_Y);
		}

		public static function cm_ACROSS_N(name:String):void {
			NetGate.getInstance().send(CmdEnum.CM_ACROSS_N + name);
		}

		public static function cm_ACROSS_D(type:int, num:int):void {
			NetGate.getInstance().send(CmdEnum.CM_ACROSS_D + type + "," + num);
		}

		public static function sm_ACROSS_K(obj:Object):void {
			DataManager.getInstance().crossServerData.loadData_K(obj);
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.CROSS_SERVER, CmdEnum.SM_ACROSS_K, !DataManager.getInstance().crossServerData.isOpen());
			if (UIManager.getInstance().isCreate(WindowEnum.CROSS_SERVER)) {
				UIManager.getInstance().crossServerWnd.setMoudle(DataManager.getInstance().crossServerData.isOpen() || Core.isTaiwan);
				if (DataManager.getInstance().crossServerData.isOpen()) {
					UIOpenBufferManager.getInstance().open(WindowEnum.CROSS_SERVER);
				} else {
					UIManager.getInstance().crossServerWnd.updateServerOpenPage();
				}
			}
		}

		public static function cm_ACROSS_K():void {
			NetGate.getInstance().send(CmdEnum.CM_ACROSS_K);
		}

		public static function cm_ACROSS_J(type:int, num:int):void {
			NetGate.getInstance().send(CmdEnum.CM_ACROSS_J + type + "," + num);
		}

		public static function cm_ACROSS_B(name:String):void {
			NetGate.getInstance().send(CmdEnum.CM_ACROSS_B + name);
		}

		public static function cm_ACROSS_A():void {
			NetGate.getInstance().send(CmdEnum.CM_ACROSS_A);
		}

	}
}

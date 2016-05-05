package com.leyou.net.cmd {
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Longz {

		public static function cm_Longz_I():void {
			NetGate.getInstance().send(CmdEnum.CM_LONGZ_I);
		}

		public static function sm_Longz_I(obj:Object):void {
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.DRAGON_BALL, CmdEnum.SM_LONGZ_I);
			DataManager.getInstance().dragonBallData.loadData_I(obj);
			UIManager.getInstance().dragonBallWnd.updateCollectionPage();
		}

		//		public static function cm_Longz_F():void{
		//			NetGate.getInstance().send(CmdEnum.CM_LONGZ_F);
		//		}

		public static function sm_Longz_W(obj:Object):void {
			UIManager.getInstance().dragonBallWnd.flyReward();
		}

		public static function cm_Longz_W(index:int):void {
			NetGate.getInstance().send(CmdEnum.CM_LONGZ_W + index);
		}

		public static function cm_Longz_C():void {
			NetGate.getInstance().send(CmdEnum.CM_LONGZ_C);
		}

		public static function sm_Longz_C(obj:Object):void {
			DataManager.getInstance().dragonBallData.loadData_C(obj);
			UIManager.getInstance().dragonBallWnd.updateCopyPage();
		}

		public static function cm_Longz_E(id:int, etype:int):void {
			NetGate.getInstance().send(CmdEnum.CM_LONGZ_E + id + "," + etype);
		}

		public static function cm_Longz_L():void {
			NetGate.getInstance().send(CmdEnum.CM_LONGZ_L);
		}

		public static function sm_Longz_T(obj:Object):void {
			if (!UIManager.getInstance().isCreate(WindowEnum.COPYTRACK)) {
				UIManager.getInstance().creatWindow(WindowEnum.COPYTRACK);
			}
			UIManager.getInstance().copyTrack.updateInfo(obj, 1);
		}

		/**
		 *龙珠魔核信息
		 上行:longz|D
		 下行:longz|{"mk":"D","dlist":[[itemid,num],[itemid,num]...], }
		 dlist  -- 已使用的魔核信息列表
		 itemid -- 魔核道具id
		 num    -- 已使用数量
		 *
		 */
		public static function cm_Longz_D():void {
			NetGate.getInstance().send(CmdEnum.CM_LONGZ_D);
		}

		public static function sm_Longz_D(o:Object):void {
			UIManager.getInstance().creatWindow(WindowEnum.MEDIC);
			UIManager.getInstance().medicWnd.updateInfo(o);
		}

		public static function cm_Longz_A(lid:int=1):void {
			NetGate.getInstance().send(CmdEnum.CM_LONGZ_A + lid);
		}

		public static function sm_Longz_A(obj:Object):void {
			DataManager.getInstance().dragonBallData.loadData_A(obj);
			if (1 == DataManager.getInstance().dragonBallData.rid) {
				UIManager.getInstance().dragonBallWnd.updateCollectionReward();
			} else {
				UIManager.getInstance().dragonBallWnd.updateRewardItem();
			}
		}

		public static function cm_Longz_H(name:String):void {
			NetGate.getInstance().send(CmdEnum.CM_LONGZ_H + name);
		}

		public static function sm_Longz_H(obj:Object):void {
			
//			UIManager.getInstance().dragonBallWnd.updateProperty();
			if (MyInfoManager.getInstance().name == obj.name){
				DataManager.getInstance().dragonBallData.loadData_H(obj);
				UIManager.getInstance().roleWnd.dragonBall.updateInfo();
			}else{
				DataManager.getInstance().dragonBallDataII.loadData_H(obj);
				UIManager.getInstance().otherPlayerWnd.dragonBall.updateInfo();
			}
		}

		public static function cm_Longz_P(pid:int, num:int, isRefresh:int=0):void {
			NetGate.getInstance().send(CmdEnum.CM_LONGZ_P + pid + "," + num + "," + isRefresh);
		}

		public static function cm_Longz_Z():void {
			NetGate.getInstance().send(CmdEnum.CM_LONGZ_Z);
		}
	}
}

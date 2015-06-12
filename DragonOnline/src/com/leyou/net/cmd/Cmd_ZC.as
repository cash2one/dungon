package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_ZC
	{
		// 中场休息
		public static function sm_ZC_C(obj:Object):void{
			DataManager.getInstance().iceBattleData.loadData_C(obj);
			UIManager.getInstance().showWindow(WindowEnum.ICE_BATTLE_PAUSE);
			UIManager.getInstance().iceBattlefieldPause.updateInfo();
		}
		
		public static function sm_ZC_L(obj:Object):void{
			DataManager.getInstance().iceBattleData.loadData_L(obj);
			UIManager.getInstance().iceBattlefieldReward.updateInfo();
		}
		
		public static function sm_ZC_N(obj:Object):void{
			DataManager.getInstance().iceBattleData.loadData_N(obj);
			UILayoutManager.getInstance().show(WindowEnum.ICE_BATTLE_END);
			UIManager.getInstance().iceBattlefieldEnd.updateInfo();		}
		
		public static function sm_ZC_U(obj:Object):void{
			DataManager.getInstance().iceBattleData.loadData_U(obj);
			if(!UIManager.getInstance().isCreate(WindowEnum.ICE_BATTLE_TRACK)){
				UIManager.getInstance().creatWindow(WindowEnum.ICE_BATTLE_TRACK);
			}
			if(!UIManager.getInstance().iceBattlefieldTrack.visible){
				UIManager.getInstance().iceBattlefieldTrack.show();
			}
			UIManager.getInstance().iceBattlefieldTrack.updateInfo();
		}
		
		public static function cm_ZC_L(begin:int, end:int):void{
			NetGate.getInstance().send(CmdEnum.CM_ZC_L + begin + "," + end);
		}
		
		public static function cm_ZC_E():void{
			NetGate.getInstance().send(CmdEnum.CM_ZC_E);
		}
		
		public static function cm_ZC_Q():void{
			NetGate.getInstance().send(CmdEnum.CM_ZC_Q);
		}
		
		public static function cm_ZC_B():void{
			NetGate.getInstance().send(CmdEnum.CM_ZC_B);
		}
		
		public static function sm_ZC_B(obj:Object):void{
			UIManager.getInstance().iceBattlefieldTrack.showbuff(obj.buffid);
		}
		
		public static function cm_ZC_I():void{
			NetGate.getInstance().send(CmdEnum.CM_ZC_I);
		}
		
		public static function sm_ZC_I(obj:Object):void{
			DataManager.getInstance().iceBattleData.loadData_I(obj);
			UIManager.getInstance().guildBattleWnd.updateIceBattleInfo();
		}
		
		public static function cm_ZC_H(type:int):void{
			NetGate.getInstance().send(CmdEnum.CM_ZC_H+type);
		}
		
		public static function sm_ZC_H(obj:Object):void{
			DataManager.getInstance().iceBattleData.loadData_H(obj);
			UIManager.getInstance().warLogWnd.updateInfo();
		}
	}
}
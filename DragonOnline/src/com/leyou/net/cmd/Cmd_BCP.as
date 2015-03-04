package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_BCP
	{
		/**
		 * <T>boss副本协议初始化</T>
		 * 
		 * @param obj 数据
		 * 
		 */		
		public static function sm_BCP_I(obj:Object):void{
//			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.BOSSCOPY, CmdEnum.SM_BCP_I);
//			UIManager.getInstance().bossCpyWnd.loadCopy(obj);
			DataManager.getInstance().bossCopyData.loadData_I(obj);
			UIManager.getInstance().bossWnd.updateCopyBoss();
		}
		
		/**
		 * <T>boss副本协议初始化</T>
		 * 
		 */	
		public static function cm_BCP_I():void{
			NetGate.getInstance().send(CmdEnum.CM_BCP_I);
		}
		
		/**
		 * <T>增加挑战上限次数</T>
		 * 
		 * @param obj 数据
		 * 
		 */		
		public static function sm_BCP_A(obj:Object):void{
			DataManager.getInstance().bossCopyData.loadData_A(obj);
			UIManager.getInstance().bossWnd.updateChallengeCount();
//			UIManager.getInstance().bossCpyWnd.updateChallengeCount(obj);
		}
		
		/**
		 * <T>增加挑战上限次数</T>
		 * 
		 * @param bossId BOSS编号
		 * 
		 */
		public static function cm_BCP_A():void{
			NetGate.getInstance().send(CmdEnum.CM_BCP_A);
		}
		
		public static function cm_BCP_B():void{
			NetGate.getInstance().send(CmdEnum.CM_BCP_B);
		}
		
		/**
		 * <T>挑战BOSS</T>
		 * 
		 * @param bossId BOSS编号
		 * 
		 */		
		public static function cm_BCP_E(copyId:int):void{
			NetGate.getInstance().send(CmdEnum.CM_BCP_E+copyId);
		}
		
		/**
		 * <T>追踪信息</T>
		 * 
		 * @param obj 信息
		 * 
		 */		
		public static function sm_BCP_T(obj:Object):void{
			if(!UIManager.getInstance().isCreate(WindowEnum.COPYTRACK)){
				UIManager.getInstance().creatWindow(WindowEnum.COPYTRACK)
			}
			UIManager.getInstance().copyTrack.updateInfo(obj, 1);
		}
		
		/**
		 * <T>副本首次击杀奖励</T>
		 * 
		 */		
		public static function sm_BCP_R(obj:Object):void{
			if(!UIManager.getInstance().isCreate(WindowEnum.BOSSCOPY_REWARD)){
				UIManager.getInstance().creatWindow(WindowEnum.BOSSCOPY_REWARD);
			}
			UIManager.getInstance().bossCopyReward.updateInfo(obj);
		}
		
		/**
		 * <T>离开副本</T>
		 * 
		 */		
		public static function cm_BCP_L():void{
			NetGate.getInstance().send(CmdEnum.CM_BCP_L);
		}
		
		/**
		 * <T>关闭面板</T>
		 * 
		 * @param obj 信息
		 * 
		 */		
		public static function sm_BCP_X(obj:Object):void{
//			UIManager.getInstance().copyTrack.hide();
//			UIManager.getInstance().taskTrack.show();
//			UIManager.getInstance().rightTopWnd.show();
		}
	}
}
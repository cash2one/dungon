package com.leyou.net.cmd
{
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;
	import com.leyou.ui.copyTrack.StoryCopyTrackBar;

	public class Cmd_SCP
	{
		/**
		 * <T>副本查询</T>
		 * 
		 */
		public static function cm_SCP_I():void{
			NetGate.getInstance().send(CmdEnum.CM_SCP_I);
		}
		
		/**
		 * <T>进入副本</T>
		 * 
		 * @param copyId 副本编号
		 * 
		 */	
		public static function cm_SCP_E(copyId:int):void{
			NetGate.getInstance().send(CmdEnum.CM_SCP_E+copyId);
		}
		
		/**
		 * <T>离开副本</T>
		 * 
		 */
		public static function cm_SCP_L():void{
			NetGate.getInstance().send(CmdEnum.CM_SCP_L);
		}
			
		/**
		 * <T>扫荡副本</T>
		 * 
		 * @param copyId 副本id
		 * 
		 */		
		public static function cm_SCP_A(copyId:int):void{
			NetGate.getInstance().send(CmdEnum.CM_SCP_A+copyId);
		}
		
		/**
		 * <T>扫荡加速</T>
		 * 
		 */		
		public static function cm_SCP_C(copyId:int):void{
			NetGate.getInstance().send(CmdEnum.CM_SCP_C+copyId);
		}
		
		/**
		 * <T>扫荡加速</T>
		 * 
		 */		
		public static function cm_SCP_J(copyId:int):void{
			NetGate.getInstance().send(CmdEnum.CM_SCP_J+copyId);
		}
		
		/**
		 * <T>副本查询</T>
		 * 
		 * @param obj 玩家副本信息
		 * 
		 */		
		public static function sm_SCP_I(obj:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.STORYCOPY, CmdEnum.SM_SCP_I);
			if(!UIManager.getInstance().isCreate(WindowEnum.STORYCOPY)){
				UIManager.getInstance().creatWindow(WindowEnum.STORYCOPY);
			}
			UIManager.getInstance().storyCopyWnd.loadCopy(obj);
		}
		
		/**
		 * <T>副本目标信息</T>
		 * 
		 */		
		public static function sm_SCP_T(obj:Object):void{
			if(!UIManager.getInstance().isCreate(WindowEnum.COPYTRACK)){
				UIManager.getInstance().creatWindow(WindowEnum.COPYTRACK);
			}
			UIManager.getInstance().copyTrack.updateInfo(obj, 0);
		}
		
		/**
		 * <T>关闭面板</T>
		 * 
		 */		
		public static function sm_SCP_X(obj:Object):void{
//			UIManager.getInstance().copyTrack.hide();
//			UIManager.getInstance().taskTrack.show();
//			UIManager.getInstance().rightTopWnd.show();
		}
		
		/**
		 * <T>副本奖励</T>
		 * 
		 */		
		public static function sm_SCP_R(obj:Object):void{
			if(!UIManager.getInstance().isCreate(WindowEnum.STORYCOPY_REWARD)){
				UIManager.getInstance().creatWindow(WindowEnum.STORYCOPY_REWARD)
			}
			var copyTrack:StoryCopyTrackBar = UIManager.getInstance().copyTrack;
			if(copyTrack && copyTrack.visible){
				UIManager.getInstance().showWindow(WindowEnum.STORYCOPY_REWARD, true, UIEnum.WND_LAYER_TOP);
			}else{
				UIManager.getInstance().showWindow(WindowEnum.STORYCOPY_REWARD);
			}
			UIManager.getInstance().storyCopyReward.updateInfo(obj);
		}
		
		/**
		 * <T>领取奖励</T>
		 * 
		 * @param copyId 副本id
		 * 
		 */		
		public static function cm_SCP_R(copyId:int):void{
			NetGate.getInstance().send(CmdEnum.CM_SCP_R+copyId);
		}
		
		/**
		 * <T>副本更新</T>
		 * 
		 * @param obj 副本信息
		 * 
		 */		
		public static function sm_SCP_U(obj:Object):void{
			if(UIManager.getInstance().isCreate(WindowEnum.STORYCOPY)){
				UIManager.getInstance().storyCopyWnd.updateInfo(obj);
			}
		}
	}
}
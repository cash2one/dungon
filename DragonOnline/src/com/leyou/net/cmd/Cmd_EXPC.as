package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_EXPC
	{
		/**
		 * <T>更新经验副本追踪信息</T>
		 * 
		 */		
		public static function sm_Exp_T(obj:Object):void{
			if(!UIManager.getInstance().isCreate(WindowEnum.EXP_COPY_TRACK)){
				UIManager.getInstance().creatWindow(WindowEnum.EXP_COPY_TRACK);
			}
			UIManager.getInstance().expCopyTrack.updateInfo(obj);
		}
		
		/**
		 * <T>经验副本追踪关闭</T>
		 * 
		 */		
		public static function sm_Exp_X(obj:Object):void{
//			UIManager.getInstance().expCopyTrack.hide();
//			UIManager.getInstance().taskTrack.show();
//			UIManager.getInstance().rightTopWnd.show();
		}
		
		/**
		 * 经验副本信息查询
		 * 
		 * @param obj 数据
		 * 
		 */		
		public static function sm_Exp_I(obj:Object):void{
//			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.EXPCOPY, CmdEnum.SM_EXPC_I);
//			UIManager.getInstance().expCopyWnd.updateCopy(obj);
		}
		
		/**
		 * 查询副本信息
		 * 
		 */		
		public static function cm_Exp_I():void{
			NetGate.getInstance().send(CmdEnum.CM_EXPC_I);
		}
		
		/**
		 * 离开副本
		 * 
		 */		
		public static function cm_Exp_L():void{
			NetGate.getInstance().send(CmdEnum.CM_EXPC_L);
		}
		
		/**
		 * 进入副本
		 * 
		 */		
		public static function cm_Exp_E(type:int, pid:int):void{
			NetGate.getInstance().send(CmdEnum.CM_EXPC_E + type + "," + pid);
		}
		
		/**
		 * 购买双倍经验
		 * 
		 */		
		public static function cm_Exp_B():void{
			NetGate.getInstance().send(CmdEnum.CM_EXPC_B);
		}
	}
}
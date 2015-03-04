package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Invest
	{
		public static function cm_TZ_I():void{
			NetGate.getInstance().send(CmdEnum.CM_TZ_I);
		}
		
		public static function sm_TZ_I(obj:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.INVEST, CmdEnum.SM_TZ_I);
			DataManager.getInstance().investData.loadData_I(obj);
			UIManager.getInstance().investWnd.updateInfoTZ();
		}
		
		/**
		 * 投资
		 * 
		 * @param type 投资类型
		 * 
		 */		
		public static function cm_TZ_T(type:int):void{
			NetGate.getInstance().send(CmdEnum.CM_TZ_T+type);
		}
		
		/**
		 * 领取投资奖励结果
		 * 
		 * @param obj 数据
		 * 
		 */		
		public static function sm_TZ_J(obj:Object):void{
			UIManager.getInstance().investWnd.flyTZR();
		}
		
		/**
		 * 领取投资奖励
		 */		
		public static function cm_TZ_J():void{
			NetGate.getInstance().send(CmdEnum.CM_TZ_J);
		}
		
		/**
		 * 投资领奖记录
		 * 
		 * @param obj 数据
		 * 
		 */		
		public static function sm_TZ_L(obj:Object):void{
			DataManager.getInstance().investData.loadData_L(obj);
			if(UIManager.getInstance().isCreate(WindowEnum.INVEST) && UIManager.getInstance().investWnd.visible){
				UIManager.getInstance().investWnd.updateTZLog();
			}
		}
		
		/**
		 * 基金信息
		 * 
		 * @param obj 数据
		 * 
		 */		
		public static function cm_TZ_C():void{
			NetGate.getInstance().send(CmdEnum.CM_TZ_C);
		}
		
		/**
		 * 基金信息
		 * 
		 * @param obj 数据
		 * 
		 */		
		public static function sm_TZ_C(obj:Object):void{
			DataManager.getInstance().investData.loadData_C(obj);
			UIManager.getInstance().investWnd.updateInfoJJ();
		}
		
		/**
		 * 购买基金
		 */		
		public static function cm_TZ_Z():void{
			NetGate.getInstance().send(CmdEnum.CM_TZ_Z);
		}
		
		/**
		 * 领取基金奖励 
		 */		
		public static function cm_TZ_D():void{
			NetGate.getInstance().send(CmdEnum.CM_TZ_D);
		}
		
		public static function sm_TZ_D(obj:Object):void{
			UIManager.getInstance().investWnd.flyJJ(obj.jlist);
		}
	}
}
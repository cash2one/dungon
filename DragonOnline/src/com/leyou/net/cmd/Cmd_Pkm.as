package com.leyou.net.cmd
{
	import com.ace.manager.UIManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Pkm
	{
		public function Cmd_Pkm()
		{
		}
		
		/**
		 * <T>PK模式通知</T>
		 * <P>通知玩家拥有的PK模式</P>
		 * 
		 * @param obj 数据
		 * 
		 */		
		public static function sm_Pkm_L(obj:Object):void{
			UIManager.getInstance().roleHeadWnd.onPkmList(obj);
		}
		
		/**
		 * <T>切换PK模式请求</T>
		 * 
		 * @param mode pk模式
		 * 
		 */		
		public static function cm_Pkm_S(mode:int):void{
			NetGate.getInstance().send(CmdEnum.CM_PKM_S+mode);
		}
		
		/**
		 * <T>切换PK模式回应</T>
		 * 
		 * @param obj 数据
		 * 
		 */		
		public static function sm_Pkm_S(obj:Object):void{
			UIManager.getInstance().roleHeadWnd.onPkmSet(obj);
		}
	}
}
package com.leyou.net.cmd
{
	import com.ace.ui.setting.AssistWnd;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Assist
	{
		public function Cmd_Assist()
		{
		}
		
		/**
		 * <T>挂机配置查询请求</T>
		 * 
		 */		
		public static function cm_Ass_I():void{
			NetGate.getInstance().send(CmdEnum.CM_ASS_I);
		}
		
		/**
		 * <T>挂机配置查询回应</T>
		 * 
		 */		
		public static function sm_Ass_I(obj:Object):void{
			AssistWnd.getInstance().unserialize(obj);
		}
		
		/**
		 * <T>挂机配置保存通知</T>
		 * 
		 */		
		public static function cm_Ass_S(value:String):void{
			NetGate.getInstance().send(CmdEnum.CM_ASS_S+value);
		}
	}
}
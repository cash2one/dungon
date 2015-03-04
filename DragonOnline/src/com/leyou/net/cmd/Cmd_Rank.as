package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Rank
	{
		public static function sm_RAK_I(obj:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.RANK, CmdEnum.SM_RAK_I);
			UIManager.getInstance().rankWnd.updateInfo(obj);
		}
		
		public static function cm_RAK_I(type:int, value:int, begin:int, end:int):void{
			NetGate.getInstance().send(CmdEnum.CM_RAK_I+type+","+value+","+begin+","+end);
		}
		
		public static function sm_RAK_A(obj:Object):void{
			UIManager.getInstance().rankWnd.palyerInfo(obj);
		}
		
//		atype -- 动作类型 (0查看 1点赞 2鄙视)
		public static function cm_RAK_A(type:int, name:String):void{
			NetGate.getInstance().send(CmdEnum.CM_RAK_A+type+","+name);
		}
	}
}
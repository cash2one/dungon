package com.leyou.net.cmd
{
	import com.ace.enum.SceneEnum;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.notice.NoticeManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Duel
	{
		public static function cm_DUEL_T(name:String):void{
//			NoticeManager.getInstance().broadcastById(10000);
//			return;
			NetGate.getInstance().send(CmdEnum.CM_DUEL_T + name);
		}
		
		public static function cm_DUEL_R(name:String, type:int):void{
			NetGate.getInstance().send(CmdEnum.CM_DUEL_R + name + ","+type);
		}
		
		public static function cm_DUEL_L():void{
			NetGate.getInstance().send(CmdEnum.CM_DUEL_L);
		}
		
		public static function sm_DUEL_M(obj:Object):void{
			var remainT:int = obj.sec;
			NoticeManager.getInstance().countdown(3526, remainT);
		}
		
		public static function onQuit():void{
			if(SceneEnum.SCENE_TYPE_JDCJ == MapInfoManager.getInstance().type){
				cm_DUEL_L();
			}
		}
		
		public static function sm_DUEL_S(obj:Object):void{
			var result:int = obj.rst;
			UIManager.getInstance().duelResultWnd.show();
			UIManager.getInstance().duelResultWnd.updateInfo(result);
		}
	}
}
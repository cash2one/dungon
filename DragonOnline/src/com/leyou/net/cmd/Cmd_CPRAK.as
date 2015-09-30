package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_CPRAK
	{
		public static function sm_CPRAK_I(obj:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.COPY_RANK, CmdEnum.SM_CPRAK_I);
			DataManager.getInstance().copyRankData.loadData(obj);
			UIManager.getInstance().copyRankWnd.updateInfo();
			
		}
		
		public static function cm_CPRAK_I(type:int=1):void{
			NetGate.getInstance().send(CmdEnum.CM_CPRAK_I+type);
		}
	}
}
package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_PayRank
	{
		public static function sm_PayRank_I(obj:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.PAY_RANK, CmdEnum.SM_CRANK_I);
			DataManager.getInstance().payRankData.loadData_I(obj);
			if(UIManager.getInstance().isCreate(WindowEnum.PAY_RANK)){
				UIManager.getInstance().payRankWnd.updateInfo();
			}
		}
		
		public static function cm_PayRank_I(type:int, begin:int, end:int):void{
			NetGate.getInstance().send(CmdEnum.CM_CRANK_I+type+","+begin+","+end);
		}
		
		public static function sm_PayRank_A(obj:Object):void{
			var ast:int = obj.ast;
			if(0 == ast){
				UIManager.getInstance().rightTopWnd.deactive("payRankBtn");
			}else{
				UIManager.getInstance().rightTopWnd.active("payRankBtn");
				UIManager.getInstance().rightTopWnd.setTime("payRankBtn", obj.stime, "活动结束");
			}
		}
	}
}
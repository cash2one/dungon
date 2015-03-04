package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_GBUY
	{
		public static function sm_GBUY_I(obj:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.GROUP_BUY, CmdEnum.SM_GBUY_I);
			DataManager.getInstance().groupBuyData.loadData_I(obj);
			UIManager.getInstance().groupBuyWnd.updateInfo();
		}
		
		public static function cm_GBUY_I():void{
			NetGate.getInstance().send(CmdEnum.CM_GBUY_I);
		}
		
		public static function sm_GBUY_B(obj:Object):void{
			UIManager.getInstance().groupBuyWnd.flyGift(obj.gbuyid);
		}
		
		public static function cm_GBUY_B(id:int):void{
			NetGate.getInstance().send(CmdEnum.CM_GBUY_B+id);
		}
		
		public static function sm_GBUY_J(obj:Object):void{
			UIManager.getInstance().groupBuyWnd.flyGroupGift(obj.gbuyid, obj.jpeople);
		}
		
		public static function cm_GBUY_J(id:int, count:int):void{
			NetGate.getInstance().send(CmdEnum.CM_GBUY_J+id+","+count);
		}
	}
}
package com.leyou.net.cmd
{
	import com.ace.enum.FunOpenEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Vip
	{
		public static function sm_VIP_I(obj:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.VIP, CmdEnum.SM_VIP_I);
			DataManager.getInstance().vipData.unserialize(obj);
			if(UIManager.getInstance().vipWnd){
				UIManager.getInstance().vipWnd.updateReward();
			}
		}
		
		public static function cm_VIP_I():void{
			NetGate.getInstance().send(CmdEnum.CM_VIP_I);
		}
		
		public static function cm_VIP_J(lv:int):void{
			NetGate.getInstance().send(CmdEnum.CM_VIP_J + lv);
		}
		
		public static function sm_VIP_J(obj:Object):void{
			if(UIManager.getInstance().vipWnd){
				UIManager.getInstance().vipWnd.flyItem();
			}
		}
		
		public static function cm_VIP_S(show:int, lv:int):void{
			NetGate.getInstance().send(CmdEnum.CM_VIP_S + show + "," + lv);
		}
		
		public static function sm_VIP_U(obj:Object):void{
			DataManager.getInstance().vipData.vipLv = obj.slv;
			UIManager.getInstance().openFun(FunOpenEnum.SPRITE, receive);
		}
		
		private static function receive():void{
			NetGate.getInstance().send(CmdEnum.CM_VIP_S + 1 + "," + DataManager.getInstance().vipData.vipLv);
		}
		
		public static function sm_VIP_L(obj:Object):void{
			UIManager.getInstance().taskWnd.setVipLvState(obj.vlv);
			UIManager.getInstance().roleHeadWnd.activeIcon("vipImg", (obj.vlv > 0));
		}
	}
}
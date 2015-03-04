package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Fanl
	{
		public static function sm_Fanl_I(obj:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.PAY_PROMOTION, CmdEnum.SM_FANL_I);
			if(0 == obj.act){
				UIManager.getInstance().rightTopWnd.deactive("promotionBtn");
			}else if(1 == obj.act){
				DataManager.getInstance().payPromotionData.loadData_I(obj);
				UIManager.getInstance().rightTopWnd.active("promotionBtn",DataManager.getInstance().payPromotionData.getRewardCount());
			}
			if(UIManager.getInstance().isCreate(WindowEnum.PAY_PROMOTION)){
				UIManager.getInstance().payPormotion.updateInfo();
			}
		}
		
		public static function cm_Fanl_I():void{
			NetGate.getInstance().send(CmdEnum.CM_FANL_I);
		}
		
		public static function sm_Fanl_J(obj:Object):void{
			DataManager.getInstance().payPromotionData.loadData_J(obj);
			if(UIManager.getInstance().isCreate(WindowEnum.PAY_PROMOTION)){
				UIManager.getInstance().payPormotion.flyItem(obj.retype, obj.update[0]);
				UIManager.getInstance().payPormotion.updateInfo();
			}
			UIManager.getInstance().rightTopWnd.active("promotionBtn",DataManager.getInstance().payPromotionData.getRewardCount());
		}
		
		public static function cm_Fanl_J(id:int):void{
			NetGate.getInstance().send(CmdEnum.CM_FANL_J+id);
		}
	}
}
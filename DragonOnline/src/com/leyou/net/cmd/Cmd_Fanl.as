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
			DataManager.getInstance().payPromotionData_II.loadData_I(obj);
			if(0 == obj.act){
				UIManager.getInstance().rightTopWnd.deactive("promotionBtn");
			}else if(1 == obj.act){
				UIManager.getInstance().rightTopWnd.active("promotionBtn",DataManager.getInstance().payPromotionData_II.getRewardCount());
			}
			if(DataManager.getInstance().payPromotionData_II.checkForecast()){
				UIManager.getInstance().rightTopWnd.active("promotionBtn", DataManager.getInstance().payPromotionData_II.getRewardCount());
			}
			if(UIManager.getInstance().isCreate(WindowEnum.PAY_PROMOTION)){
				UIManager.getInstance().payPormotion.updateInfo();
			}
		}
		
		public static function cm_Fanl_I():void{
			NetGate.getInstance().send(CmdEnum.CM_FANL_I);
		}
		
		public static function sm_Fanl_J(obj:Object):void{
			DataManager.getInstance().payPromotionData_II.loadData_J(obj);
			if(UIManager.getInstance().isCreate(WindowEnum.PAY_PROMOTION)){
				UIManager.getInstance().payPormotion.flyItem(obj.retype, obj.update[0]);
				UIManager.getInstance().payPormotion.updateInfo();
			}
			UIManager.getInstance().rightTopWnd.active("promotionBtn",DataManager.getInstance().payPromotionData_II.getRewardCount());
		}
		
		public static function cm_Fanl_J(id:int):void{
			NetGate.getInstance().send(CmdEnum.CM_FANL_J+id);
		}
		
		public static function sm_Fanl_D(obj:Object):void{
			var type:int = obj.dtype;
			var pos:int = obj.jlpos;
			var num:int = obj.num;
			UIManager.getInstance().payPormotion.rollToPos(type, pos, num);
		}
		
//		抽奖
//		上行：fanl|Ddtype (1绑定钻石抽奖 2钻石抽奖)
//		下行: fanl|{"mk":"D", dtype:num, jlpos:pos }
		public static function cm_Fanl_D(type:int):void{
			NetGate.getInstance().send(CmdEnum.CM_FANL_D+type);
		}
		
		public static function cm_Fanl_A(type:int):void{
			NetGate.getInstance().send(CmdEnum.CM_FANL_A+type);
		}
		
		public static function cm_Fanl_B(id:int):void{
			NetGate.getInstance().send(CmdEnum.CM_FANL_B+id);
		}
	}
}
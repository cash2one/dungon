package com.leyou.net.cmd {
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;
	import com.leyou.ui.ttsc.KfhdWnd;

	public class Cmd_Fanl {

		public static function sm_Fanl_I(obj:Object):void {
			
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.PAY_PROMOTION, CmdEnum.SM_FANL_I);
			DataManager.getInstance().payPromotionData_II.loadData_I(obj);
			
			if (0 == obj.act) {
				UIManager.getInstance().rightTopWnd.deactive("promotionBtn");
			} else if (1 == obj.act) {
				UIManager.getInstance().rightTopWnd.active("promotionBtn", DataManager.getInstance().payPromotionData_II.getRewardCount());
			}
			
			if (DataManager.getInstance().payPromotionData_II.checkForecast()) {
				UIManager.getInstance().rightTopWnd.active("promotionBtn", DataManager.getInstance().payPromotionData_II.getRewardCount());
			}

			if (UIManager.getInstance().isCreate(WindowEnum.PAY_PROMOTION)) {
				UIManager.getInstance().payPormotion.updateInfo();
			}
 
		}
		
		/**
		 *开合服活动
上行：fanl|K 
下行: fanl|{"mk":"K", "st":num, "stime":num, "opentime":num,  "retype":[ [fid,st,cc,mc,dc],,,]} 
		 * @param obj
		 * 
		 */		
		public static function sm_Fanl_K(obj:Object):void {
			
			DataManager.getInstance().payPromotionData_III.loadData_I(obj);
			
			if (!UIManager.getInstance().isCreate(WindowEnum.KFHD)) {
				UIManager.getInstance().creatWindow(WindowEnum.KFHD);
			}
			
			UIManager.getInstance().kfhdWnd.updateInfo(obj);
		}
		
		public static function cm_Fanl_K():void {
			NetGate.getInstance().send(CmdEnum.CM_FANL_K);
		}

		/**
		 *上行：fanl|I
下行：fanl|{"mk":"I", "retype":[[fid,st,cc,mc],,,], "act":num}
  act -- 是否有活动（1有活动 0没活动）
		  retype  -- 类型 (1充值,2坐骑,3翅膀)
				fid  -- 返利id
				st   -- 按钮状态(0不可领取,1可领取,2已领取)
				cc   -- 剩余领取次数
				mc   -- 总领取次数
		 *
		 */
		public static function cm_Fanl_I():void {
			NetGate.getInstance().send(CmdEnum.CM_FANL_I);
		}

		public static function sm_Fanl_J(obj:Object):void {
			DataManager.getInstance().payPromotionData_II.loadData_J(obj);
			if (UIManager.getInstance().isCreate(WindowEnum.PAY_PROMOTION)) {
				UIManager.getInstance().payPormotion.flyItem(obj.retype, obj.update[0]);
				UIManager.getInstance().payPormotion.updateInfo();
			}
			UIManager.getInstance().rightTopWnd.active("promotionBtn", DataManager.getInstance().payPromotionData_II.getRewardCount());
		}

		public static function cm_Fanl_J(id:int):void {
			NetGate.getInstance().send(CmdEnum.CM_FANL_J + id);
		}

		public static function sm_Fanl_D(obj:Object):void {
			var type:int=obj.dtype;
			var pos:int=obj.jlpos;
			var num:int=obj.num;
			UIManager.getInstance().payPormotion.rollToPos(type, pos, num);
		}

//		抽奖
//		上行：fanl|Ddtype (1绑定钻石抽奖 2钻石抽奖)
//		下行: fanl|{"mk":"D", dtype:num, jlpos:pos }
		public static function cm_Fanl_D(type:int):void {
			NetGate.getInstance().send(CmdEnum.CM_FANL_D + type);
		}

		public static function cm_Fanl_A(type:int):void {
			NetGate.getInstance().send(CmdEnum.CM_FANL_A + type);
		}

		public static function cm_Fanl_B(id:int):void {
			NetGate.getInstance().send(CmdEnum.CM_FANL_B + id);
		}
	}
}

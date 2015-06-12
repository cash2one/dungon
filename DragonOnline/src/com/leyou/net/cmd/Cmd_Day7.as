package com.leyou.net.cmd {
	import com.ace.enum.WindowEnum;
	import com.ace.manager.UIManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	
	
	
	public class Cmd_Day7 {

		public static function sm_day_I(o:Object):void{
			
			if(!UIManager.getInstance().isCreate(WindowEnum.KEEP_7))
				UIManager.getInstance().creatWindow(WindowEnum.KEEP_7);
			
			UIManager.getInstance().sdayWnd.updateInfo(o);
		}
		
		/**
		 *登录信息
上行：lday|I
下行：lday|{"mk":"I", "dlist":[st,...],  "logind":num }
          logind -- 已登录天数
          dlist -- 奖励状态列表 (7天的奖励状态列表)
            st -- 状态(0未领取 1已领取) 
		 * 
		 */		
		public static function cmInit():void{
			NetGate.getInstance().send(CmdEnum.CM_DAY7_I);
		}
		
		public static function sm_day_J(o:Object):void{
			
			 UIManager.getInstance().sdayWnd.rewardFlyBag();
		}
		
		/**
		 * 领取奖励
--------------------------------------------------------------------------------  
上行：lday|Jday
         day -- 要领取的奖励天数
下行：lday|{"mk":"J", "day":num} 领取成功返回 I和J

		 * @param day
		 * 
		 */		
		public static function cmAccpet(day:int):void{
			NetGate.getInstance().send(CmdEnum.CM_DAY7_J+day);
		}

	}
}

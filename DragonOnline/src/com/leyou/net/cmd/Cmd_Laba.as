package com.leyou.net.cmd {
	import com.ace.manager.UIManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Laba {

		public static function sm_laba_I(o:Object):void {

			if (o.ast == 1)
				UIManager.getInstance().rightTopWnd.active("gambleBtn");
			else
				UIManager.getInstance().rightTopWnd.deactive("gambleBtn");

		}

		/**
		 *上行:laba|I
下行:laba|{"mk":"I", "ast":num }
	 ast -- 活动状态 （1开启 0关闭）
		  *
		 */
		public static function cmInit():void {
			NetGate.getInstance().send(CmdEnum.CM_LABA_I);
		}


		public static function sm_laba_H(o:Object):void {

			UIManager.getInstance().labaWnd.updateHistoryInfo(o);

		}

		/**
		 *抽奖历史信息
上行：laba|H
下行: laba|{"mk":"H", "hlist":[ [dtime,name,itemid,num],...]}
   hlist  -- 记录信息列表
				 dtime -- 抽奖时间
			   name  -- 抽奖人名字
			   itemid -- 中奖道具
			   num    -- 道具数量
		 *
		 */
		public static function cmHistory():void {
			NetGate.getInstance().send(CmdEnum.CM_LABA_H);
		}


		public static function sm_laba_D(o:Object):void {
			UIManager.getInstance().labaWnd.updateInfo(o);
		}

		/**
		 *开始抽奖
上行: laba|Ddtype
下行: laba|{"mk":"D", "jlid":num }
   dtype -- 抽奖类型 (1钻石 2道具 )
			 jlid -- 奖励id
		 * @param type
		 *
		 */
		public static function cmGamble(type:int):void {
			NetGate.getInstance().send(CmdEnum.CM_LABA_D + type);
		}


		/**
		 *领取奖励
上行: laba|J
 * @param type
	   *
			*/
		public static function cmAccpet():void {
			NetGate.getInstance().send(CmdEnum.CM_LABA_J);
		}



	}
}

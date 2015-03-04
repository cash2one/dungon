package com.leyou.net.cmd {
	import com.ace.enum.WindowEnum;
	import com.ace.manager.UIManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Ecp {


		/**
		 *副本信息
下行：ecp|{"mk":"T", "stime":num,  "jf":num,  "npcl":[{npcid,dou},...]  }
   stime  -- 剩余时间秒
			 jf     -- 当前积分
		   npcl --怪物列表
			  npcid  -- 怪物id
			  dou    -- 是否双倍 (0无双倍 1双倍)
		 * @param o
		 *
		 */
		public static function sm_Ecp_T(o:Object):void {

			if (!UIManager.getInstance().isCreate(WindowEnum.PKCOPYSGTRACK))
				UIManager.getInstance().creatWindow(WindowEnum.PKCOPYSGTRACK);


			UIManager.getInstance().pkCopySGTrack.showPanel(o);
		}

		/**
		 *关闭信息面板
下行：ecp|{"mk":"X" }
 * @param o
	   *
			*/
		public static function sm_Ecp_X(o:Object):void {
			if (!UIManager.getInstance().isCreate(WindowEnum.PKCOPYSGTRACK))
				UIManager.getInstance().creatWindow(WindowEnum.PKCOPYSGTRACK);

			UIManager.getInstance().pkCopySGTrack.hide();
		}
		
		/**
		 * 奖励信息
		 下行：ecp|{"mk":"R", "exp":num }
		 * 
		 */		
		public static function sm_Ecp_R(o:Object):void {
			
			if (!UIManager.getInstance().isCreate(WindowEnum.PKCOPYDRAGONFINISH))
				UIManager.getInstance().creatWindow(WindowEnum.PKCOPYDRAGONFINISH);
			
			UIManager.getInstance().pkCopyDungeonFinish.showPanel(o);
		}

		/**
		 * 离开副本
			上行:ecp|L
 			* @param o
	  		 *
			*/
		public static function cmExpExit():void {
			NetGate.getInstance().send(CmdEnum.CM_ECP_L);
		}

	}
}

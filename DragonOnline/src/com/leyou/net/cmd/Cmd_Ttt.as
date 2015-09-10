package com.leyou.net.cmd {


	import com.ace.enum.WindowEnum;
	import com.ace.manager.UIManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;
	import com.leyou.ui.ttt.TttWnd;

	public class Cmd_Ttt {


		public static function sm_ttt_I(o:Object):void {

			UIManager.getInstance().tttWnd.updateInfo(o);

		}

		/**
		 * --------------------------------------------------------------------------------
主要信息
上行：bbt|U
下行: bbt|{"mk":"U", "cfloor":num, "scount":num}
	cfloor -- 当前应该进入层数 (当全部完成后为 0)
		scount  -- 剩余通关次数
		 *
		 */
		public static function cmInit():void {
			NetGate.getInstance().send(CmdEnum.CM_TTT_I);
		}

		public static function sm_ttt_U(o:Object):void {

			UIManager.getInstance().tttWnd.updateCurrentInfo(o);

		}

		/**
		 *--------------------------------------------------------------------------------
某层通关信息
上行：bbt|Ifloor
下行: bbt|{"mk":"I", "floor":num, "fname":str, "ftime":num, }
	fname -- 第一名字
		ftime -- 最快通关时间
		 *
		 */
		public static function cmCurrentCopy(floor:int):void {
			NetGate.getInstance().send(CmdEnum.CM_TTT_U+floor);
		}

		/**
		 *----------------------------------------------------------------
副本追踪
下行:bbt|{"mk":"T","cfloor":num,"rt":remainTime, "m":[{"mid":id, "cc":currentCount, "mc":maxCount}...]}
	 *
		  */
		public static function sm_ttt_T(o:Object):void {

			if (!UIManager.getInstance().isCreate(WindowEnum.TTT_TRACK))
				UIManager.getInstance().creatWindow(WindowEnum.TTT_TRACK);
			
			UIManager.getInstance().ttttackWnd.updateInfo(o);

		}
		
		/**
		 *-------------------------------------------------------------------
首次击杀通知
下行:bbt|{"mk":"R", "cid":copyid} 
		 * @param o
		 * 
		 */		
		public static function sm_ttt_R(o:Object):void {

			if (!UIManager.getInstance().isCreate(WindowEnum.BOSSCOPY_REWARD))
				UIManager.getInstance().creatWindow(WindowEnum.BOSSCOPY_REWARD);
			
			UIManager.getInstance().bossCopyReward.updateInfo(o);

		}

		/**
		 *-------------------------------------------------------------------

快速完成
上行:bbt|Kfloor,btype
	 floor -- 层数（0为扫荡全部）
		  btype -- 消耗类型（0钻石 1绑定钻石）
		 * @param o
		 *
		 */
		public static function cmfastComplete(lv:int, type:int):void {
			NetGate.getInstance().send(CmdEnum.CM_TTT_K+lv+","+type);
		}

		/**
		 *进入副本
   上行:bbt|Efloor
	  floor -- 层数
		   * @param lv
		 *
		 */
		public static function cmEnterCopy(lv:int):void {
			NetGate.getInstance().send(CmdEnum.CM_TTT_E + lv);
		}

		/**
		 * -------------------------------------------------------------------
离开副本
上行:bbt|L
	 * @param lv
		  * @param type
		 *
		 */
		public static function cmCopyExit():void {
			NetGate.getInstance().send(CmdEnum.CM_TTT_L);
		}

		/**
		 * -------------------------------------------------------------------
重置副本
上行:bbt|F
	 * @param lv
		  * @param type
		 *
		 */
		public static function cmCopyReset():void {
			NetGate.getInstance().send(CmdEnum.CM_TTT_F);
		}





	}
}

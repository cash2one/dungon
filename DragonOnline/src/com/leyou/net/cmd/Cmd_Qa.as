package com.leyou.net.cmd {
	
	import com.ace.enum.WindowEnum;
	import com.ace.manager.UIManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	/**
	 *答题
	 */
	public class Cmd_Qa {


		public static function sm_Qa_E(o:Object):void {
			if(!UIManager.getInstance().isCreate(WindowEnum.QUESTION))
				UIManager.getInstance().creatWindow(WindowEnum.QUESTION);
			
			UIManager.getInstance().questionWnd.show();
//			UIManager.getInstance().rightTopWnd.active("questBtn");
		}

		/**
		 *进入答题场景
上行:qa|E
下行:qa|{"mk
	 *
		  */
		public static function cmQaEnter():void {
			NetGate.getInstance().send(CmdEnum.CM_QA_E);
		}

		public static function sm_Qa_X(o:Object):void {
			UIManager.getInstance().questionWnd.hide();
//			UIManager.getInstance().rightTopWnd.deactive("questBtn");
		}

		/**
		 *离开答题场景
			上行:qa|X
			下行:qa|{"mk":"X"}
	 	*
		 */
		public static function cmQaExit():void {
			NetGate.getInstance().send(CmdEnum.CM_QA_X);
		}

		/**
		 *答题任务追踪
			下行:qa|{"mk":"T", "rtime":num}
			rtime   -- 剩余时间秒数 (大于0 剩余秒数, 0 活动正在开启，小于0 活动结束了关闭此显示)
		  
		 */
		public static function sm_Qa_T(o:Object):void {
			UIManager.getInstance().taskTrack.updateQuestion(o);
		}

		/**
		 *下行:qa|{"mk":"R", "qright":str,"rw":num}
		  qright  -- 正确答案 （a,b）
		  rw      -- 是否答对 （1 正确，2 错误）
		 *
		 */
		public static function sm_Qa_R(o:Object):void {
			if(!UIManager.getInstance().isCreate(WindowEnum.QUESTION))
				UIManager.getInstance().creatWindow(WindowEnum.QUESTION);
			
			UIManager.getInstance().questionWnd.updateRight(o);
		}

		/**
		 *题目信息
			下行:qa|{"mk":"Q", "qid":id,"a":num,"b":num}
			qid  -- 题目 id
			a    -- num (编号, 1 anw1， 2 anw2)
			b    -- num (编号, 1 anw1， 2 anw2)
		 * @param o
		 *
		 */
		public static function sm_Qa_Q(o:Object):void {
			if(!UIManager.getInstance().isCreate(WindowEnum.QUESTION))
				UIManager.getInstance().creatWindow(WindowEnum.QUESTION);
			
			UIManager.getInstance().questionWnd.updateInfo(o);
		}

		/**
		 *奖励信息
			下行:qa|{"mk":"J", "right":num,"cright":num,"exp":num,"money":num}
	  		right  -- 答对数量
			cright -- 连队数量
		  	exp    -- 累计经验
		 	 money  -- 累计金钱
		 *
		 */
		public static function sm_Qa_J(o:Object):void {
			UIManager.getInstance().questionWnd.updateReward(o);
		}

	}
}

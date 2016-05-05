package com.leyou.net.cmd {

	import com.ace.enum.WindowEnum;
	import com.ace.manager.UIManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Rnkj {

		/**
		 *排行竞技
--------------------------------------------------------------------------------
rakj

上行：rakj|I
下行: rakj|{"mk":"I", "st":num, "stime":num, "opentime":num, "raklist":[[rtype,name,vocation,gender],...]}
st -- 服务器状态 (1开服 2合服)
stime -- 当前时间戳 秒
  opentime -- 开服时间戳 秒
	  raklist -- 排行榜信息列表
			rtype -- 排行榜类型 对应表中类型
		  --第一名信息
		  name  -- 名字
		  vocation -- 职业
		  gender   -- 性别
		 *
		 */
		public static function cmRnkjInit():void {
			NetGate.getInstance().send(CmdEnum.CM_RNKJ_I);
		}

		public static function sm_rnkj_I(o:Object):void {

			if (!UIManager.getInstance().isCreate(WindowEnum.KFCB))
				UIManager.getInstance().creatWindow(WindowEnum.KFCB);

			UIManager.getInstance().kfcbWnd.updateInfo(o);
		}


	}
}

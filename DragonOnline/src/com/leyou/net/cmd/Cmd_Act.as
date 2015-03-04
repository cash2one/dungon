package com.leyou.net.cmd {

	import com.ace.enum.WindowEnum;
	import com.ace.manager.UIManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	/**
	 *--------------------------------------------------------------------------------------------
活动列表
上行:act|I
下行:act|{"mk":"I", "actl":[{"actid":num,"level":num,"state":num,"lock":num,"count":num},{...}]}
					 actid -- 活动id(1答题 2运镖 3龙穴 4入侵)
					 level -- 开启等级
					 state -- 活动状态(1开启,  0未开启)
					 lock  -- 是否锁定(1锁定 0未锁定)
					 count -- 剩余次数(部分活动没有此项)

---------------------------------------------------------------
立即参与
上行:act|Gactid


--------------------------------------------------------------------------------------------
增加次数
上行:act|Cactid

--------------------------------------------------------------------------------------------
活动开启
上行:act|Aactid

actid -- 活动id(1答题 2运镖 3龙穴 4入侵)
	 *
	 */
	public class Cmd_Act {


		public static function sm_Act_I(o:Object):void {
			UIManager.getInstance().pkCopyWnd.updateInfo(o);
		}

		public static function cmActInit():void {
			NetGate.getInstance().send(CmdEnum.CM_ACT_I);
		}

		public static function sm_Act_A(o:Object):void {

			if (!UIManager.getInstance().isCreate(WindowEnum.PKCOPYPANEL))
				UIManager.getInstance().creatWindow(WindowEnum.PKCOPYPANEL);

			cmActInit();
			UIManager.getInstance().pkCopyPanel.updateInfo(o);
		}

		public static function cmActAddCount(id:int):void {
			NetGate.getInstance().send(CmdEnum.CM_ACT_C + id);
		}

		public static function cmActNowAccept(id:int):void {
			NetGate.getInstance().send(CmdEnum.CM_ACT_G + id);
		}

	}
}

package com.leyou.net.cmd {

	import com.ace.enum.WindowEnum;
	import com.ace.manager.LayerManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;
	import com.leyou.ui.monsterInvade.child.MonsterInFinish;

	public class Cmd_Wbs {


		/**
		 * 世界boss信息
下行:wbs|{"mk":I,"stime":num, "rankl":[[name,damage],...]], "myrank":num, "mydamage":num, "myexp":num, "aprop":num}
stime  -- 剩余时间
		  rankl  -- 排行榜
				 name  -- 名字
				 damage -- 伤害
			  myrank     -- 我的排行
			  mydamage   -- 我的伤害
			  myexp      -- 我的经验
			  aprop      -- 增加的属性比
		 *
		 */
		public static function sm_Wbs_I(o:Object):void {

			if (!UIManager.getInstance().isCreate(WindowEnum.MONSTERINVADEWND))
				UIManager.getInstance().creatWindow(WindowEnum.MONSTERINVADEWND);

			UIManager.getInstance().monsterInvadeWnd.showPanel(o);
		}

		/**
		 *关闭界面
下行：wbs|{"mk":"X"}
*
*/
		public static function sm_Wbs_X(o:Object):void {

			UIManager.getInstance().hideWindow(WindowEnum.MONSTERINVADEWND);
			UIManager.getInstance().taskTrack.show();
			UIManager.getInstance().rightTopWnd.visible=true;
		}

		/**
		 *奖励提示
下行:wbs|{"mk":J,"jtype":num, "rank":num}
jtype  -- 奖励类型 (1击杀奖励 2 排名奖励)
	 rank   -- 排名 当 jtype = 2 时有
		  *
		 */
		public static function sm_Wbs_J(o:Object):void {
//			if (!UIManager.getInstance().isCreate(WindowEnum.MONSTERINFINISH))
//				UIManager.getInstance().creatWindow(WindowEnum.MONSTERINFINISH);
//			
//			UIManager.getInstance().monsterInFinish.showPanel(o);

			var finishwnd:MonsterInFinish=new MonsterInFinish();
			LayerManager.getInstance().windowLayer.addChild(finishwnd);
			finishwnd.showPanel(o);
		}

		/**
		 *---------------------------------------------------------------------------------
购买buff
上行:wbs|B
*
*/
		public static function cmBuyBuff():void {
			NetGate.getInstance().send(CmdEnum.CM_WBS_B);
		}

		/**
		 *---------------------------------------------------------------------------------
退出活动
上行:wbs|Q
*
*/
		public static function cmQuitActive():void {
			NetGate.getInstance().send(CmdEnum.CM_WBS_Q);
		}

	}
}

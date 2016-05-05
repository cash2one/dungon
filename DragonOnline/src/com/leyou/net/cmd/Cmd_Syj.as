package com.leyou.net.cmd {
	import com.ace.config.Core;
	import com.ace.enum.FunOpenEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.manager.UIManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Syj {

		/**
		 *syj


某个类型试衣间信息
上行：syj|Istype
下行: syj|{"mk":"I", "stype":num, "slist":[[sid,st],...]}
stype -- 试衣间类型
	  slist -- 当前此类型拥有的效果id （只发已获得的）
			  sid -- 效果id
			st  -- 效果状态（1已获得,2使用中）
		 * @param type
		 *
		 */
		public static function cmSelectTab(type:int):void {
			NetGate.getInstance().send(CmdEnum.CM_SYJ_I + type);
		}

		public static function sm_syj_I(o:Object):void {

			UIManager.getInstance().shiyeWnd.updateTabInfo(o);

		}

		/**
		 *某个效果信息
上行：syj|Fsid
下行: syj|{"mk":"F", "sinfo":[sid,st,stime,[v1,v2,v3,...]]}
sid -- 效果id
   st  -- 效果状态（0未获得,1已获得,2使用中）
		   stime -- 到期时间秒
		 v1 ,  -- 当前条件完成值

		 * @param sid
		 *
		 */
		public static function cmOpen(sid:int):void {
			NetGate.getInstance().send(CmdEnum.CM_SYJ_F + sid);
		}

		public static function sm_syj_F(o:Object):void {

			if (!UIManager.getInstance().isCreate(WindowEnum.SHIYI))
				return;

			UIManager.getInstance().shiyeWnd.updateInfo(o);
		}

		/**
		 *购买效果
上行：syj|Bsid
* @param sid
   *
		   */
		public static function cmBuy(sid:int):void {
			NetGate.getInstance().send(CmdEnum.CM_SYJ_B + sid);
		}

		/**
		 * 启用效果
上行：syj|Usid
* @param sid
   *
		   */
		public static function cmInstall(sid:int):void {
			NetGate.getInstance().send(CmdEnum.CM_SYJ_U + sid);
		}

		/**
		 * 关闭效果
上行：syj|Dsid
* @param sid
   *
		   */
		public static function cmUninstall(sid:int):void {
			NetGate.getInstance().send(CmdEnum.CM_SYJ_D + sid);
		}

		/**
		 *--------------------------------------------------------------------------------
获得效果
下行: syj|{"mk":"G", "sinfo":[sid,st,stime,[v1,v2,v3,...] ]}
 * @param o
	   *
			*/
		public static function sm_syj_G(o:Object):void {

			if (!o.hasOwnProperty("sinfo") || Core.me == null || Core.me.info == null)
				return;

			UIManager.getInstance().openFun(FunOpenEnum.SHIYIJIANG, null, o.sinfo);

			if (UIManager.getInstance().isCreate(WindowEnum.SHIYI) && UIManager.getInstance().shiyeWnd.visible)
				UIManager.getInstance().shiyeWnd.updateTabList();
		}

	}
}

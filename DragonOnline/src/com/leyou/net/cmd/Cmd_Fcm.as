package com.leyou.net.cmd {

	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TNoticeInfo;
	import com.ace.manager.UIManager;
	import com.ace.ui.window.children.SimpleWindow;
	import com.ace.utils.StringUtil;
	import com.leyou.manager.PopupManager;
	import com.leyou.utils.PropUtils;

	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	/**
	 *防沉迷
	 * @author Administrator
	 *
	 */
	public class Cmd_Fcm {

		private static var wnd:SimpleWindow;

		/**
		 *下行：fcm|{"mk":"I","msgid":num}
			 -- msgid 消息提示id
		 * @param o
		 *
		 */
		public static function sm_Fcm_I(o:Object):void {
			if (!o.hasOwnProperty("msgid"))
				return;

			var notice:TNoticeInfo=TableManager.getInstance().getSystemNotice(o.msgid);
			if (notice != null) {
				if (int(o.msgid) % 2 == 0) {
					UIManager.getInstance().fcmWnd.updateInfo(StringUtil.substitute(notice.content, [o.mvar]), false);
				} else
					UIManager.getInstance().fcmWnd.updateInfo(StringUtil.substitute(notice.content, [o.mvar]), true);
			}

		}

		/**
		 *玩家防沉迷状态
下行：fcm|{"mk":"S","st":num,"ftime":num }
st (0=已填身份证且满18周岁，1=无身份信息，2=已填身份证但不满18周岁。)
ftime -- 已经防沉迷累计时间 秒

* @param o
*
*/
		public static function sm_Fcm_S(o:Object):void {
			if (!o.hasOwnProperty("st"))
				return;

			var pid:int;

			var v:Number=o.ftime / 3600;
			if (v < 1) {
				if (o.st == 1)
					pid=9710;
			} else if (v >= 1 && v < 3) {
				if (o.st == 1)
					pid=9701;
				else if (o.st == 2)
					pid=9702;
			} else if (v >= 3 && v < 5) {
				if (o.st == 1)
					pid=9703;
				else if (o.st == 2)
					pid=9704;
			} else if (v >= 5) {
				if (o.st == 1)
					pid=9705;
				else if (o.st == 2)
					pid=9706;
			}

			if (pid != 0) {

//				var tn:TNoticeInfo=TableManager.getInstance().getSystemNotice(9710);
//				trace(tn.content);
				UIManager.getInstance().fcmWnd.updateInfo(StringUtil.substitute(TableManager.getInstance().getSystemNotice(pid).content, [int(o.ftime / 3600)]), (o.st == 1));
			}

			if (o.ftime < 5 * 3600)
				return;

			if (wnd != null) {
				wnd.hide();
			}

			if (o.st == 1)
				pid=9708;
			else if (o.st == 2)
				pid=9709;

			var notice:TNoticeInfo=TableManager.getInstance().getSystemNotice(pid);

			if (notice != null) {
				if (o.st == 2) {
					wnd=PopupManager.showAlert(notice.content, quitFunc, true, "fcm1", PropUtils.getStringById(1566));
				} else if (o.st == 1) {
					wnd=PopupManager.showAlert(notice.content, okFunc, true, "fcm2", PropUtils.getStringById(1566));
				}
			}

		}

		private static function quitFunc():void {
			Cmd_Chat.cm_say("@quit");
		}

		private static function okFunc():void {
			navigateToURL(new URLRequest(TableManager.getInstance().getSystemNotice(9707).content), "_self");
		}

	}
}

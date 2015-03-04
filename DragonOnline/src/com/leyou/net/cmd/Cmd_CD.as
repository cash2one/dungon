package com.leyou.net.cmd {

	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.UIManager;
	import com.leyou.data.bag.Baginfo;

	public class Cmd_CD {

		public function Cmd_CD() {
			
		}

		/**
		 *--道具cd
		下行:cd|{"mk":I,icd:[[gid,cdtime],...]}
		  gid   cd组id(格式为item表中的classid +"_"+subclassid 例(2_2))
		  cdtime   cd剩余的时间最小单位为(0.1秒)
		 *
		 */
		public static function sm_cd_I(o:Object):void {
 
			var arr:Array;
			for each (arr in o.icd) {
				UIManager.getInstance().backpackWnd.startGridCD(arr);
			}
		}

		/**
		 *--技能cd
		下行:cd|{"mk":S,scd:[[sgid,cdtime],...]}
		  sid    cd组id(格式为skill表中的 (group))
		 *
		 */
		public static function sm_cd_S(o:Object):void {

			var arr:Array;
			for each (arr in o.scd) {
//				trace(arr,"====================");
				UIManager.getInstance().toolsWnd.updateCD(arr[0], arr[1]);
			}
		}


	}
}

/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-11-26 下午5:33:42
 */
package com.ace.ui.map.wnd {
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.manager.KeysManager;
	import com.ace.manager.UIManager;
	import com.leyou.net.cmd.Cmd_Tm;
	
	import flash.geom.Point;
	import flash.ui.Keyboard;


	/**
	 * 只负责鼠标事件
	 * @author ace
	 *
	 */
	public class BigMap extends BigMapEvent {

		public function BigMap() {
			super();
		}

		override protected function getTeamInfo():void {
			super.getTeamInfo();
			Cmd_Tm.cm_tmM();
		}


		override protected function onClickMap(pt:Point):void {
			if (KeysManager.getInstance().isDown(Keyboard.CONTROL)) {
				UIManager.getInstance().chatWnd.generateMapLink(MapInfoManager.getInstance().sceneId, MapInfoManager.getInstance().sceneName, pt.x, pt.y);
			}
		}

	}
}

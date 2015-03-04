/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-10-25 下午12:25:14
 */
package com.leyou.net.cmd {
	import com.ace.config.Core;
	import com.ace.enum.EffectEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.game.scene.ui.SceneUIManager;
	import com.ace.game.utils.LivingUtil;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.player.PlayerInfo;
	import com.ace.manager.UIManager;
	import com.ace.utils.DebugUtil;

	//属性同步
	public class Cmd_Prop {

		static private var tmpArr:Array;

		//主界面属性同步
		static public function sm_synp(obj:Object):void {
			var info:PlayerInfo=MyInfoManager.getInstance();

			tmpArr=String(PlayerEnum.propDic[obj["prop"]]).split(".");
			if (tmpArr[0] == "undefined") {
				return;
				DebugUtil.throwError("该版本该属性还未定义同步");
			}
//			trace("【属性改变】" + obj["prop"] + "=" + tmpArr + ":" + obj["value"]);
			if (obj["prop"] == 22 || obj["prop"] == 23) {
				var tmp:int;
				if (tmpArr.length > 1) {
					tmp=obj["value"] - MyInfoManager.getInstance()[tmpArr[0]][tmpArr[1]];
				} else {
					tmp=obj["value"] - MyInfoManager.getInstance()[tmpArr[0]];
				}

				SceneUIManager.getInstance().addEffect(Core.me, EffectEnum.BUBBLE_LEFT, tmp, EffectEnum.COLOR_GREEN);
			}


			if (tmpArr.length > 1) {
				MyInfoManager.getInstance()[tmpArr[0]][tmpArr[1]]=obj["value"];
			} else {
				MyInfoManager.getInstance()[tmpArr[0]]=obj["value"];
			}
			LivingUtil.updataPropUI();
		}
	}
}
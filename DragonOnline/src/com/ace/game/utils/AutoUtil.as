package com.ace.game.utils {
	import com.ace.game.core.SceneCore;
	import com.ace.game.proxy.CmdProxy;
	import com.ace.game.proxy.ModuleProxy;
	import com.ace.gameData.manager.SettingManager;

	public class AutoUtil {

		/**
		 * 自动复活
		 * @return 是否成功复活
		 *
		 */
		static public function autoRevive():Boolean {
			if (SettingManager.getInstance().assitInfo.isAutoRevive) {
				if (ModuleProxy.itemNum(31500) >= 1) {
					CmdProxy.cm_revive(1);
					return true;
				}
				if (ModuleProxy.itemNum(31501) >= 1) {
					CmdProxy.cm_revive(1);
					return true;
				}
			}
			return false;
		}

		/**自动吃药*/
		static public function autoEat():void {
//			trace("---------my hp = "+SceneCore.me.info.hp + "---set hp = "+SettingManager.getInstance().assitInfo.minHP)
			if (SettingManager.getInstance().assitInfo.isAutoEatHP && SceneCore.me.info.hp < SettingManager.getInstance().assitInfo.minHP) {
//				trace("自动吃药xxxxx：", SceneCore.me.info.hp, SettingManager.getInstance().assitInfo.minHP);
				if (!ModuleProxy.itemEathHP()) {
					autoBuyHp();
				}
			}

//			if (SettingManager.getInstance().assitInfo.isAutoEatMP && SceneCore.me.info.mp < SettingManager.getInstance().assitInfo.minMP) {
//				if (PreExecutManager.getInstance().check(ModuleProxy.itemEathMP) && !ModuleProxy.itemEathMP()) {
//					autoBuyMP();
//				}
//			}
		}


		static public function autoBuyHp():void {
			if (SettingManager.getInstance().assitInfo.isAutoBuyHP && ModuleProxy.itemNum(SettingManager.getInstance().assitInfo.hpItem) < 1) {
				ModuleProxy.itemBuy(SettingManager.getInstance().assitInfo.hpItem);
			}
		}

		static public function autoBuyMP():void {
			if (SettingManager.getInstance().assitInfo.isAutoBuyMP && ModuleProxy.itemNum(SettingManager.getInstance().assitInfo.mpItem) < 1) {
				ModuleProxy.itemBuy(SettingManager.getInstance().assitInfo.mpItem);
			}
		}


	}
}

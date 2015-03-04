package com.ace.game.scene {
	import com.ace.bt.BTManager;
	import com.ace.config.Core;
	import com.ace.enum.AIEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.game.core.SceneCore;
	import com.ace.game.manager.ReuseManager;
	import com.ace.game.proxy.SceneProxy;
	import com.ace.game.scene.map.SceneModel;
	import com.ace.game.scene.player.Living;
	import com.ace.game.scene.player.MyPlayer;
	import com.ace.game.scene.player.part.LivingBase;
	import com.ace.game.scene.player.part.LivingModel;
	import com.ace.game.scene.ui.child.Item;
	import com.ace.game.scene.ui.child.LivingUI;
	import com.ace.gameData.player.LivingInfo;
	import com.ace.gameData.player.PlayerInfo;
	import com.ace.manager.UIManager;
	import com.ace.utils.DebugUtil;
	import com.leyou.net.cmd.Cmd_Scene;

	import flash.geom.Point;

	public class GameScene extends SceneModel {
		public function GameScene() {
			super();
		}

		/**同步场景位置*/
		public function gotoPt(pt:Point):void {
			this.nextPs=pt;
			this.isInitOk && this.syncSelectPlayer();
		}

		override protected function onLoaded():void {
			super.onLoaded();
			Cmd_Scene.cm_r();
		}

		override public function addMe(info:PlayerInfo):void {
			if (!Core.me) {
				Core.me=new MyPlayer();
				SceneCore.me=Core.me;
				Core.me.initData(info);
				this.changeSelectPlayer(Core.me);
				UIManager.getInstance().sceneBG.changeSelectPlayer(Core.me); //
				this.sortLayer.addChild(Core.me);
				this.addPlayer(info.id, Core.me);
			}
			super.addMe(info);
		}

		/**
		 * 添加其他living
		 * @param info
		 *
		 */
		override public function addLiving(info:LivingInfo,forceShow:Boolean=false):Living {
			return this.autoAddLiving(info,forceShow);
		}


		public function getPlayerBy(tag:String):LivingModel {
			if (tag == Core.me.info.idTag)
				return Core.me;
			for each (var living:LivingBase in this.livingArr) {
				if (living is LivingModel && tag == LivingModel(living).info.idTag) {
					return living as LivingModel;
				}
			}
			return null;
		}

		public function updatePlayerId(preId:int, newId:int):LivingModel {
			if (preId == newId)
				return this.getPlayer(preId);
			var living:LivingModel=this.getPlayer(preId);
//			return this.playerObj[newId]=living;
			return living;
		}

	}
}
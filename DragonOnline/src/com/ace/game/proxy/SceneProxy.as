/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-11-27 下午12:56:03
 */
package com.ace.game.proxy {

	import com.ace.astarII.child.INode;
	import com.ace.config.Core;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.core.SceneCore;
	import com.ace.game.scene.player.part.LivingBase;
	import com.ace.game.scene.player.part.LivingModel;
	import com.ace.game.scene.ui.SceneTipUI;
	import com.ace.game.utils.SceneUtil;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.SettingManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TLivingInfo;
	import com.ace.manager.GuideManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.map.MapWnd;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.ui.setting.AssistWnd;
	import com.ace.utils.AreaUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.PkMode;
	import com.leyou.net.cmd.Cmd_Attack;
	import com.leyou.net.cmd.Cmd_Yct;
	import com.leyou.ui.convenientuse.ConvenientUseManager;
	import com.test.Test200;
	import com.test.TestScene;
	
	import flash.geom.Point;
	import flash.utils.setTimeout;

	public class SceneProxy {

		/**升级*/
		static public function onLevelUp(id:int, level:int=0):void {
			var living:LivingModel=SceneCore.sceneModel.getPlayer(id);
			if (living == null)
				return;

			living.levelUp();
			if (Core.me.info.idTag != living.info.idTag) {
				return;
			}
			// 便捷换装
			ConvenientUseManager.getInstance().checkAvailable();
			// 右上角图标激活
			UIManager.getInstance().rightTopWnd.checkActiveIcon();
			// 功能预告
			UIManager.getInstance().funForcastWnd.checkFunction(level);
			UIManager.getInstance().moldWnd.checkFunction(level);
			// 功能指引
			GuideManager.getInstance().checkGuideByLevel(level);
			// 挂机可用药品
			AssistWnd.getInstance().refreshHpItem();
			// 可进入场景检测
			MapWnd.getInstance().refreshMapStatus();
			// 刷新野外BOSS
			if (UIManager.getInstance().isCreate(WindowEnum.BOSS)) {
				UIManager.getInstance().bossWnd.refreshBossItem();
			}
			
			if(UIManager.getInstance().isCreate(WindowEnum.DUNGEON_TEAM)){
				UIManager.getInstance().teamCopyWnd.updatePage();
			}
			
			UIManager.getInstance().toolsWnd.openFuncToLevel();

			UIManager.getInstance().roleWnd.openWingBuy();
			UIManager.getInstance().adWnd.updateState();
			if (UIManager.getInstance().isCreate(WindowEnum.MARKET)) {
				UIManager.getInstance().marketWnd.updateADState();
			}
		}

		/**移动结束*/
		static public function onMoveOver():void {
			UIManager.getInstance().taskNpcTalkWnd.outClosePanel();
		}

		/**站立*/
		static public function onStand():void {
			SceneTipUI.getInstance().removeMc(PlayerEnum.FILE_AUTO_WALK);
			MapWnd.getInstance().bigMap.hideTarget();

			if (int(MapInfoManager.getInstance().sceneId) == ConfigEnum.question16) {

				if (!UIManager.getInstance().isCreate(WindowEnum.QUESTION))
					UIManager.getInstance().creatWindow(WindowEnum.QUESTION);

				var pt:Point=Core.me.nowTilePt();
				if (MapInfoManager.getInstance().areaDic.hasOwnProperty(pt.x + ":" + pt.y)) {

					var i:int=MapInfoManager.getInstance().areaDic[pt.x + ":" + pt.y];

					switch (i) {
						case ConfigEnum.question12:
							UIManager.getInstance().questionWnd.onClickLeftBtn();
							break;
						case ConfigEnum.question14:
							UIManager.getInstance().questionWnd.onClickRightBtn();
							break;
					}

				} else {

					if (UIManager.getInstance().questionWnd.isSelectedWnd != null) {
						UIManager.getInstance().questionWnd.isSelectedWnd.setSelectState(false);
						UIManager.getInstance().questionWnd.isSelectedWnd=null;
					}

				}
			}
		}

		/**人物死亡*/
		static public function onDead():void {
			trace("人物死亡！！！");
			if (UIManager.getInstance().isCreate(WindowEnum.STOREGE))
				UIManager.getInstance().storageWnd.cancelBatchStore();
			if (SettingManager.getInstance().assitInfo.isAuto) {
				AssistWnd.getInstance().onButtonClick(null);
			} else {
				SettingManager.getInstance().assitInfo.clearPreIsAuto();
			}

			UIManager.getInstance().toolsWnd.stopAddMp();
		}

		/**人物移动*/
		static public function walkTick(livingBase:LivingBase):void {
			UIManager.getInstance().smallMapWnd.updatePs(livingBase);
			MapWnd.getInstance().bigMap.updatePs(livingBase.id, livingBase.x, livingBase.y);
		}

		/**修改新的目标点*/
		static public function changeTarget(pt:Point):void {
			MapWnd.getInstance().bigMap.changeTarget(pt);
		}

		/**跳转*/
		static public function flyTo(livingBase:LivingBase):void {
			UIManager.getInstance().smallMapWnd.updatePs(livingBase);
			MapWnd.getInstance().bigMap.updatePs(livingBase.id, livingBase.x, livingBase.y);
		}

		/**显示路径*/
		static public function showPaths(paths:Vector.<INode>):void {
			MapWnd.getInstance().bigMap.showPaths(paths);
		}

		//添加living
		static public function addLiving(livingBase:LivingBase):void {
			MapWnd.getInstance().bigMap.addLiving(livingBase);
		}

		//删除living
		static public function removeLiving(livingBase:LivingBase):void {
			MapWnd.getInstance().bigMap.removeLiving(livingBase.id, livingBase.race);
		}

		//地图加载完毕
		static public function onMapLoaded():void {
//			trace("进入地图：" + MapInfoManager.getInstance().sceneId);
			UIManager.getInstance().smallMapWnd.updateName();
			MapWnd.getInstance().bigMap.updateImg();

//			if (int(MapInfoManager.getInstance().sceneId) != ConfigEnum.DemonInvasion2 && int(MapInfoManager.getInstance().sceneId) != 320) {
//				UIManager.getInstance().taskTrack.show();
//			}

			CONFIG::offline {
				TestScene.addMe();
			}
//			TestScene.getInstance().delayTest();
//			setTimeout(Test200.getInstance().testOtherPlayer, 3000);
		}

		//场景重置
		static public function reset():void {
			MapWnd.getInstance().bigMap.clear();
		}

		static public function addSceneTipMc(id:int):void {
			SceneTipUI.getInstance().addMc(id);
		}

		static public function removeSceneTipMc(id:int):void {
			SceneTipUI.getInstance().removeMc(id);
		}

		/**接受任务*/
		static public function onTaskAccept():void {
			SceneTipUI.getInstance().addMc(PlayerEnum.FILE_TASK_ACCEPT);
		}

		/**任务完成*/
		static public function onTaskComplete():void {
			SceneTipUI.getInstance().addMc(PlayerEnum.FILE_TASK_COMPLETE);
		}

		static public function onRestBegin():void {
			SceneTipUI.getInstance().resetWnd.show();
		}

		static public function onRestEnd():void {
			SceneTipUI.getInstance().resetWnd.hide();
		}

		static public function playerIsInTeam(playerName:String):Boolean {
			return UIManager.getInstance().teamWnd.compareTeamPlayName(playerName);
		}


		static public function backPackIsFull(id:int=0):Boolean {
			if (id == 65535) {
				return true;
			}

			return MyInfoManager.getInstance().getBagEmptyGridIndex(id) == -1;
		}

		static public function onEscortBtnClick(isEnter:Boolean):void {
			if (isEnter) {
				Cmd_Yct.cm_DeliveryEnterCart()
			} else {
				Cmd_Yct.cm_DeliveryQuitCart();
			}
		}

		/**
		 * 根据自己pk模式，是否可以攻击他人
		 * @param living
		 * @return true为可攻击
		 *
		 */
		static public function canAttackOtherLiving(living:LivingModel):Boolean {

			if (null == living) {
				return false;
			}

			//在安全区不允许相互攻击
			if (Core.me.pInfo.isInSafety || //
				AreaUtil.checkSafe(SceneUtil.screenXToTileX(living.x), SceneUtil.screenYToTileY(living.y))) {
				NoticeManager.getInstance().broadcastById(9976);
				return false;
			}

			//地图不允许pk
			if (!MapInfoManager.getInstance().canPk()) {
				NoticeManager.getInstance().broadcastById(3507);
//				NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(3507));
				return false;
			}

			// 自己是新手模式
			if (PkMode.PK_MODE_FRESH == Core.me.info.pkMode) {
				NoticeManager.getInstance().broadcastById(2115);
//				NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(2115));
				return false;
			}

			// 死亡保护BUFF
			if (null != living.info.buffsInfo.getBuff(952)) {
				NoticeManager.getInstance().broadcastById(2117);
				return false;
			}

			// 对方为新手模式不可攻击
			if (PkMode.PK_MODE_FRESH == living.info.pkMode) {
				NoticeManager.getInstance().broadcastById(2116);
//				NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(2116));
				return false;
			}

			switch (Core.me.info.pkMode) {
				case PkMode.PK_MODE_FRESH:
					return false;
				case PkMode.PK_MODE_PEACE:
					NoticeManager.getInstance().broadcastById(2111);
//					NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(2111));
					return false;
				case PkMode.PK_MODE_GUILD:
					var sameGuild:Boolean=((null == Core.me.info.guildName) || (Core.me.info.guildName == living.info.guildName));
					if (sameGuild) {
						NoticeManager.getInstance().broadcastById(2111);
//						NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(2111));
					}
					return !sameGuild;
				case PkMode.PK_MODE_HYSTERICAL:
					return true;
				case PkMode.PK_MODE_KIND:
					var tliving:TLivingInfo=TableManager.getInstance().getLivingInfo(living.info.tId);
					if ((null != tliving) && (3 == tliving.npcType)) {
						NoticeManager.getInstance().broadcastById(2111);
						return false;
					}
					// 善恶模式下判断对象是否是全体模式,红名玩家强制性全体模式
					return (PkMode.PK_COLOR_RED == living.info.color) || (PkMode.PK_COLOR_GREY == living.info.color);
				case PkMode.PK_MODE_TEAM:
					var sameTeam:Boolean=UIManager.getInstance().teamWnd && UIManager.getInstance().teamWnd.compareTeamPlayName(living.info.name);
					if (sameTeam) {
						NoticeManager.getInstance().broadcastById(2111);
//						NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(2111));
					}
					return !sameTeam;
			}
			return true;
		}

		/**取消准备上马*/
		static public function cancelReadyMount():void {
			UIManager.getInstance().roleWnd.mountStopDown();
		}

		static public function sm_update_buff(id:int):void {
			Cmd_Attack.cm_bft_I(id);
		}

		static public function canHideLiving(living:LivingModel):Boolean {
			return (SettingManager.getInstance().assitInfo.isHideGuid && living.info.guildName == SceneCore.me.info.guildName) || //
				(SettingManager.getInstance().assitInfo.isHideOther)
			return false;
		}

	}
}

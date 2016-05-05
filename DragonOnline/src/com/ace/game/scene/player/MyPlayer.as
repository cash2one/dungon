package com.ace.game.scene.player {
	import com.ace.config.Core;
	import com.ace.enum.EventEnum;
	import com.ace.enum.ItemEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.game.core.SceneCore;
	import com.ace.game.manager.LogManager;
	import com.ace.game.manager.SceneMouseManager;
	import com.ace.game.proxy.ModuleProxy;
	import com.ace.game.scene.player.part.LivingBase;
	import com.ace.game.scene.player.part.LivingModel;
	import com.ace.game.scene.ui.SceneTipUI;
	import com.ace.game.scene.ui.child.Item;
	import com.ace.game.utils.SceneUtil;
	import com.ace.game.utils.TableUtil;
	import com.ace.gameData.buff.child.BuffInfo;
	import com.ace.gameData.item.LivingItemInfo;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.SettingManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TBuffInfo;
	import com.ace.manager.EventManager;
	import com.ace.manager.KeysManager;
	import com.ace.manager.UIManager;
	import com.ace.tools.FPS;
	import com.ace.ui.setting.AssistWnd;
	import com.ace.utils.AreaUtil;
	import com.ace.utils.DebugUtil;
	import com.leyou.net.cmd.Cmd_Attack;
	import com.leyou.net.cmd.Cmd_Scene;

	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;

	public class MyPlayer extends MyPlayerModel {
		public function MyPlayer() {
			super();
		}

		override public function die():void {
			DebugUtil.throwError("不该死亡");
		}

		//=======================协议===================================

		private var findeTime:int;
		private var preLen:int;
		protected var tmpLiving:LivingBase;

		override protected function findPath(pt:Point):Boolean {
			super.findPath(pt);
			tmpLiving=this.info.hasLookTarget() ? UIManager.getInstance().gameScene.getLivingBase(this.info.recordLookTargetId) : null;
			if (tmpLiving && tmpLiving.race == PlayerEnum.RACE_NPC && pt.equals(tmpLiving.nowTilePt()) || //
				(this.pInfo.hasWaitToTalk() && this.info.scenePathArr && this.info.scenePathArr.length == 0)) {
				this.info.pathArr.pop();
				this.info.pathArr.pop();
				this.info.pathArr.pop();
			}
			this.findeTime=getTimer();
			if (this.info.pathArr.length > 0)
				Cmd_Scene.cm_3002(0, uint(MapInfoManager.getInstance().sceneId), this.info.pathArr);
			return true;
		}

		override public function playDefaultAct(isSamePt:Boolean=false):Boolean {
			if (this.preLen == 1 || isSamePt) {
				this.preLen=0;
				FPS.getInstance().changeFrame(FPS.MIDDLE);
//				trace("移动完毕耗时：", this.info.speed, (getTimer() - this.findeTime));
				this.pInfo.changePreTargetTile(new Point(-1, -1));
				UIManager.getInstance().gameScene.hideMouseMc();
//				if (this.pInfo.currentTaskType == PlayerEnum.TASK_MONSTER) {
				if (this.pInfo.currentTaskType > 0) {
					this.pInfo.currentTaskType=-1;
					EventManager.getInstance().dispatchEvent(EventEnum.SETTING_AUTO_MONSTER);
				}
				!this.info.hasFollowOwner() && !this.pInfo.isTransing && Cmd_Scene.cm_3003(this);
			}
//			this.pInfo.currentTaskType=-1;
			return super.playDefaultAct(isSamePt);
		}

		override public function onSceneTrans(isFly:Boolean=false):void {
			super.onSceneTrans(isFly);
		}

		override public function stopMove():void {
			this.preLen=0;
			super.stopMove();
		}

//		override public function flyTo(tx:int, ty:int, stop:Boolean=true):void {
//			super.flyTo(tx, ty, stop);
//		}

		override public function nextStep():Boolean {
			if (this.info.pathArr.length == 0)
				return false;
			this.preLen=this.info.pathArr.length;
//			trace("还有多少步：", this.preLen);
			return super.nextStep();
		}

		override public function autoAttack():Boolean {
			var pt:Point=SceneUtil.tileToScreen(SceneMouseManager.getInstance().mouseTile().x, SceneMouseManager.getInstance().mouseTile().y);
			Cmd_Attack.cm_3010(1, this.info.recordAttackTargetId, pt.x, pt.y, this.x, this.y);
			super.autoAttack();
			return true;
		}

		override public function autoMagic():Boolean {
			if (this.info.isOnMount && !MapInfoManager.getInstance().isNeedMount) {
				this.info.clearPath();
				this.info.clearUseMageicState();
				this.info.clearTargetTile();
				KeysManager.getInstance().disPatchEvent(Keyboard.X, KeyboardEvent.KEY_UP);
				return true;
			}

			if (!this.info.isOnMount && MapInfoManager.getInstance().isNeedMount) {
				KeysManager.getInstance().disPatchEvent(Keyboard.X, KeyboardEvent.KEY_UP);
			}

			UIManager.getInstance().toolsWnd.updateCurrentCD(this.info.recordMagicId);
//			trace("释放技能：id" + this.info.recordMagicId + "	坐标：" + SceneMouseManager.getInstance().mouseTile());
			var receivePlayer:LivingModel=SceneCore.sceneModel.getPlayer(this.info.recordAttackTargetId);
			var pt:Point;
			if (receivePlayer != null && this.pInfo.isAutoMagic && TableUtil.isBulletSkill(this.info.recordMagicId)) { //如果有玩家，则发送玩家的中心位置，否则，鼠标的位置
				pt=new Point();
				pt.x=receivePlayer.x;
				pt.y=receivePlayer.y - receivePlayer.radius;
			} else {
				pt=SceneUtil.tileToScreen(this.info.recordTargetTile.x, this.info.recordTargetTile.y);
			}

			this.info.recordMagicId=this.selectSkillId(this.info.recordMagicId);
			Cmd_Attack.cm_3010(this.info.recordMagicId, this.info.recordAttackTargetId, pt.x, pt.y, this.x, this.y);
			super.autoMagic();
			return true;
		}

		override protected function onMoveOver():void {
			super.onMoveOver();
//			this.checkAutoPick();
			this.checkTrans();
			this.checkSafe();
			this.checkExp4();
		}


		/**检测传送*/
		private function checkTrans():void {
			if (AreaUtil.checkTrans(SceneUtil.screenXToTileX(this.x), SceneUtil.screenYToTileY(this.y), //
				Core.isTaiwan ? true : DataManager.getInstance().crossServerData.isOpen())) {
				this.onSceneTrans();
				this.pInfo.isTransing=true;
				Cmd_Scene.cm_tag(AreaUtil.getTransId(SceneUtil.screenXToTileX(this.x), SceneUtil.screenYToTileY(this.y)));
			}
		}

		private function checkSafe():void {
			if (AreaUtil.checkSafe(SceneUtil.screenXToTileX(this.x), SceneUtil.screenYToTileY(this.y))) {
				if (!this.pInfo.isInSafety) {
					ModuleProxy.broadcastMsg(9973); //进入安全区域
					this.pInfo.isInSafety=true;
				}
			} else {
				if (this.pInfo.isInSafety) {
					ModuleProxy.broadcastMsg(9974); //离开安全区域
					this.pInfo.isInSafety=false;
				}
			}
		}

		private function checkExp4():void {
			if (AreaUtil.checkExp4(SceneUtil.screenXToTileX(this.x), SceneUtil.screenYToTileY(this.y))) {
				if (!this.pInfo.isInExp4) {
					ModuleProxy.broadcastMsg(3097); //进入收益区
					this.pInfo.isInExp4=true;
				}
			} else {
				if (this.pInfo.isInExp4) {
					ModuleProxy.broadcastMsg(3098); //离开收益区
					this.pInfo.isInExp4=false;
				}
			}
		}

		override public function sm_addBuff(info:BuffInfo):Boolean {
			if (super.sm_addBuff(info)) {
				UIManager.getInstance().roleHeadWnd.buffWnd.addBuff(info);
				var tInfo:TBuffInfo=TableManager.getInstance().getBuffInfo(info.id);
				if (tInfo.effType == "e")
					UIManager.getInstance().toolsWnd.setStopState(true);
				return true;
			}
			return false
		}

		override public function sm_removeBuff(id:int):void {
			super.sm_removeBuff(id);
			UIManager.getInstance().roleHeadWnd.buffWnd.removeBuff(id);
			var tInfo:TBuffInfo=TableManager.getInstance().getBuffInfo(id);
			if (tInfo.effType == "e")
				UIManager.getInstance().toolsWnd.setStopState(false);
		}

		/**自动拾取*/
		override public function checkAutoPick():void {
			//暂时每一步都循环查找，到时候修改为字典索引
			if (!SettingManager.getInstance().assitInfo.isAutoPickupEquip && !SettingManager.getInstance().assitInfo.isAutopickupItem)
				return;

			var item:Item;
			var pt:Point=this.nowTilePt();
			for (var i:int=pt.x - 2; i < pt.x + 2; i++) {
				for (var j:int=pt.y - 2; j < pt.y + 2; j++) {
					if (i < 0 || i > MapInfoManager.getInstance().tileW || j < 0 || j > MapInfoManager.getInstance().tileH) {
						continue;
					}

					item=UIManager.getInstance().gameScene.findItem(new Point(i, j));
					if (!item || !item.bInfo.isDead || (!this.pInfo.isManualPickUp && LivingItemInfo(item.bInfo).throwOwnerId == this.info.id))
						continue;
//					if (item.bInfo.tId == 65535 || this.pInfo.isManualPickUp) {

					if (item.bInfo.tId == 65535) {
						this.pInfo.isManualPickUp=false;
						Cmd_Scene.cm_drop(item);
						continue;
					}

					if (SettingManager.getInstance().assitInfo.isAutoPickupEquip && //
						LivingItemInfo(item.bInfo).type == ItemEnum.ITEM_TYPE_EQUIP && //
						LivingItemInfo(item.bInfo).quality >= SettingManager.getInstance().assitInfo.autoPickEquipQuality) {
						this.pInfo.isManualPickUp=false;
						Cmd_Scene.cm_drop(item);
						continue;
					}

					if (SettingManager.getInstance().assitInfo.isAutopickupItem //
						&& LivingItemInfo(item.bInfo).type != ItemEnum.ITEM_TYPE_EQUIP && //
						LivingItemInfo(item.bInfo).quality >= SettingManager.getInstance().assitInfo.autoPickItemQuality) {
						this.pInfo.isManualPickUp=false;
						Cmd_Scene.cm_drop(item);
						continue;
					}


//					}
				}
			}
//			this.pInfo.isManualPickUp=false;
		}

		//========================状态改变时，需要改变外部模块的===================================

		override public function checkDazuo():Boolean {
			super.checkDazuo();
//			if (!this.info.isSit)
			this.info.isSit ? Cmd_Scene.cm_sit_s() : Cmd_Scene.cm_sit_o();
			return this.info.isSit;
		}

	}
}

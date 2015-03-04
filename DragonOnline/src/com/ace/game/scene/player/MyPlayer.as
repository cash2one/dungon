package com.ace.game.scene.player {
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
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.SettingManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.EventManager;
	import com.ace.manager.UIManager;
	import com.ace.tools.FPS;
	import com.ace.ui.setting.AssistWnd;
	import com.ace.utils.AreaUtil;
	import com.ace.utils.DebugUtil;
	import com.leyou.net.cmd.Cmd_Attack;
	import com.leyou.net.cmd.Cmd_Scene;

	import flash.geom.Point;
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
			Cmd_Attack.cm_3010(this.info.recordMagicId, this.info.recordAttackTargetId, pt.x, pt.y, this.x, this.y);
			super.autoMagic();
			return true;
		}

		override protected function onMoveOver():void {
			super.onMoveOver();
			this.checkAutoPick();
			this.checkTrans();
			this.checkSafe();
			this.checkExp4();
		}


		/**检测传送*/
		private function checkTrans():void {
			if (AreaUtil.checkTrans(SceneUtil.screenXToTileX(this.x), SceneUtil.screenYToTileY(this.y))) {
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
					ModuleProxy.broadcastMsg(3097); //进入安全区域
					this.pInfo.isInExp4=true;
				}
			} else {
				if (this.pInfo.isInExp4) {
					ModuleProxy.broadcastMsg(3098); //离开安全区域
					this.pInfo.isInExp4=false;
				}
			}
		}

		override public function sm_addBuff(info:BuffInfo):Boolean {
			if (super.sm_addBuff(info)) {
				UIManager.getInstance().roleHeadWnd.buffWnd.addBuff(info);
				return true;
			}
			return false
		}

		override public function sm_removeBuff(id:int):void {
			super.sm_removeBuff(id);
			UIManager.getInstance().roleHeadWnd.buffWnd.removeBuff(id);
		}

		/**自动拾取*/
		override public function checkAutoPick():void {
			//暂时每一步都循环查找，到时候修改为字典索引
			var item:Item;
			if (!SettingManager.getInstance().assitInfo.isAutoPickupEquip && !SettingManager.getInstance().assitInfo.isAutopickupItem)
				return;
			item=UIManager.getInstance().gameScene.findItem(this.nowTilePt());
			if (!item)
				return;
			if (SettingManager.getInstance().assitInfo.isAutoPickupEquip && LivingItemInfo(item.bInfo).type == ItemEnum.ITEM_TYPE_EQUIP) {
				Cmd_Scene.cm_drop(item);
				return;
			}
			if (SettingManager.getInstance().assitInfo.isAutopickupItem && LivingItemInfo(item.bInfo).type != ItemEnum.ITEM_TYPE_EQUIP) {
				Cmd_Scene.cm_drop(item);
				return;
			}
			if (item.bInfo.tId == 65535) {
				Cmd_Scene.cm_drop(item);
				return;
			}
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

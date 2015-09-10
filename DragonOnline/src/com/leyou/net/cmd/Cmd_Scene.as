package com.leyou.net.cmd {


	import com.ace.astarII.Node;
	import com.ace.astarII.child.INode;
	import com.ace.config.Core;
	import com.ace.enum.EventEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.SceneEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.manager.LogManager;
	import com.ace.game.proxy.SceneProxy;
	import com.ace.game.scene.player.Living;
	import com.ace.game.scene.player.part.LivingBase;
	import com.ace.game.scene.player.part.LivingModel;
	import com.ace.game.scene.ui.ReConnectionWnd;
	import com.ace.game.scene.ui.SceneTipUI;
	import com.ace.game.scene.ui.SceneUIManager;
	import com.ace.game.scene.ui.child.Item;
	import com.ace.game.utils.LivingUtil;
	import com.ace.game.utils.SceneUtil;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.SettingManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.player.LivingInfo;
	import com.ace.gameData.player.PlayerInfo;
	import com.ace.gameData.player.child.FeatureInfo;
	import com.ace.gameData.scene.child.SLivingInfo;
	import com.ace.manager.EventManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LoadingManager;
	import com.ace.manager.UIManager;
	import com.ace.tools.FPS;
	import com.ace.ui.FlyManager;
	import com.ace.ui.map.MapWnd;
	import com.ace.ui.setting.AssistWnd;
	import com.ace.ui.window.children.PopWindow;
	import com.ace.ui.window.children.WindInfo;
	import com.ace.utils.DebugUtil;
	import com.leyou.data.net.scene.PAddPlayerInfo;
	import com.leyou.data.net.scene.PSMPInfo;
	import com.leyou.data.net.scene.SMItemInfo;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;
	import com.test.TestPlayer;

	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getTimer;

	public class Cmd_Scene {

		public static function sm_game(obj:Object):void {

		}

		//服务器关闭
		public static function sm_cue(obj:Object):void {
			trace("服务器关闭");
			ReConnectionWnd.getInstance().show();
			return;
			var info:WindInfo=WindInfo.getAlertInfo(obj["c"]);
			info.isModal=true;
			info.allowDrag=false;
			info.showClose=false;
			PopWindow.showWnd(UIEnum.WND_TYPE_ALERT, info, "sm_cue");
		}

		//退出游戏
		public static function cm_quit():void {
			trace("通知服务期退出游戏");
			NetGate.getInstance().send(CmdEnum.CM_QUIT);
		}

		/**
		 * 切换场景
		 * @param areaId 传送点id、索引
		 *
		 */
		public static function cm_tag(areaId:int):void {
			//			trace("通知切换场景", areaId);
			NetGate.getInstance().send(CmdEnum.CM_TAG + "|" + areaId);
		}

		public static function cm_ulogi():void {
			NetGate.getInstance().send(CmdEnum.CM_ULOGI_I + UIEnum.PLAT_FORM_ID);
		}

		internal static var PRE_PS:Point;

		//通知进入地图
		public static function sm_r(obj:String):void {
			Core.me && (PRE_PS=Core.me.nowTilePt());
			trace("进入地图：", getTimer(), obj, "传送前地点：", PRE_PS);


			obj=obj.split("|")[1];
			var mapId:String=obj.split(",")[1];

			EventManager.getInstance().dispatchEvent(EventEnum.SCENE_TRANS, TableManager.getInstance().getSceneInfo(mapId).type != SceneEnum.SCENE_TYPE_PTCJ);
			LayerManager.getInstance().windowLayer.hideAllWnd();

			UIManager.getInstance().gameScene.gotoMap(mapId, new Point(0, 0));
//			MyInfoManager.getInstance().roomId=int(obj.split(",")[1]);
//			trace("房间id:"+MyInfoManager.getInstance().roomId);
//			KeysManager.getInstance().addKeyFun(Keyboard.I,cm_r);
//			cm_r();
			Core.isTencent && cm_tx();
			cm_ulogi();
		}

		internal static var isFirst:Boolean=true; //

		public static function cm_tx():void {
			if (!isFirst)
				return;
			isFirst=false;
			NetGate.getInstance().send(CmdEnum.CM_TX + Core.TX_OPENID + "," + Core.TX_OPENKEY + "," + //
				Core.TX_APPID + "," + Core.TX_SIG + "," + Core.TX_PF + "," + Core.TX_PFKey + "," + Core.TX_ZONEID);
		}

		//加载资源完毕
		public static function cm_r():void {
//			trace("qzq:发送资源加载完毕",getTimer());
			EventManager.getInstance().dispatchEvent(EventEnum.SCENE_LOADED);
			NetGate.getInstance().send(CmdEnum.CM_R);
		}

		//添加他人、怪物、npc
		public static function sm_3000(br:ByteArray):void {
			br.position=3;
			var info:PAddPlayerInfo
			var linfo:LivingInfo;
			while (br.bytesAvailable > 10) {
				info=new PAddPlayerInfo(br);
				//				if (info.race == PlayerEnum.RACE_ESCORT) { //特殊处理
				//					if (info.followId == MyInfoManager.getInstance().id) {
				//					} else {
				//						info.race=PlayerEnum.RACE_HUMAN;
				//					}
				//				}
				if (info.idTag == MyInfoManager.getInstance().idTag) { //添加自己
					SceneUIManager.getInstance().changeSyncId(MyInfoManager.getInstance().id, info.id);
					UIManager.getInstance().gameScene.livingMap.change(MyInfoManager.getInstance().id, info.id);
					PAddPlayerInfo.copyToLivingInfo(info, MyInfoManager.getInstance());
					addMe();
					UIManager.getInstance().gameScene.updatePlayerId(Core.me.info.id, info.id);
					Core.me.info.currentDir=-1;
					Core.me.changeDir(info.dir);
					FPS.getInstance().startDetect();
				} else { //添加他人
					linfo=LivingInfo.getDefaultInfo();
					PAddPlayerInfo.copyToLivingInfo(info, linfo);
					UIManager.getInstance().gameScene.addLiving(linfo);
				}
					//				trace("添加玩家：" + info.id);
			}
		}

		static private function addMe():void {
			if (!Core.me)
				UIManager.getInstance().gameScene.addMe(MyInfoManager.getInstance());
		}

		//添加自己
		public static function sm_3001(br:ByteArray):void {
			br.position=3;
			br.position++;
			var idTag:String=br.readMultiByte(br.readUnsignedByte(), "utf-8");
			br.position++;
			var isFollow:Boolean=br.readBoolean();
			br.position++;
			var px:int=br.readUnsignedShort();
			br.position++;
			var py:int=br.readUnsignedShort();
			var info:PlayerInfo;
			if (Core.me) {
				info=MyInfoManager.getInstance();
			} else {
				info=TestPlayer.getPlayerInfo();
				info.idTag=idTag;
			}
			trace("sm_3001：添加自己坐标点", SceneUtil.screenToTile(px, py));
			if (!MapInfoManager.getInstance().walkable(SceneUtil.screenXToTileX(px), SceneUtil.screenYToTileY(py))) {
				DebugUtil.throwError("3011协议异常：人物传送到障碍点" + SceneUtil.screenToTile(px, py));
			}
			if (PRE_PS && SceneUtil.screenToTile(px, py).equals(PRE_PS)) {
				DebugUtil.throwError("3011协议异常：人物和上次场景位置相同" + SceneUtil.screenToTile(px, py));
			}
			var len:int=Core.me ? Core.me.info.scenePathArr.length : -1;
			UIManager.getInstance().gameScene.gotoPt(SceneUtil.screenToTile(px, py));
			UIManager.getInstance().gameScene.addMe(info);
			Core.me.pInfo.isTransing=false;
			Core.me.pInfo.changeAutoMonsterPs(SceneUtil.screenToTile(px, py));
			LoadingManager.getInstance().hide();
			if (Core.me.pInfo.currentTaskType > 0 && len == 0) {
				Core.me.pInfo.currentTaskType=-1;
				EventManager.getInstance().dispatchEvent(EventEnum.SETTING_AUTO_MONSTER);
			}
			//			EventManager.getInstance().dispatchEvent(EventEnum.SCENE_TRANS);
			//			TestPlayer.onSpace(); //测试
		}

		//行走：服务器
		public static function sm_3002(br:ByteArray):void {
			br.position=3;
			br.position++;
			var time:int=br.readUnsignedShort();
			while (br.bytesAvailable) {
				br.position++;
				var id:uint=br.readUnsignedShort();


				br.position++;
				var len:uint=br.readUnsignedShort() >> 2;

				var path:Vector.<INode>=new Vector.<INode>;
				var pt:Point=new Point();
				var sDs:String="";
				for (var i:int=0; i < len; i++) {
					pt.x=br.readUnsignedShort();
					pt.y=br.readUnsignedShort();
					sDs+=pt.toString();
					path.push(new Node(SceneUtil.screenXToTileX(pt.x), SceneUtil.screenYToTileY(pt.y)));
						//				path.push(new Node(SceneUtil.screenXToTileX(br.readUnsignedShort()), SceneUtil.screenYToTileY(br.readUnsignedShort())));
				}
				//			trace("接受像素点：" + sDs);
				var player:LivingModel=UIManager.getInstance().gameScene.getPlayer(id);
				if (!player || id == Core.me.id) {
//					trace("没有找到该玩家");
					continue;
				}

				CONFIG::debug {
					sm_3002_check2(path, player);
					sm_3002_check(path);
				}
				Living(player).sm_walk(path);
			}
		}

		//测试路点是否正确
		static private function sm_3002_check2(path:Vector.<INode>, player:LivingModel):void {
			var pt:Point=new Point(path[0].x, path[0].y);
			if (!SceneUtil.ptNeighbour(pt, player.nowTilePt())) {
				LogManager.getInstance().showLog("【错误：3002协议，起始路点不正确】", LogManager.TYPE_ERROR);
				LogManager.getInstance().showLog("人物位置：" + player.nowTilePt());
				LogManager.getInstance().showLog("服务器路点：" + path.toString());
			}
		}

		//测试路点是否重复
		static private function sm_3002_check(path:Vector.<INode>):void {
			if (path.length < 2)
				return;

			if (path[0].x == path[1].x && path[0].y == path[1].y) {
				LogManager.getInstance().showLog("【错误：3002协议，路点重复】", LogManager.TYPE_ERROR);
				LogManager.getInstance().showLog("服务器路点：" + path.toString());
			}
		}

		//客户端：矫正人物位置
		static public function cm_3003(living:LivingModel):void {
//			trace("客户端发送：", "矫正自己的位置", living.nowTilePt());
			var br:ByteArray=new ByteArray();
			br.endian=Endian.LITTLE_ENDIAN;
			br.writeByte(0xFF);
			br.writeShort(CmdEnum.CM_3003);
			br.writeByte(0x22);
			br.writeShort(living.x);
			br.writeByte(0x32);
			br.writeShort(living.y);
			br.writeByte(0x01);
			br.writeByte(living.info.currentDir);
			br.position=0;
			NetGate.getInstance().send(br);
		}

		//服务器：矫正人物位置
		static public function sm_3003(br:ByteArray):void {
			br.position=3;
			br.position++;
			var stag:int=br.readUnsignedShort();
			br.position++;
			var px:int=SceneUtil.screenXToTileX(br.readUnsignedShort());
			br.position++;
			var py:int=SceneUtil.screenYToTileY(br.readUnsignedShort());
			br.position++;
			var dir:int=br.readByte();

			var living:LivingModel=UIManager.getInstance().gameScene.getPlayer(stag);
			if (!living /*|| Core.me == living*/)
				return;
			if (Core.me == living)
				return;
			living.flyTo(px, py);
		}

		//传送
		static public function sm_3005(br:ByteArray):void {
			br.position=3;
			br.position++;
			var stag:int=br.readUnsignedShort();
			br.position++;
			var px:int=SceneUtil.screenXToTileX(br.readUnsignedShort());
			br.position++;
			var py:int=SceneUtil.screenYToTileY(br.readUnsignedShort());
			br.position++;
			var dir:int=br.readByte();
			var living:LivingModel=UIManager.getInstance().gameScene.getPlayer(stag);
			if (!living)
				return;
			living.flyTo(px, py);
			living.addEffect(27014); //传送特效
			if (living == Core.me) {
				Core.me.pInfo.changeAutoMonsterPs(Core.me.nowTilePt());
				if (Core.me.pInfo.currentTaskType > 0) {
					Core.me.pInfo.currentTaskType=-1;
					EventManager.getInstance().dispatchEvent(EventEnum.SETTING_AUTO_MONSTER);
				}
			}
			trace(getTimer(), "传送瞬移", living.info.name, px, py);
		}


		// 改变名字颜色
		static public function sm_3020(br:ByteArray):void {
			br.position=3;
			br.position++;
			var stag:int=br.readUnsignedShort();
			br.position++;
			var living:LivingModel=UIManager.getInstance().gameScene.getPlayer(stag);
			if (!living) {
				return;
			}
			living.info.color=br.readUnsignedShort();
			living.ui.showName(living.info);
		}

		//行走：客户端
		public static function cm_3002(time:uint, roomId:uint, path:Vector.<INode>):void {
			//			trace("行走速度：" + Core.me.info.speed);
			//			tracePath("cm发送的路点：", path);
			var br:ByteArray=new ByteArray();
			br.endian=Endian.LITTLE_ENDIAN;
			br.writeByte(0xFF);
			br.writeShort(CmdEnum.CM_3002);
			br.writeByte(0x02);
			br.writeShort(time);
			br.writeByte(0x12);
			br.writeShort(roomId);
			br.writeByte(0x07);
			br.writeShort(4 * path.length); //会有bug：只有1个字节长度
			var sDs:String="";
			var pt:Point=new Point();
			for (var i:int=0; i < path.length; i++) {
				pt.x=path[i].x * SceneEnum.TILE_WIDTH + SceneEnum.TILE_HALFW;
				pt.y=path[i].y * SceneEnum.TILE_HEIGHT + SceneEnum.TILE_HALFH;
				sDs+=pt.toString();
				br.writeShort(path[i].x * SceneEnum.TILE_WIDTH + SceneEnum.TILE_HALFW);
				br.writeShort(path[i].y * SceneEnum.TILE_HEIGHT + SceneEnum.TILE_HALFH);
			}

			//trace("发送像素点：" + sDs);
			br.position=0;
			//			trace(HexUtil.toHexDump("发送协议", br, 0, br.length));
			NetGate.getInstance().send(br);
		}

		static private function tracePath(des:String, path:Vector.<INode>):void {
			for (var i:int=0; i < path.length; i++) {
				des+=path[i].toString();
			}
			trace(des);
		}

		internal static var IS_FIRST_LOGIN:Boolean=false; //是否第一次登陆

		//换装
		static public function sm_p(obj:String):void {
			var tag:String=obj.split("|")[1];
			var living:LivingModel=UIManager.getInstance().gameScene.getPlayerBy(tag);

			if (!living)
				return;


			var fInfo:FeatureInfo=PSMPInfo.readTo(obj, living.info);
			//			living.changeAvatars(fInfo);

			//			trace("服务器添加角色：",living.id,living.info.name);
			living.ui && living.ui.showName(living.info);
			living.ui && living.ui.updataHp(living.info);
			living.sm_updateTitle(living.info.tileNames);

			if (living.info.preIsOnMount) {
				living.info.isOnMount=!living.info.isOnMount;
				living.info.featureInfo=fInfo;
			} else if (living.info.isJumping) {
				living.info.featureInfo=fInfo;
			} else {
				living.changeAvatars(fInfo);
			}

			//如果他人骑坐骑打坐进入自己视野，则下马打坐
			if (living.info.isSit && living.info.isOnMount && !living.info.preIsOnMount) {
				living.info.preIsOnMount=true;
				living.info.isOnMount=!living.info.isOnMount;
				living.info.featureInfo=fInfo;
				living.changeAvatars(fInfo);
			}

			//如果是自己
			if (living.id == Core.me.info.id) {
//				living.info.isSit&&living.checkDazuo();
				living.updataHealth(living.info.hp, living.info.mp);
//				if (!Core.clientTest) {
				if (IS_FIRST_LOGIN) {
					LivingUtil.updataPropUI();
					UIManager.getInstance().roleWnd.updateRoleAvatar();
					UIManager.getInstance().teamWnd.updateSelfAvatar();
					UIManager.getInstance().roleWnd.updateVipEquip();
					if (UIManager.getInstance().vipWnd) {
						UIManager.getInstance().vipWnd.updateVipLv();
					}
					if (UIManager.getInstance().teamCopyWnd) {
						UIManager.getInstance().teamCopyWnd.storyCopy.updateVipLv();
					}
				} else {
					IS_FIRST_LOGIN=true; // 读取缓存配置
					UIManager.getInstance().roleHeadWnd.setMode(living.info.pkMode);
					UIManager.getInstance().rightTopWnd.checkActiveIcon();
					UIManager.getInstance().funForcastWnd.checkFunction(living.info.level);
					UIManager.getInstance().moldWnd.lockMoldByLevel();
					SettingManager.getInstance().assitInfo.loadCookie();
					UIManager.getInstance().soundConfig.loadSetting();
					UIManager.getInstance().viewConfig.loadSetting();
					UIManager.getInstance().petIconbar.checkActive();
					// 挂机可用药品
					AssistWnd.getInstance().refreshHpItem();
					// 刷新可用地图
					MapWnd.getInstance().refreshMapStatus();
				}

//				}
			} else {
//				if (living.info.preIsOnMount && !living.info.isOnMount) {
//					living.onMount();
//				}
			}

			sm_shenQi(living.info.vipEquipId, living.info.id);
			sm_equipEffect(living.info.id);
			sm_lockChange(living);
			sm_hideGuidLiving(living);

			sm_onAddPet(living);

			if (living.info.race == PlayerEnum.RACE_PET) {
				living.addEffect(TableManager.getInstance().getPetStarLvInfo(living.info.tId, living.info.color).pnfId2);
			}
		}

		static public function sm_onAddPet(living:LivingModel):void {
			if (living.id == Core.me.info.id)
				return;
			if (String(living.info.tileNames[1]).indexOf(Core.me.info.name) != -1) {
				trace("自己的佣兵");
				Core.pet=living;
				Core.me.info.petId=living.id;
				EventManager.getInstance().dispatchEvent(EventEnum.PET_ADD);
			}
		}

		static public function sm_onDelPet(id:int):void {
			if (id == Core.me.info.id)
				return;
			if (Core.me.info.petId == id) {
				trace("删除佣兵");
				EventManager.getInstance().dispatchEvent(EventEnum.PET_DEL);
				Core.pet=null;
				Core.me.info.petId=-1;
			}
		}

		static public function sm_hideGuidLiving(living:LivingModel):void {
			if (living == Core.me || living.race != PlayerEnum.RACE_HUMAN)
				return;
			living.switchVisible(SceneProxy.canHideLiving(living));
		}

		static public function sm_lockChange(living:LivingModel):void {
			if (!Core.me.pInfo.isLockAttackTarget)
				return;
//			trace("是否是锁定玩家：", living.info.name, Core.me.pInfo.lockAttackName);
			if (living.info.name == Core.me.pInfo.lockAttackName && !living.info.isHiding) {
				Core.me.pInfo.changeLockTarget(living.id);
				EventManager.getInstance().dispatchEvent(EventEnum.LOCK_TARGET_IN);
			}
		}

		//特殊强化装备特效
		static public function sm_equipEffect(id:int):void {
			var livingModel:LivingModel=UIManager.getInstance().gameScene.getPlayer(id);
//			livingModel.info.equipLv=8;
			livingModel.removeEffectBy(-3);
			livingModel.removeEffectBy(17);
			if (livingModel.info.equipColor == 3) {
				livingModel.addEffect(99928);
			} else if (livingModel.info.equipColor == 4) {
				livingModel.addEffect(99929);
			} else {
				livingModel.removeEffectBy(-3);
			}

			if (livingModel.info.equipLv >= 16) {
				livingModel.addEffect(99932);
			} else if (livingModel.info.equipLv >= 12) {
				livingModel.addEffect(99931);
			} else if (livingModel.info.equipLv >= 8) {
				livingModel.addEffect(99930);
			} else {
				livingModel.removeEffectBy(17);
			}
		}

		/**
		 * 神器
		 * @param id 神器id
		 * @param ownerId 角色id
		 *
		 */
		static public function sm_shenQi(id:int, ownerId:int):void {
			var livingModel:LivingModel=UIManager.getInstance().gameScene.getPlayer(ownerId);
			if (!livingModel)
				return;

			if (id > 0 && !livingModel.info.hasShenQi()) {
				UIManager.getInstance().gameScene.autoAddShenQi(TableManager.getInstance().getVipDetailInfo(id).modelSmallId, ownerId);
			}

			if (id > 0 && livingModel.info.hasShenQi()) {
				var shenqi:LivingModel=UIManager.getInstance().gameScene.getPlayer(livingModel.info.shenQiId);
				if (shenqi.info.featureInfo.suit != TableManager.getInstance().getVipDetailInfo(id).modelSmallId) {
					shenqi.info.featureInfo.suit=TableManager.getInstance().getVipDetailInfo(id).modelSmallId;
					shenqi.changeAvatars(shenqi.info.featureInfo, true);
				}
			}

			if (id == 0 && livingModel.info.hasShenQi()) {
				UIManager.getInstance().gameScene.delLivingBase(livingModel.info.shenQiId);
				livingModel.info.shenQiId=0;
			}
		}

		//人物同步标志信息：npc头顶、组队标志、摆摊标志
		static public function sm_a(obj:String):void {
			var arr:Array=String(obj.split("|")[1]).split(",");
			if (arr.length <= 1)
				return;


			var livingModel:LivingModel=UIManager.getInstance().gameScene.getPlayer(arr[0]);
			var sLivingInfo:SLivingInfo=MapInfoManager.getInstance().getLivingInfo(arr[0]);

			for (var i:int=1; i < arr.length; i++) {
				livingModel && livingModel.info.clearIcoState();
				sLivingInfo && sLivingInfo.clearState();
				switch (int(arr[i])) {
					case PlayerEnum.NPC_TASK_ACCEPT:
					case PlayerEnum.NPC_TASK_COMPLETE:
					case PlayerEnum.NPC_TASK_UNDONE:
						livingModel && (livingModel.info.taskState=arr[i]);
						sLivingInfo && (sLivingInfo.taskState=arr[i]);
						break;
				}
			}
			livingModel && livingModel.ui.showName(livingModel.info);
		}

		/**删除living*/
		static public function sm_d(obj:String):void {
			obj=obj.split("|")[1];
			var arr:Array=obj.split(",");
			for (var i:int=0; i < arr.length; i++) {
				sm_onDelPet(arr[i]);
				UIManager.getInstance().gameScene.delLivingBase(arr[i]);
			}
		}

		/**显示道具*/
		static public function sm_drop_a(br:ByteArray):void {
			SMItemInfo.parse(br, UIManager.getInstance().gameScene.addItem);
		}

		/**删除道具*/
		static public function sm_drop_d(br:ByteArray):void {
			br.position=3;
			br.position++;
			UIManager.getInstance().gameScene.removeItem(br.readUnsignedShort());
		}

		/**拾取道具*/
		static public function cm_drop(item:Item):void {
			//			trace("发送拾取道具协议：", item.id);
			NetGate.getInstance().send(CmdEnum.CM_DROP + item.id.toString());
		}

		/**拾取道具成功*/
		static public function smd_drop_s(obj:Object):void {
			var livingBase:LivingBase=UIManager.getInstance().gameScene.getLivingBase(obj["stag"]);
			if (livingBase != null && livingBase is Item) {
				FlyManager.getInstance().flyBags([livingBase.bInfo.tId], [livingBase.localToGlobal(new Point())], null, 1);
			}
		}

		/**拾取道具失败*/
		static public function smd_drop_f(obj:Object):void {
			var livingBase:LivingBase=UIManager.getInstance().gameScene.getLivingBase(obj["stag"]);
			if (livingBase != null && livingBase is Item) {
				Item(livingBase).pickFailEffect();
			}

			Core.me.pInfo.prePickFailTime=getTimer();
		}

		static public function sm_onMount():void {

		}

		/**打坐-开始*/
		static public function cm_sit_s():void {
			NetGate.getInstance().send(CmdEnum.CM_SIT_S);
		}

		/**打坐-结束*/
		static public function cm_sit_o():void {
			NetGate.getInstance().send(CmdEnum.CM_SIT_O);
		}

		/**打坐-信息*/
		static public function sm_sit_s(obj:Object):void {
			SceneTipUI.getInstance().resetWnd.sm_update(obj["exp"], obj["hl"]);
		}

		/**人物状态改变*/
		static public function sm_ust_u(obj:Object):void {
			var living:LivingModel=UIManager.getInstance().gameScene.getPlayer(obj["stag"]);
			if (!living)
				return;
			switch (obj["sttype"]) {
				case 1:
					SceneProxy.onLevelUp(living.id, obj["svar"][0]);
					break;
				case 2:
					(obj["svar"][0] == 1) && living.addEffect(PlayerEnum.FILE_ON_MOUNT);
					//					!living.info.preIsOnMount && living.changeAvatars(living.info.featureInfo, true);
					break;
				case 3:
					if (living == Core.me)
						return;
					living.info.isSit=obj["svar"][0];
					break;
				case 4:
					sm_shenQi(obj["svar"][0], living.info.id);
					if (living == Core.me) {
						Core.me.info.vipEquipId=obj["svar"][0];
						UIManager.getInstance().roleWnd.updateVipEquip();
					}
					break;
				case 5:
					living.info.equipLv=obj["svar"][0];
					living.info.equipColor=obj["svar"][1];
					sm_equipEffect(living.info.id);
					break;
				case 6:
					living.info.name=obj["svar"][0];
					living.ui.showName(living.info);
					break;
			}
		}


		//更新自己镖车状态信息:进出镖车
		public static function sm_3004(br:ByteArray):void {
			br.position=3;
			var info:PAddPlayerInfo;
			var living:LivingModel;
			var linfo:LivingInfo;

			while (br.bytesAvailable > 10) {
				info=new PAddPlayerInfo(br);
				living=UIManager.getInstance().gameScene.getPlayer(info.id);
				if (info.id == MyInfoManager.getInstance().id) { //添加自己
					trace("自己跟随：", info.followId);
					Core.me.onFollow(info.followId);
					if (UIManager.getInstance().isCreate(WindowEnum.DELIVERYPANEL)) {
						UIManager.getInstance().deliveryPanel.changeEnterCartState((info.followId != 0));
					}

				} else if (!living) { //添加他人
					linfo=LivingInfo.getDefaultInfo();
					PAddPlayerInfo.copyToLivingInfo(info, linfo);
					UIManager.getInstance().gameScene.addLiving(linfo);
				}
			}
		}

	}
}

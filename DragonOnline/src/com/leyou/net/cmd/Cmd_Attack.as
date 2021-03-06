package com.leyou.net.cmd {
	import com.ace.config.Core;
	import com.ace.enum.EffectEnum;
	import com.ace.enum.EventEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.core.SceneCore;
	import com.ace.game.manager.BulletManager;
	import com.ace.game.scene.player.Living;
	import com.ace.game.scene.player.part.LivingModel;
	import com.ace.game.scene.ui.CopyReviveWnd;
	import com.ace.game.scene.ui.ReviveWnd;
	import com.ace.game.scene.ui.SceneUIManager;
	import com.ace.game.scene.ui.head.OtherHead;
	import com.ace.game.utils.LivingUtil;
	import com.ace.game.utils.SceneUtil;
	import com.ace.game.utils.TableUtil;
	import com.ace.gameData.buff.child.BuffInfo;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.SettingManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.player.child.FeatureInfo;
	import com.ace.gameData.table.TBuffInfo;
	import com.ace.gameData.table.TSkillEffectInfo;
	import com.ace.gameData.table.TSkillInfo;
	import com.ace.manager.EventManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.SoundManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.setting.AssistWnd;
	import com.ace.utils.DebugUtil;
	import com.leyou.enum.CmdEnum;
	import com.leyou.enum.PkMode;
	import com.leyou.net.NetGate;
	import com.leyou.ui.element.ElementUtil;
	import com.leyou.utils.EffectUtil;
	
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getTimer;

	public class Cmd_Attack {

		//清空技能CD
		static public function sm_3021(br:ByteArray):void {
			Core.me.info.clearMagicCD();
			UIManager.getInstance().toolsWnd.clearSkillAllCD()
		}

		/**
		 * 技能：客户端
		 * @param skillId
		 * @param targetId	目标着id
		 * @param mx 鼠标像素坐标
		 * @param my
		 *
		 */
		static public function cm_3010(skillId:int, targetId:int, mx:int, my:int, playerX:int, playerY:int):void {
//			trace("发送攻击：" + skillId, targetId, SceneUtil.screenToTile(mx, my), SceneUtil.screenToTile(playerX, playerY));
			//			trace("距离：", Point.distance(new Point(mx, my), new Point(playerX, playerY)));
			//			ModuleProxy.showChatMsg("攻击技能：" + skillId +"攻击者id："+ targetId);
			var br:ByteArray=new ByteArray();
			br.endian=Endian.LITTLE_ENDIAN;
			br.writeByte(0xFF);
			br.writeShort(CmdEnum.CM_3010);
			br.writeByte(0x42);
			br.writeShort(skillId);
			br.writeByte(0x02);
			br.writeShort(targetId);
			br.writeByte(0x22);
			br.writeShort(mx);
			br.writeByte(0x32);
			br.writeShort(my);
			br.writeByte(0x52);
			br.writeShort(playerX);
			br.writeByte(0x62);
			br.writeShort(playerY);
			br.position=0;
			NetGate.getInstance().send(br);
		}

		/**怪物说话*/
		static public function sm_ntk_i(obj:Object):void {
			var living:LivingModel=UIManager.getInstance().gameScene.getPlayer(obj["stag"]);
			if (!living)
				return;
			SceneUIManager.getInstance().addChatII(living, obj["con"]);
		}

		//技能：服务器
		static public function sm_3010(br:ByteArray):void {
			br.position=3;
			br.position++;
			var sendId:int=br.readShort();
			br.position++;
			var skillId:int=br.readShort();
			br.position++;
			var receiveId:int=br.readShort();
			br.position++;
			var mx:int=br.readShort();
			br.position++;
			var my:int=br.readShort();
			br.position++;
			var bulletId:int=br.readShort();

			mx=SceneUtil.screenXToTileX(mx);
			my=SceneUtil.screenYToTileY(my);

			var beLving:LivingModel=UIManager.getInstance().gameScene.getPlayer(receiveId);
			if (beLving) {
				beLving.info.changeRecordBeAttack(sendId, skillId);
			}


			if (sendId == Core.me.id) {
				if (skillId >= 1200 && skillId <= 1400) {
					var skillInfo:TSkillInfo=TableManager.getInstance().getSkillInfo(skillId);
					var effectInfo:TSkillEffectInfo=TableManager.getInstance().getSkillEffectInfo(skillInfo.getEffectId(Core.me.info.skillEffectId));
					SoundManager.getInstance().play(effectInfo.sound);
				}
				return;
			}
			var player:LivingModel=UIManager.getInstance().gameScene.getPlayer(sendId);
			if (!player) {
				//				DebugUtil.throwError("没有找到该玩家");
				return;
			}
			//			LogManager.getInstance().showLog("接受技能：id" + skillId + "	坐标：" + mx + "-" + my);
			Living(player).sm_actAttaack(skillId, receiveId, mx, my);

			if (player.race == PlayerEnum.RACE_PET && skillId > 10) {
				SceneUIManager.getInstance().addChatII(player, TableManager.getInstance().getSkillInfo(skillId).name);
			}
		}

		//战斗伤害：特效
		static public function sm_3011(br:ByteArray):void {
			if (!Core.me)
				return;
			br.position=3;
			var living:LivingModel;
			br.position++;
			var skillId:int=br.readUnsignedShort();
			br.position++;
			var bulletId:int=br.readUnsignedShort();
			br.position++;
			var sendId:int=br.readUnsignedShort();
			// 发起攻击实体
			var sendLiving:LivingModel=UIManager.getInstance().gameScene.getPlayer(sendId);

			if (null == sendLiving) {
				return;
			}

			if (skillId != 10000)
				var times:int=TableUtil.getDamTimes(skillId, sendLiving.info.skillEffectId);


//						trace("+++++++++++++++++++sm.3011++begin++tick = "+new Date().toString())
			while (br.bytesAvailable) {
				br.position++;
				var stag:int=br.readUnsignedShort();
				living=UIManager.getInstance().gameScene.getPlayer(stag);

				br.position++;
				var hurtNum:int=br.readByte();
				for (var i:int=0; i < hurtNum; i++) {
					br.position++;
					var hurtType:int=br.readByte(); //（1普通攻击，2暴击，3闪避...）
					br.position++;
					var propName:int=br.readByte(); //(1掉血，2 掉蓝, 3 元素伤害)
					br.position++;
					var value:int=br.readInt();
					// 被攻击实体
					if (!living)
						continue;
//					trace("-------------------------------战斗伤害" + living.info.name + "|" + propName + "-" + value);
					var color:String;
					var strFront:Boolean;
					if (living == Core.me) {
						if (propName == 1) {
							// 区别佣兵
							if (sendLiving.race == PlayerEnum.RACE_PET && 3 != hurtType) {
								color=EffectEnum.COLOR_PURPLE;
								// 佣兵使用100，伤害前加佣兵两字
								hurtType=100;
								strFront=false;
							} else {
								strFront=true;
								color=EffectEnum.COLOR_YELLOW;
							}
							SceneUIManager.getInstance().addEffect(living, EffectEnum.BUBBLE_LEFT, value, color, EffectUtil.getEffectName(hurtType), "", null, false, strFront, times);
						} else if (propName == 2) {
							SceneUIManager.getInstance().addEffect(living, EffectEnum.BUBBLE_LEFT, value, EffectEnum.COLOR_BLUE, EffectUtil.getEffectName(hurtType), "", null, false, true, times);
						} else {
							strFront=false;
							hurtType=ElementUtil.getHurtType(sendLiving.info.baseInfo.yuanS, living.info.baseInfo.yuanS, true);
							SceneUIManager.getInstance().addEffect(living, EffectEnum.BUBBLE_RIGHT, value, EffectEnum.COLOR_YELLOW, EffectUtil.getEffectName(hurtType), "", null, false, strFront, times);
						}
						// 和平模式下被攻击
						if ((sendLiving.race == PlayerEnum.RACE_HUMAN) && (PkMode.PK_MODE_PEACE == Core.me.info.pkMode)) {
							GuideManager.getInstance().showGuide(7, UIManager.getInstance().roleHeadWnd.getUIbyID("modeBtn"));
						}
					} else {
						//					var log:String = "------------------------cmd_attack.3011--stag={1},hurtNum={2},hurtNum={3},propName={4},value={5}";
						//					trace(StringUtil.substitute(log, stag, hurtNum, hurtType, propName, value))
						if (!sendLiving) {
							SceneUIManager.getInstance().addEffect(living, EffectEnum.BUBBLE_LINE, value, EffectEnum.COLOR_RED, EffectUtil.getEffectName(hurtType), "", null, false, true, times);
						} else {
							// 元素伤害
							if (propName == 3) {
								strFront=false;
								hurtType=ElementUtil.getHurtType(sendLiving.info.baseInfo.yuanS, living.info.baseInfo.yuanS);
								SceneUIManager.getInstance().addEffect(living, EffectEnum.BUBBLE_LEFT, value, color, EffectUtil.getEffectName(hurtType), "", //
									[new Point(sendLiving.x, sendLiving.y - sendLiving.radius), new Point(living.x, living.y - living.radius * 2)], false, strFront, times);
							} else {
								// 区别佣兵
								if (sendLiving.race == PlayerEnum.RACE_PET && 3 != hurtType) {
									color=EffectEnum.COLOR_PURPLE;
									// 佣兵使用100，伤害前加佣兵两字
									hurtType=100;
									strFront=false;
								} else {
									strFront=true;
									color=EffectEnum.COLOR_RED;
								}
								SceneUIManager.getInstance().addEffect(living, EffectEnum.BUBBLE_RIGHT, value, color, EffectUtil.getEffectName(hurtType), "", //
									[new Point(sendLiving.x, sendLiving.y - sendLiving.radius), new Point(living.x, living.y - living.radius)], false, strFront, times);
							}
						}
						if (living.race == PlayerEnum.RACE_MONSTER && !SceneCore.sceneModel.isHideAll) {
							living.addLivingUI(true);
						}

						if (living.race == PlayerEnum.RACE_MONSTER && sendLiving == Core.me) {
							living.beatOff();
						}
//												trace("-------------------------------战斗伤害" + living.info.name + "|" + propName + "-" + value);
					}


//				trace("施暴者方向：",sendLiving.info.name,sendLiving.info.currentDir);
					(skillId != 10000) && living.addEffect(TableUtil.getHurtPnfId(skillId, sendLiving.info.skillEffectId));
					//晕！10000为buff伤害
					/*(skillId != 10000) && */
					living.beHurt(sendId, TableUtil.getHurtPnfId(skillId, sendLiving.info.skillEffectId));
				}
			}
//						trace("+++++++++++++++++++sm.3011++end")
		}

		//同步血、蓝值
		static public function sm_3012(br:ByteArray):void {
			br.position=3;
			var living:LivingModel;
			while (br.bytesAvailable) {
				br.position++;
				var stag:int=br.readUnsignedShort();
				br.position++;
				var hp:int=br.readInt();
				br.position++;
				var mp:int=br.readInt();

				living=UIManager.getInstance().gameScene.getPlayer(stag);
				if (!living)
					continue;
				if (Core.me.info.id == living.info.id) {
					// 血蓝增加提示
					var dHp:int=hp - living.info.hp;
					var dMp:int=mp - living.info.mp;
					if (dHp > 0) {
						SceneUIManager.getInstance().addEffect(living, EffectEnum.BUBBLE_LEFT, dHp, EffectEnum.COLOR_GREEN, EffectUtil.getPropName(22), "", null, true);
					}
					if (dMp >= 20) {
						SceneUIManager.getInstance().addEffect(living, EffectEnum.BUBBLE_LEFT, dMp, EffectEnum.COLOR_GREEN, EffectUtil.getPropName(23), "", null, true);
					}
				}

				living.updataHealth(hp, mp != -1 ? mp : living.info.mp);
				//				trace("同步血蓝值：",living.id,living.info.name,hp,mp);

				MyInfoManager.getInstance().Mp=mp;

				OtherHead.getInstance().updataHP(stag);
				if (living == Core.me) { //同步血蓝
					LivingUtil.updataPropUI();
						//					UIManager.getInstance().roleWnd.updateRoleAvatar();
						//					UIManager.getInstance().teamWnd.updateSelfAvatar();
				}
				if (living.id == Core.me.info.petId) {
//					trace("佣兵血蓝改变");
					EventManager.getInstance().dispatchEvent(EventEnum.PET_UPDATE_HP);
				}
			}
		}

		//同步buff
		static public function sm_3013(br:ByteArray):void {
			br.position=3;

			var info:BuffInfo=new BuffInfo();
			br.position++;
			var stag:int=br.readUnsignedShort();
			br.position++;
			var isAdd:int=br.readUnsignedByte();
			br.position++;
			info.id=br.readUnsignedShort();
			br.position++;
			info.ceng=br.readUnsignedShort();
			br.position++;
			info.lastTime=br.readInt();
			var living:LivingModel=UIManager.getInstance().gameScene.getPlayer(stag);
			if (!living) {
				trace("没有找到buff使用的玩家");
				return;
			}
			//			if (living == Core.me && (1 == isAdd)) {
			//				if(tInfo.type == SkillEnum.DEBUFF_TYPE){
			//					//获得不良BUFF
			//					SceneUIManager.getInstance().addEffect(living, EffectEnum.BUBBLE_RIGHT, 0, EffectEnum.COLOR_RED, EffectEnum.DEBUFF,
			//						TableManager.getInstance().getBuffInfo(info.id).icon);
			//				}else{
			//					// 获得增益BUFF
			//					SceneUIManager.getInstance().addEffect(living, EffectEnum.BUBBLE_LEFT, 0, EffectEnum.COLOR_GREEN, EffectEnum.HUO_DE,
			//						TableManager.getInstance().getBuffInfo(info.id).icon);
			//				}
			//			}
			//			UIManager.getInstance().chatWnd.chatNotice(/*"客户端角色名 = "+Core.me.info.name+*/"--buff角色名 = "+living.info.name+"--收到buff协议" + (isAdd ? "【添加】" : "【删除】") + info.id.toString());
			//			trace("--buff角色名 = "+living.info.name+"--收到buff协议" + (isAdd ? "【添加】" : "【删除】") + info.id.toString());
			if (0 == isAdd) {
				living.sm_removeBuff(info.id);
				vmAvatar(living, info, false);
				visualLiving(living, info, true);
			} else if (1 == isAdd) {
				living.sm_addBuff(info);
				vmAvatar(living, info, true);
				visualLiving(living, info, false);
			} else if (2 == isAdd) {
				living.sm_addBuff(info);
				vmAvatar(living, info, true);
				visualLiving(living, info, false);
			} else if (3 == isAdd) {
				if (living == Core.me) {
					SceneUIManager.getInstance().addEffect(living, EffectEnum.BUBBLE_LEFT, 0, EffectEnum.COLOR_GREEN, EffectEnum.MIAN_YI);
				} else {
					SceneUIManager.getInstance().addEffect(living, EffectEnum.BUBBLE_LINE, 0, EffectEnum.COLOR_RED, EffectEnum.MIAN_YI);
				}
			}

			if (living == Core.me) {
				UIManager.getInstance().roleHeadWnd.checkBuffChange();
				UIManager.getInstance().roleHeadWnd.resetPosition();
			} else {
				//				EventManager.getInstance().dispatchEvent(EventEnum.BUFF_CHANGE);
				OtherHead.getInstance().updateBuff(living.info.id);
			}
		}

		static public function vmAvatar(living:LivingModel, info:BuffInfo, isAdd:Boolean):void {
//			var tInfo:TBuffInfo=TableManager.getInstance().getBuffInfo(info.id);
//			if (tInfo.model <= 0)
//				return;
//			if (isAdd) {
//				living.info.backupFeatureInfo=living.info.featureInfo.clone();
//				var featureInfo:FeatureInfo=new FeatureInfo();
//				featureInfo.suit=tInfo.model;
//				living.changeAvatars(featureInfo);
//			} else {
//				living.changeAvatars(living.info.backupFeatureInfo);
//			}
		}


		static public function visualLiving(living:LivingModel, info:BuffInfo, visible:Boolean):void {
			var tInfo:TBuffInfo=TableManager.getInstance().getBuffInfo(info.id);
			if (tInfo.model != -1)
				return;

			var tmpLiving:LivingModel;
			var op:Number=visible ? 1 : 0.3;
			living.info.isHiding=!visible;
			(living == Core.me) ? living.opacity(op) : living.visual(visible);
//			if (living.info.petId != 0) {
//				tmpLiving=UIManager.getInstance().gameScene.getPlayer(living.info.petId);
//				tmpLiving.info.isHiding=!visible;
//				(living == Core.me) ? tmpLiving.opacity(op) : tmpLiving.visual(visible);
//			}
			if (living.info.shenQiId != 0) {
				tmpLiving=UIManager.getInstance().gameScene.getPlayer(living.info.shenQiId);
				tmpLiving.info.isHiding=!visible;
				(living == Core.me) ? tmpLiving.opacity(op) : tmpLiving.visual(visible);
			}

			//
			if (Core.me.pInfo.lockAttackName == living.info.name) {
				EventManager.getInstance().dispatchEvent(living.info.isHiding ? EventEnum.LOCK_TARGET_OUT : EventEnum.LOCK_TARGET_IN);
			}
			if (Core.me.pInfo.recordLookTargetId == living.id) {
				SceneCore.me.info.clearLookTarget();
			}
		}

		//
		static public function cm_bft_I(id:int):void {
			NetGate.getInstance().send(CmdEnum.CM_BFT_I + id.toString());
		}

		static public function sm_bft_I(obj:Object):void {
			var info:BuffInfo=new BuffInfo();
			info.id=obj["id"];
			info.zhi=obj["y"];
			info.lastTime=-1;
			Core.me.info.buffsInfo.addBuff(info);
		}

		/**晕时：锁定状态*/
		static public function sm_3014(br:ByteArray):void {
			br.position=3;

			br.position++;
			var stag:int=br.readUnsignedShort();
			var living:LivingModel=UIManager.getInstance().gameScene.getPlayer(stag);
			if (!living)
				return;
			br.position++;
			living.info.isActLocked=br.readByte() == 1 ? true : false;
		}

		/**速度改变*/
		static public function sm_3015(br:ByteArray):void {
			br.position=3;

			br.position++;
			var stag:int=br.readUnsignedShort();
			br.position++;
			var speed:int=br.readUnsignedShort();
			var living:LivingModel=UIManager.getInstance().gameScene.getPlayer(stag);
			if (!living)
				return;
			living.info.speed=speed / 1000;
			if (living.info.speed == 0) {
				living.stopMove();
			}
		}

		//添加子弹
		static public function sm_3016(br:ByteArray):void {
			if (SettingManager.getInstance().assitInfo.isHideSkill)
				return;
			//			trace(HexUtil.toHexDump("sm_3016", br, 0, br.length));
			br.position=3;

			br.position++;
			var skillId:int=br.readUnsignedShort();
			br.position++;
			var stag:int=br.readUnsignedShort();
			br.position++;
			var sendName:String=br.readUTFBytes(br.readByte());
			br.position++;
			var fx:int=br.readUnsignedShort();
			br.position++;
			var fy:int=br.readUnsignedShort();
			br.position++;
			var tx:int=br.readUnsignedShort();
			br.position++;
			var ty:int=br.readUnsignedShort();
			br.position++;
			var sendId:int=br.readUnsignedShort();
			br.position++;
			var receiveId:int=br.readUnsignedShort();

			if (skillId == 0) {
				DebugUtil.throwError("收到协议：技能id为0");
			}
			//			var tt:int=Math.random() * 0xFFFFFF;
			//			DebugUtil.addFlag(fx, fy, UIManager.getInstance().gameScene, tt);
			//			DebugUtil.addFlag(tx, ty, UIManager.getInstance().gameScene, tt);

			var sendLiving:LivingModel=UIManager.getInstance().gameScene.getPlayer(sendId);

			if (!sendLiving)
				return;
			var effectInfo:TSkillEffectInfo=TableManager.getInstance().getSkillEffectInfo(TableManager.getInstance().getSkillInfo(skillId).getEffectId(sendLiving.info.skillEffectId));

			if (stag < 20000 && stag > 0) {
				if (effectInfo.sceneEffect1 != 0) {
					UIManager.getInstance().gameScene.addBuff(stag, effectInfo.sceneEffect1, fx, fy, sendName, skillId, sendLiving.info.skillEffectId);
				}
				if (effectInfo.sceneEffect2 != 0) {
					UIManager.getInstance().gameScene.addBuff(stag, effectInfo.sceneEffect2, fx, fy, sendName, skillId, sendLiving.info.skillEffectId);
				}
			} else {
//				BulletManager.getInstance().addBulletII(fx, fy, tx, ty, skillId, stag);
//				if(sendId==0)
				if (skillId == 832 || skillId == 834 || skillId == 836 || skillId == 838) {
					trace("添加子弹：", getTimer(), sendLiving.info.name, effectInfo.times, skillId, tx, ty);
				}
				if (effectInfo.times == 1) {
					BulletManager.getInstance().addBullet(sendId, receiveId, SceneUtil.screenXToTileX(tx), SceneUtil.screenYToTileY(ty), skillId, sendLiving.info.skillEffectId);
				}
			}
		}

		//移除子弹
		static public function sm_3022(br:ByteArray):void {
			br.position=3;

			br.position++;
			var stag:int=br.readUnsignedShort();
			BulletManager.getInstance().removeBullet(stag);
		}

		static public function sm_3017(br:ByteArray):void {
			br.position=3;

			br.position++;
			var stag:int=br.readUnsignedShort();
			//			trace("删除持续特效：" + stag);
			UIManager.getInstance().gameScene.removeBuff(stag);
		}

		static public function sm_3023(br:ByteArray):void {
			br.position=3;

			br.position++;
			var tsid:int=br.readUnsignedShort();
			if (UIManager.getInstance().isCreate(WindowEnum.ELEMENT)) {
				UIManager.getInstance().elementWnd.playCD(tsid);
			}
//			UIManager.getInstance().roleWnd.playVipSkillCd(tsid);
		}

		//死亡通知
		static public function sm_rev(obj:Object):void {
			LayerManager.getInstance().windowLayer.hideAllWnd();
			if (obj.type > 0) {
				ReviveWnd.getInstance().serv_show(obj);
			} else {
				CopyReviveWnd.getInstance().serv_show(obj);
					//				CmdProxy.cm_revive(0);
			}

			CONFIG::online {
				if (Core.me.info.baseInfo.hp != 0) {
					//					DebugUtil.throwError("自己还未死亡，血量不为0");
				}
			}
		}

		//复活
		static public function cm_rev(type:int):void {
			NetGate.getInstance().send(CmdEnum.CM_REV + type.toString());
		}

		static public function sm_rev_r(obj:Object):void {
			var living:LivingModel=UIManager.getInstance().gameScene.getPlayer(obj["id"]);
			if (!living)
				return;
			if (living == Core.me) {
				if (!SettingManager.getInstance().assitInfo.isAuto && SettingManager.getInstance().assitInfo.preIsAuto) {
					AssistWnd.getInstance().onButtonClick(null);
				}
			}
			living.addEffect(PlayerEnum.FILE_REVIVE);
		}

		// 道具购买刷新
		public static function sm_REV_B(obj:Object):void {
			ReviveWnd.getInstance().ser_REV_B(obj);
		}

		// 死亡复活道具购买
		public static function cm_REV_B(type:int, itemId:int, num:int):void {
			NetGate.getInstance().send(CmdEnum.CM_REV_B + type + "," + itemId + "," + num);
		}
	}
}

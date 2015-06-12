package com.leyou.net.cmd {
	import com.ace.config.Core;
	import com.ace.enum.EffectEnum;
	import com.ace.enum.PlayerEnum;
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
	import com.ace.gameData.table.TSkillEffectInfo;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.setting.AssistWnd;
	import com.ace.utils.DebugUtil;
	import com.leyou.enum.CmdEnum;
	import com.leyou.enum.PkMode;
	import com.leyou.net.NetGate;
	import com.leyou.utils.EffectUtil;
	
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
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
				return;
			}
			var player:LivingModel=UIManager.getInstance().gameScene.getPlayer(sendId);
			if (!player) {
				//				DebugUtil.throwError("没有找到该玩家");
				return;
			}
			//			LogManager.getInstance().showLog("接受技能：id" + skillId + "	坐标：" + mx + "-" + my);
			Living(player).sm_actAttaack(skillId, receiveId, mx, my);
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
			var sendLiving:LivingModel=UIManager.getInstance().gameScene.getPlayer(sendId);
			if (null == sendLiving) {
				return;
			}
			//			trace("+++++++++++++++++++sm.3011++begin++tick = "+new Date().toString())
			while (br.bytesAvailable) {
				br.position++;
				var stag:int=br.readUnsignedShort();
				br.position++;
				var hurtNum:int=br.readByte();
				br.position++;
				var hurtType:int=br.readByte(); //（1普通攻击，2暴击，3闪避...）
				br.position++;
				var propName:int=br.readByte();
				br.position++;
				var value:int=br.readInt();
				living=UIManager.getInstance().gameScene.getPlayer(stag);
				if (!living)
					continue;
				if (living == Core.me) {
					var typeName:String = EffectUtil.getEffectName(hurtType);
					if (propName == 1) {
						SceneUIManager.getInstance().addEffect(living, EffectEnum.BUBBLE_RIGHT, value, EffectEnum.COLOR_YELLOW, EffectUtil.getEffectName(hurtType));
					} else {
						SceneUIManager.getInstance().addEffect(living, EffectEnum.BUBBLE_RIGHT, value, EffectEnum.COLOR_BLUE, EffectUtil.getEffectName(hurtType));
					}
					// 和平模式下被攻击
					if ((sendLiving.race == PlayerEnum.RACE_HUMAN) && (PkMode.PK_MODE_PEACE == Core.me.info.pkMode)) {
						GuideManager.getInstance().showGuide(7, UIManager.getInstance().roleHeadWnd);
					}
				} else {
					//					var log:String = "------------------------cmd_attack.3011--stag={1},hurtNum={2},hurtNum={3},propName={4},value={5}";
					//					trace(StringUtil.substitute(log, stag, hurtNum, hurtType, propName, value))
					if (!sendLiving) {
						SceneUIManager.getInstance().addEffect(living, EffectEnum.BUBBLE_LINE, value, EffectEnum.COLOR_RED, EffectUtil.getEffectName(hurtType));
					} else {
						SceneUIManager.getInstance().addEffect(living, EffectEnum.BUBBLE_RIGHT, value, EffectEnum.COLOR_RED, EffectUtil.getEffectName(hurtType), "", [new Point(sendLiving.x, sendLiving.y - sendLiving.radius), new Point(living.x, living.y - living.radius)]);
					}
					if (living.race == PlayerEnum.RACE_MONSTER && !SceneCore.sceneModel.isHideAll) {
						living.addLivingUI(true);
					}
					
					if (living.race == PlayerEnum.RACE_MONSTER && sendLiving == Core.me) {
						living.beatOff();
					}
					//					trace("-------------------------------战斗伤害" + living.info.name + "|" + propName + "-" + value);
				}
				(skillId != 10000) && living.addEffect(TableUtil.getHurtPnfId(skillId));
				//晕！10000为buff伤害
				/*(skillId != 10000) && */
				living.beHurt(sendId, TableUtil.getHurtPnfId(skillId));
			}
			//			trace("+++++++++++++++++++sm.3011++end")
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
			} else if (1 == isAdd) {
				living.sm_addBuff(info);
			} else if (2 == isAdd) {
				living.sm_addBuff(info);
			} else if (3 == isAdd) {
				if (living == Core.me) {
					SceneUIManager.getInstance().addEffect(living, EffectEnum.BUBBLE_LEFT, 0, EffectEnum.COLOR_GREEN, EffectEnum.MIAN_YI);
				} else {
					SceneUIManager.getInstance().addEffect(living, EffectEnum.BUBBLE_LINE, 0, EffectEnum.COLOR_RED, EffectEnum.MIAN_YI);
				}
			}
			if (living == Core.me) {
				UIManager.getInstance().roleHeadWnd.checkBuffChange();
			} else {
				//				EventManager.getInstance().dispatchEvent(EventEnum.BUFF_CHANGE);
				OtherHead.getInstance().updateBuff(living.info.id);
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
			
			if (skillId == 0) {
				DebugUtil.throwError("收到协议：技能id为0");
			}
			//			var tt:int=Math.random() * 0xFFFFFF;
			//			DebugUtil.addFlag(fx, fy, UIManager.getInstance().gameScene, tt);
			//			DebugUtil.addFlag(tx, ty, UIManager.getInstance().gameScene, tt);
			
			if (stag < 20000) {
				var effectInfo:TSkillEffectInfo=TableManager.getInstance().getSkillEffectInfo(TableManager.getInstance().getSkillInfo(skillId).skillEffectId);
				
				if (effectInfo.sceneEffect1 != 0) {
					UIManager.getInstance().gameScene.addBuff(stag, effectInfo.sceneEffect1, fx, fy, sendName, skillId);
				}
				if (effectInfo.sceneEffect2 != 0) {
					UIManager.getInstance().gameScene.addBuff(stag, effectInfo.sceneEffect2, fx, fy, sendName, skillId);
				}
			} else {
				BulletManager.getInstance().addBulletII(fx, fy, tx, ty, skillId, stag);
			}
		}
		
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
			UIManager.getInstance().roleWnd.playVipSkillCd(tsid);
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

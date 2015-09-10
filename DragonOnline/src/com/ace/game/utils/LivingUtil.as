/**
 * @VERSION:	1.0
 * @AUTHOR:		ace
 * @EMAIL:		ace_a@163.com
 * 2013-10-17 下午2:49:03
 */
package com.ace.game.utils {
	import com.ace.config.Core;
	import com.ace.enum.PlayerEnum;
	import com.ace.game.scene.player.part.LivingBase;
	import com.ace.game.scene.player.part.LivingModel;
	import com.ace.game.scene.ui.ReviveWnd;
	import com.ace.game.scene.ui.child.Item;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.utils.StringUtil;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Npc;
	import com.leyou.net.cmd.Cmd_Scene;
	import com.leyou.utils.TaskUtil;

	public class LivingUtil {


		static public function onDie():void {
			ReviveWnd.getInstance().show();
		}

		//种族------场景上的物品分类
		static public function onClickLiving(living:LivingBase):void {
			if (living.race == PlayerEnum.RACE_COLLECT) {
				talkWithNpc(living as LivingModel, true);
			} else if (living.race == PlayerEnum.RACE_NPC) {
				talkWithNpc(living as LivingModel);
			}

			if (living.race == PlayerEnum.RACE_ITEM) {
				Cmd_Scene.cm_drop(living as Item);
			}
		}

		static public var rareBoxidTag:String="";

		static public function talkWithNpc(living:LivingModel, iscoll:Boolean=false):void {
			if (living.info.taskState <= 1)
				TaskUtil.openNpcFuncPanel(living.info.tId);

			UIManager.getInstance().taskNpcTalkWnd.taskNpc=living.id;

			if (iscoll) {
				if (2014 != living.info.tId) {
					Cmd_Npc.cmNpcClick(living.info.idTag);
				} else {
					// tid 是2014时是boss副本的宝箱
					if(UIManager.getInstance().backpackWnd.yb >= ConfigEnum.BossBoxOpenCost){
						rareBoxidTag=living.info.idTag;
						var cid:int = (Core.isSF ? 30001 : 4405);
						var content:String=TableManager.getInstance().getSystemNotice(cid).content;
						content=StringUtil.substitute(content, ConfigEnum.BossBoxOpenCost);
						PopupManager.showConfirm(content, onClickRareBox, null, false, "rareBox.click");
					}else{
						NoticeManager.getInstance().broadcastById(2008);
					}
				}
			} else {
					Cmd_Npc.cmNpcClick(living.info.tId.toString());
			}
		}

		static public function onClickRareBox():void {
			Cmd_Npc.cmNpcClick(rareBoxidTag);
		}

		static public function lookPlayer(living:LivingModel):void {

		}

		static public function lookStallPlayer(living:LivingModel):void {

		}

		static public function updataPropUI():void {
			UIManager.getInstance().roleHeadWnd.updataInfo(Core.me.info);
			UIManager.getInstance().toolsWnd.updataPropUI();
			//			Core.me.updataHealth(1, 2);
		}
	}
}

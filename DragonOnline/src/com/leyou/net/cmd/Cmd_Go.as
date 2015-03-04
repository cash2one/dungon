package com.leyou.net.cmd {


	import com.ace.config.Core;
	import com.ace.enum.EventEnum;
	import com.ace.enum.SceneEnum;
	import com.ace.game.utils.SceneUtil;
	import com.ace.gameData.manager.MapInfoManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.EventManager;
	import com.ace.utils.StringUtil;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.NetGate;

	import flash.geom.Point;

	public class Cmd_Go {

		private static var useItemCount:int=0;

		public function Cmd_Go() {
		}


		//和npc对话
		public static function sm_go_G(o:Object):void {
			if (!o.hasOwnProperty("where"))
				return;
			Core.me.walkToAndTalkWith(o.where[3], SceneUtil.screenToTile(o.where[1], o.where[2]), o.where[0]);
		}

		//寻路去某一点
		public static function sm_go_p(o:Object):void {
			Core.me.gotoMap(SceneUtil.screenToTile(o.where[1], o.where[2]), o.where[0]);
		}

		public static function sm_go_V(o:Object):void {
			if (!o.hasOwnProperty("snum"))
				return;

			MyInfoManager.getInstance().VipLastTransterCount=o.snum;
		}

		/**
		 * @param npcID
		 */
		public static function cmGo(npcID:int):void {
//			trace("npc寻路：", npcID);
			NetGate.getInstance().send("go|G" + npcID);
		}

		/**
		 *传送到npc
  上行:go|Nnpcid

传送某个点
上行:go|Troomid,x,y
* @param npcID
*
*/
		public static function cmGoNpc(npcID:int):void {
//			trace("Npc传送：", npcID);
			EventManager.getInstance().dispatchEvent(EventEnum.SCENE_TRANS, true);
			NetGate.getInstance().send("go|N" + npcID);
		}

		/**
		 *传送到npc
  上行:go|Nnpcid

传送某个点
上行:go|Troomid,x,y
* @param npcID
*
*/
		public static function cmGoPoint(roomid:int, x:int, y:int):void {
			EventManager.getInstance().dispatchEvent(EventEnum.SCENE_TRANS, true);
			NetGate.getInstance().send("go|T" + roomid + "," + x + "," + y);
		}


		/**
		 *vip 免费传送次数
		上行：go|V
		下行: go|{mk:"V",snum:num}
		-- snum 剩余免费传送次数
		 *
		 */
		public static function cmGoVipTransterCount():void {
			NetGate.getInstance().send("go|V");
		}

		/**
		 *-- 上行：go|Croomid,x,y
		 * @param rid
		 * @param _x
		 * @param _y
		 *
		 */
		public static function cmGoCall(rid:int, _x:int, _y:int):void {
			NetGate.getInstance().send("go|C" + rid + "," + _x + "," + _y);
		}

		/**
		 *-- 下行: go|{mk:"C","name":str, "zb":[roomid,x,y]}
		 * @param o
		 *
		 */
		public static function sm_go_C(o:Object):void {

			useItemCount++;
			var id:int=0;
			if (SceneEnum.SCENE_TYPE_JSC == MapInfoManager.getInstance().type) {
				id=4116;
			} else {
				id=4115;
			}

			PopupManager.showConfirm(StringUtil.substitute(TableManager.getInstance().getSystemNotice(4116).content, [o.name]), function():void {
				Cmd_Go.cmGoCall(o.zb[0], o.zb[1], o.zb[2]);
			}, null, false, "useitemView" + useItemCount);


		}



	}
}

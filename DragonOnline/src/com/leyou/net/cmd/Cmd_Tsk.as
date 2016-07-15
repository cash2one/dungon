package com.leyou.net.cmd {

	import com.ace.config.Core;
	import com.ace.game.manager.CutSceneManager;
	import com.ace.game.proxy.SceneProxy;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TMissionDate;
	import com.ace.gameData.table.TNoticeInfo;
	import com.ace.manager.UIManager;
	import com.ace.ui.notice.NoticeManager;
	import com.leyou.enum.TaskEnum;
	import com.leyou.net.NetGate;


	/**
	 * tsk

服务器 <----> 客户端

mk(“A” --接受任务 , "D" --交付任务 , "T" --任务追踪面板 )
	 * @author Administrator
	 *
	 */
	public class Cmd_Tsk {


		public function Cmd_Tsk() {
		}

		/**
		 *----------------------------------------------------------------------------------
接任务界面信息 （点击任务npc/其它条件自动弹出）
下行：tsk|{mk:A,tid:taskid}
* @param o
*
*/
		public static function sm_tsk_A(o:Object):void {
			if (!o.hasOwnProperty("tid"))
				return;

			if (o.hasOwnProperty("act") && o.act == 1) {

				SceneProxy.onTaskAccept();

				var n:TNoticeInfo=new TNoticeInfo();
				n.screenId1=5;
				n.content=TableManager.getInstance().getMissionDataByID(o.tid).describ;
				NoticeManager.getInstance().broadcast(n);

			} else {

				UIManager.getInstance().taskNpcTalkWnd.showPanel(o);
//				UIManager.getInstance().taskTrack.updateList(o);

			}

		}

		/**
		 **
----------------------------------------------------------------------------------
交任务界面信息 （点击任务npc/其它条件自动弹出）
下行：tsk|{mk:D,tid:taskid}

* @param o
*
*/
		public static function sm_tsk_D(o:Object):void {
			if (!o.hasOwnProperty("tid") || UIManager.getInstance().taskNpcTalkWnd == null)
				return;

			if (o.hasOwnProperty("act") && o.act == 1) {
				var info:TMissionDate=TableManager.getInstance().getMissionDataByID(o.tid)
				if (int(info.dtype) == TaskEnum.taskType_dialogue || int(info.dtype) == TaskEnum.taskType_post || int(info.dtype) == TaskEnum.taskType_upgrade) {
					SceneProxy.onTaskComplete();
				}

				//完成处理
				if (int(info.type) == TaskEnum.taskLevel_mainLine) {
					UIManager.getInstance().taskNpcTalkWnd.rewardFlyBag();
//					UIManager.getInstance().taskTrack.completeHallow();
				}

			} else {
				UIManager.getInstance().taskNpcTalkWnd.showPanel(o);
//				UIManager.getInstance().taskTrack.updateList(o);
			}
		}


		/**
		 *下行：tsk|{mk:T,tr:{[{tid:taskid, st:num, var:num},{...}]} （任务追踪面板信息）
	  tr -- 任务信息
										 tid -- 任务id
			 st  -- 任务状态(0：未完成 1：已完成 -1：可领取)
			 var -- 任务当前完成进度变量num
		 * @param o
		 *
		 */
		public static function sm_tsk_T(o:Object):void {

			if (!o.hasOwnProperty("tr") || o.tr.length == 0 || Core.me == null)
				return;


//			UIManager.getInstance().taskWnd.updateData(o);
			 
			UIManager.getInstance().taskTrack2.updateInfo(o);
			UIManager.getInstance().taskTrack.updateList(o);
//			UIManager.getInstance().taskTrack3.updateList(o);
//			UIManager.getInstance().taskNpcTalkWnd.updateData(o.tr[0]);

		}

		/**
		 * 刷新日常任务星级
		 *tsk|S
		 * @return
		 *
		 */
		public static function cmTaskDailyStar():void {
			NetGate.getInstance().send("tsk|S");
		}

		/**
		 *领取日常任务奖励
		 */
		public static function cmTaskDailyReward():void {
			NetGate.getInstance().send("tsk|W");
		}

		/**
		 * 完成日常任务
		 * tsk|Ktype
   type (1 快速完成一次,2 完成全部)
  * 快速完成日常任务  tsk|Ktype,btype (0钻石 1绑定钻石)
  */
		public static function cmTaskDailySuccess(type:int=1, btype:int=0):void {
			NetGate.getInstance().send("tsk|K" + type + "," + btype);
		}


		/**
----------------------------------------------------------------------------------
接受任务
上行: tsk|Ataskid
下行：tsk|{mk:T,tr:{[{tid:taskid, st:num, var:num},{...}]} （任务追踪面板信息）
tr -- 任务信息
tid -- 任务id
st  -- 任务状态(0：未完成 1：已完成 -1：可领取)
var -- 任务当前完成进度变量num
* @param id
   *
		   */
		public static function cmTaskKAccept(id:int):void {
			NetGate.getInstance().send("tsk|A" + id);
		}

		/**
		 *----------------------------------------------------------------------------------
完成任务
上行：tsk|Dtaskid
下行：tsk|{mk:T,tr:{[{tid:taskid, st:num, var:num},{...}]} （任务追踪面板信息）

----------------------------------------------------------------------------------
* @param id
*
*/
		public static function cmTaskKSucc(id:int):void {
			NetGate.getInstance().send("tsk|D" + id);
		}

		public static function cmTaskQuest():void {
			NetGate.getInstance().send("tsk|T");
		}
		
		/**
		 *tsk|R -- 重置环任务 
		 */		
		public static function cmTaskReset():void {
			NetGate.getInstance().send("tsk|R");
		}
		
		/**
		 * tsk|Ltaskid
		 * @param tid
		 * 
		 */		
		public static function cmTaskLevel(tid:int):void {
			NetGate.getInstance().send("tsk|L"+tid);
		}

	}
}

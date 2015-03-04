package com.leyou.net.cmd {
	import com.ace.manager.UIManager;
	import com.leyou.net.NetGate;

	/**
	 *
npc

服务器 <----> 客户端

mk("I" --npc功能面板 "D" -- npc对话面板)
	 * @author Administrator
	 *
	 */
	public class Cmd_Npc {



		public function Cmd_Npc() {
		}

		/**
		 *--------------------------------------------------
点击npc
上行：npc|Inpcid
下行：npc|{mk:I,npc:npcid,f:[findex,...]}
  npc -- npcid 任务表中的npc的id
		  f   -- npc功能id 序列 npc功能表中的功能id

		 * @param o
		 *
		 */
		public static function sm_npc_I(o:Object):void {
			if (!o.hasOwnProperty("npc"))
				return;



		}

		
		
		/**
		 *下行：npc|{mk:D,npc:npcid,di:msgid}
		  id  -- 对话内容消息id 任务表中
		 * @param o
		 *
		 */
		public static function sm_npc_D(o:Object):void {
			if (!o.hasOwnProperty("npc"))
				return;

			UIManager.getInstance().taskNpcTalkWnd.showPanel(o);
		}


		/**
		 *--------------------------------------------------
npc采集
下行：npc|{"mk":C, "npc":npcid, t":time}
 npc --npcid
	   t:进度条时间
			(收到此协议，开始读条)

上行：npc|Cnpcid
 (客户端读完条 发送此协议)
	   * @param o
			*
		 */
		public static function sm_npc_C(o:Object):void {
			if (!o.hasOwnProperty("t") || !o.hasOwnProperty("npc"))
				return;
			 
			
			UIManager.getInstance().taskCollectProgress.startProgress(o.t,function():void{ Cmd_Npc.cmNpcCollect(o.npc);});
		}

		/**
		 *--------------------------------------------------
点击npc
上行：npc|Inpcid
下行：npc|{mk:I,npc:npcid,f:[findex,...]}
  npc -- npcid 任务表中的npc的id
		  f   -- npc功能id 序列 npc功能表中的功能id
		 * @param npcid
		 *
		 */
		public static function cmNpcClick(npcid:String):void {
			NetGate.getInstance().send("npc|I" + npcid);
		}

		/**
		 *--------------------------------------------------
触发npc功能
上行：npc|Fnpcid,findex
下行：根据不同功能调用其他模块协议

 * @param npcid
	   * @param findex
			*
		 */
		public static function cmNpcAlert(npcid:int, findex:int):void {
			NetGate.getInstance().send("npc|F" + npcid + "," + findex);
		}

		/**
		 *--------------------------------------------------
npc采集
下行：npc|{"mk":C, "npc":npcid, t":time}
 npc --npcid
	   t:进度条时间
			(收到此协议，开始读条)

上行：npc|Cnpcid
 (客户端读完条 发送此协议)
	   *
			*/
		public static function cmNpcCollect(npcid:int):void {
			NetGate.getInstance().send("npc|C" + npcid);
		}

	}
}

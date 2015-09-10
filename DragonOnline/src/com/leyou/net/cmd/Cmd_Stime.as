package com.leyou.net.cmd {
	
	import com.leyou.enum.CmdEnum;
	import com.leyou.manager.TimerManager;
	import com.leyou.net.NetGate;

	public class Cmd_Stime {

		/**
		 *服务器时间

stime
下行: stime|{"mk":"I", "time":num} 
		 * @param o
		 * 
		 */
		public static function sm_stime_I(o:Object):void {
			TimerManager.CurrentServerTime=o.time;
			Cmd_Act.cmActInit();
		}


		public static function cmRequestTime():void{
			NetGate.getInstance().send("stime|I");
		}
		
	}
}

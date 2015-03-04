package com.leyou.net.cmd
{
	import com.ace.manager.UIManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_LZ
	{
		public static function sm_LZ_I(obj:Object):void{
			// 1- 经验  2- 钱  3- buff  4- 魂力
			var count:int = obj.kills;
			var time:int = obj.dtime;
			var type:int = obj.jltype;
			var itemCount:int = obj.jlval;
			var itemId:int = obj.jlid;
			if(itemId <= 0){
				switch(type){
					case 1:
						itemId = 65534;
						break;
					case 2:
						itemId = 65535;
						break;
					case 3:
						itemCount = 1;
						break;
					case 4:
						itemId = 65533;
						break;
				}
			}
			UIManager.getInstance().continuousWgt.startCouner(count, time, itemId, itemCount);
		}
		
		public static function cm_LZ_J():void{
			NetGate.getInstance().send(CmdEnum.CM_LZ_J);
		}
	}
}
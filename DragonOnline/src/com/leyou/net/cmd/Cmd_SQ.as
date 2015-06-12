package com.leyou.net.cmd
{
	import com.ace.manager.UIManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_SQ
	{
		public static function sm_SQ_M(obj:Object):void{
			UIManager.getInstance().legendaryWnd.flyToBag();
			UIManager.getInstance().legendaryWnd.updateMaterialCount();
		}
		
		public static function cm_SQ_M(id:int, posArr:Array):void{
//			if(posArr.length <= 0){
//				return;
//			}
			var pos:String = posArr.splice(",");
			NetGate.getInstance().send(CmdEnum.CM_SQ_M+id+","+pos);
		}
	}
}
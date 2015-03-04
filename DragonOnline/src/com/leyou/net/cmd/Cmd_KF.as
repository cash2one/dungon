package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.NetGate;

	public class Cmd_KF
	{
		public static function sm_KF_I(obj:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.AREA_CELEBRATE, CmdEnum.SM_KF_I);
			DataManager.getInstance().areaCelebrate.loadData_I(obj);
			UIManager.getInstance().areaCelebrate.updateInfo();
		}
		
		public static function sm_KF_T(obj:Object):void{
			DataManager.getInstance().areaCelebrate.loadData_T(obj);
			var cd:int = DataManager.getInstance().areaCelebrate.currentDay;
			if(cd > 0 && cd <= ConfigEnum.welfare19){
				UIManager.getInstance().rightTopWnd.active("areaCelebrate");
				var rt:int = DataManager.getInstance().areaCelebrate.remainT();
				UIManager.getInstance().rightTopWnd.setTime("areaCelebrate", rt);
			}else{
				UIManager.getInstance().rightTopWnd.deactive("areaCelebrate");
			}
		}
		
		public static function sm_KF_R(obj:Object):void{
			UIManager.getInstance().areaCelebrate.playRewardEffect(obj.tid);
		}
		
		public static function cm_KF_I(type:int):void{
			NetGate.getInstance().send(CmdEnum.CM_KF_I+type);
		}
		
		public static function cm_KF_R(id:int):void{
			NetGate.getInstance().send(CmdEnum.CM_KF_R+id);
		}
	}
}
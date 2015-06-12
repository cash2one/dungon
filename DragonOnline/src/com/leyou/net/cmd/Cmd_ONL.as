package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.UIManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;
	import com.leyou.utils.PropUtils;

	public class Cmd_ONL
	{
		public function Cmd_ONL(){
		}
		
		public static function sm_ONL_I(obj:Object):void{
//			UIManager.getInstance().rightTopWnd.packDisplay(UIManager.getInstance().onlineReward, 50, 3);
//			UIManager.getInstance().onlineReward.updateInfo(obj);
			DataManager.getInstance().onlineRewardData.loadData_I(obj);
			UIManager.getInstance().rightTopWnd.active("onlineBtn");
			UIManager.getInstance().rightTopWnd.setTime("onlineBtn", obj.stime, PropUtils.getStringById(1567));
			if(UIManager.getInstance().isCreate(WindowEnum.ONLINDREWARD)){
				UIManager.getInstance().onlinePanel.updateInfo();
			}
		}
		
		public static function sm_ONL_X(obj:Object):void{
//			UIManager.getInstance().rightTopWnd.removeDisplay("onlineReward", 2);
			UIManager.getInstance().rightTopWnd.deactive("onlineBtn");
			if(UIManager.getInstance().isCreate(WindowEnum.ONLINDREWARD)){
				UIManager.getInstance().onlinePanel.hide();
			}
		}
		
		public static function cm_ONL_J():void{
			NetGate.getInstance().send(CmdEnum.CM_ONL_J);
		}
		
		public static function sm_ONL_Z(obj:Object):void{
			UIManager.getInstance().onlinePanel.flyItem();
		}
	}
}
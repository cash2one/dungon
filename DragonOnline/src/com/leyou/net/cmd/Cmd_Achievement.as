package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.data.achievement.AchievementEraData;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Achievement
	{
		public static function cm_HSY_S():void{
			NetGate.getInstance().send(CmdEnum.CM_HSY_S);
		}
		
		public static function sm_HSY_S(obj:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.ACHIEVEMENT, CmdEnum.SM_HSY_S);
			DataManager.getInstance().achievementData.pushServerId(obj.sl);
			UIManager.getInstance().achievementWnd.updateServerView();
		}
		
		public static function cm_HSY_I(serverId:String):void{
			NetGate.getInstance().send(CmdEnum.CM_HSY_I+","+serverId);
		}
		
		public static function sm_HSY_I(obj:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.ACHIEVEMENT, CmdEnum.SM_HSY_I);
			DataManager.getInstance().achievementData.loadData_I(obj);
			UIManager.getInstance().achievementWnd.updateAchievementView();
		}
		
		public static function cm_HSY_R(serverId:String):void{
			NetGate.getInstance().send(CmdEnum.CM_HSY_R+","+serverId);
		}
		
		public static function sm_HSY_R(obj:Object):void{
			DataManager.getInstance().achievementData.loadData_R(obj);
			UIManager.getInstance().achievementWnd.updateRoleView();
		}
		
		public static function sm_HSY_N(obj:Object):void{
			var data:AchievementEraData = new AchievementEraData();
			data.tid = obj.hi[0];
			data.name = obj.hi[1];
			data.date = obj.hi[2];
			UIManager.getInstance().showWindow(WindowEnum.ACHIEVEMENTNOTIFY);
			UIManager.getInstance().achievementNotifyWnd.updateInfo(data, obj.hi[3], obj.hi[4]);
		}
	}
}
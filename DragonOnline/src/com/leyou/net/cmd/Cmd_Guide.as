package com.leyou.net.cmd
{
	import com.ace.gameData.manager.SettingManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.UIManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Guide
	{
		public function Cmd_Guide()
		{
		}
		
		public static function sm_GUD_I(obj:Object):void{
			SettingManager.getInstance().assitInfo.loadGuideInfo(obj);
		}
		
		public static function cm_GUD_F(id:int):void{
			NetGate.getInstance().send(CmdEnum.CM_GUD_F+id);
		}
		
		public static function sm_GUD_T(obj:Object):void{
			GuideManager.getInstance().recordTime(obj);
		}
		
		public static function sm_GUD_N(obj:Object):void{
			var ids:Array = obj.gids;
			if(null == ids || 0 == ids.length){
				throw new Error("guide notify is invalid.");
			}
			if(!UIManager.getInstance().rightTopWnd.visible){
				return;
			}
			//UIManager.getInstance().chatWnd.chatNotice("cmd_guide reveice msg guide id = "+ids.join(","));
			switch(ids[0]){
				case 39:
//					GuideManager.getInstance().showGuide(39, UIManager.getInstance().rightTopWnd.getWidget("activityBtn", 1), true);
					break;
				case 50:
//					GuideManager.getInstance().showGuide(50, UIManager.getInstance().rightTopWnd.getWidget("welfareBtn", 2), true);
//					UIManager.getInstance().creatWindow(WindowEnum.WELFARE).changeTable(0);
					break;
				case 52:
//					GuideManager.getInstance().showGuide(52, UIManager.getInstance().rightTopWnd.getWidget("welfareBtn", 2), true);
//					UIManager.getInstance().creatWindow(WindowEnum.WELFARE).changeTable(2);
					break;
				case 54:
//					GuideManager.getInstance().showGuide(54, UIManager.getInstance().rightTopWnd.getWidget("welfareBtn", 2), true);
//					UIManager.getInstance().creatWindow(WindowEnum.WELFARE).changeTable(0);
					break;
				case 81:
					GuideManager.getInstance().showGuide(81, UIManager.getInstance().roleHeadWnd);
					break;
				
			}
		}
	}
}
package com.leyou.ui.crossServer.children
{
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCSMissionInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.crossServer.children.CrossServerMissionData;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;
	
	public class CrossServerMissionRankItem extends AutoSprite
	{
		private var rankLbl:Label;
		
		private var roleLbl:Label;
		
		private var donateLbl:Label;
		
		public function CrossServerMissionRankItem(){
			super(LibManager.getInstance().getXML("config/ui/crossServer/kfdtMRankRender.xml"));
			init();
		}
		
		private function init():void{
			rankLbl = getUIbyID("rankLbl") as Label;
			roleLbl = getUIbyID("roleLbl") as Label;
			donateLbl = getUIbyID("donateLbl") as Label;
		}
		
		public function updateInfo(data:CrossServerMissionData):void{
			rankLbl.text = StringUtil.substitute(PropUtils.getStringById(2281), data.rank);
			roleLbl.text = data.name;
			var taskInfo:TCSMissionInfo = TableManager.getInstance().getCrossServerMissionInfo(DataManager.getInstance().crossServerData.taskId);
			donateLbl.text = StringUtil.substitute(getMyProgress(taskInfo.type), data.ptnunm);
		}
		
		private function getMyProgress(type:int):String{
			switch(type){
				case 1:
				case 2:
				case 5:
					return PropUtils.getStringById(2265);
				case 3:
				case 4:
					return PropUtils.getStringById(2266);
				case 6:
					return PropUtils.getStringById(2267);
				case 7:
					return PropUtils.getStringById(2268);
				case 8:
					return PropUtils.getStringById(2269);
				case 9:
					return PropUtils.getStringById(2270);
			}
			return null;
		}
	}
}
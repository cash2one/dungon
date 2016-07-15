package com.leyou.ui.crossServer.children {
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCSServerRankInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.leyou.data.crossServer.CrossServerData;
	import com.leyou.data.crossServer.children.CrossServerLvData;
	import com.leyou.utils.PropUtils;

	public class CrossServerTaskCarItemRender extends AutoSprite {
		private var rankLbl:Label;

		private var serverLbl:Label;

		private var timeLbl:Label;

		public function CrossServerTaskCarItemRender() {
			super(LibManager.getInstance().getXML("config/ui/crossServer/kfdtHorseList.xml"));
			init();
		}

		public function init():void {
			rankLbl=getUIbyID("rankLbl") as Label;
			serverLbl=getUIbyID("serverLbl") as Label;
			timeLbl=getUIbyID("timeLbl") as Label;
		}

		public function updateInfo(serverData:CrossServerLvData):void {
			rankLbl.text=serverData.rank + "";
			serverLbl.text=serverData.serverName;
			var data:CrossServerData=DataManager.getInstance().crossServerData;
			var serverLv:TCSServerRankInfo=TableManager.getInstance().getCrossServerRankInfo(serverData.rank);
			var cd:Date=new Date(data.currentTime());
			var timeArr:Array=serverLv.deliveryTime.split(":");
			var tickDate:Date=new Date(cd.fullYear, cd.month, cd.date, timeArr[0], timeArr[1], timeArr[2]);
			if (cd.time > tickDate.time) {
				if (serverData.serverName == data.gname) {
					timeLbl.htmlText=serverLv.deliveryTime + PropUtils.getStringById(2282);
				} else {
					timeLbl.htmlText=serverLv.deliveryTime + PropUtils.getStringById(2284);
				}
			} else {
				timeLbl.htmlText=serverLv.deliveryTime + PropUtils.getStringById(2283);
			}
		}
	}
}

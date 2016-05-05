package com.leyou.ui.crossServer.children
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCSLvInfo;
	import com.ace.gameData.table.TCSServerRankInfo;
	import com.ace.gameData.table.TServerListInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.leyou.data.crossServer.children.CrossServerLvData;
	import com.leyou.ui.mail.child.MaillGrid;
	
	public class CrossServerLvItemRender extends AutoSprite
	{
		private var rankLbl:Label;
		
		private var serverLbl:Label;
		
		private var roleLbl:Label;
		
		private var valueLbl:Label;
		
		private var grids:Vector.<MaillGrid>;
		
		public function CrossServerLvItemRender(){
			super(LibManager.getInstance().getXML("config/ui/crossServer/kfdtLvList.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			rankLbl = getUIbyID("rankLbl") as Label;
			serverLbl = getUIbyID("serverLbl") as Label;
			roleLbl = getUIbyID("roleLbl") as Label;
			valueLbl = getUIbyID("valueLbl") as Label;
			grids = new Vector.<MaillGrid>();
			for(var n:int = 0; n < 5; n++){
				var grid:MaillGrid = new MaillGrid();
				grids.push(grid);
				grid.x = 446 + 42*n;
				grid.y = 1;
				addChild(grid);
			}
		}
		
		public function updateInfo(data:CrossServerLvData):void{
			rankLbl.text = data.rank+"";
			serverLbl.text = data.serverName;
			roleLbl.text = data.masterName;
			valueLbl.text = data.wboomValue+"";
			var serverInfo:TCSServerRankInfo = TableManager.getInstance().getCrossServerRankInfo(data.rank);
			var l:int = grids.length;
			for(var n:int = 0; n < l; n++){
				grids[n].updateInfo(serverInfo.itemList[n], serverInfo.itemNumList[n]);
			}
		}
	}
}
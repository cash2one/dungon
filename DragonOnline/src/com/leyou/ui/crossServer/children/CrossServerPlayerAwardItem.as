package com.leyou.ui.crossServer.children
{
	import com.ace.gameData.table.TCSPlayerRankInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.ui.mail.child.MaillGrid;
	import com.leyou.utils.PropUtils;
	
	public class CrossServerPlayerAwardItem extends AutoSprite
	{
		private var rankLbl:Label;
		
		private var grids:Vector.<MaillGrid>;
		
		public var id:int;
		
		public function CrossServerPlayerAwardItem(){
			super(LibManager.getInstance().getXML("config/ui/crossServer/kfdtMAwardRender2.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			rankLbl = getUIbyID("rankLbl") as Label;
			grids = new Vector.<MaillGrid>();
			for(var n:int = 0; n < 5; n++){
				var grid:MaillGrid = new MaillGrid();
				grids.push(grid);
				addChild(grid);
				grid.x = 151 + n*45;
				grid.y = 8;
			}
		}
		
		public function updateInfo(playerRankInfo:TCSPlayerRankInfo):void{
			id = playerRankInfo.rankId;
			rankLbl.text = StringUtil.substitute(PropUtils.getStringById(2274), playerRankInfo.rankId);
			var l:int = grids.length;
			for(var n:int = 0; n < l; n++){
				var grid:MaillGrid = grids[n];
				grid.updateInfo(playerRankInfo.itemList[n], playerRankInfo.itemNumList[n]);
			}
		}
	}
}
package com.leyou.ui.crossServer.children
{
	import com.ace.gameData.table.TCSLvInfo;
	import com.ace.gameData.table.TCSServerRankInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.ui.mail.child.MaillGrid;
	import com.leyou.utils.PropUtils;
	
	public class CrossServerServerAwardItem extends AutoSprite
	{
		private var serverLbl:Label;
		
		private var grids:Vector.<MaillGrid>;
		
		public var id:int;
		
		public function CrossServerServerAwardItem(){
			super(LibManager.getInstance().getXML("config/ui/crossServer/kfdtMAwardRender1.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			serverLbl = getUIbyID("serverLbl") as Label;
			grids = new Vector.<MaillGrid>();
			for(var n:int = 0; n < 5; n++){
				var grid:MaillGrid = new MaillGrid();
				grids.push(grid);
				addChild(grid);
				grid.x = 151 + n*45;
				grid.y = 8;
			}
		}
		
		public function updateInfo(serverRankInfo:TCSLvInfo):void{
			id = serverRankInfo.lv;
			serverLbl.text = StringUtil.substitute(PropUtils.getStringById(2273), serverRankInfo.lv);
			var l:int = grids.length;
			for(var n:int = 0; n < l; n++){
				var grid:MaillGrid = grids[n];
				grid.updateInfo(serverRankInfo.itemIdlist[n], serverRankInfo.itemNumlist[n]);
			}
		}
	}
}
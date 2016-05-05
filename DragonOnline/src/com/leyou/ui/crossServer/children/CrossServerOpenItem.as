package com.leyou.ui.crossServer.children
{
	import com.ace.config.Core;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TCSServerRankInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.leyou.data.crossServer.children.CrossServerLvData;
	import com.leyou.ui.mail.child.MaillGrid;
	import com.leyou.utils.PropUtils;
	
	public class CrossServerOpenItem extends AutoSprite
	{
		private var rankLbl:Label;
		
		private var serverLbl:Label;
		
		private var valueLbl:Label;
		
		public function CrossServerOpenItem(){
			super(LibManager.getInstance().getXML("config/ui/crossServer/kfdtOpenList.xml"));
			init();
		}
		
		private function init():void{
			rankLbl = getUIbyID("rankLbl") as Label;
			serverLbl = getUIbyID("serverLbl") as Label;
			valueLbl = getUIbyID("valueLbl") as Label;
			
		}
		
		public function updateInfo(data:CrossServerLvData):void{
			if(data.rank > 0){
				rankLbl.text = data.rank+"";
				serverLbl.text = data.masterName;
				valueLbl.text = data.gx+"";
			}else{
				rankLbl.text = PropUtils.getStringById(1821);
				serverLbl.text = Core.me.info.name;
				valueLbl.text = "0";
			}
		}
	}
}
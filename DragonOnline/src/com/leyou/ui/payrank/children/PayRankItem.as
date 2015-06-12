package com.leyou.ui.payrank.children
{
	import com.ace.config.Core;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.leyou.data.payrank.PayRankChildItem;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class PayRankItem extends AutoSprite
	{
		private var rankLbl:Label;
		
		private var nameLbl:Label;
		
		private var itemLbl:Label;
		
		public function PayRankItem(){
			super(LibManager.getInstance().getXML("config/ui/payRank/yrcbList.xml"));
			init();
		}
		
		private function init():void{
			rankLbl = getUIbyID("rankLbl") as Label;
			nameLbl = getUIbyID("nameLbl") as Label;
			itemLbl = getUIbyID("itemLbl") as Label;
		}
		
		public function updateInfo(item:PayRankChildItem):void{
//			if(Core.isSF && (1 == item.type) && (item.rank <= 10)){
//				itemLbl.text = "???";
//			}else{
			itemLbl.text = item.value+"";
//			}
			rankLbl.text = item.rank+"";
			nameLbl.text = item.name;
		}
	}
}
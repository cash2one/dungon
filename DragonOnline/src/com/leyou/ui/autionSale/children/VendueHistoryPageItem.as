package com.leyou.ui.autionSale.children
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TVendueInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.vendue.VendueHistoryData;
	import com.leyou.ui.mail.child.MaillGrid;
	
	public class VendueHistoryPageItem extends AutoSprite
	{
		private var dateLbl:Label;
		
		private var timeLbl:Label;
		
		private var priceLbl:Label;
		
		private var nameLbl:Label;
		
		private var grid:MaillGrid;
		
		public function VendueHistoryPageItem(){
			super(LibManager.getInstance().getXML("config/ui/vendue/vendueRender3Bar.xml"));
			init();
		}
		
		private function init():void{
			mouseEnabled = true;
			mouseChildren = true;
			dateLbl = getUIbyID("dateLbl") as Label;
			timeLbl = getUIbyID("timeLbl") as Label;
			priceLbl = getUIbyID("priceLbl") as Label;
			nameLbl = getUIbyID("nameLbl") as Label;
			grid = new MaillGrid();
			grid.isShowPrice = false;
			grid.x = 9;
			grid.y = 12;
			addChild(grid);
		}
		
		public function updateInfo(data:VendueHistoryData):void{
			var info:TVendueInfo = TableManager.getInstance().getVendueInfo(data.id);
			grid.updateInfo(info.itemId, info.itemCount);
			var date:Date = new Date(data.tick*1000);
			dateLbl.text = StringUtil.substitute("{1}.{2}.{3}", date.fullYear, date.month+1, date.date);
			timeLbl.text = StringUtil.substitute("{1}:{2}", date.hours, date.minutes);
			priceLbl.text = data.price+"";
			nameLbl.text = data.name;
		}
	}
}
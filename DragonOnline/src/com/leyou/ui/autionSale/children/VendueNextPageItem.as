package com.leyou.ui.autionSale.children
{
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TVendueInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.vendue.VendueNextData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.ui.market.child.MarketGrid;
	import com.leyou.utils.PropUtils;
	
	public class VendueNextPageItem extends AutoSprite
	{
		private var bpriceLbl:Label;
		
		private var timeLbl:Label;
		
		private var grid:MarketGrid;
		
		public function VendueNextPageItem(){
			super(LibManager.getInstance().getXML("config/ui/vendue/vendueRender2Bar.xml"));
			init();
		}
		
		private function init():void{
			mouseEnabled = true;
			mouseChildren = true;
			bpriceLbl = getUIbyID("bpriceLbl") as Label;
			timeLbl = getUIbyID("timeLbl") as Label;
			
			grid = new MarketGrid();
			grid.isShowPrice = false;
			grid.x = 20;
			grid.y = 17;
			addChild(grid);
		}
		
		public function updateInfo(data:VendueNextData):void{
			var info:TVendueInfo = TableManager.getInstance().getVendueInfo(data.id);
			grid.updataInfo({itemId:info.itemId, count:info.itemCount});
			bpriceLbl.text = info.bprice+"";
			var cdate:Date = new Date();
			var pdate:Date = new Date(data.dtime*1000);
			var edate:Date = new Date((data.dtime+ConfigEnum.vendue5)*1000);
			var timeStr:String = "{1}{2}:{3}~{4}:{5}"
			var dateStr:String = (cdate.date == pdate.date) ? PropUtils.getStringById(1618) : PropUtils.getStringById(1618);
			timeLbl.text = StringUtil.substitute(timeStr, dateStr, pdate.hours, pdate.minutes, edate.hours, edate.minutes);
		}
	}
}
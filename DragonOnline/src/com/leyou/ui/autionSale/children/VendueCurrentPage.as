package com.leyou.ui.autionSale.children
{
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TVendueInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.TimeManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.vendue.VendueData;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_PM;
	import com.leyou.ui.market.child.MarketGrid;
	import com.leyou.util.DateUtil;
	
	import flash.events.MouseEvent;
	
	public class VendueCurrentPage extends AutoSprite
	{
		private var cpriceLbl:Label;
		
		private var nameLbl:Label;
		
		private var timeTitleLbl:Label;
		
		private var timeLbl:Label;
		
		private var bpriceLbl:Label;
		
		private var mpriceLbl:TextInput;
		
		private var cautionBtn:NormalButton;
		
		private var mautionBtn:NormalButton;
		
		private var grid:MarketGrid;

		private var autionPrice:int;

		private var info:TVendueInfo;

		public function VendueCurrentPage(){
			super(LibManager.getInstance().getXML("config/ui/vendue/vendueRender1.xml"));
			init();
		}
		
		private function init():void{
			mouseEnabled = true;
			mouseChildren = true;
			cpriceLbl = getUIbyID("cpriceLbl") as Label;
			nameLbl = getUIbyID("nameLbl") as Label;
			timeLbl = getUIbyID("timeLbl") as Label;
			timeTitleLbl = getUIbyID("timeTitleLbl") as Label;
			bpriceLbl = getUIbyID("bpriceLbl") as Label;
			mpriceLbl = getUIbyID("mpriceLbl") as TextInput;
			cautionBtn = getUIbyID("cautionBtn") as NormalButton;
			mautionBtn = getUIbyID("mautionBtn") as NormalButton;
			mpriceLbl.restrict = "0-9";
			
			cautionBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			mautionBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			
			grid = new MarketGrid();
			grid.isShowPrice = false;
			grid.x = 33+11;
			grid.y = 33+44;
			addChild(grid);
		}
		
		public function addTimer():void{
			if(!TimeManager.getInstance().hasITick(updateTime)){
				TimeManager.getInstance().addITick(1000, updateTime);
			}
		}
		
		private function updateTime():void{
			var rtime:int = DataManager.getInstance().vendueData.remianTime;
			timeLbl.text = DateUtil.formatTime(rtime*1000, 2);
		}
		
		public function removeTimer():void{
			if(TimeManager.getInstance().hasITick(updateTime)){
				TimeManager.getInstance().removeITick(updateTime);
			}
		}
		
		private function onBtnClick(event:MouseEvent):void{
			var itemInfo:Object = TableManager.getInstance().getItemInfo(info.itemId);
			if(null == itemInfo){
				itemInfo = TableManager.getInstance().getEquipInfo(info.itemId);
			}
			switch(event.target.name){
				case "cautionBtn":
					autionPrice = int(bpriceLbl.text);
					break;
				case "mautionBtn":
					autionPrice = int(mpriceLbl.text);
					break;
			}
			var content:String = TableManager.getInstance().getSystemNotice(6505).content;
			content = StringUtil.substitute(content, autionPrice, itemInfo.name, info.itemCount);
			PopupManager.showConfirm(content, auction, null, false, "vendue.aution");
		}
		
		private function auction():void{
			Cmd_PM.cm_PM_P(autionPrice);
		}
		
		public function updateInfo(data:VendueData):void{
			updateTime();
			info = TableManager.getInstance().getVendueInfo(data.pid);
			grid.updataInfo({itemId:info.itemId, count:info.itemCount});
			cpriceLbl.text = data.cprice+"";
			nameLbl.text = data.cname+"";
			
			if(0 == data.pstatus){
				timeLbl.textColor = 0xff0000;
				timeTitleLbl.textColor = 0xff0000;
				timeTitleLbl.text = "距离本次拍卖开始还剩：";
			}else if(1 == data.pstatus){
				timeLbl.textColor = 0xff00;
				timeTitleLbl.textColor = 0xff00;
				timeTitleLbl.text = "距离本次拍卖结束还剩：";
			}
//			timeTitleLbl.text = (0 == data.pstatus) ? "距离本次拍卖开始还剩：" : "距离本次拍卖结束还剩：";
			cautionBtn.setActive((1 == data.pstatus), 1, true);
			mautionBtn.setActive((1 == data.pstatus), 1, true);
			bpriceLbl.text = data.bprice+"";
			mpriceLbl.text = data.bprice+"";
		}
	}
}
package com.leyou.ui.qqVip.children
{
	import com.ace.enum.FilterEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TQQVipDayRewardInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.leyou.data.qqvip.QQVipData;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_QQVip;
	import com.leyou.ui.market.child.MarketGrid;
	
	import flash.events.MouseEvent;

	public class QQVipDayPage extends AutoSprite
	{
		private var scrollPanel:ScrollPane;
		
		private var receiveImg:Image;
		
		private var receiveBtn:ImgButton;
		
		private var grid1:MarketGrid;
		
		private var grid2:MarketGrid;
		
		private var rewards:Vector.<QQVipDayRender>;
		
		public function QQVipDayPage(){
			super(LibManager.getInstance().getXML("config/ui/qqVip/qqVipDay.xml"));
			init();
		}
		
		private function init():void{
			mouseChildren = true;
			scrollPanel = getUIbyID("scrollPanel") as ScrollPane;
			receiveImg = getUIbyID("receiveImg") as Image;
			receiveBtn = getUIbyID("receiveBtn") as ImgButton;
			rewards = new Vector.<QQVipDayRender>(8);
			grid1 = new MarketGrid();
			grid2 = new MarketGrid();
			addChild(grid1);
			addChild(grid2);
			grid1.x = 330;
			grid1.y = 43;
			grid2.x = 330;
			grid2.y = 134;
			initTable();
			addChild(receiveImg);
			
			receiveBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function initTable():void{
			var arr:Array = ConfigEnum.qqvip1.split("|");
			var reward1:Array = arr[0].split(",");
			var reward2:Array = arr[1].split(",");
			grid1.updataInfo({itemId:reward1[0], count:reward1[1]});
			grid2.updataInfo({itemId:reward2[0], count:reward2[1]});
			var l:int = rewards.length;
			for(var n:int = 0; n < l; n++){
				var dayRender:QQVipDayRender = rewards[n];
				if(null == dayRender){
					dayRender = new QQVipDayRender();
					rewards[n] = dayRender;
				}
				addChild(dayRender);
				dayRender.x = 4;
				dayRender.y = n*50;
				scrollPanel.addToPane(dayRender);
				var tinfo:TQQVipDayRewardInfo = TableManager.getInstance().getQQDayInfo(n+1);
				dayRender.updateTableInfo(tinfo);
			}
			scrollPanel.updateUI();
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			switch(event.target.name){
				case "receiveBtn":
					Cmd_QQVip.cm_TX_X(2);
					break;
			}
		}
		
		public function updateInfo():void{
			var data:QQVipData = DataManager.getInstance().qqvipData;
			var r:Boolean = (0 == data.ydStatus);
			receiveBtn.setActive(r, 1, true);
			receiveImg.visible = (1 == data.ydStatus);
			grid1.filters = receiveImg.visible ? [FilterEnum.enable] : null;
			grid2.filters = receiveImg.visible ? [FilterEnum.enable] : null;
			var l:int = rewards.length;
			for(var n:int = 0; n < l; n++){
				var dayRender:QQVipDayRender = rewards[n];
				dayRender.updateStatus(data);
			}
		}
	}
}
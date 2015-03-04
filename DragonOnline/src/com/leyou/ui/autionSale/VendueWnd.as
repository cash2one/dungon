package com.leyou.ui.autionSale
{
	import com.ace.enum.TipEnum;
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.lable.Label;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.leyou.data.vendue.VendueData;
	import com.leyou.net.cmd.Cmd_PM;
	import com.leyou.ui.autionSale.children.VendueCurrentPage;
	import com.leyou.ui.autionSale.children.VendueHistoryPage;
	import com.leyou.ui.autionSale.children.VendueNextPage;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class VendueWnd extends AutoWindow
	{
		private var vendueCurrent:VendueCurrentPage;
		
		private var vendueHistory:VendueHistoryPage;
		
		private var vendueNext:VendueNextPage;
		
		private var vendueBar:TabBar;
		
		private var currentIndex:int;
		
		private var ruleLbl:Label;
		
		private var ybLbl:Label;
		
		public function VendueWnd(){
			super(LibManager.getInstance().getXML("config/ui/vendue/vendueWnd.xml"));
			init();
		}
		
		private function init():void{
			hideBg();
			clsBtn.x += 4;
			clsBtn.y += 13;
			
			vendueCurrent = new VendueCurrentPage();
			vendueNext = new VendueNextPage();
			vendueHistory = new VendueHistoryPage();
			
			vendueBar = getUIbyID("saleBar") as TabBar;
			ruleLbl = getUIbyID("ruleLbl") as Label;
			ybLbl = getUIbyID("ybLbl") as Label;
			vendueBar.addToTab(vendueCurrent, 0);
			vendueBar.addToTab(vendueNext, 1);
			vendueBar.addToTab(vendueHistory, 2);
			vendueBar.addEventListener(TabbarModel.changeTurnOnIndex, onTableChage);
			vendueCurrent.x = 28;
			vendueCurrent.y = 2;
			vendueNext.x = 28;
			vendueNext.y = 2;
			vendueHistory.x = -7;
			vendueHistory.y = 2;
			
			ruleLbl.mouseEnabled = true;
			ruleLbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			var content:String = TableManager.getInstance().getSystemNotice(6504).content;
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
		}
		
		public function onTableChage(event:Event):void{
			if(vendueBar.turnOnIndex == currentIndex){
				return;
			}
			currentIndex = vendueBar.turnOnIndex;
			switch(currentIndex){
				case 0:
					Cmd_PM.cm_PM_I();
					break;
				case 1:
					Cmd_PM.cm_PM_F();
					break;
				case 2:
					Cmd_PM.cm_PM_L();
					break;
			}
		}
		
		public function resize():void {
			x = (UIEnum.WIDTH - width) >> 1;
			y = (UIEnum.HEIGHT - height) >> 1;
		}
		
		public override function hide():void{
			super.hide();
			vendueCurrent.removeTimer();
		}
		
		public function updateCurrentPage():void{
			var data:VendueData = DataManager.getInstance().vendueData;
			vendueCurrent.updateInfo(data);
			vendueCurrent.addTimer();
		}
		
		public function updateNextPage():void{
			var data:VendueData = DataManager.getInstance().vendueData;
			vendueNext.updateInfo(data);
			vendueCurrent.removeTimer();
		}
		
		public function updateHistoryPage():void{
			var data:VendueData = DataManager.getInstance().vendueData;
			vendueHistory.updateInfo(data);
			vendueCurrent.removeTimer();
		}
		
		public override function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void{
			super.show(toTop, $layer, toCenter);
			updataMoney();
		}
		
		/**
		 * <T>更新金钱</T>
		 * 
		 */		
		public function updataMoney():void {
			ybLbl.text = UIManager.getInstance().backpackWnd.yb+"";
		}
	}
}
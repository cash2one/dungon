package com.leyou.ui.integral.children
{
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TShop;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.ui.market.child.MarketGrid;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class IntegralShopItem extends AutoSprite
	{
		private var valueLbl:Label;
		
		private var nameLbl:Label;
		
		private var grid:MarketGrid;
		
		private var bgImg:Image;
		
		private var _itemId:int;
		
		private var iconImg:Image;
		
		public var tshopData:TShop;
		
		public function IntegralShopItem(){
			super(LibManager.getInstance().getXML("config/ui/cost/xffl1Btn.xml"));
			init();
		}
		
		public function get itemId():int{
			return _itemId;
		}

		private function init():void{
			mouseEnabled = true;
			mouseChildren = true;
			bgImg = getUIbyID("bgImg") as Image;
			valueLbl = getUIbyID("valueLbl") as Label;
			nameLbl = getUIbyID("nameLbl") as Label;
			iconImg = getUIbyID("iconImg") as Image;
			var spt:Sprite = new Sprite();
			spt.addChild(iconImg);
			spt.addEventListener(MouseEvent.MOUSE_OVER, onIconOver);
			addChild(spt);
			grid = new MarketGrid();
			addChild(grid);
			grid.x = 14;
			grid.y = 10;
			grid.isShowPrice = false;
			addEventListener(MouseEvent.CLICK, onMouseClick);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		protected function onIconOver(event:MouseEvent):void{
			var content:String = TableManager.getInstance().getSystemNotice(10002).content;
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
		}
		
		protected function onMouseOut(event:MouseEvent):void{
			bgImg.updateBmp("ui/xffl/xffl_bg2.jpg");
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			bgImg.updateBmp("ui/xffl/xffl_bg3.jpg");
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			UIManager.getInstance().buyWnd.show();
			DataManager.getInstance().integralData.itemId = _itemId;
			UIManager.getInstance().buyWnd.updateIntegral(this);
//			Cmd_CLI.cm_CLI_B(itemId, 1);
		}
		
		public function updateInfo(shop:TShop):void{
			tshopData = shop;
			valueLbl.text = shop.moneyNum+"";
			_itemId = shop.itemId;
			var eitem:TEquipInfo = TableManager.getInstance().getEquipInfo(shop.itemId);
			if(null != eitem){
				nameLbl.text = eitem.name;
			}
			var item:TItemInfo = TableManager.getInstance().getItemInfo(shop.itemId);
			if(null != item){
				nameLbl.text = item.name;
			}
			grid.updataById(shop.itemId);
		}
	}
}
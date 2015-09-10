package com.leyou.ui.market.child {
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.market.MarketItemInfo;
	import com.leyou.net.cmd.Cmd_Market;
	import com.leyou.ui.shop.BuyWnd;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.StringUtil_II;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;

	public class MarketItemRender extends AutoSprite {
		private var nameLbl:Label;
		private var typeLbl:Label;
		private var applyLbl:Label;
		private var nowPriceValueLbl:Label;
		private var priceValueLbl:Label;
		private var buyBtn:NormalButton;
		private var dicountLbl:Label;
		private var nowPriceImg:Image;
		private var priceImg:Image;
		private var hotImg:Image;
		private var priceLbl:Label;
		private var newPriceLbl:Label;
		
//		private var line:Shape;
		
		public static var buyWnd:BuyWnd;
		private var grid:MarketGrid;
		
		public var id:int;
		public var dataLink:MarketItemInfo;
		
		public function MarketItemRender() {
			super(LibManager.getInstance().getXML("config/ui/market/marketItemRender.xml"));
			init();
		}
		
		/**
		 * <T>初始化</T> 
		 * 
		 */		
		private function init():void{
			mouseChildren=true;
			nameLbl=getUIbyID("nameLbl") as Label;
			typeLbl=getUIbyID("typeLbl") as Label;
			applyLbl=getUIbyID("applyLbl") as Label;
			priceValueLbl=getUIbyID("priceValueLbl") as Label;
			nowPriceValueLbl=getUIbyID("nowPriceValueLbl") as Label;
			buyBtn=getUIbyID("buyBtn") as NormalButton;
			dicountLbl=getUIbyID("dicountLbl") as Label;
			hotImg=getUIbyID("hotImg") as Image;
			priceLbl=getUIbyID("priceLbl") as Label;
			newPriceLbl=getUIbyID("newPriceLbl") as Label;
			
			nowPriceImg=getUIbyID("nowPriceImg") as Image;
			var container:Sprite = new Sprite();
			container.name = nowPriceImg.name;
			container.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			nowPriceImg.parent.addChild(container);
			container.addChild(nowPriceImg);
			priceImg=getUIbyID("priceImg") as Image;
			container = new Sprite();
			container.name = priceImg.name;
			container.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			priceImg.parent.addChild(container);
			container.addChild(priceImg);
			
			typeLbl.multiline = true;
			typeLbl.wordWrap = true;
			var textForat:TextFormat = new TextFormat();
			textForat.leading = 3;
			typeLbl.defaultTextFormat = textForat;
			dicountLbl.mouseEnabled = true;
			var style:StyleSheet = new StyleSheet()
			style.setStyle("body", {leading:0.5});
			style.setStyle("a:hover", {color:"#ff0000"});
			dicountLbl.styleSheet = style;
			dicountLbl.htmlText = StringUtil_II.addEventString(dicountLbl.text, dicountLbl.text, true);
			dicountLbl.addEventListener(TextEvent.LINK, onBtnClick);
			
			buyBtn.addEventListener(MouseEvent.CLICK, onBtnClick, false, 0, true);
//			dicountLbl.addEventListener(MouseEvent.CLICK, onBtnClick, false, 0, true);
			
			grid=new MarketGrid();
			grid.x=10;
			grid.y=10; 
			addChild(grid);
			grid.isShowPrice = true;
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			var content:String;
			switch(dataLink.moneyType){
				case 1:
					content = TableManager.getInstance().getSystemNotice(9558).content;
					break;
				case 2:
					content = TableManager.getInstance().getSystemNotice(9559).content;
					break;
				default:
					throw new Error("aution show money icon tip unknow fault");
					break;
			}
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX, stage.mouseY));
			
		}
		
		/**
		 * <T>按钮点击监听</T>
		 * 
		 * @param evt 鼠标事件
		 * 
		 */		
		private function onBtnClick(evt:Event):void{
			if(evt.target.name=="buyBtn"){//购买按钮
				if(null == buyWnd){
					buyWnd = new BuyWnd();
				}
//				buyWnd.setKeepMode(false);
				buyWnd.updateMarket(dataLink);
				LayerManager.getInstance().addPopWnd(false, buyWnd);
				buyWnd.show();
			}else if(evt.target.name=="dicountLbl"){//打折按钮
				Cmd_Market.cm_Mak_A(dataLink.pageType, dataLink.itemId);
			}
		}
		
		/**
		 * <T>更新显示信息</T>
		 * 
		 * @param info 数据信息
		 * 
		 */		
		public function updateInfo(data:MarketItemInfo):void{
			if(null != dataLink){
				// 断开原来的数据与显示对象的连接
				dataLink.render = null;
			}
			dataLink = data;
			dataLink.render = this;
			dataLink.buyType = 2;
			updataRender();
		}
		
		/**
		 * <T>更新显示</T>
		 * 
		 */		
		public function updataRender():void{
			grid.moneyType = dataLink.moneyType;
			grid.moneyNum = dataLink.nowPrice;
			var itemName:String;
			var color:uint;
			// 找到物品信息
			var info:Object = TableManager.getInstance().getItemInfo(dataLink.itemId);
			if(null == info){
				info = TableManager.getInstance().getEquipInfo(dataLink.itemId);
			}
			itemName = info.name;
			typeLbl.text = info.des;
			color = ItemUtil.getColorByQuality(parseInt(info.quality));
			nameLbl.htmlText = "<Font face='SimSun' size = '12' color='#"+ color.toString(16).replace("0x") + "'>" + itemName + "</Font>";
			
			priceValueLbl.text = dataLink.price+"";
			nowPriceValueLbl.text = dataLink.nowPrice+"";
			applyLbl.visible = dataLink.isapply;
			dicountLbl.visible = (dataLink.acceptDiscount && !dataLink.isapply);
			
			var sourcePath:String = ItemUtil.getExchangeIcon(dataLink.moneyType)
			priceImg.updateBmp(sourcePath);
			nowPriceImg.updateBmp(sourcePath);
			hotImg.visible = dataLink.hot;
			
			grid.updataInfo(dataLink);
			
			priceValueLbl.visible = dataLink.discount;
			priceImg.visible = dataLink.discount;
			priceLbl.visible = dataLink.discount;
		}
		
		/**
		 * <T>...</T>
		 * 
		 */		
		public override function die():void{
			dataLink.render = null;
			dataLink = null;
			buyBtn.removeEventListener(MouseEvent.CLICK,onBtnClick);
			dicountLbl.removeEventListener(MouseEvent.CLICK,onBtnClick);
		}
	}
}
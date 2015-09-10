package com.leyou.ui.quickBuy
{
	import com.ace.config.Core;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TMarketInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.button.children.RadioButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.input.children.NumericStepper;
	import com.ace.ui.lable.Label;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.ui.scrollBar.event.ScrollBarEvent;
	import com.ace.ui.slider.children.HSlider;
	import com.leyou.data.quickBuy.QuickBuyInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Market;
	import com.leyou.ui.market.child.MarketGrid;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PayUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class QuickBuyWnd extends AutoWindow
	{
//		private var numInput:TextInput;
		
		private var nameLbl:Label;
		
		private var totalPriceImg:Image;
		
//		private var addBtn:ImgButton;
		
//		private var delBtn:ImgButton;
		
		private var bybRBtn:RadioButton;
		
		private var ybRBtn:RadioButton;
		
		private var autoBuyCheck:CheckBox;
		
		private var sumPrice:Label;
		
		private var buyBtn:NormalButton;
		
//		private var supplementBtn:NormalButton;
		
		private var grid:MarketGrid;
		
		private var items:Vector.<QuickBuyInfo>;
		
		private var currentId:int;
		
		private var currentIdB:int;
		
		private var yiconImg:Image;
		
		private var byiconImg:Image;
		
		private var currentItem:QuickBuyInfo;
		
		private var itemInfo:QuickBuyInfo;
		
		private var itemInfoB:QuickBuyInfo;
		
		private var numStep:NumericStepper;
		
		private var numSlider:HSlider;
		
		private var payBtn:NormalButton;

		private var maxCount:int;
		
		public function QuickBuyWnd(){
			super(LibManager.getInstance().getXML("config/ui/quickBuyWnd.xml"));
			this.init();
		}
		
		private function init():void{
			mouseEnabled = true;
			mouseChildren = true;
			hideBg();
			ybRBtn = getUIbyID("ybChek") as RadioButton;
			bybRBtn = getUIbyID("bybChek") as RadioButton;
			autoBuyCheck = getUIbyID("autoBuyCheck") as CheckBox;
			totalPriceImg = getUIbyID("totalPriceImg") as Image;
//			addBtn = getUIbyID("addBtn") as ImgButton;
//			delBtn = getUIbyID("delBtn") as ImgButton;
			nameLbl = getUIbyID("nameLbl") as Label;
			sumPrice = getUIbyID("sumPrice") as Label;
			buyBtn = getUIbyID("buyBtn") as NormalButton;
			payBtn = getUIbyID("payBtn") as NormalButton;
//			supplementBtn = getUIbyID("supplementBtn") as NormalButton;
			yiconImg = getUIbyID("yiconImg") as Image;
			byiconImg = getUIbyID("byiconImg") as Image;
			numStep = getUIbyID("numStep") as NumericStepper;
			numSlider = getUIbyID("numSlider") as HSlider;
//			numInput = getUIbyID("numInput") as TextInput;
//			var format:TextFormat = numInput.input.defaultTextFormat;
//			format.align = TextFormatAlign.CENTER;
//			numInput.input.defaultTextFormat = format
			grid = new MarketGrid();
			grid.x = 42;
			grid.y = 64;
			addChild(grid);
			items = new Vector.<QuickBuyInfo>();
			numStep.input.addEventListener(Event.CHANGE, onInputChange);
			numStep.addEventListener(Event.CHANGE, onInputChange);
			bybRBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			ybRBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
//			addBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
//			delBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			autoBuyCheck.addEventListener(MouseEvent.CLICK, onMouseClick);
			buyBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			payBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			numSlider.addEventListener(ScrollBarEvent.Progress_Update, onSliderScroll);
//			supplementBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			if(!Core.PAY_OPEN){
				payBtn.setActive(false, 1, true);
			}else{
				payBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			}
			clsBtn.x -= 6;
			clsBtn.y -= 14;
//			opaqueBackground = 0xff;
		}
		
		protected function onSliderScroll(event:Event):void {
			var n:String=event.target.name;
			switch (n) {
				case "numSlider":
					var count:int = numSlider.progress*maxCount;
					if(0 >= count){
						count = 1;
					}
					numStep.value = count;
					break;
			}
		}
		
		protected function getMaxCount(itemId:int, price:int, quckInfo:QuickBuyInfo):int{
			var yb:int = UIManager.getInstance().backpackWnd.yb;
			var byb:int = UIManager.getInstance().backpackWnd.byb;
			var freeBagNum:int = MyInfoManager.getInstance().getBagEmptyNum();
			
			var itTable:TItemInfo = TableManager.getInstance().getItemInfo(itemId);
			var maxCount:int = itTable.maxgroup * freeBagNum;
			var tmpCount:int = quckInfo.isBind ? byb/price : yb/price;
			if(maxCount > tmpCount){
				maxCount = tmpCount;
			}
			if(maxCount <= 0){
				maxCount = 1;
			}
			return maxCount;
		}
		
		protected function onInputChange(event:Event):void{
			var sumCount:int = int(numStep.text);
//			var table:TItemInfo = TableManager.getInstance().getItemInfo(currentItem.itemId);
//			if (sumCount > maxCount) {
//				sumCount = maxCount;
//				numStep.value = sumCount;
//			}
			sumPrice.text = (currentItem.price * sumCount) + "";
			numSlider.progress = numStep.value/maxCount;
		}
		
		public function getItemNotShow(itemId1:uint, itemId2:uint, itemCount:int=1):Boolean{
			if(0 == itemId1 || 0 == itemId2){
				throw new Error("getItemNotShow .快捷购买ID是0")
			}
			if(Core.me.info.level < ConfigEnum.MarketOpenLevel){
				NoticeManager.getInstance().broadcastById(9955);
				return false;
			}
			currentId = itemId1;
			currentIdB = itemId2;
			itemInfo = findItem(currentId);
			itemInfoB = findItem(currentIdB);
			if(null == itemInfo && null == itemInfoB){
				Cmd_Market.cm_Mak_F(itemId1, itemId2);
			}else{
				if(bybRBtn.isOn && itemInfoB){
					if(itemInfoB.autoBuy){
						Cmd_Market.cm_Mak_B(4, itemInfoB.itemId, itemCount);
						hide();
						return itemInfoB.autoBuy;
					}
				}
				if(ybRBtn.isOn && itemInfo){
					if(itemInfo.autoBuy){
						Cmd_Market.cm_Mak_B(1, itemInfo.itemId, itemCount);
						hide();
						return itemInfo.autoBuy;
					}
				}
			}
			return false;
		}
		
		/**
		 * 是否拥有足够货币购买道具
		 * 
		 * @param itemId 道具ID
		 * @param itemCount 道具数量
		 * @return       是否足够
		 * 
		 */		
		public function enoughToBuy(itemId:uint, itemCount:int=1):uint{
			itemInfo = findItem(itemId);
			itemInfoB = findItem(itemId);
			if(itemInfoB){
				return itemInfoB.price * itemCount;
			}
			if(itemInfo){
				return itemInfo.price * itemCount;
			}
			throw new Error("can't find item by id");
			return 0;
		}
		
		public function isAutoBuy(itemId1:uint, itemId2:uint):Boolean{
			if(0 == itemId1 || 0 == itemId2){
				throw new Error("isAutoBuy .快捷购买ID是0")
			}
			itemInfo = findItem(itemId1);
			itemInfoB = findItem(itemId2);
			//			if(bybRBtn.isOn){
			if(itemInfo && itemInfo.autoBuy){
				return true;
			}else{
				if(itemInfoB && itemInfoB.autoBuy){
					return true;
				}
			}
			return false;
		}
		
		private function findItem(itemId:uint):QuickBuyInfo{
			var length:int = items.length;
			for(var n:int = 0; n < length; n++){
				var itemInfo:QuickBuyInfo = items[n];
				if(itemInfo.itemId == itemId){
					return itemInfo;
				}
			}
			return null;
		}
		
		public override function hide():void{
			super.hide();
			if(UIManager.getInstance().roleWnd.visible){
				UILayoutManager.getInstance().composingWnd(WindowEnum.ROLE);
			}
			if(UIManager.getInstance().skillWnd && UIManager.getInstance().skillWnd.visible){
				UILayoutManager.getInstance().composingWnd(WindowEnum.SKILL);
			}
			if(UIManager.getInstance().equipWnd && UIManager.getInstance().equipWnd.visible){
				UILayoutManager.getInstance().composingWnd(WindowEnum.EQUIP);
			}
		}
		
		public function pushItem(itemId1:uint, itemId2:uint, itemCount:int=1):void{
			if(0 == itemId1 || 0 == itemId2){
				throw new Error("pushItem .快捷购买ID是0")
			}
			if(Core.me.info.level < ConfigEnum.MarketOpenLevel){
				NoticeManager.getInstance().broadcastById(9955);
				return;
			}
			currentId = itemId1;
			currentIdB = itemId2;
			numStep.text = itemCount + "";
			itemInfo = findItem(currentId);
			itemInfoB = findItem(currentIdB);
			if(null == itemInfo && null == itemInfoB){
				Cmd_Market.cm_Mak_F(itemId1, itemId2);
				return;
			}
			if(/*ybRBtn.isOn && */itemInfo && itemInfo.select){
				showItem(itemInfo);
				return;
			}
			if(/*bybRBtn.isOn && */itemInfoB && itemInfoB.select){
				showItem(itemInfoB);
				return;
			}
			if((itemInfo && !itemInfo.select) && (itemInfoB && !itemInfoB.select)){
				showItem(itemInfo);
				ybRBtn.turnOn();
				return;
			}
			if((null == itemInfo) && (null != itemInfoB)){
				showItem(itemInfoB);
				bybRBtn.turnOn();
				return;
			}
		}
		
		private function showItem(info:QuickBuyInfo):void{
			autoBuyCheck.visible = !(21000 == info.itemId || 21001 == info.itemId);
			
			var iconUrl:String;
			grid.updataById(info.itemId);
			if(info.isBind){
				bybRBtn.visible = true;
				byiconImg.visible = true;
				iconUrl = "ui/backpack/yuanbaoIco_bound.png";
				if(info.relativeItem){
					ybRBtn.visible = true;
					yiconImg.visible = true;
				}else{
					ybRBtn.visible = false;
					yiconImg.visible = false;
				}
				if(info.select){
					bybRBtn.turnOn();
				}else{
					ybRBtn.turnOn();
				}
			}else{
				iconUrl = "ui/backpack/yuanbaoIco.png";
				ybRBtn.visible = true;
				yiconImg.visible = true;
				if(info.relativeItem){
					bybRBtn.visible = true;
					byiconImg.visible = true;
				}else{
					bybRBtn.visible = false;
					byiconImg.visible = false;
				}
				if(info.select){
					ybRBtn.turnOn();
				}else{
					bybRBtn.turnOn();
				}
			}
			if(info && info.autoBuy){
				autoBuyCheck.turnOn();
			}else if(info.relativeItem && info.relativeItem.autoBuy){
				autoBuyCheck.turnOn();
			}else{
				autoBuyCheck.turnOff();
			}
			currentItem = info;
			totalPriceImg.updateBmp(iconUrl);
			sumPrice.text = (currentItem.price * int(numStep.text))+"";
			var color:int = ItemUtil.getColorByQuality(currentItem.quality);
			nameLbl.htmlText = "<Font face='SimSun' size = '16' color='#"+ color.toString(16).replace("0x") + "'>" + currentItem.name+ "</Font>";
			numStep.minimum = 1;
			numStep.maximum = getMaxCount(info.itemId, info.price, info);
			numStep.value = 1;
			numSlider.progress = 0;
			maxCount = numStep.maximum;
			sumPrice.text = (currentItem.price * numStep.value) + "";
		}
		
		// 0 -- 使用绑定元宝  1 -- 使用元宝
		public function getCost(item1:int, item2:int):int{
			var item:QuickBuyInfo = findItem(item1);
			var bitem:QuickBuyInfo = findItem(item2);
			if(item.autoBuy){
				return 1;
			}
			if(bitem.autoBuy){
				return 0;
			}
			// 出错3
			return 3;
		}
		
		protected function onMouseClick(event:MouseEvent):void{
			switch(event.target.name){
				case "ybChek":
					currentItem = itemInfo;
					if(autoBuyCheck.isOn){
						currentItem.autoBuy = true;
						if(currentItem.relativeItem){
							currentItem.relativeItem.autoBuy = false;
						}
					}
					currentItem.select = true;
					if(currentItem.relativeItem){
						currentItem.relativeItem.select = false;
						
					}
					showItem(currentItem);
					break;
				case "bybChek":
					currentItem = itemInfoB;
					if(autoBuyCheck.isOn){
						currentItem.autoBuy = true;
						if(currentItem.relativeItem){
							currentItem.relativeItem.autoBuy = false;
						}
					}
					currentItem.select = true;
					if(currentItem.relativeItem){
						currentItem.relativeItem.select = false;
						
					}
					showItem(currentItem);
					break;
				case "autoBuyCheck":
					if(autoBuyCheck.isOn){
						if(ybRBtn.isOn){
							itemInfo.autoBuy = true;
							if(itemInfo.relativeItem){
								itemInfo.relativeItem.autoBuy = false;
							}
						}else{
							itemInfoB.autoBuy = true;
							if(itemInfoB.relativeItem){
								itemInfoB.relativeItem.autoBuy = false;
							}
						}
					}else{
						currentItem.autoBuy = false;
						if(currentItem.relativeItem){
							currentItem.relativeItem.autoBuy = false;
						}
					}
					break;
				case "buyBtn":
					if(null == currentItem){
						return;
					}
					var type:int = currentItem.isBind ? 4 : 1;
					Cmd_Market.cm_Mak_B(type, currentItem.itemId, int(numStep.text));
					hide();
					break;
				case "payBtn":
					// 充值按钮
					PayUtil.openPayUrl();
					break;
			}
		}
		
		public override function get width():Number{
			return 308;
		}
		
		public override function get height():Number{
			return 482/*512*/;
		}
		
		public function loadItem(o:Object):void{
			autoBuyCheck.turnOff();
			var list:Array = o.list;
			var length:uint = list.length;
			for(var n:int = 0; n < length; n++){
				var itemId:int = list[n][0];
				if(null != findItem(itemId)){
					continue;
				}
				var price:uint = list[n][1];
				var item:TItemInfo = TableManager.getInstance().getItemInfo(itemId);
				var mitem:TMarketInfo = TableManager.getInstance().getMarketItem(itemId);
				var info:QuickBuyInfo = new QuickBuyInfo();
				info.name = item.name;
				info.itemId = itemId;
				info.price = price;
				info.isBind = mitem.isBind();
				info.quality = int(item.quality);
				items.push(info);
				if(info.isBind){
					itemInfoB = info;
				}else{
					itemInfo = info;
				}
			}
			if(null != itemInfo){
				itemInfo.select = true;
				ybRBtn.turnOn();
				itemInfo.relativeItem = itemInfoB;
				currentItem = itemInfo;
				showItem(currentItem);
				ybRBtn.turnOn();
			}
			if(null != itemInfoB){
				itemInfoB.relativeItem = itemInfo;
				if(null == currentItem){
					currentItem = itemInfoB;
					showItem(currentItem);
					bybRBtn.turnOn();
				}
			}
//			if(null != currentItem){
//				showItem(currentItem);
//			}
		}
	}
}
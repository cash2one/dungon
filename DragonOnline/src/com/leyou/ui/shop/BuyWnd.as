package com.leyou.ui.shop {

	import com.ace.enum.FontEnum;
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TShop;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.input.children.NumericStepper;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.Label;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.ui.scrollBar.event.ScrollBarEvent;
	import com.ace.ui.slider.children.HSlider;
	import com.leyou.data.aution.AutionItemData;
	import com.leyou.data.market.MarketItemInfo;
	import com.leyou.net.cmd.Cmd_CLI;
	import com.leyou.net.cmd.Cmd_Guild;
	import com.leyou.net.cmd.Cmd_Market;
	import com.leyou.net.cmd.Cmd_Shp;
	import com.leyou.ui.integral.children.IntegralShopItem;
	import com.leyou.ui.shop.child.ShopGrid;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.ShopUtil;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;

	public class BuyWnd extends AutoWindow {

		private var confirmBtn:NormalButton;
		private var cancelBtn:NormalButton;
		private var numInput:TextInput;
		private var delBtn:ImgButton;
		private var addBtn:ImgButton;
		private var nameLbl:Label;
		private var unitPriceLbl:Label;
		private var stackLbl:Label;
		private var sumPrice:Label;
		private var grid:ShopGrid;
		private var priceImg:Image;
		private var totalPriceImg:Image;
		private var silder:HSlider;
		private var numStep:NumericStepper;

		private var index:int=0;

		private var moneyId:int=0;
		/**
		 * 0 -- 商店
		 * 1 -- 行会
		 * 2 -- 商城
		 * 3 -- 随身寄售
		 * 4 -- 神秘商店
		 */
		private var buyType:int=0;
		private var subbuyType:int=0;

		private var table:Object;

		public function BuyWnd() {
			super(LibManager.getInstance().getXML("config/ui/shop/ShopBuyWnd.xml"));
			this.init();
			this.hideBg();
//			this.clsBtn.y-=10;
		}

		private function init():void {

			this.confirmBtn=this.getUIbyID("confirmBtn") as NormalButton;
			this.cancelBtn=this.getUIbyID("cancelBtn") as NormalButton;
			this.numInput=this.getUIbyID("numInput") as TextInput;
			this.delBtn=this.getUIbyID("delBtn") as ImgButton;
			this.addBtn=this.getUIbyID("addBtn") as ImgButton;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.unitPriceLbl=this.getUIbyID("unitPriceLbl") as Label;
			this.stackLbl=this.getUIbyID("stackLbl") as Label;
			this.sumPrice=this.getUIbyID("sumPrice") as Label;

			this.silder=this.getUIbyID("silder") as HSlider;
			this.numStep=this.getUIbyID("numStep") as NumericStepper;

			this.numStep.input.restrict="0-9";

			this.silder.addEventListener(ScrollBarEvent.Progress_Update, onChange);
			this.numStep.addEventListener(Event.CHANGE, onInput);
			this.numStep.input.addEventListener(MouseEvent.CLICK, onInputSelect);
//			this.numStep.input.addEventListener(TextEvent.TEXT_INPUT,onTextInput)

			this.silder.progress=1;
			this.numStep.maximum=int.MAX_VALUE;
			this.numStep.minimum=1;

			this.numStep.stepSize=1;
			this.numStep.restrict="0-9"
			this.numStep.value=1;

			this.priceImg=this.getUIbyID("priceImg") as Image;
			this.totalPriceImg=this.getUIbyID("totalPriceImg") as Image;

//			this.numInput.input.restrict="0-9";
//			this.numInput.input.defaultTextFormat=FontEnum.getTextFormat("Gode12ForMoneyCenter");
//			this.numInput.text="1";
//			this.numInput.input.addEventListener(Event.CHANGE, onInputChange);
//			this.numInput.input.addEventListener(MouseEvent.CLICK, onInputSelect);
			//this.numInput.input.addEventListener(TextEvent.TEXT_INPUT, onInputTxt);

			this.confirmBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			this.cancelBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
//			this.delBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
//			this.addBtn.addEventListener(MouseEvent.CLICK, onBtnClick);

			this.grid=new ShopGrid();
			this.grid.x=43;
			this.grid.y=70;
			this.addChild(this.grid);

//			this.addBtn.visible=false;
//			this.delBtn.visible=false;
//			this.numInput.visible=false;
		}

		private function onTextInput(e:TextEvent):void {
			this.silder.progress=int(this.numStep.value) / int(this.numStep.maximum);

			var count:int;
			var current:int=ShopUtil.getIndexTotMoney(this.moneyId);
			count=int(this.unitPriceLbl.text) * int(this.numStep.value); // * table.maxgroup;

			if (this.buyType == 1)
				current=UIManager.getInstance().guildWnd.guildContribute;
			else if (this.buyType == 4) {
				if (this.subbuyType == 1)
					current=MyInfoManager.getInstance().getBagItemNumById(30401);
				else if (this.subbuyType == 3)
					current=ShopUtil.getIndexTotMoney(7);
				else if (this.subbuyType == 4)
					current=ShopUtil.getIndexTotMoney(8);
			} else
				current=ShopUtil.getIndexTotMoney(this.moneyId);

			if (current < count)
				this.sumPrice.textColor=0xff0000;
			else
				this.sumPrice.textColor=0xffffff;

			if (count < 0)
				count=0;

			this.sumPrice.text=count + "";
		}

		private function onChange(e:Event):void {
			this.numStep.value=Math.ceil(this.numStep.maximum * this.silder.progress)

			var count:int;
			var current:int=ShopUtil.getIndexTotMoney(this.moneyId);
			count=int(this.unitPriceLbl.text) * int(this.numStep.value); // * table.maxgroup;

			if (this.buyType == 1)
				current=UIManager.getInstance().guildWnd.guildContribute;
			else if (this.buyType == 4) {
				if (this.subbuyType == 1)
					current=MyInfoManager.getInstance().getBagItemNumById(30401);
				else if (this.subbuyType == 3)
					current=ShopUtil.getIndexTotMoney(7);
				else if (this.subbuyType == 4)
					current=ShopUtil.getIndexTotMoney(8);
			} else
				current=ShopUtil.getIndexTotMoney(this.moneyId);

			var bagCount:int=MyInfoManager.getInstance().getBagEmptyNum();

			if (bagCount == 0 || current < count)
				this.sumPrice.textColor=0xff0000;
			else
				this.sumPrice.textColor=0xffffff;

			if (count < 0)
				count=0;

			this.sumPrice.text=count + "";
		}

		private function onInput(e:Event):void {
			this.silder.progress=int(this.numStep.value) / int(this.numStep.maximum);

			var count:int;

			count=int(this.unitPriceLbl.text) * int(this.numStep.value); // * table.maxgroup;
			var current:int=ShopUtil.getIndexTotMoney(this.moneyId);

			if (this.buyType == 1)
				current=UIManager.getInstance().guildWnd.guildContribute;
			else if (this.buyType == 4) {
				if (this.subbuyType == 1)
					current=MyInfoManager.getInstance().getBagItemNumById(30401);
				else if (this.subbuyType == 3)
					current=ShopUtil.getIndexTotMoney(7);
				else if (this.subbuyType == 4)
					current=ShopUtil.getIndexTotMoney(8);
			} else
				current=ShopUtil.getIndexTotMoney(this.moneyId);


			var bagCount:int=MyInfoManager.getInstance().getBagEmptyNum();

			if (bagCount == 0 || current < count)
				this.sumPrice.textColor=0xff0000;
			else
				this.sumPrice.textColor=0xffffff;

			if (count < 0)
				count=0;

			this.sumPrice.text=count + "";
		}

		private function onBtnClick(evt:MouseEvent):void {

			var count:int;
			var current:int;

			switch (evt.target.name) {
				case "confirmBtn": //确定
					if (this.buyType == 1) {

						var pr:int=this.numStep.value;
						var bgdiff:int=pr * (int(this.unitPriceLbl.text)) - UIManager.getInstance().guildWnd.guildContribute;

						if (bgdiff <= 0) {
							Cmd_Guild.cm_GuildBuy(table.id, pr);
							this.hide();
						} else {
//							PopupManager.showConfirm("贡献度不足是否花费" + int(bgdiff * ConfigEnum.union6) + "钻石补足贡献度购买该商品", function():void {
//								Cmd_Guild.cm_GuildBuy(table.id, pr);
//							}, null, true);
							NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(3045));

//							UIManager.getInstance().guildWnd.guildDonateMessage.show(true, UIEnum.WND_LAYER_TOP);
						}
					} else if (this.buyType == 0) {
						Cmd_Shp.cm_shpBuy(UIManager.getInstance().shopWnd.shopID, this.index, int(this.numStep.value));
					} else if (this.buyType == 2) {
						var pageType:int=UIManager.getInstance().marketWnd.currentIdx;
						Cmd_Market.cm_Mak_B(pageType, table.id, int(this.numStep.value));
					} else if (this.buyType == 4) {
						Cmd_Shp.cm_shpBuy(2, this.index, int(this.numStep.value));
					} else if (this.buyType == 5) {
						Cmd_CLI.cm_CLI_B(DataManager.getInstance().integralData.itemId, int(this.numStep.value));
					} else if (this.buyType == 6) {
						Cmd_Market.cm_Mak_G(UIManager.getInstance().marketWnd.promotionRender.pid, int(this.numStep.value));
					}

					if (this.sumPrice.textColor != 0xff0000)
						this.hide();
					break;
				case "cancelBtn": //取消
					this.hide();
					break;
				case "delBtn": //减少
					if (int(this.numInput.text) > 1) {
						this.numInput.text=int(this.numInput.text) - 1 + "";

						count=int(this.unitPriceLbl.text) * int(this.numInput.text); // * table.maxgroup;

						if (this.buyType == 1)
							current=UIManager.getInstance().guildWnd.guildContribute;
						else if (this.buyType == 4) {
							if (this.subbuyType == 1)
								current=MyInfoManager.getInstance().getBagItemNumById(30401);
							else if (this.subbuyType == 3)
								current=ShopUtil.getIndexTotMoney(7);
						} else
							current=ShopUtil.getIndexTotMoney(this.moneyId);

						if (current < count)
							this.sumPrice.textColor=0xff0000;
						else
							this.sumPrice.textColor=0xffffff;

						if (count < 0)
							count=0;

						this.sumPrice.text=count + "";
					}
					break;
				case "addBtn": //增加
//					if (int(this.numInput.text) < int(this.stackLbl.text)) {
					this.numInput.text=int(this.numInput.text) + 1 + "";

					var bagCount:int=MyInfoManager.getInstance().getBagEmptyNum();
					if (Math.ceil(int(this.numInput.text) / table.maxgroup) > bagCount) {
						this.numInput.text=(bagCount * table.maxgroup) + "";
					}

					count=int(this.unitPriceLbl.text) * int(this.numInput.text); // * table.maxgroup;

					if (this.buyType == 1)
						current=UIManager.getInstance().guildWnd.guildContribute;
					else if (this.buyType == 4) {
						if (this.subbuyType == 1)
							current=MyInfoManager.getInstance().getBagItemNumById(30401);
						else if (this.subbuyType == 3)
							current=ShopUtil.getIndexTotMoney(7);
					} else
						current=ShopUtil.getIndexTotMoney(this.moneyId);

					if (current < count)
						this.sumPrice.textColor=0xff0000;
					else
						this.sumPrice.textColor=0xffffff;

					this.sumPrice.text=count + "";
//					}
					break;
			}

		}

		private function onInputChange(evt:Event):void {
//			if (this.numInput.text.length > 8)
//				this.numInput.text=this.numInput.text.substr(0, 8);
//			else
//				this.numInput.text=int(this.numInput.text) + "";

//			if (int(this.numInput.text) > ) {
//				this.numInput.text=table.maxgroup + "";
//			}

			var bagCount:int=MyInfoManager.getInstance().getBagEmptyNum();
			if (Math.ceil(int(this.numInput.text) / table.maxgroup) > bagCount) {
				this.numInput.text=(bagCount * table.maxgroup) + "";
			}

			var count:int=int(this.unitPriceLbl.text) * int(this.numInput.text); //* table.maxgroup;
			var current:int=ShopUtil.getIndexTotMoney(this.moneyId);

			if (this.buyType == 1)
				current=UIManager.getInstance().guildWnd.guildContribute;
			else if (this.buyType == 4) {
//				if (this.subbuyType == 2)
//					current=UIManager.getInstance().backpackWnd.honour;
//				else 
				if (this.subbuyType == 1)
					current=MyInfoManager.getInstance().getBagItemNumById(30401);
				else if (this.subbuyType == 3)
					current=ShopUtil.getIndexTotMoney(7);
				else if (this.subbuyType == 4)
					current=ShopUtil.getIndexTotMoney(8);
			} else
				current=ShopUtil.getIndexTotMoney(this.moneyId);

			if (bagCount == 0 || current < count)
				this.sumPrice.textColor=0xff0000;
			else
				this.sumPrice.textColor=0xffffff;

			if (count < 0)
				count=0;

//			TextField(this.numInput.input).setSelection(0, this.numInput.text.length);
//			this.stage.focus=this.numInput.input;
			this.sumPrice.text=count + "";
		}

		private function onInputSelect(e:MouseEvent):void {

//			TextField(this.numInput.input).setSelection(0, this.numInput.text.length);
//			this.stage.focus=this.numInput.input;

			this.stage.focus=this.numStep.input;
			this.numStep.input.setSelection(0, this.numStep.input.text.length);
		}

		public function updateMystery(info:Object, index:int, maxNum:int=0):void {
			this.index=index;
//			this.numInput.text="1";
			this.buyType=4;
			this.subbuyType=info.tagId;

			if (info is TShop) {

//				if (info.tagId == "3") {
//				table=TableManager.getInstance().getItemInfo(info.itemId);
//				} else {
				table=TableManager.getInstance().getEquipInfo(info.itemId);
				if (table == null)
					table=TableManager.getInstance().getItemInfo(info.itemId);
//				}

				if (info.tagId == "2" || info.tagId == "3" || info.tagId == "4") {
					this.unitPriceLbl.text=info.moneyNum + "";
				} else if (info.tagId == "1") {
					this.unitPriceLbl.text=info.itemNum + "";
				}

				this.moneyId=info.moneyId;

			} else {

				table=info;
				this.unitPriceLbl.text=info.price + "";
			}

			var current:int=0
			if (info.tagId == "4") {

				current=ShopUtil.getBuyCountByMoneyOrBagNum(8, int(this.unitPriceLbl.text), table.maxgroup);
				this.numStep.maximum=(current <= 0 ? 1 : (current > maxNum ? maxNum : current));
				this.numStep.value=1;
				this.silder.progress=1 / this.numStep.maximum;

				this.priceImg.updateBmp(ItemUtil.getExchangeIcon(7));
				this.totalPriceImg.updateBmp(ItemUtil.getExchangeIcon(7));

			} else if (info.tagId == "3") {

				current=ShopUtil.getBuyCountByMoneyOrBagNum(7, int(this.unitPriceLbl.text), table.maxgroup);
				this.numStep.maximum=(current <= 0 ? 1 : current);
				this.numStep.value=1;
				this.silder.progress=1 / this.numStep.maximum;

				this.priceImg.updateBmp(ItemUtil.getExchangeIcon(6));
				this.totalPriceImg.updateBmp(ItemUtil.getExchangeIcon(6));

			} else if (info.tagId == "2") {

				current=ShopUtil.getBuyCountByMoneyOrBagNum(moneyId, int(this.unitPriceLbl.text), table.maxgroup);
				this.numStep.maximum=(current <= 0 ? 1 : current);
				this.numStep.value=1;
				this.silder.progress=1 / this.numStep.maximum;

				this.priceImg.updateBmp(ItemUtil.getExchangeIcon(4));
				this.totalPriceImg.updateBmp(ItemUtil.getExchangeIcon(4));

			} else if (info.tagId == "1") {

				current=ShopUtil.getBuyCountByMoneyOrBagNum(30401, int(this.unitPriceLbl.text), table.maxgroup);
				this.numStep.maximum=(current <= 0 ? 1 : current);
				this.numStep.value=1;
				this.silder.progress=1 / this.numStep.maximum;

				var infoItem:TItemInfo=TableManager.getInstance().getItemInfo(30401);

				this.priceImg.updateBmp("ico/items/" + infoItem.icon + ".png");
				this.totalPriceImg.updateBmp("ico/items/" + infoItem.icon + ".png");
			}

			this.priceImg.setWH(20, 20);
			this.totalPriceImg.setWH(20, 20);

			this.grid.updataInfo(table);
			this.nameLbl.text=table.name;
			this.nameLbl.textColor=ItemUtil.getColorByQuality(table.quality);

			this.stackLbl.text=table.maxgroup + "";
			this.sumPrice.text=int(this.unitPriceLbl.text) * this.numStep.value + "";

			var count:int=int(this.unitPriceLbl.text) * this.numStep.value; //* table.maxgroup;

			if (current < 1)
				this.sumPrice.textColor=0xff0000;
			else
				this.sumPrice.textColor=0xffffff;

			if (count < 0)
				count=0;

			this.sumPrice.text=count + "";

		}

		public function update(info:Object, index:int, num:int=-1):void {
			this.index=index;

//			this.numInput.text=(num == -1 ? "1" : num) + "";

			if (info is TShop) {

				if (info.tagId == "3") {
					table=TableManager.getInstance().getItemInfo(info.itemId);
				} else {
					table=TableManager.getInstance().getEquipInfo(info.itemId);
				}

				this.priceImg.updateBmp(ItemUtil.getExchangeIcon(info.moneyId));
				this.totalPriceImg.updateBmp(ItemUtil.getExchangeIcon(info.moneyId));
				this.unitPriceLbl.text=info.moneyNum + "";

				this.moneyId=info.moneyId;

			} else {

				table=info;

				this.priceImg.updateBmp(ItemUtil.getExchangeIcon(0));
				this.totalPriceImg.updateBmp(ItemUtil.getExchangeIcon(0));
				this.unitPriceLbl.text=info.price + "";
			}

			var current:int=ShopUtil.getBuyCountByMoneyOrBagNum(this.moneyId, int(this.unitPriceLbl.text), table.maxgroup)
			this.numStep.maximum=(current <= 0 ? 1 : current);
			this.numStep.value=1;
			this.silder.progress=1 / this.numStep.maximum;

			this.grid.updataInfo(table);
			this.nameLbl.text=table.name;
			this.nameLbl.textColor=ItemUtil.getColorByQuality(table.quality);
			this.stackLbl.text=table.maxgroup + "";
			this.sumPrice.text=int(this.unitPriceLbl.text) * int(this.numStep.value) + "";

			var count:int=int(this.unitPriceLbl.text) * int(this.numStep.value); //* table.maxgroup;

			if (current < 1)
				this.sumPrice.textColor=0xff0000;
			else
				this.sumPrice.textColor=0xffffff;

			if (count < 0)
				count=0;

			this.sumPrice.text=count + "";

		}

		/**
		 *行会商店
		 */
		public function updateGuild(infoXml:XML):void {

			this.buyType=1;
//			this.numInput.text="1";

			if (int(infoXml.@U_ItemID) < 10000)
				table=TableManager.getInstance().getEquipInfo(infoXml.@U_ItemID);
			else
				table=TableManager.getInstance().getItemInfo(infoXml.@U_ItemID);

			this.priceImg.updateBmp(ItemUtil.getExchangeIcon(3));
			this.totalPriceImg.updateBmp(ItemUtil.getExchangeIcon(3));
			this.unitPriceLbl.text=infoXml.@U_LPrice + "";

			this.grid.updataInfo(table);
			this.moneyId=5;

			var current:int=ShopUtil.getBuyCountByMoneyOrBagNum(this.moneyId, int(this.unitPriceLbl.text), table.maxgroup)
			this.numStep.maximum=(current <= 0 ? 1 : current);
			this.numStep.value=1;
			this.silder.progress=1 / this.numStep.maximum;

			this.nameLbl.text=table.name;
			this.nameLbl.textColor=ItemUtil.getColorByQuality(table.quality);
			this.stackLbl.text=table.maxgroup + "";
			this.sumPrice.text=int(this.unitPriceLbl.text) * this.numStep.value + "";

			var count:int=int(this.unitPriceLbl.text) * this.numStep.value; //* table.maxgroup;

			if (current < 1)
				this.sumPrice.textColor=0xff0000;
			else
				this.sumPrice.textColor=0xffffff;

			if (count < 0)
				count=0;

			this.sumPrice.text=count + "";
		}

		/**
		 * <T>商城购买</T>
		 */
		public function updateMarket(marketItem:MarketItemInfo):void {
			this.buyType=marketItem.buyType;
//			this.numInput.text="1";

			table=TableManager.getInstance().getItemInfo(marketItem.itemId);
			if (null == table) {
				table=TableManager.getInstance().getEquipInfo(marketItem.itemId);
			}

			this.unitPriceLbl.text=marketItem.nowPrice + "";
			this.moneyId=marketItem.moneyType;

			var current:int=ShopUtil.getBuyCountByMoneyOrBagNum(this.moneyId, int(this.unitPriceLbl.text), table.maxgroup);
			this.numStep.maximum=(current <= 0 ? 1 : current);
			this.numStep.value=1;
			this.silder.progress=1 / this.numStep.maximum;

			this.nameLbl.text=table.name;
			this.nameLbl.textColor=ItemUtil.getColorByQuality(table.quality);
			this.stackLbl.text=table.maxgroup;

			this.sumPrice.text=int(this.unitPriceLbl.text) * this.numStep.value + "";

			if (current < 1)
				this.sumPrice.textColor=0xff0000;
			else
				this.sumPrice.textColor=0xffffff;

			var sourcePath:String=ItemUtil.getExchangeIcon(marketItem.moneyType);
			this.grid.updataInfo(table);
			this.priceImg.updateBmp(sourcePath);
			this.totalPriceImg.updateBmp(sourcePath);
		}

		public function updateIntegral(item:IntegralShopItem):void {
			this.buyType=5;
//			this.numInput.text="1";

			table=TableManager.getInstance().getItemInfo(item.itemId);
			if (null == table) {
				table=TableManager.getInstance().getEquipInfo(item.itemId);
			}

			var current:int=DataManager.getInstance().integralData.integral / item.tshopData.moneyNum;
			this.numStep.maximum=(current <= 0 ? 1 : current);
			this.numStep.value=1;
			this.silder.progress=1 / this.numStep.maximum;

			this.moneyId=6;
			this.nameLbl.text=table.name;
			this.nameLbl.textColor=ItemUtil.getColorByQuality(table.quality);
			this.stackLbl.text=table.maxgroup;
			this.unitPriceLbl.text=TableManager.getInstance().getShopItem(item.itemId).moneyNum + "";
			this.sumPrice.text=int(this.unitPriceLbl.text) * this.numStep.value + "";

			if (current < 1)
				this.sumPrice.textColor=0xff0000;
			else
				this.sumPrice.textColor=0xffffff;

			var sourcePath:String="ui/xffl/icon_jifen.png";
			this.grid.updataInfo(table);
			this.priceImg.updateBmp(sourcePath);
			this.totalPriceImg.updateBmp(sourcePath);
		}

		/**
		 * <T>随身寄售</T>
		 */
		public function updateAution(autionData:AutionItemData):void {
			this.buyType=3;
//			this.numInput.text="1";

			table=TableManager.getInstance().getItemInfo(autionData.itemId);
			if (null == table) {
				table=TableManager.getInstance().getEquipInfo(autionData.itemId);
			}

			this.moneyId=autionData.moneyType;

			var current:int=ShopUtil.getBuyCountByMoneyOrBagNum(this.moneyId, int(this.unitPriceLbl.text), table.maxgroup);
			this.numStep.maximum=(current <= 0 ? 1 : current);
			this.numStep.value=1;
			this.silder.progress=1 / this.numStep.maximum;

			this.nameLbl.text=table.name;
			this.nameLbl.textColor=ItemUtil.getColorByQuality(table.quality);
			this.stackLbl.text=table.maxgroup;
			this.unitPriceLbl.text=autionData.price + "";
			this.sumPrice.text=int(this.unitPriceLbl.text) * this.numStep.value + "";

			if (current < 1)
				this.sumPrice.textColor=0xff0000;
			else
				this.sumPrice.textColor=0xffffff;

			var sourcePath:String=ItemUtil.getExchangeIcon(autionData.moneyType);
			this.grid.updataInfo(table);
			this.priceImg.updateBmp(sourcePath);
			this.totalPriceImg.updateBmp(sourcePath);
		}

		/**
		 *
		 * @param itemid
		 *
		 */
		public function updateTask(itemid:int, num:int):void {
			var infoXml:XML=LibManager.getInstance().getXML("config/table/shop.xml");
			var xmllist:XMLList=infoXml.shop;

			var i:int=-1;
			var xml:XML
			var infoItem:TShop;
			for each (xml in xmllist) {
				i++;
				if (xml.@itemId == itemid) {
					infoItem=new TShop(xml);
					break;
				}
			}

			UIManager.getInstance().shopWnd.setTabIndex(2);
			this.update(infoItem, i, num);
		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
		}

		override public function hide():void {
			super.hide();
			this.buyType=0;
			this.subbuyType=0;
		}

		override public function die():void {
			super.die();

//			this.numInput.input.removeEventListener(Event.CHANGE, onInputChange);
			this.confirmBtn.removeEventListener(MouseEvent.CLICK, onBtnClick);
			this.cancelBtn.removeEventListener(MouseEvent.CLICK, onBtnClick);
//			this.delBtn.removeEventListener(MouseEvent.CLICK, onBtnClick);
//			this.addBtn.removeEventListener(MouseEvent.CLICK, onBtnClick);
		}

		public function resize():void {
			this.x=(UIEnum.WIDTH - this.width) / 2;
			this.y=(UIEnum.HEIGHT - this.height) / 2;
		}

	}
}

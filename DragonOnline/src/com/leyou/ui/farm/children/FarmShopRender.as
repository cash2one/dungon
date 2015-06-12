package com.leyou.ui.farm.children {
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TFarmLvInfo;
	import com.ace.gameData.table.TFarmPlantInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.PnfUtil;
	import com.ace.utils.StringUtil;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Farm;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PropUtils;

	import flash.events.MouseEvent;

	public class FarmShopRender extends AutoSprite {
		private var nameLbl:Label;

		private var priceLbl:Label;

		private var timeLbl:Label;

		private var reapLbl:Label;

		private var growBtn:NormalButton;

		private var icon:Image;

		private var PriceImg:Image;

		private var ripeImg:Image;

		private var seedId:int=1;

		private var currency:int;

		private var effect:SwfLoader;

		public function FarmShopRender() {
			super(LibManager.getInstance().getXML("config/ui/farm/farmShopRender.xml"));
			init();
		}

		/**
		 * <T>初始化</T>
		 *
		 */
		public function init():void {
			mouseChildren=true;
			nameLbl=getUIbyID("nameLbl") as Label;
			priceLbl=getUIbyID("priceLbl") as Label;
			timeLbl=getUIbyID("timeLbl") as Label;
			reapLbl=getUIbyID("reapLbl") as Label;
			growBtn=getUIbyID("growBtn") as NormalButton;
			PriceImg=getUIbyID("PriceImg") as Image;
			ripeImg=getUIbyID("ripeImg") as Image;
			growBtn.addEventListener(MouseEvent.CLICK, onMouseClick);

			icon=new Image();
			icon.x=11;
			icon.y=11;
			addChild(icon);
		}

		/**
		 * <T>种植按钮点击</T>
		 *
		 * @param event 鼠标事件
		 *
		 */
		protected function onMouseClick(event:MouseEvent):void {
			if (2 == currency) {
				var content:String=TableManager.getInstance().getSystemNotice(2717).content;
				content=StringUtil.substitute(content, priceLbl.text, nameLbl.text);
				PopupManager.showConfirm(content, callbackGrow, null, false, "farm.shop.grow");
			} else {
				Cmd_Farm.cm_FAM_G(UIManager.getInstance().farmShopWnd.blockId, seedId);
				UIManager.getInstance().farmShopWnd.hide();
			}
		}

		/**
		 * <T>种植作物回调</T>
		 *
		 */
		protected function callbackGrow():void {
			Cmd_Farm.cm_FAM_G(UIManager.getInstance().farmShopWnd.blockId, seedId);
			UIManager.getInstance().farmShopWnd.hide();
		}

		public function updateProfit():void {
			if (!UIManager.getInstance().farmShopWnd || !UIManager.getInstance().farmShopWnd.block) {
				return;
			}
			var farmLvInfo:TFarmLvInfo=TableManager.getInstance().getLandLvInfo(UIManager.getInstance().farmShopWnd.block.level);
			var plant:TFarmPlantInfo=TableManager.getInstance().getPlant(seedId);
			reapLbl.text=plant.plantNum + "(+" + farmLvInfo.profitRate + "%)";
		}

		/**
		 * <T>更新信息</T>
		 *
		 */
		public function updataInfo($seedId:int):void {
			seedId=$seedId;
			if (0 >= seedId) {
				throw new Error("unvalid seed id");
			}
			var plant:TFarmPlantInfo=TableManager.getInstance().getPlant(seedId);
			var color:int=ItemUtil.getColorByQuality(plant.color);
			nameLbl.htmlText="<Font face='SimSun' size = '12' color='#" + color.toString(16).replace("0x") + "'>" + plant.name + "</Font>";
			var price:int=(0 == plant.sellMoney) ? plant.sellIB : plant.sellMoney;
			priceLbl.text=price + "";
			timeLbl.text=plant.growTime / 60 / 60 + PropUtils.getStringById(1706);
			icon.updateBmp("ico/items/" + plant.icon, null, false, 40, 40);
			checkPrice(plant);
			checkEarnings(plant);
			if (0 != plant.effectId) {
				if (null == effect) {
					effect=new SwfLoader(plant.effectId);
				}
				effect.update(plant.effectId);
				effect.x=icon.x + 1;
				effect.y=icon.y + 1;
				addChild(effect);
			} else {
				if (effect && contains(effect)) {
					removeChild(effect);
				}
			}
			updateProfit();
		}

		/**
		 * <T>检测营收</T>
		 *
		 */
		public function checkEarnings(plant:TFarmPlantInfo):void {
			switch (plant.plantId) {
				case 0: // 金币
				case 1: // 绑定元宝
				case 2: // 元宝
					ripeImg.updateBmp(ItemUtil.getExchangeIcon(plant.plantId));
					break;
				case 3:
					// 魂力
					ripeImg.updateBmp("ui/common/hl.png");
					break;
				case 4:
					// 经验
					break;
			}
		}

		/**
		 * <T>检测货币类型</T>
		 *
		 */
		public function checkPrice(plant:TFarmPlantInfo):void {
			if (0 != plant.sellMoney) {
				currency=0;
			} else if (0 != plant.sellIB) {
				currency=2;
			}
			PriceImg.updateBmp(ItemUtil.getExchangeIcon(currency));
		}
	}
}

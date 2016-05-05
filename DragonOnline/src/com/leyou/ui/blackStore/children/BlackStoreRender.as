package com.leyou.ui.blackStore.children {
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TBlackStoreInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LibManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.blackStore.BlackStoreItem;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_BlackStore;
	import com.leyou.ui.mail.child.MaillGrid;
	import com.leyou.ui.shop.child.ShopGrid;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PropUtils;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class BlackStoreRender extends AutoSprite {
		private var discountImg:Image;

		private var vipLbl:Label;

		private var nMoneyImg:Image;

		private var cMoneyImg:Image;

		private var nameLbl:Label;

		private var nPriceTLbl:Label;

		private var nPriceLbl:Label;

		private var cPriceTLbl:Label;

		private var cPriceLbl:Label;

		private var buyImg:Image;

		private var buyBtn:NormalButton;

		private var grid:ShopGrid;

		private var type:int;

		private var pos:int;
		
		private var cid:int;
		
		

		public function BlackStoreRender() {
			super(LibManager.getInstance().getXML("config/ui/blackStore/blackStoreRender.xml"));
			init();
		}

		private function init():void {
			mouseChildren=true;
			buyImg=getUIbyID("buyImg") as Image;
			nMoneyImg=getUIbyID("nMoneyImg") as Image;
			cMoneyImg=getUIbyID("cMoneyImg") as Image;
			discountImg=getUIbyID("discountImg") as Image;
			vipLbl=getUIbyID("vipLbl") as Label;
			nameLbl=getUIbyID("nameLbl") as Label;
			nPriceTLbl=getUIbyID("nPriceTLbl") as Label;
			cPriceTLbl=getUIbyID("cPriceTLbl") as Label;
			cPriceLbl=getUIbyID("cPriceLbl") as Label;
			nPriceLbl=getUIbyID("nPriceLbl") as Label;
			buyBtn=getUIbyID("buyBtn") as NormalButton;

			grid=new ShopGrid();
			grid.x=7;
			grid.y=7;
			addChild(grid);
			swapChildren(grid, buyImg);

			buyBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
		}

		public function setPosition($pos:int):void {
			pos=$pos;
		}

		protected function onMouseClick(event:MouseEvent):void {
			switch (event.target.name) {
				case "buyBtn":
					//					var id:int=((0 == type) ? 23008 : 23011)
					//					var content:String=TableManager.getInstance().getSystemNotice(id).content;
					//					content=StringUtil.substitute(content, cPriceLbl.text);
					//					PopupManager.showConfirm(content, onBuy, null, false, "black.store.buy");

					var content:String=TableManager.getInstance().getSystemNotice(23006).content;
					content=StringUtil.substitute(content, cPriceLbl.text, ItemUtil.getColorName(cid, 12), grid.getNum());
					PopupManager.showConfirm(content, onBuy, null, false, "black.store.buy");
					break;
			}
		}

		private function onBuy():void {
			Cmd_BlackStore.cm_BMAK_B(type, pos);
		}

		public function flyItem():void {
			FlyManager.getInstance().flyBags([this.cid], [grid.localToGlobal(new Point(0, 0))]);
		}

		public function updateInfo(bd:BlackStoreItem):void {
			var info:TBlackStoreInfo=TableManager.getInstance().getBlackStoreInfo(bd.id);
			var itemInfo:TItemInfo=TableManager.getInstance().getItemInfo(info.itemId);
			type=info.moneyType;
			buyImg.visible=(1 == bd.status);
			buyBtn.visible=!(1 == bd.status);
			vipLbl.visible=(info.vipLv > 0);
			if (vipLbl.visible) {
				vipLbl.text=StringUtil.substitute(PropUtils.getStringById(1647), info.vipLv);
			}

			var isDiscount:Boolean=(info.nprice > info.price);
			discountImg.visible=isDiscount;
			nPriceTLbl.visible=isDiscount;
			nMoneyImg.visible=isDiscount;
			nPriceLbl.visible=isDiscount;
			nameLbl.text=itemInfo.name;
			nPriceLbl.text=info.nprice + "";
			cPriceLbl.text=info.price + "";
			discountImg.updateBmp(StringUtil.substitute("ui/blackstore/{1}", info.tip));
//			grid.updateInfo(info.itemId, info.num);

			grid.updataInfo(itemInfo);
			if (info.num > 1)
				grid.numLblTxt=info.num + "";

			cid=info.itemId;
			
			if (0 == info.moneyType) {
				nMoneyImg.updateBmp("ui/backpack/yuanbaoIco.png");
				cMoneyImg.updateBmp("ui/backpack/yuanbaoIco.png");
			} else {
				nMoneyImg.updateBmp("ui/backpack/yuanbaoIco_bound.png");
				cMoneyImg.updateBmp("ui/backpack/yuanbaoIco_bound.png");
			}
		}
	}
}

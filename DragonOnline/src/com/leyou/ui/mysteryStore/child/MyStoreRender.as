package com.leyou.ui.mysteryStore.child {

	import com.ace.config.Core;
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.ui.shop.child.ShopGrid;
	import com.leyou.utils.ItemUtil;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class MyStoreRender extends AutoSprite {

		private var nameLbl:Label;
		private var lvLbl:Label;
		private var numLbl:Label;
		private var bgimg:Image;
		private var icoImg:Image;

		public var index:int=-1;
		private var grid:ShopGrid;
		private var isselected:Boolean=false;

		private var info:Object;

		private var tips:TipsInfo;
		private var tipsInfo:TipsInfo;

		public function MyStoreRender() {
			super(LibManager.getInstance().getXML("config/ui/mysteryStore/myStoreRender.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.lvLbl=this.getUIbyID("lvLbl") as Label;
			this.numLbl=this.getUIbyID("numLbl") as Label;
			this.bgimg=this.getUIbyID("bgimg") as Image;
			this.icoImg=this.getUIbyID("icoImg") as Image;

			this.grid=new ShopGrid();
			this.addChild(this.grid);

			this.grid.x=22;
			this.grid.y=35;

			this.grid.type=1;

			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.addEventListener(MouseEvent.CLICK, onMouseClick);

			var einfo:MouseEventInfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.icoImg, einfo);

			this.tips=new TipsInfo();
			this.tipsInfo=new TipsInfo();
		}

		private function onMouseTipsOver(e:MouseEvent):void {

		}

		private function onMouseTipsOut(e:MouseEvent):void {

		}

		public function setItem(id:int):void {
			var infoItem:TItemInfo=TableManager.getInstance().getItemInfo(id);
//			this.icoImg.updateBmp("ico/items/" + infoItem.icon + ".png");

			this.icoImg.fillEmptyBmd();
//			this.icoImg.bitmapData=LibManager.getInstance().getImg("ico/items/" + infoItem.icon + ".png");
			this.icoImg.updateBmp("ico/items/" + infoItem.icon + ".png");
			this.tips.itemid=id;
		}

		private function onTipsMouseOver(e:DisplayObject):void {
			if (this.tipsInfo.moneyType == 4) {
				this.tips.isShowPrice=false;
				ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, this.tips, new Point(this.stage.mouseX, this.stage.mouseY));
			} else if (this.tipsInfo.moneyType == 5) {
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(10001).content, new Point(this.stage.mouseX, this.stage.mouseY));
			}

		}

		private function onTipsMouseOut(e:DisplayObject):void {
			ToolTipManager.getInstance().hide();
		}

		private function onMouseClick(e:MouseEvent):void {
			UIManager.getInstance().buyWnd.show();
			UIManager.getInstance().buyWnd.updateMystery(info, index);
		}

		private function onMouseOver(e:MouseEvent):void {
			this.bgimg.updateBmp("ui/mysteryStoe/smsd_wp2.jpg");
		}

		private function onMouseOut(e:MouseEvent):void {
			this.bgimg.updateBmp("ui/mysteryStoe/smsd_wp1.jpg");
		}

		public function updataInfo(o:Object, num:int):void {
			this.info=o;

			var infoItem:Object;

			if (o.tagId == "3") {
				infoItem=TableManager.getInstance().getItemInfo(o.itemId);
			} else {
				infoItem=TableManager.getInstance().getEquipInfo(o.itemId);
			}

			this.grid.updataInfo(infoItem);

			this.nameLbl.text=infoItem.name + "";
			this.nameLbl.textColor=ItemUtil.getColorByQuality(infoItem.quality);

			this.lvLbl.text=infoItem.level + "";

			if (Core.me.info.level < int(infoItem.level)) {
				this.lvLbl.textColor=0xff0000;
			} else {
				this.lvLbl.textColor=0xffffff;
			}

			if (o.moneyId == 4) {

				this.numLbl.text=o.moneyNum + "";

				if (num < int(o.moneyNum)) {
					this.numLbl.textColor=0xff0000;
				} else {
					this.numLbl.textColor=0xffffff;
				}

				this.tipsInfo.itemid=infoItem.id;
				this.tipsInfo.moneyType=5;
				this.tipsInfo.moneyNum=int(o.moneyNum);
//				this.tipsInfo.moneyItemid=10001;


				this.icoImg.fillEmptyBmd();
//				this.icoImg.bitmapData=LibManager.getInstance().getImg("ico/items/" + infoItem.icon + ".png");
				this.icoImg.updateBmp(ItemUtil.getExchangeIcon(4));

			} else {

				this.numLbl.text=o.itemNum + "";

				if (num < int(o.itemNum)) {
					this.numLbl.textColor=0xff0000;
				} else {
					this.numLbl.textColor=0xffffff;
				}


				this.tipsInfo.itemid=infoItem.id;
				this.tipsInfo.moneyType=4;
				this.tipsInfo.moneyNum=this.info.itemNum;
				this.tipsInfo.moneyItemid=int(o.consumeItem);

			
				
				infoItem=TableManager.getInstance().getItemInfo(o.consumeItem);
				this.icoImg.fillEmptyBmd();
//			this.icoImg.bitmapData=LibManager.getInstance().getImg("ico/items/" + infoItem.icon + ".png");
				this.icoImg.updateBmp("ico/items/" + infoItem.icon + ".png");
				this.tips.itemid=o.consumeItem;
			}

			this.grid.settipsInfo(tipsInfo);
		}

		override public function get width():Number {
			return 255;
		}

		override public function get height():Number {
			return 142;
		}

		override public function die():void {
			super.die();
		}

	}
}

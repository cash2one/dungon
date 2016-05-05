package com.leyou.ui.promotion.children {
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TPayPromotion;
	import com.ace.manager.LibManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.leyou.data.paypromotion.PayPromotionItem;
	import com.leyou.net.cmd.Cmd_Fanl;
	import com.leyou.ui.mail.child.MaillGrid;
	import com.leyou.ui.market.child.MarketGrid;
	import com.leyou.utils.PropUtils;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class PromotionExchangeRender extends AutoSprite {
		private static const SPAN_NUM:int=6;

		private static const INTERVAL:int=3;

		private var exItemGrids:Vector.<GridBase>;

		private var itemGrids:Vector.<GridBase>;

		private var plusSignImgs:Vector.<Image>;

		private var equalSignImg:Image;

		private var receiveBtn:NormalButton;

		private var repeatLbl:Label;

		private var _id:int;

		private var _type:int;

		public function PromotionExchangeRender() {
			super(LibManager.getInstance().getXML("config/ui/promotion/wybqJzRender.xml"));
			init();
		}

		public function get type():int {
			return _type;
		}

		public function get id():int {
			return _id;
		}

		public function init():void {
			mouseChildren=true;
			exItemGrids=new Vector.<GridBase>();
			itemGrids=new Vector.<GridBase>();
			plusSignImgs=new Vector.<Image>();
			receiveBtn=getUIbyID("receiveBtn") as NormalButton;
			repeatLbl=getUIbyID("repeatLbl") as Label;
			receiveBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			equalSignImg=new Image("ui/lianz/icon_d.png");
			addChild(equalSignImg);
		}

		protected function onMouseClick(event:MouseEvent):void {
			Cmd_Fanl.cm_Fanl_J(_id);
		}

		private function initItemGrid(exItemNum:int, itemNum:int):void {
			if (exItemGrids.length == exItemNum && itemGrids.length == itemNum) {
				return;
			}
			if (exItemGrids.length < exItemNum) {
				exItemGrids.length=exItemNum;
				plusSignImgs.length=exItemNum - 1;
			}
			var gw:int;
			var cls:Class;
			var itemDis:int;
			var beginY:int;
			if ((exItemNum + itemNum) >= SPAN_NUM) {
				gw=40;
				beginY=31;
				itemDis=85;
				cls=MaillGrid;
			} else {
				gw=64;
				beginY=20;
				itemDis=106;
				cls=MarketGrid;
			}
			// 兑换物格子
			var length:int=exItemGrids.length;
			for (var n:int=0; n < length; n++) {
				var grid:GridBase=exItemGrids[n];
				if (n < exItemNum) {
					if ((null == grid) || !(grid is cls)) {
						grid=new cls();
					} else {
						if (contains(grid)) {
							removeChild(grid);
							grid.die();
						}
						grid=new cls();
					}
					grid.x=23 + itemDis * n;
					grid.y=beginY;
					exItemGrids[n]=grid;
					addChild(grid);
					if (grid is MarketGrid) {
						(grid as MarketGrid).updateBG("ui/tips/TIPS_bg_frame.jpg");
					}
				} else {
					if ((null != grid) && contains(grid)) {
						removeChild(grid);
						grid.die();
						exItemGrids[n]=null;
					}
				}
			}
			exItemGrids.length=exItemNum;
			// 加号
			length=plusSignImgs.length;
			for (var m:int=0; m < length; m++) {
				var plusImg:Image=plusSignImgs[m];
				if (m < (exItemNum - 1)) {
					if (null == plusImg) {
						plusImg=new Image("ui/lianz/icon_plus.png");
					}
					plusImg.x=exItemGrids[m].x + gw + 3;
					plusImg.y=32;
					plusSignImgs[m]=plusImg;
					addChild(plusImg);
				} else {
					if ((null != plusImg) && (contains(plusImg))) {
						removeChild(plusImg);
						plusImg.die();
						plusImg[m]=null;
					}
				}
			}
			plusSignImgs.length=exItemNum - 1;
			/** 等号*/
			equalSignImg.x=exItemGrids[exItemNum - 1].x + gw + 3;
			equalSignImg.y=32;
			/** 被兑换格子*/
			if (itemGrids.length < itemNum) {
				itemGrids.length=itemNum;
			}
			length=itemGrids.length;
			for (var i:int=0; i < length; i++) {
				var egrid:GridBase=itemGrids[i];
				if (i < itemNum) {
					if ((null == egrid) || !(egrid is cls)) {
						egrid=new cls();
					} else {
						if (contains(egrid)) {
							removeChild(egrid);
							egrid.die();
						}
						egrid=new cls();
					}
					egrid.x=(equalSignImg.x + 35) + (itemDis-35) * i;
					egrid.y=beginY;
					itemGrids[i]=egrid;
					addChild(egrid);
					if (egrid is MarketGrid) {
						(egrid as MarketGrid).updateBG("ui/tips/TIPS_bg_frame.jpg");
					}
				} else {
					if ((null != egrid) && contains(egrid)) {
						removeChild(egrid);
						egrid.die();
						itemGrids[i]=null;
					}
				}
			}
			itemGrids.length=itemNum;
		}

		public function updateInfo(info:PayPromotionItem):void {
			_id=info.id;
			_type=info.type;
			repeatLbl.visible=(info.maxc != -1);
			repeatLbl.text=StringUtil.substitute(PropUtils.getStringById(1827), info.currentc);
			var tinfo:TPayPromotion=TableManager.getInstance().getPayPromotion(info.id);
			var items:Vector.<int>=tinfo.items;
			var itemNums:Vector.<int>=tinfo.itemNums;
			var exItems:Vector.<int>=tinfo.ex_items;
			var exItemNums:Vector.<int>=tinfo.ex_itemNum;
			initItemGrid(exItems.length, items.length);
			var length:int=exItemGrids.length;
			for (var n:int=0; n < length; n++) {
				var grid:GridBase=exItemGrids[n];
				grid.updataInfo({itemId: exItems[n], count: exItemNums[n]});
			}
			length=itemGrids.length;
			for (var m:int=0; m < length; m++) {
				var egrid:GridBase=itemGrids[m];
				egrid.updataInfo({itemId: items[m], count: itemNums[m]});
			}
			if (info.currentc <= 0) {
				receiveBtn.setActive(false, 1, true);
			}
		}

		public function flyItem():void {
			var ids:Array=[];
			var point:Array=[];
			var length:int=itemGrids.length;
			for (var n:int=0; n < length; n++) {
				var g:GridBase=itemGrids[n];
				if ((null != g) && g.visible) {
					ids.push(g.dataId);
					point.push(g.localToGlobal(new Point(0, 0)));
				}
			}
			FlyManager.getInstance().flyBags(ids, point);
		}

		public override function die():void {
			// 兑换物格子
			var length:int=exItemGrids.length;
			for (var n:int=0; n < length; n++) {
				exItemGrids[n].die();
			}
			exItemGrids.length=0;
			length=itemGrids.length;
			for (var m:int=0; m < length; m++) {
				itemGrids[m].die();
			}
			itemGrids.length=0;
			length=plusSignImgs.length;
			for (var l:int=0; l < length; l++) {
				plusSignImgs[l].die();
			}
			plusSignImgs.length=0;
			receiveBtn=null;
			repeatLbl=null;
		}
	}
}

package com.leyou.ui.promotion.children {
	import com.ace.enum.FilterEnum;
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

	public class PromotionSpendRender extends AutoSprite {
		private static const SPAN_NUM:int=6;

		private var titleLbl:Label;

		private var receiveImg:Image;

		private var repeatLbl:Label;

		private var receiveBtn:NormalButton;

		private var _id:int;

		private var grids:Vector.<GridBase>;

		private var citemNum:int;

		private var _type:int;

		public function PromotionSpendRender() {
			super(LibManager.getInstance().getXML("config/ui/promotion/wybqXfRender.xml"));
			init();
		}


		public function get type():int {
			return _type;
		}

		public function get id():int {
			return _id;
		}

		private function init():void {
			mouseChildren=true;
			grids=new Vector.<GridBase>();
			titleLbl=getUIbyID("titleLbl") as Label;
			receiveImg=getUIbyID("receiveImg") as Image;
			repeatLbl=getUIbyID("repeatLbl") as Label;
			receiveBtn=getUIbyID("receiveBtn") as NormalButton;
			receiveBtn.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function initGrid(itemNum:int):void {
			if (grids.length == itemNum) {
				return;
			}
			if (grids.length < itemNum) {
				grids.length=itemNum;
			}
			var cls:Class;
			var itemDis:int;
			var beginY:int;
			if (itemNum >= SPAN_NUM) {
				cls=MaillGrid;
				itemDis=43;
				beginY=31;
			} else {
				cls=MarketGrid;
				itemDis=72;
				beginY=20;
			}
			var length:int=grids.length;
			for (var n:int=0; n < length; n++) {
				var grid:GridBase=grids[n]
				if (n < itemNum) {
					if ((null == grid) || !(grid is cls)) {
						grid=new cls();
					} else {
						if (contains(grid)) {
							removeChild(grid);
							grid.die();
						}
						grid=new cls();
					}
					grid.x=192 + itemDis * n;
					grid.y=beginY;
					grids[n]=grid;
					addChild(grid);
					if (grid is MarketGrid) {
						(grid as MarketGrid).updateBG("ui/tips/TIPS_bg_frame.jpg");
					}
				} else {
					if ((null != grid) && contains(grid)) {
						removeChild(grid);
						grid.die();
						grids[n]=null;
					}
				}
			}
			grids.length=itemNum;
		}

		protected function onClick(event:MouseEvent):void {
			switch (event.target.name) {
				case "receiveBtn":
					Cmd_Fanl.cm_Fanl_J(_id);
					break;
			}
		}

		public function updateInfo(info:PayPromotionItem):void {
			_id=info.id;
			_type=info.type;
			repeatLbl.visible=(info.maxc != -1);
			repeatLbl.text=StringUtil.substitute(PropUtils.getStringById(1827), info.currentc);
			var tinfo:TPayPromotion=TableManager.getInstance().getPayPromotion(info.id);
			titleLbl.text=tinfo.des1;
			var items:Vector.<int>=tinfo.items;
			var itemNums:Vector.<int>=tinfo.itemNums;
			citemNum=items.length;
			initGrid(citemNum);
			for (var n:int=0; n < citemNum; n++) {
				var grid:GridBase=grids[n];
				grid.updataInfo({itemId: items[n], count: itemNums[n]});
				grid.filters=(2 == info.status) ? [FilterEnum.enable] : null;
			}
			receiveImg.visible=false;
			if (0 == info.status) {
				receiveBtn.text=PropUtils.getStringById(1576);
				receiveBtn.setActive(false, 1, true);
			} else if (1 == info.status) {
				receiveBtn.text=PropUtils.getStringById(1575);
				receiveBtn.setActive(true, 1, true);
			} else if (2 == info.status) {
				receiveBtn.text=PropUtils.getStringById(1574);
				receiveImg.visible=true;
				addChild(receiveImg);
				receiveBtn.setActive(false, 1, true);
			}

			receiveBtn.visible=repeatLbl.visible=(tinfo.mail == 0);
		}

		public function flyItem():void {
			var ids:Array=[];
			var point:Array=[];
			for each (var g:GridBase in grids) {
				if (null != g) {
					ids.push(g.dataId);
					point.push(g.localToGlobal(new Point(0, 0)));
				}
			}
			FlyManager.getInstance().flyBags(ids, point);
		}

		public override function die():void {
			titleLbl=null;
			receiveImg.die();
			repeatLbl=null;
			receiveBtn=null;
			var length:int=grids.length;
			for (var n:int=0; n < length; n++) {
				grids[n].die();
			}
			grids.length=0;
		}
	}
}

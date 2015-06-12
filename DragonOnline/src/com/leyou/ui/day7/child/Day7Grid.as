package com.leyou.ui.day7.child {
	import com.ace.enum.ItemEnum;
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.ToolTipManager;
	import com.leyou.ui.arena.childs.ArenaGrid;
	import com.leyou.ui.backpack.child.BackpackGrid;
	import com.leyou.utils.FilterUtil;
	import com.leyou.utils.PropUtils;

	import flash.geom.Point;

	public class Day7Grid extends ArenaGrid {


		public function Day7Grid() {
			super();
		}

		override public function updataInfo(info:Object):void {
			this.reset();
			this.unlocking();

			//			super.updataInfo(info);

			this.iconBmp.updateBmp("ico/items/" + info.icon + ".png");
			this.iconBmp.x=this.iconBmp.y=(ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) / 2;
			this.iconBmp.setWH(36, 36);

//			if (info.effect != null && info.effect != "0")
//				this.playeMc(int(info.effect));

			this.dataId=int(info.id);
//			this.addChild(this.numLbl);
		}


		override public function mouseOverHandler($x:Number, $y:Number):void {
			if (this.dataId != -1) {
				this.tips.itemid=this.dataId;
				ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, this.tips, new Point($x, $y));
			} else {
				switch (this.type) {
					case 5:
						ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, PropUtils.getStringEasyById(31) + ":" + this.num, new Point($x, $y));
						break;
					case 6:
						ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, PropUtils.getStringEasyById(33) + ":" + this.num, new Point($x, $y));
						break;
					default:
						super.mouseOverHandler($x, $y);
				}

			}

		}

		override public function setSize(w:Number, h:Number):void {

			this.bgBmp.setWH(w + 5, h + 5);
			this.bgBmp.visible=false;
			this.selectBmp.bitmapData=null;
			this.iconBmp.setWH(w, h);

			this.stopMc();
			if (this.data.effect1 != "0")
				this.playeMc(int(this.data.effect1), new Point(0.5, 0));
		}

		override public function playeMc(pnfId:int, ps:Point=null):void {
			super.playeMc(pnfId, ps);
		}

		override public function get data():* {
			if (this.dataId < 10000)
				return TableManager.getInstance().getEquipInfo(this.dataId);
			else
				return TableManager.getInstance().getItemInfo(this.dataId);
		}

		override public function setNum(num:int):void {
			if (num > 10000) {
				if (num / 10000 > 100 || num % 10000 == 0)
					this.numLbl.text=int(num / 10000) + PropUtils.getStringById(1532);
				else {
					this.numLbl.text=(num / 10000).toFixed(1) + PropUtils.getStringById(1532);
				}
			} else
				this.numLbl.text=num + "";

			this.num=num;

			this.numLbl.x=60 - this.numLbl.width;
			this.numLbl.y=60 - this.numLbl.height;
			FilterUtil.showBlackStroke(this.numLbl);

			this.canMove=false;
			this.addChild(this.numLbl);
		}

		public function updateBg():void {
			this.iconBmp.updateBmp("ico/items/gong.png");
			this.iconBmp.x=this.iconBmp.y=(ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) / 2;
			this.iconBmp.setWH(36, 36);

			this.stopMc();
			var info:TItemInfo=TableManager.getInstance().getItemInfo(65531);
			if (info.effect != null && info.effect != "0")
				this.playeMc(int(info.effect));

			this.dataId=65531
			this.type=5;
			this.addChild(this.numLbl);
		}

		public function updateByb():void {
			this.iconBmp.updateBmp("ico/items/bdzs.png");
			this.iconBmp.x=this.iconBmp.y=(ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) / 2;
			this.iconBmp.setWH(36, 36);

			this.stopMc();
			var info:TItemInfo=TableManager.getInstance().getItemInfo(65532);
			if (info.effect != null && info.effect != "0")
				this.playeMc(int(info.effect));

			this.dataId=65532
			this.type=6;
			this.addChild(this.numLbl);
		}

		override public function doubleClickHandler():void {


		}

		override public function mouseOutHandler():void {



		}

	}
}

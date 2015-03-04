package com.leyou.ui.arena.childs {

	import com.ace.enum.ItemEnum;
	import com.ace.enum.TipEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.ui.backpack.child.BackpackGrid;
	import com.leyou.utils.FilterUtil;

	import flash.geom.Point;

	public class ArenaGrid extends BackpackGrid {

		private var num:int;
		private var type:int=0;

		private var tips:TipsInfo;

		public function ArenaGrid() {
			super(-1);
		}

		override protected function init(hasCd:Boolean=false):void {
			super.init(hasCd);

//			this.iconBmp.y=10;
//			this.bgBmp.y=10;
			this.bgBmp.bitmapData=LibManager.getInstance().getImg("ui/common/common_icon_bg.png");
			this.selectBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/select.png");

			this.tips=new TipsInfo();
		}

		public function updateMoney():void {
			this.iconBmp.updateBmp("ico/items/money.png");
			this.iconBmp.x=this.iconBmp.y=(ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) / 2;
			this.iconBmp.setWH(36, 36);

			this.stopMc();
			var info:TItemInfo=TableManager.getInstance().getItemInfo(65535);
			if (info.effect != null && info.effect != "0")
				this.playeMc(int(info.effect));

			this.dataId=65535;
			this.type=1;
			this.addChild(this.numLbl);
		}

		public function updateHun():void {
			this.iconBmp.updateBmp("ico/items/hun.png");
			this.iconBmp.x=this.iconBmp.y=(ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) / 2;
			this.iconBmp.setWH(36, 36);

			this.stopMc();
			var info:TItemInfo=TableManager.getInstance().getItemInfo(65533);
			if (info.effect != null && info.effect != "0")
				this.playeMc(int(info.effect));

			this.dataId=65533;
			this.type=2;
			this.addChild(this.numLbl);
		}

		public function updateExp():void {
			this.iconBmp.updateBmp("ico/items/exp.png");
			this.iconBmp.x=this.iconBmp.y=(ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) / 2;
			this.iconBmp.setWH(36, 36);

			this.stopMc();
			var info:TItemInfo=TableManager.getInstance().getItemInfo(65534);
			if (info.effect != null && info.effect != "0")
				this.playeMc(int(info.effect));

			this.dataId=65534
			this.type=3;
			this.addChild(this.numLbl);
		}

		public function setNum(num:int):void {
			if (num > 10000) {
				if (num / 10000 > 100)
					this.numLbl.text=int(num / 10000) + "万";
				else
					this.numLbl.text=(num / 10000).toFixed(1) + "万";
			} else
				this.numLbl.text=num + "";

			this.num=num;

			this.numLbl.x=40 - this.numLbl.width;
			FilterUtil.showBlackStroke(this.numLbl);

			this.canMove=false;
			this.addChild(this.numLbl);
		}

		override public function mouseUpHandler($x:Number, $y:Number):void {


		}

		override public function updataInfo(info:Object):void {
			this.reset();
			this.unlocking();

//			super.updataInfo(info);

			this.iconBmp.updateBmp("ico/items/" + info.icon + ".png");
			this.iconBmp.x=this.iconBmp.y=(ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) / 2;
			this.iconBmp.setWH(36, 36);

			if (info.effect != null && info.effect != "0")
				this.playeMc(int(info.effect));

			this.dataId=int(info.id);
			this.addChild(this.numLbl);
		}

		override public function mouseOverHandler($x:Number, $y:Number):void {
//			if (this.dataId != -1) {
//				this.tips.itemid=this.dataId;
//				ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, this.tips, new Point($x, $y));
//			} else {
				switch (this.type) {
					case 1:
						ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, "金币:" + this.num, new Point($x, $y));
						break;
					case 2:
						ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, "魂力:" + this.num, new Point($x, $y));
						break;
					case 3:
						ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, "经验:" + this.num, new Point($x, $y));
						break;
				}
//			}

		}

		override public function doubleClickHandler():void {


		}

		override public function mouseOutHandler():void {



		}



	}
}

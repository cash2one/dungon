package com.leyou.ui.guild.child {

	import com.ace.enum.ItemEnum;
	import com.ace.enum.TipEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.leyou.data.tips.TipsInfo;

	import flash.display.Shape;
	import flash.geom.Point;

	public class GuildShopGrid extends GridBase {

		private var remask:Shape;
		private var info:Object;
		private var tipsinfo:TipsInfo;

		public function GuildShopGrid(id:int=-1) {
			super(id);
		}

		override protected function init(hasCd:Boolean=false):void {
			super.init();

			this.isLock=false;
			this.gridType=ItemEnum.TYPE_GRID_EQUIP;

			this.bgBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/bg.png");
//			this.iconBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/lock.png");
			this.selectBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/select.png");
			this.setSize(38, 38);

			this.selectBmp.x=this.bgBmp.width - this.selectBmp.width >> 1;
			this.selectBmp.y=this.bgBmp.height - this.selectBmp.height >> 1;

			this.remask=new Shape();
			this.remask.graphics.beginFill(0xff0000);
			this.remask.graphics.drawRect(0, 0, this.bgBmp.width, this.bgBmp.height);
			this.remask.graphics.endFill();

			this.addChild(this.remask);
			this.remask.visible=false;

			this.remask.alpha=.6;

//			this.dataId=-1;

			this.tipsinfo=new TipsInfo();


		}

		override public function updataInfo(info:Object):void {
			super.reset();
			super.unlocking();

			if (info == null)
				return;

			this.tipsinfo.itemid=info.id;

			super.updataInfo(info);

			this.iconBmp.updateBmp("ico/items/" + info.icon + ".png");
			this.iconBmp.setWH(this.bgBmp.width, this.bgBmp.height);
			this.iconBmp.x=this.iconBmp.y=(this.bgBmp.width - this.iconBmp.width) / 2;

			if (info.effect != null && info.effect != "0")
				this.playeMc(int(info.effect), new Point(-2, -1));
		}

		public function setSize(w:Number, h:Number):void {
			this.bgBmp.setWH(w, h);
			this.selectBmp.setWH(w + 5, h + 5);

			this.selectBmp.x=this.bgBmp.width - this.selectBmp.width >> 1;
			this.selectBmp.y=this.bgBmp.height - this.selectBmp.height >> 1;
		}

		override public function mouseDownHandler($x:Number, $y:Number):void {
			super.mouseDownHandler($x, $y);

			if (this.isEmpty)
				return;

		}

		override public function mouseOutHandler():void {
			super.mouseOutHandler();

		}

		override public function mouseOverHandler($x:Number, $y:Number):void {
			super.mouseOverHandler($x, $y);

			if (this.isEmpty)
				return;

		}

		public function set hight(v:Boolean):void {
			this.remask.visible=v;
		}


	}
}

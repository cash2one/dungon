package com.leyou.ui.backpack.child {

	import com.ace.enum.FontEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TShop;
	import com.ace.manager.LibManager;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.data.store.StoreInfo;
	import com.leyou.manager.TimerManager;
	import com.leyou.ui.tips.childs.TipsGrid;
	import com.leyou.utils.ColorUtil;
	import com.leyou.utils.FilterUtil;
	
	import flash.display.Bitmap;

	public class GridModel extends GridBase {

		protected var numLbl:Label;
		protected var limitTimeLbl:Label;
		protected var topBmp:Image;
		protected var intensifyLbl:Image

		private var topDown:Image;
		private var topUp:Image;

		protected var disableBmp:Image;



		public function GridModel(id:int=-1, hasCd:Boolean=false) {
			super(id, hasCd);
		}

		override protected function init(hasCd:Boolean=false):void {
			super.init(hasCd);

			this.numLbl=new Label();
			this.numLbl.x=22;
			this.numLbl.y=24;
			this.addChild(this.numLbl);

			this.numLbl.defaultTextFormat=FontEnum.getTextFormat("White10right");
			this.numLbl.filters=[FilterUtil.showBorder(0x000000)];

			this.limitTimeLbl=new Label();
			this.limitTimeLbl.x=12;
			this.limitTimeLbl.y=0;
			this.addChild(this.limitTimeLbl);

			this.limitTimeLbl.defaultTextFormat=FontEnum.getTextFormat("Red12");
			this.limitTimeLbl.filters=[FilterUtil.showBorder(0x000000)];

			this.limitTimeLbl.text="限时";
			this.limitTimeLbl.visible=false;

			this.topBmp=new Image();
			this.addChild(this.topBmp);
			this.topBmp.x=24;
			this.topBmp.y=20;

			this.intensifyLbl=new Image();
			this.addChild(this.intensifyLbl);
			this.intensifyLbl.x=21;
			this.intensifyLbl.y=1;

			this.bindingBmp.updateBmp("ui/common/icon_lock.png");
			this.bindingBmp.y=26;

			this.disableBmp=new Image();
			this.addChild(this.disableBmp);
			this.disableBmp.updateBmp("ui/backpack/bg_unavail.png");
			this.disableBmp.y=26;

			this.disableBmp.visible=false;

			this.topDown=new Image();
			this.topUp=new Image();

			this.topDown.updateBmp("ui/common/icon_down.png");
			this.topUp.updateBmp("ui/common/icon_up.png");
		}

		override protected function reset():void {
			super.reset();

			this.topBmp.visible=false;
			this.bindingBmp.visible=false;
			this.disableBmp.visible=false;
			this.limitTimeLbl.visible=false;
			this.intensifyLbl.bitmapData=null;
		}

		protected function setDisable(v:Boolean):void {
			this.disableBmp.visible=v;
			this.disableBmp.x=0;

			if (this.bindingBmp.visible) {
				this.bindingBmp.x=this.disableBmp.width;
			} else {
				this.bindingBmp.x=0;
			}

		}

		override public function updataInfo(info:Object):void {
			super.updataInfo(info);
			this.setLimitTimeByInfo(info);
		}

		protected function setLimitTime(v:Boolean):void {
			this.limitTimeLbl.visible=v;
		}

		protected function setLimitTimeByInfo(info:Object):void {
			if (info != null) {
				if (info is TItemInfo || info is TEquipInfo) {

					if (this is TipsGrid && TipsGrid(this).tips != null && TimerManager.CurrentTime >= TipsGrid(this).tips.dtime)
						this.limitTimeLbl.text="过期";
					else
						this.limitTimeLbl.text="限时";

					this.limitTimeLbl.visible=(int(info.limitTime) != 0)
				} else if (info is TShop) {

					var tinfo:Object=TableManager.getInstance().getItemInfo(info.itemId) || TableManager.getInstance().getEquipInfo(info.itemId);
					if (tinfo == null)
						return;

					this.limitTimeLbl.visible=(int(tinfo.limitTime) != 0);
						
				} else {
					
					if (info is Baginfo || info is StoreInfo) {
						if (TimerManager.CurrentTime >= info.tips.dtime)
							this.limitTimeLbl.text="过期";
						else
							this.limitTimeLbl.text="限时";
					}

					this.limitTimeLbl.visible=(int(info.info.limitTime) != 0)
				}

				if (int(this.width / 10)==6)
					this.limitTimeLbl.x=60 - 25;
				else
					this.limitTimeLbl.x=40 - 25;
			}
		}

		protected function setIntensify(s:String):void {
			this.intensifyLbl.bitmapData=ColorUtil.getEquipBitmapDataByInt(s);
			this.intensifyLbl.x=this.bgBmp.width - this.intensifyLbl.width - 3;
			this.addChild(this.intensifyLbl)
		}

		protected function changeTopState(st:int):void {
			if (st == 0) {
				this.topBmp.bitmapData=this.topDown.bitmapData;
			} else if (st == 1) {
				this.topBmp.bitmapData=this.topUp.bitmapData;
			} else if (st == -1) {
				this.topBmp.bitmapData=null;
			}

			this.topBmp.x=24 + (this.bgBmp.width - 40 - 3);
			this.topBmp.y=20 + (this.bgBmp.height - 40 - 3);
		}

	}
}

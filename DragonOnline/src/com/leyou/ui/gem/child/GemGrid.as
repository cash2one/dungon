package com.leyou.ui.gem.child {


	import com.ace.enum.FontEnum;
	import com.ace.enum.ItemEnum;
	import com.ace.enum.TipEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.lable.Label;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.net.cmd.Cmd_Gem;
	import com.leyou.utils.FilterUtil;
	
	import flash.geom.Point;

	public class GemGrid extends GridBase {

		private var tips:TipsInfo;

		public var selectIndex:int=-1;

		public var gemGridList:Vector.<GemGrid>;

		public var effectGlow:Function;

		protected var numLbl:Label;

		public function GemGrid() {
			super();
		}

		override protected function init(hasCd:Boolean=false):void {
			super.init();
			this.isLock=false;
//			this.canMove=true;
			this.gridType=ItemEnum.TYPE_GRID_GEM;
			this.bgBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/bg.png");
			this.bgBmp.alpha=0;

			this.mouseEnabled=true;
			this.mouseChildren=true;

			this.iconBmp.x=(40 - 36) >> 1;
			this.iconBmp.y=(40 - 36) >> 1;
			this.iconBmp.setWH(40, 40);

			this.tips=new TipsInfo();

			this.numLbl=new Label();
			this.numLbl.x=22;
			this.numLbl.y=24;
			this.addChild(this.numLbl);

			this.numLbl.defaultTextFormat=FontEnum.getTextFormat("White10right");
			this.numLbl.filters=[FilterUtil.showBorder(0x000000)];

			this.doubleClickEnabled=true;
//						this.opaqueBackground=0xff0000;
		}

		override public function updataInfo(info:Object):void {
			this.reset();
			this.unlocking();

//			this.bgBmp.alpha=0;

			if (info == null)
				return;

			super.updataInfo(info);
//			this.info=info;
			this.tips.itemid=info.id;

			this.iconBmp.updateBmp("ico/items/" + info.icon + ".png");
			this.canMove=false;

//			this.iconBmp.x=(40 - 36) >> 1;
//			this.iconBmp.y=(40 - 36) >> 1;
//			this.iconBmp.setWH(36, 36);

			this.stopMc();
			if (info.effect != null && info.effect != "0" && this.selectIndex == -1) {
				if (this.iconBmp.width == 60 && this.iconBmp.height == 60 && info.effect1 != "") {
					this.playeMc(int(info.effect1), new Point(0, 0));
				} else
					this.playeMc(int(info.effect), new Point(0, 0));
			}

		}

		override protected function reset():void {
			super.reset();
			this.tips.itemid=0;
		}

		public function reseGrid():void {
			this.reset();
			this.iconBmp.bitmapData=null;
		}

		public function setSize(w:Number, h:Number):void {
//			this.bgBmp.setWH(w, h);
			this.selectBmp.setWH(w + 5, h + 5);

			this.selectBmp.x=60 - this.selectBmp.width >> 1;
			this.selectBmp.y=60 - this.selectBmp.height >> 1;
			this.iconBmp.setWH(w, h);
			//			if (info.info.effect1 != null && info.info.effect1 != "0" && this.dataId == -1)
			//				this.playeMc(int(info.info.effect1));



		}

		public function setBgBmp(s:int):void {
			if (s == 2) {
				this.bgBmp.bitmapData=LibManager.getInstance().getImg("ui/other/icon_prop_bigframe.png");
				this.bgBmp.x=-11;
				this.bgBmp.y=-11;
			} else if (s == 1) {
				this.bgBmp.updateBmp("ui/equip/icon_prop_smframe.png");
				this.bgBmp.x=-7;
				this.bgBmp.y=-7;
			}

			this.bgBmp.alpha=1;
		}

		public function setNum(num:String):void {
			this.numLbl.text="" + num;
			this.numLbl.x=40 - this.numLbl.textWidth - 5;
		}

		public function getItemID():int {
			return this.tips.itemid;
		}

		override public function mouseOverHandler($x:Number, $y:Number):void {
			super.mouseOverHandler($x, $y);

			if (this.isEmpty)
				return;

			
			tips.isdiff=false;
			
			var type:int=TipEnum.TYPE_GEM_OTHER;
			if(this.tips.itemid>10000){
				type=TipEnum.TYPE_EQUIP_ITEM;
			}
			
			ToolTipManager.getInstance().show(type, tips, new Point(this.stage.mouseX + this.width, this.stage.mouseY + this.height));
		}

		override public function mouseOutHandler():void {
			super.mouseOutHandler();

			ToolTipManager.getInstance().hide();
		}

		override public function switchHandler(fromItem:GridBase):void {
//			super.switchHandler(fromItem);

			if (!this.doubleClickEnabled)
				return;

			if (fromItem.gridType == ItemEnum.TYPE_GRID_BACKPACK) {

				if (fromItem.data.info.classid == 10 && this.selectIndex != -1) {

//					var tequip:TEquipInfo;
//					for (var i:int=0; i < this.gemGridList.length; i++) {
//
//						tequip=TableManager.getInstance().getEquipInfo(this.gemGridList[i].getItemID());
//						if (tequip != null && tequip.classid == 10 && tequip.classid == fromItem.data.info.classid && tequip.subclassid == fromItem.data.info.subclassid)
//							break;
//
//						if (this.gemGridList[i].isEmpty)
//							break;
//					}

					Cmd_Gem.cmGemInlay(fromItem.data.pos, this.selectIndex, this.dataId);

					if (this.effectGlow != null)
						this.effectGlow();

					ToolTipManager.getInstance().hide();
				}

			}


		}

		override public function doubleClickHandler():void {
			super.doubleClickHandler();

			if (!this.doubleClickEnabled)
				return;

			if (this.selectIndex != -1 && this.dataId != -1) {
				Cmd_Gem.cmGemQuit(this.selectIndex, this.dataId);
			}

		}

		override public function mouseUpHandler($x:Number, $y:Number):void {

			if (!this.doubleClickEnabled)
				return;

			if (this.selectIndex == -1 || this.dataId == -1)
				return;

			var p:Point=LayerManager.getInstance().windowLayer.globalToLocal(this.parent.localToGlobal(new Point(this.x + 40, this.y)));

			UIManager.getInstance().selectWnd.type=2;
			UIManager.getInstance().selectWnd.succEffect=effectGlow;
			UIManager.getInstance().selectWnd.showGemPanel(this.selectIndex, this.dataId, p);

		}


	}
}

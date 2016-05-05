package com.leyou.ui.equip.child {

	import com.ace.enum.ItemEnum;
	import com.ace.enum.TipEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.game.manager.DragManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.notice.NoticeManager;
	import com.leyou.data.role.EquipInfo;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.ui.backpack.child.GridModel;
	import com.leyou.utils.FilterUtil;

	import flash.display.Shape;
	import flash.geom.Point;

	public class EquipStrengGrid extends GridModel {

		private var info:Object;
		private var remask:Shape;
		private var bg:Shape;

		public static var selectState:EquipStrengGrid;
		public static var selectStateII:EquipStrengGrid;

		public var selectSt:Boolean=false;

		public function EquipStrengGrid(id:int=-1) {
			super(id);
		}

		override protected function init(hasCd:Boolean=false):void {
			super.init();

			this.isLock=false;
			this.gridType=ItemEnum.TYPE_GRID_EQUIP;

			this.bgBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/bg.png");
//			this.iconBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/lock.png");
			this.selectBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/select.png");

			this.selectBmp.x=this.bgBmp.width - this.selectBmp.width >> 1;
			this.selectBmp.y=this.bgBmp.height - this.selectBmp.height >> 1;

//			this.remask=new Shape();
//			this.remask.graphics.beginFill(0xff0000);
//			this.remask.graphics.drawRect(0, 0, this.bgBmp.width, this.bgBmp.height);
//			this.remask.graphics.endFill();
//
//			this.addChild(this.remask);
//			this.remask.visible=false;
//
//			this.remask.alpha=.6;

			this.dataId=-1;
		}

		override public function updataInfo(info:Object):void {
			this.reset();
			this.unlocking();

			if (info == null)
				return;

			super.updataInfo(info);
			this.info=info;

//			if (Baginfo(info).num > 1) {
//				this.numLbl.htmlText="<font face='宋体' size='12'>" + Baginfo(info).num + "</font>";
//			} else {
//				this.numLbl.text="";
//			}

			this.iconBmp.updateBmp("ico/items/" + info.info.icon + ".png");
//			this.iconBmp.setWH(this.bgBmp.width, this.bgBmp.height);
//			this.iconBmp.setWH(40, 40);
//			this.iconBmp.x=this.iconBmp.y=(this.bgBmp.width - this.iconBmp.width) / 2;

			//if (!(info is EquipInfo))
			//	this.dataId=info.pos;

			if (info.info.effect != null && info.info.effect != "0" && info.info.effect1 != null && info.info.effect1 != "0") {
				if (this.dataId == -1 || this.dataId == 2 || this.dataId == 5 || this.dataId == 3) {
					this.playeMc(int(info.info.effect), new Point(1, 2));
					this.iconBmp.setWH(38, 38);
				} else {
					this.playeMc(int(info.info.effect1), new Point(-3, -2.5));
					this.iconBmp.setWH(60, 60);
				}
			} else {
				if (this.dataId == -1 || this.dataId == 2 || this.dataId == 5 || this.dataId == 3)
					this.iconBmp.setWH(38, 38);
				else
					this.iconBmp.setWH(60, 60);
			}

			this.iconBmp.x=this.iconBmp.y=(this.bgBmp.width - this.iconBmp.width) / 2;

			if (int(info.tips.qh) > 0) {
				this.setIntensify("" + info.tips.qh);
				this.intensifyLbl.x=this.bgBmp.width - this.intensifyLbl.width;
			}

			this.addChild(this.bindingBmp);
			this.addChild(this.numLbl);
		}

		public function setSize(w:Number, h:Number):void {
			this.bgBmp.setWH(w, h);
			this.selectBmp.setWH(w + 5, h + 5);

			this.selectBmp.x=this.bgBmp.width - this.selectBmp.width >> 1;
			this.selectBmp.y=this.bgBmp.height - this.selectBmp.height >> 1;

//			if (info.info.effect1 != null && info.info.effect1 != "0" && this.dataId == -1)
//				this.playeMc(int(info.info.effect1));
		}

		override protected function reset():void {
			super.reset();
			this.selectBmp.visible=false;
			this.canMove=true;
//			this.selectSt=false;
			//super.updataInfo(null);
//			this.numLbl.text="";
			//this.dataId=-1;
			//this.gridId=this.initId;

		}


		public function selectState():void {
			this.selectBmp.bitmapData=null; //LibManager.getInstance().getImg("ui/backpack/select.png");
			this.bgBmp.visible=false;

			this.bg=new Shape();
			this.bg.graphics.beginFill(0x000000);
//			this.bg.graphics.drawRect(0, 0, this.bgBmp.width - 4, this.bgBmp.height - 4);
			this.bg.graphics.drawRect(0, 0, this.bgBmp.width, this.bgBmp.height);
			this.bg.graphics.endFill();
			this.bg.x=2;
			this.bg.y=2;

			this.addChild(this.bg);
			this.swapChildren(this.bg, this.iconBmp);

//			this.bgBmp.bitmapData=null;
//			this.bgBmp.bitmapData.fillRect(new Rectangle(0,0,this.bgBmp.width,this.bgBmp.height),0x00000000);
		}

		override public function get data():* {
			return this.info;
		}

		override public function mouseDownHandler($x:Number, $y:Number):void {
			super.mouseDownHandler($x, $y);

			if (DragManager.getInstance().grid == null)
				return;
		}

		public function setBgVisible(v:Boolean):void {
			this.bgBmp.visible=v;
		}

		override public function doubleClickHandler():void {
//			super.doubleClickHandler();

//			if (this.canMove)
//				this.setChangeState(this);
		}

		override public function mouseUpHandler($x:Number, $y:Number):void {
			super.mouseUpHandler($x, $y);
			this.setChangeState(this);
		}

		/**
		 * 改变选择的状态
		 */
		private function setChangeState(g:EquipStrengGrid):void {
			if (g.data == null)
				return;

			var _i:int=UIManager.getInstance().equipWnd.getTabIndex();

			if (_i == 0) {

				if (EquipStrengGrid.selectState != null && g.dataId == 1) {

					EquipStrengGrid.selectState.setSelectState(false);
					EquipStrengGrid.selectState=null;

					g.resetGrid();
					g.delItemHandler()

				} else {

					UIManager.getInstance().equipWnd.IntensifyRender.setDownItem(g);
					EquipStrengGrid.selectStateII=null;

					g.setSelectState(true);

					if (EquipStrengGrid.selectState != null)
						EquipStrengGrid.selectState.setSelectState(false);

					EquipStrengGrid.selectState=g;
				}

			} else if (_i == 1) {

				if ((EquipStrengGrid.selectState != null && g.dataId == 1) || (EquipStrengGrid.selectStateII != null && g.dataId == 2)) {

					if (EquipStrengGrid.selectState != null && g.dataId == 1) {
						EquipStrengGrid.selectState.setSelectState(false);
						EquipStrengGrid.selectState=null;
					}

					if (EquipStrengGrid.selectStateII != null && g.dataId == 2) {
						EquipStrengGrid.selectStateII.setSelectState(false);
						EquipStrengGrid.selectStateII=null;
					}

					g.resetGrid();
					g.delItemHandler();
				} else {

					if (g.data.tips.qh == 0) {
						EquipStrengGrid.selectState=g;
					} else {
						EquipStrengGrid.selectStateII=g;
					}

					UIManager.getInstance().equipWnd.TransRender.setDownItem(g);
					g.setSelectState(true);
				}

			} else if (_i == 2) {

				if (EquipStrengGrid.selectState != null && g.dataId == 1) {

					EquipStrengGrid.selectState.setSelectState(false);
					EquipStrengGrid.selectState=null;

					g.delItemHandler();
					g.resetGrid();

					if (EquipStrengGrid.selectStateII != null) {
						EquipStrengGrid.selectStateII.setSelectState(false);
						EquipStrengGrid.selectStateII=null;
					}

				} else if (EquipStrengGrid.selectStateII != null && g.dataId == 2) {

					EquipStrengGrid.selectStateII.setSelectState(false);
					EquipStrengGrid.selectStateII=null;

					g.resetGrid();
					g.delItemHandler();

				} else if (EquipStrengGrid.selectStateII == null || EquipStrengGrid.selectState == null) {

					if (EquipStrengGrid.selectState == null)
						EquipStrengGrid.selectState=g;
					else if (EquipStrengGrid.selectStateII == null) {
						EquipStrengGrid.selectStateII=g;
					}

					UIManager.getInstance().equipWnd.RecastRender.setDownItem(g);
					g.setSelectState(true);
				}
			} else if (_i == 3) {

				if (EquipStrengGrid.selectState != null && g.dataId == 1) {

					EquipStrengGrid.selectState.setSelectState(false);
					EquipStrengGrid.selectState=null;

					g.delItemHandler();
					g.resetGrid();

					if (EquipStrengGrid.selectStateII != null) {
						EquipStrengGrid.selectStateII.setSelectState(false);
						EquipStrengGrid.selectStateII=null;
					}

				} else if (EquipStrengGrid.selectStateII != null && g.dataId == 2) {

					EquipStrengGrid.selectStateII.setSelectState(false);
					EquipStrengGrid.selectStateII=null;

					g.resetGrid();
					g.delItemHandler();

				} else if (EquipStrengGrid.selectStateII == null || EquipStrengGrid.selectState == null) {

					if (EquipStrengGrid.selectState == null) {
						if (g.data.info.limit == 0) {
							NoticeManager.getInstance().broadcastById(2623);
							return;
						}

						if (g.data.info.bind == 1 || g.data.info.Suit_Group > 0) {
							NoticeManager.getInstance().broadcastById(2626);
							return;
						}

						EquipStrengGrid.selectState=g;
					} else if (EquipStrengGrid.selectStateII == null) {
						EquipStrengGrid.selectStateII=g;
					}

					UIManager.getInstance().equipWnd.ReclassRender.setDownItem(g);
					g.setSelectState(true);
				}

			} else if (_i == 4) {
				if (this.dataId == 5) {
					if (!g.isEmpty)
						UIManager.getInstance().equipWnd.BagRender.setBagSelectState(g.data.pos, false);

					g.resetGrid();
					g.delItemHandler();
				} else
					UIManager.getInstance().equipWnd.BreakRender.setDownItem(g);

			} else if (_i == 5) {

				if (EquipStrengGrid.selectState != null && g.dataId == 3) {

					EquipStrengGrid.selectState.setSelectState(false);
					EquipStrengGrid.selectState=null;

					g.resetGrid();
					g.delItemHandler();

					if (EquipStrengGrid.selectStateII != null) {
						EquipStrengGrid.selectStateII.setSelectState(false);
						EquipStrengGrid.selectStateII=null;
					}

				} else if (EquipStrengGrid.selectStateII != null && g.dataId == 2) {

					EquipStrengGrid.selectStateII.setSelectState(false);
					EquipStrengGrid.selectStateII=null;

					g.resetGrid();
					g.delItemHandler();

				} else if (EquipStrengGrid.selectStateII == null || EquipStrengGrid.selectState == null) {

					if (this.dataId == 51)
						return;

					if (g.data.info.quality < 2 || g.data.info.lvup_id == 0) {
						NoticeManager.getInstance().broadcastById(2627);
						return;
					}

					if (g.data.info.Suit_Group > 0) {
						NoticeManager.getInstance().broadcastById(2626);
						return;
					}

					if (EquipStrengGrid.selectState == null) {
						EquipStrengGrid.selectState=g;
						
					} else if (EquipStrengGrid.selectStateII == null) {
						if (g.data.info.id != EquipStrengGrid.selectState.data.info.id)
							return;

						EquipStrengGrid.selectStateII=g;
					}

					UIManager.getInstance().equipWnd.LvupRender.setDownItem(g);
					g.setSelectState(true);
				}

			} else if (_i == 6) {

				if (EquipStrengGrid.selectState != null && g.dataId == 1) {

					EquipStrengGrid.selectState.setSelectState(false);
					EquipStrengGrid.selectState=null;

					g.resetGrid();
					g.delItemHandler()

				} else {

					UIManager.getInstance().equipWnd.ElementRender.setDownItem(g);
					EquipStrengGrid.selectStateII=null;

					g.setSelectState(true);

					if (EquipStrengGrid.selectState != null)
						EquipStrengGrid.selectState.setSelectState(false);

					EquipStrengGrid.selectState=g;
				}


			}

		}

		public function getGridEmpty():Boolean {
			return this.isEmpty;
		}

		public function setSelectState(v:Boolean):void {
			this.selectBmp.visible=v;

			if (UIManager.getInstance().equipWnd.getTabIndex() == 4)
				this.selectSt=v;
			else
				this.canMove=!v;
		}


		override public function switchHandler(fromItem:GridBase):void {

			var d:*=fromItem.data;
			if (d == null || !(fromItem is EquipStrengGrid))
				return;

			if (this.dataId != -1 && this.dataId == fromItem.dataId)
				return;

			if (UIManager.getInstance().equipWnd.getTabIndex() == 0 && d.tips.qh >= int(d.info.maxlevel) && fromItem.dataId != 1 && (this.dataId == 1 || this.dataId == 2))
				return;

			if ((fromItem.dataId == 1 || fromItem.dataId == 2) && this.gridType == fromItem.gridType)
				return;

			if (this.gridType != fromItem.gridType) {

				if (this.dataId == 5) {
					if (UIManager.getInstance().equipWnd.BreakRender.isExist(d.pos) || d.info.quality == 0)
						return;

					if (!this.isEmpty) {
						UIManager.getInstance().equipWnd.BagRender.setBagSelectState(this.data.pos, false);
					}

					this.updataInfo(d);

					EquipStrengGrid(fromItem).setSelectState(true);
					UIManager.getInstance().equipWnd.BreakRender.updateViewState();
				} else if (this.dataId == -1 && fromItem.dataId == 5) {
					UIManager.getInstance().equipWnd.BagRender.setBagSelectState(fromItem.data.pos, false);
					fromItem.delItemHandler();
					EquipStrengGrid(fromItem).resetGrid();
					UIManager.getInstance().equipWnd.BreakRender.updateViewState();
				} else
					this.setChangeState(fromItem as EquipStrengGrid);
//					}

			} else if (this.gridType == fromItem.gridType) {

				if (!this.canMove || this.selectSt || EquipStrengGrid(fromItem).selectSt)
					return;

				if (!this.isEmpty) {
					fromItem.updataInfo(this.data);
					this.updataInfo(d);
				} else {
					fromItem.delItemHandler();
					this.updataInfo(d);
					EquipStrengGrid(fromItem).resetGrid();
				}

			}

		}

		override public function mouseMoveHandler($x:Number, $y:Number):void {
			super.mouseMoveHandler($x, $y);
			if (this.isEmpty)
				return;

			var type:int=TipEnum.TYPE_EQUIP_ITEM;
			var tips:TipsInfo=this.info.tips;

			if (this.dataId == 51) {
				tips.itemid=this.info.info.id;
				type=TipEnum.TYPE_EMPTY_ITEM;
			}

			ToolTipManager.getInstance().show(type, tips, this.parent.localToGlobal(new Point(this.x + this.width, this.y + this.height)));
		}

		override public function mouseOverHandler($x:Number, $y:Number):void {
			super.mouseOverHandler($x, $y);
			if (this.isEmpty)
				return;

			var type:int=TipEnum.TYPE_EQUIP_ITEM;
			var tips:TipsInfo=this.info.tips;

			if (this.dataId == 51) {
				tips.itemid=this.info.info.id;
				type=TipEnum.TYPE_EMPTY_ITEM;
			}

			ToolTipManager.getInstance().show(type, tips, this.parent.localToGlobal(new Point(this.x + this.width, this.y + this.height)));
		}

		public function resetGrid():void {
			super.delItemHandler();
			this.updataInfo(null);
			this.info=null;
			this.selectSt=false;
		}

		override public function dropHandler():void {
			//super.dropHandler();
		}

		override public function delItemHandler():void {
//			if (!this.isEmpty) {

			this.updataInfo(null);
			super.dropHandler();

			var p:*=this.parent;
			if (p.hasOwnProperty("clearAllData")) {

				if (p is EquipTransRender) {
					UIManager.getInstance().equipWnd.TransRender.updateViewState(null, true);
				} else if (p is EquipRecastRender) {
					if (this.dataId == 1)
						p.clearAllData();

					UIManager.getInstance().equipWnd.RecastRender.updateViewState();

				} else if (p is EquipReclassRender) {
					if (this.dataId == 1)
						p.clearAllData();

					UIManager.getInstance().equipWnd.ReclassRender.updateViewState();
				} else if (p is EquipBreakRender) {
					UIManager.getInstance().equipWnd.BreakRender.updateViewState();
				} else if (p is EquipLvupRender) {
					if (this.dataId == 3)
						p.clearAllData();

					UIManager.getInstance().equipWnd.LvupRender.updateViewState();
				} else {
					p.clearAllData();
				}


					//是否消耗装备
//				if (!(p is EquipRecastRender && this.dataId == 2)) {
//					p.clearAllData();
//					UIManager.getInstance().equipWnd.RecastRender.updateViewState();
//				}

			}
//			}

		}


		override public function set enable(value:Boolean):void {
			super.enable=value;
//			this.canMove=value;

//			if (!value) {
//				this.filters=[FilterUtil.enablefilter];
//			} else {
//				this.filters=[];
//			}

		}

		public function setRemask(v:Boolean):void {
			//this.remask.visible=v;
			if (v) {
				this.filters=[FilterUtil.enablefilter];
			} else {
				this.filters=[];
			}

//			this.enable=!v;
			this.canMove=!v;
		}
		
		public function setTargetGrid(g:EquipStrengGrid):void {
			this.setChangeState(g);
		}

		override public function canMDHandler():Boolean {
			return this.canMove;
		}

		override public function mouseOutHandler():void {

			if (this.isEmpty || !this.selectSt)
				super.mouseOutHandler();

			if (EquipStrengGrid.selectState == this)
				this.setSelectState(true);

			if (EquipStrengGrid.selectStateII == this)
				this.setSelectState(true);
		}

		public function setEnable(v:Boolean):void {
			this.mouseChildren=v;
			this.mouseEnabled=v;
		}

	}
}

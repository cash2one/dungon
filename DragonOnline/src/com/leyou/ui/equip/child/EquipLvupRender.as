package com.leyou.ui.equip.child {

	import com.ace.enum.PlayerEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.game.manager.DragManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.FlyManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.notice.NoticeManager;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.net.cmd.Cmd_Equip;
	import com.leyou.utils.FilterUtil;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class EquipLvupRender extends AutoSprite {

		private var confirmBtn:ImgButton;
		private var ruleLbl:Label;
		private var bgImg:Image;

		private var lvupBar1:EquipLvupBar1;
		private var lvupBar2:EquipLvupBar2;

		private var targetGrid:EquipStrengGrid;
		private var CostGrid:EquipStrengGrid;

		private var succGrid:EquipStrengGrid;

		private var equipTransBar:EquipTransBar;

		private var targetEffect:SwfLoader;
		private var costEffect:SwfLoader;
		private var succEffect:SwfLoader;

		public function EquipLvupRender() {
			super(LibManager.getInstance().getXML("config/ui/equip/equipLvupRender.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {
			this.confirmBtn=this.getUIbyID("confirmBtn") as ImgButton;
			this.ruleLbl=this.getUIbyID("ruleLbl") as Label;
			this.bgImg=this.getUIbyID("bgImg") as Image;

			this.lvupBar1=new EquipLvupBar1();
			this.addChild(lvupBar1);
			this.lvupBar1.x=36;
			this.lvupBar1.y=270;

			this.lvupBar2=new EquipLvupBar2();
			this.addChild(lvupBar2);
			this.lvupBar2.x=36;
			this.lvupBar2.y=275;

			this.lvupBar1.visible=true;
			this.lvupBar2.visible=false;


			this.targetGrid=new EquipStrengGrid();
			this.addChild(this.targetGrid);

			this.CostGrid=new EquipStrengGrid();
			this.addChild(this.CostGrid);

			this.succGrid=new EquipStrengGrid();
			this.addChild(this.succGrid);

			this.targetGrid.x=65;
			this.targetGrid.y=45;

			this.CostGrid.x=189;
			this.CostGrid.y=45;

			this.targetGrid.setSize(40, 40);
			this.CostGrid.setSize(40, 40);
//			this.targetGrid.setSize(38,38);
//			this.CostGrid.setSize(38,38);

			this.succGrid.setSize(60, 60);
			this.succGrid.x=122;
			this.succGrid.y=175;

			this.succGrid.canMove=false;

			this.targetGrid.selectState();
			this.CostGrid.selectState();
			this.succGrid.selectState();

			this.targetGrid.dataId=3;
			this.CostGrid.dataId=2;
			this.succGrid.dataId=51;

			this.targetEffect=new SwfLoader(99907);
			this.addChild(this.targetEffect);
			this.targetEffect.x=this.targetGrid.x; // - 14;
			this.targetEffect.y=this.targetGrid.y; // - 14;

			this.targetEffect.visible=false;

			this.costEffect=new SwfLoader(99907);
			this.addChild(this.costEffect);
			this.costEffect.x=this.CostGrid.x; // + 20;
			this.costEffect.y=this.CostGrid.y; // + 20;

			this.costEffect.visible=false;

			this.succEffect=new SwfLoader(99906);
			this.addChild(this.succEffect);
			this.succEffect.x=this.succGrid.x - 16;
			this.succEffect.y=this.succGrid.y - 16;

			this.succEffect.visible=false;

			this.ruleLbl.setToolTip(TableManager.getInstance().getSystemNotice(2628).content);

			this.x=60;
			this.y=1;

			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.confirmBtn.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(e:MouseEvent):void {
			if (!this.targetGrid.isEmpty && !this.CostGrid.isEmpty) {

				var data:TEquipInfo=this.targetGrid.data.info as TEquipInfo;
				var type:int=0;

				if (MyInfoManager.getInstance().getBagItemNumByName(TableManager.getInstance().getItemInfo(ConfigEnum.equip25).name) < data.lvup_itemNum) {
					if (UIManager.getInstance().quickBuyWnd.isAutoBuy(ConfigEnum.equip25, ConfigEnum.equip26)) {
						type=(UIManager.getInstance().quickBuyWnd.getCost(ConfigEnum.equip25, ConfigEnum.equip26) == 0 ? 2 : 1);
					} else {
						UILayoutManager.getInstance().show(WindowEnum.EQUIP, WindowEnum.QUICK_BUY, UILayoutManager.SPACE_X, UILayoutManager.SPACE_Y + 40);
						UIManager.getInstance().quickBuyWnd.pushItem(ConfigEnum.equip25, ConfigEnum.equip26, data.lvup_itemNum);

						return;
					}
				}

				if (this.targetGrid.data.hasOwnProperty("pos") && this.CostGrid.data.hasOwnProperty("pos")) {

					if (this.targetGrid.data.num == 0)
						Cmd_Equip.cm_EquipCompound(40, this.targetGrid.data.info.subclassid - 13, 1, this.CostGrid.data.pos, type);
					else if (this.CostGrid.data.num == 0)
						Cmd_Equip.cm_EquipCompound(1, this.targetGrid.data.pos, 40, this.CostGrid.data.info.subclassid - 13, type);
					else
						Cmd_Equip.cm_EquipCompound(1, this.targetGrid.data.pos, 1, this.CostGrid.data.pos, type);

				} else if (!this.targetGrid.data.hasOwnProperty("pos") && this.CostGrid.data.hasOwnProperty("pos")) {

					if (this.CostGrid.data.num == 0)
						Cmd_Equip.cm_EquipCompound(3, this.targetGrid.data.position, 40, this.CostGrid.data.info.subclassid - 13, type);
					else
						Cmd_Equip.cm_EquipCompound(3, this.targetGrid.data.position, 1, this.CostGrid.data.pos, type);

				} else if (this.targetGrid.data.hasOwnProperty("pos") && !this.CostGrid.data.hasOwnProperty("pos")) {

					if (this.targetGrid.data.num == 0)
						Cmd_Equip.cm_EquipCompound(40, this.targetGrid.data.info.subclassid - 13, 3, this.CostGrid.data.position, type);
					else
						Cmd_Equip.cm_EquipCompound(1, this.targetGrid.data.pos, 3, this.CostGrid.data.position, type);

				} else if (!this.targetGrid.data.hasOwnProperty("pos") && !this.CostGrid.data.hasOwnProperty("pos")) {
					Cmd_Equip.cm_EquipCompound(3, this.targetGrid.data.position, 3, this.CostGrid.data.position, type);
				}

				this.targetEffect.visible=true;

				targetEffect.playAct(PlayerEnum.ACT_STAND, -1, false, function():void {
					targetEffect.visible=false;
				});

				this.costEffect.visible=true;

				costEffect.playAct(PlayerEnum.ACT_STAND, -1, false, function():void {
					costEffect.visible=false;
				});


			}


		}

		public function updateSuccess(o:Object):void {

			if (o.hasOwnProperty("pos")) {

				this.clearData();

				this.targetGrid.resetGrid();
				this.CostGrid.resetGrid();

				if (EquipStrengGrid.selectState != null) {
					EquipStrengGrid.selectState.setSelectState(false);
					EquipStrengGrid.selectState.resetGrid();
					EquipStrengGrid.selectState=null;
				}

				if (EquipStrengGrid.selectStateII != null) {
					EquipStrengGrid.selectStateII.setSelectState(false);
					EquipStrengGrid.selectStateII.resetGrid();
					EquipStrengGrid.selectStateII=null;
				}

				this.succEffect.visible=true;

				succEffect.playAct(PlayerEnum.ACT_STAND, -1, false, function():void {
					succEffect.visible=false;
				});

				this.succGrid.resetGrid();
				this.succGrid.filters=[];
//				this.succGrid.updataInfo(MyInfoManager.getInstance().bagItems[o.pos]);
//				this.succGrid.canMove=false;

				FlyManager.getInstance().flyBags([MyInfoManager.getInstance().bagItems[o.pos].aid], [this.localToGlobal(new Point(this.succGrid.x, this.succGrid.y))], [[60, 60]])

				this.confirmBtn.setActive(false, .6, true);
				UIManager.getInstance().equipWnd.BagRender.update();

				GuideManager.getInstance().removeGuide(132);
			}


		}

		public function setDownItem(g:GridBase):void {

			var data:Object=g.data;
			var info:TipsInfo=data.tips;

			var pos:int;
			var pos1:int;

			if (!this.targetGrid.isEmpty) {
				if (this.targetGrid.data.hasOwnProperty("pos") && data.hasOwnProperty("pos")) {

					if (int(this.targetGrid.data.pos) == data.pos && int(this.targetGrid.data.num) == data.num && int(this.targetGrid.data.info.subclassid) == data.info.subclassid) {
						return;
					}

				} else if (!this.targetGrid.data.hasOwnProperty("pos") && !data.hasOwnProperty("pos")) {

					pos=data.position;
					pos1=this.targetGrid.data.position;

					if (pos == pos1) {
						return;
					}

				}

			} else if (!this.CostGrid.isEmpty) {

				if (this.CostGrid.data.hasOwnProperty("pos") && data.hasOwnProperty("pos")) {

					if (int(this.CostGrid.data.pos) == data.pos) {
						return;
					}

				} else {

					pos=data.position;
					pos1=this.targetGrid.data.position;

					if (pos == pos1) {
						return;
					}

				}
			}

			if (this.targetGrid.isEmpty) {
				this.targetGrid.updataInfo(data);
				this.clearData();
				this.updateViewState(data);

				var bvec:Vector.<EquipStrengGrid>=UIManager.getInstance().equipWnd.BagRender.getBagGridAll();
				var i:int=0;
				var idx:int=0;
				var zdl:int=int.MAX_VALUE;
				for (i=0; i < bvec.length; i++) {

					if (bvec[i] != null && bvec[i].data != null) {
						if (bvec[i].data.tips.zdl < zdl) {

							if (bvec[i].dataId == 51)
								continue;

							if (bvec[i].data.info.quality < 2 || bvec[i].data.info.lvup_id == 0) {
								continue;
							}

							if (bvec[i].data.info.Suit_Group > 0) {
								continue;
							}

							zdl=bvec[i].data.tips.zdl;
							idx=i;
						}
					}

				}

				if (zdl != int.MAX_VALUE)
					bvec[idx].setTargetGrid(bvec[idx]);

				if (EquipStrengGrid.selectStateII == null) {
					bvec=UIManager.getInstance().equipWnd.BagRender.getBodyGridAll();
					zdl=int.MAX_VALUE;
					idx=0;
					for (i=0; i < bvec.length; i++) {

						if (bvec[i] != null && bvec[i].data != null) {
							if (bvec[i].data.tips.zdl < zdl) {

								if (bvec[i].dataId == 51)
									continue;

								if (bvec[i].data.info.quality < 2 || bvec[i].data.info.lvup_id == 0) {
									continue;
								}

								if (bvec[i].data.info.Suit_Group > 0) {
									continue;
								}

								zdl=bvec[i].data.tips.zdl;
								idx=i;
							}
						}

					}

					if (zdl != int.MAX_VALUE)
						bvec[idx].setTargetGrid(bvec[idx]);
				}

			} else if (this.CostGrid.isEmpty) {

				if (data.info.id == this.targetGrid.data.info.id)
					this.CostGrid.updataInfo(data);
			}

			this.update(this.targetGrid.data);

			if (!this.targetGrid.isEmpty && !this.CostGrid.isEmpty) {
				this.confirmBtn.setActive(true, 1, true);
				this.confirmBtn.setToolTip("");
			}
		}

		public function setDownItemII(tinfo:Baginfo):void {

			var data:Object=tinfo;
			var info:TipsInfo=data.tips;

			var pos:int;
			var pos1:int;

			if (!this.targetGrid.isEmpty) {
				if (this.targetGrid.data.hasOwnProperty("pos") && data.hasOwnProperty("pos")) {

					if (int(this.targetGrid.data.pos) == data.pos && int(this.targetGrid.data.num) == data.num && int(this.targetGrid.data.info.subclassid) == data.info.subclassid) {
						return;
					}

				} else if (!this.targetGrid.data.hasOwnProperty("pos") && !data.hasOwnProperty("pos")) {

					pos=data.position;
					pos1=this.targetGrid.data.position;

					if (pos == pos1) {
						return;
					}

				}

			} else if (!this.CostGrid.isEmpty) {

				if (this.CostGrid.data.hasOwnProperty("pos") && data.hasOwnProperty("pos")) {

					if (int(this.CostGrid.data.pos) == data.pos) {
						return;
					}

				} else {

					pos=data.position;
					pos1=this.targetGrid.data.position;

					if (pos == pos1) {
						return;
					}

				}
			}

			if (this.targetGrid.isEmpty) {
				this.targetGrid.updataInfo(data);
				this.clearData();
				this.updateViewState(data);
			} else if (this.CostGrid.isEmpty) {

				if (data.info.id == this.targetGrid.data.info.id)
					this.CostGrid.updataInfo(data);
			}

			this.update(this.targetGrid.data);

			if (!this.targetGrid.isEmpty && !this.CostGrid.isEmpty) {
				this.confirmBtn.setActive(true, 1, true);
				this.confirmBtn.setToolTip("");
			}
		}

		private function onMouseUp(e:MouseEvent):void {

			if (e.target is EquipStrengGrid) {
				if (DragManager.getInstance().grid == null || DragManager.getInstance().grid.isEmpty || DragManager.getInstance().grid.dataId == 1 || DragManager.getInstance().grid.dataId == 2)
					return;

//				trace(DragManager.getInstance().grid, DragManager.getInstance().grid.isEmpty);

				var data:Object=DragManager.getInstance().grid.data;

				if (data == null || !data.hasOwnProperty("tips"))
					return;

				if (data.info.quality < 2 || data.info.lvup_id == 0) {
					NoticeManager.getInstance().broadcastById(2627);

//					e.preventDefault();
					e.stopImmediatePropagation();
					return;
				}

				var info:TipsInfo=data.tips;

				var pos:int;
				var pos1:int;

				if (!this.targetGrid.isEmpty) {
					if (this.targetGrid.data.hasOwnProperty("pos") && data.hasOwnProperty("pos")) {

						if (int(this.targetGrid.data.pos) == data.pos && int(this.targetGrid.data.num) == data.num && int(this.targetGrid.data.info.subclassid) == data.info.subclassid) {
							return;
						}

					} else if (!this.targetGrid.data.hasOwnProperty("pos") && !data.hasOwnProperty("pos")) {

						pos=data.position;
						pos1=this.targetGrid.data.position;

						if (pos == pos1) {
							return;
						}

					}

				} else if (!this.CostGrid.isEmpty) {

					if (this.CostGrid.data.hasOwnProperty("pos") && data.hasOwnProperty("pos")) {

						if (int(this.CostGrid.data.pos) == data.pos) {
							return;
						}

					} else {

						pos=data.position;
						pos1=this.targetGrid.data.position;

						if (pos == pos1) {
							return;
						}

					}
				}

				if (e.target == this.targetGrid) {
					this.clearData();

					this.update(data);
				}

				this.updateViewState(data);

				if (!this.targetGrid.isEmpty && !this.CostGrid.isEmpty) {
					this.confirmBtn.setActive(true, 1, true);
					this.confirmBtn.setToolTip("");
				}
			}
		}

		public function updateViewState(data:Object=null):void {

			var bagpos:int=-1;
			var bodypos:int=-1;
			var mountypos:int=-1;

			var info:Object=data;

			if (!this.targetGrid.isEmpty) {

				if (this.targetGrid.data.hasOwnProperty("pos"))
					if (this.targetGrid.data.num == 0)
						mountypos=this.targetGrid.data.info.subclassid;
					else
						bagpos=this.targetGrid.data.pos;
				else
					bodypos=this.targetGrid.data.position;

				info=this.targetGrid.data;
			}

			if (!this.CostGrid.isEmpty) {

				if (this.CostGrid.data.hasOwnProperty("pos"))
					if (this.CostGrid.data.num == 0)
						mountypos=this.CostGrid.data.info.subclassid;
					else
						bagpos=this.CostGrid.data.pos;
				else
					bodypos=this.CostGrid.data.position;

				info=this.CostGrid.data;
			}


			if (info != null && info.info.id != -1) {
				UIManager.getInstance().equipWnd.BagRender.updateAllByID(info.info.id);
			} else {
				UIManager.getInstance().equipWnd.BagRender.update();
			}

		}

		private function update(info:Object):void {

			this.bgImg.visible=true;
			this.lvupBar1.visible=true;
			this.lvupBar2.visible=false;

			this.lvupBar1.updateInfo(info.info);

			var binfo:Baginfo=new Baginfo();
			binfo.info=TableManager.getInstance().getEquipInfo(info.info.lvup_id);
			binfo.tips=new TipsInfo();

			if (info.tips.qh > 0) {
				binfo.tips.qh=info.tips.qh;
				binfo.tips.p=info.tips.p;
			}

			this.succGrid.updataInfo(binfo);
			this.succGrid.canMove=false;
			this.succGrid.filters=[FilterUtil.enablefilter];
		}

		public function clearAllData():void {

			this.clearData();
			this.targetGrid.resetGrid();
			this.CostGrid.resetGrid();
			this.succGrid.resetGrid();
			this.succGrid.canMove=false;
			this.confirmBtn.setActive(false, .6, true);
//			this.confirmBtn.setToolTip(TableManager.getInstance().getSystemNotice(2609).content);

			//			if (!this.CostGrid.isEmpty) {
			//				if (this.CostGrid.gridType == ItemEnum.TYPE_GRID_EQUIP_BODY) {
			//					UIManager.getInstance().equipWnd.BagRender.updateEmptyBodyGrid(this.CostGrid.data);
			//				} else if (this.CostGrid.gridType == ItemEnum.TYPE_GRID_EQUIP_EQUIP) {
			//					UIManager.getInstance().equipWnd.BagRender.updateEmptyBagGrid(this.CostGrid.data);
			//				}
			//			}
			//			this.CostGrid.dropHandler();

//			this.succData=null;
		}

		private function clearData():void {
			this.bgImg.visible=false;
			this.lvupBar1.visible=false;
			this.lvupBar2.visible=false;
		}


	}
}

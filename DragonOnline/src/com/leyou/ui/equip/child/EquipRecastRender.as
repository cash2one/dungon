package com.leyou.ui.equip.child {

	import com.ace.enum.PlayerEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.game.manager.DragManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.SoundManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.utils.StringUtil;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Equip;

	import flash.events.MouseEvent;

	public class EquipRecastRender extends AutoSprite {

		private var EquipGrid:EquipStrengGrid;
		private var CostGrid:EquipStrengGrid;

		private var descLbl:Label;

		private var confirmBtn:ImgButton;

		private var succData:Object;

		private var recastBar1:EquipRecastBar1;
		private var recastBar2:EquipRecastBar2;

		private var targetEffect:SwfLoader;
		private var costEffect:SwfLoader;

		public function EquipRecastRender() {
			super(LibManager.getInstance().getXML("config/ui/equip/equipRecastRender.xml"));
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {
			this.descLbl=this.getUIbyID("descLbl") as Label;

			this.recastBar1=new EquipRecastBar1();
			this.addChild(this.recastBar1);
			this.recastBar1.x=27;
			this.recastBar1.y=199;

			this.recastBar2=new EquipRecastBar2();
			this.addChild(this.recastBar2);
			this.recastBar2.x=27;
			this.recastBar2.y=199;

			this.recastBar1.visible=false;
			this.recastBar2.visible=false;

			this.EquipGrid=new EquipStrengGrid();
			this.addChild(this.EquipGrid);

			this.CostGrid=new EquipStrengGrid();
			this.addChild(this.CostGrid);

			this.EquipGrid.x=54;
			this.EquipGrid.y=52;

			this.CostGrid.x=206;
			this.CostGrid.y=60;

			this.EquipGrid.setSize(60, 60);
//			this.CostGrid.setSize(60, 60);

			this.EquipGrid.selectState();
			this.CostGrid.selectState();
			this.EquipGrid.dataId=1;
			this.CostGrid.dataId=2;

			this.confirmBtn=this.getUIbyID("confirmBtn") as ImgButton;
			this.confirmBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);

			this.confirmBtn.setToolTip(TableManager.getInstance().getSystemNotice(2609).content);
			this.confirmBtn.setActive(false, .6, true);

			this.descLbl.htmlText="" + TableManager.getInstance().getSystemNotice(2610).content;
			this.descLbl.height=306;
			this.descLbl.width=279;
			this.descLbl.wordWrap=true;

			this.targetEffect=new SwfLoader(99908);
			this.addChild(this.targetEffect);
			this.targetEffect.x=this.EquipGrid.x - 14;
			this.targetEffect.y=this.EquipGrid.y - 14;

			this.targetEffect.visible=false;

			this.costEffect=new SwfLoader(99907);
			this.addChild(this.costEffect);
			this.costEffect.x=this.CostGrid.x; // + 20;
			this.costEffect.y=this.CostGrid.y; // + 20;

			this.costEffect.visible=false;

			this.y=1;
			this.x=-10;
		}

		private function onClick(e:MouseEvent):void {

			switch (e.target.name) {
				case "useGoldCb":

					break;
				case "confirmBtn":
					if (!this.EquipGrid.isEmpty && !this.CostGrid.isEmpty) {

						if (UIManager.getInstance().backpackWnd.jb < this.recastBar2.getUseGold()) {
							NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(2405));
							return;
						}

						if (this.CostGrid.data.tips.qh > 0)
							PopupManager.showConfirm(StringUtil.substitute(TableManager.getInstance().getSystemNotice(2611).content, [this.CostGrid.data.tips.qh, this.CostGrid.data.info.name]), this.startRecast, null, false, "equipstartrecast");
						else
							this.startRecast();

					}
					break;
			}
		}

		private function startRecast():void {
			if (this.EquipGrid.data.hasOwnProperty("pos") && this.CostGrid.data.hasOwnProperty("pos")) {
				
				if (this.EquipGrid.data.num == 0 && this.CostGrid.data.num == 0)
					Cmd_Equip.cm_EquipRecast(40, this.EquipGrid.data.info.subclassid - 13, 40, this.CostGrid.data.info.subclassid - 13, (this.recastBar2.getUseGold() ? 1 : 0));
				else if (this.EquipGrid.data.num == 0)
					Cmd_Equip.cm_EquipRecast(40, this.EquipGrid.data.info.subclassid - 13, 1, this.CostGrid.data.pos, (this.recastBar2.getUseGold() ? 1 : 0));
				else if (this.CostGrid.data.num == 0)
					Cmd_Equip.cm_EquipRecast(1, this.EquipGrid.data.pos, 40, this.CostGrid.data.info.subclassid - 13, (this.recastBar2.getUseGold() ? 1 : 0));
				else
					Cmd_Equip.cm_EquipRecast(1, this.EquipGrid.data.pos, 1, this.CostGrid.data.pos, (this.recastBar2.getUseGold() ? 1 : 0));
			} else if (!this.EquipGrid.data.hasOwnProperty("pos") && this.CostGrid.data.hasOwnProperty("pos")) {
				if (this.CostGrid.data.num == 0)
					Cmd_Equip.cm_EquipRecast(3, this.EquipGrid.data.position, 40, this.CostGrid.data.info.subclassid - 13, (this.recastBar2.getUseGold() ? 1 : 0));
				else
					Cmd_Equip.cm_EquipRecast(3, this.EquipGrid.data.position, 1, this.CostGrid.data.pos, (this.recastBar2.getUseGold() ? 1 : 0));
			} else if (!this.EquipGrid.data.hasOwnProperty("pos") && !this.CostGrid.data.hasOwnProperty("pos")) {
				Cmd_Equip.cm_EquipRecast(3, this.EquipGrid.data.position, 3, this.CostGrid.data.position, (this.recastBar2.getUseGold() ? 1 : 0));
			} else if (this.EquipGrid.data.hasOwnProperty("pos") && !this.CostGrid.data.hasOwnProperty("pos")) {
				if (this.EquipGrid.data.num == 0)
					Cmd_Equip.cm_EquipRecast(40, this.EquipGrid.data.info.subclassid - 13, 3, this.CostGrid.data.position, (this.recastBar2.getUseGold() ? 1 : 0));
				else
					Cmd_Equip.cm_EquipRecast(1, this.EquipGrid.data.pos, 3, this.CostGrid.data.position, (this.recastBar2.getUseGold() ? 1 : 0));
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

		/**
		 *模拟拖拽
		 */
		public function setDownItem(g:GridBase):void {

			var data:Object=g.data;
			var info:TipsInfo=data.tips;

			var pos:int;
			var pos1:int;

			if (!this.EquipGrid.isEmpty) {
				if (this.EquipGrid.data.hasOwnProperty("pos") && data.hasOwnProperty("pos")) {

					if (int(this.EquipGrid.data.pos) == data.pos && int(this.EquipGrid.data.num) == data.num && int(this.EquipGrid.data.info.subclassid) == data.info.subclassid) {
						return;
					}

				} else if (!this.EquipGrid.data.hasOwnProperty("pos") && !data.hasOwnProperty("pos")) {

					pos=data.position;
					pos1=this.EquipGrid.data.position;

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
					pos1=this.EquipGrid.data.position;

					if (pos == pos1) {
						return;
					}

				}
			}

			if (this.EquipGrid.isEmpty) {
				this.EquipGrid.updataInfo(data);
				this.clearData();
				this.updateViewState(data);
			} else if (this.CostGrid.isEmpty) {
				this.CostGrid.updataInfo(data);
			}

			this.update(this.EquipGrid.data.tips);
		}

		private function onMouseUp(e:MouseEvent):void {

			if (e.target is EquipStrengGrid) {
				if (DragManager.getInstance().grid == null || DragManager.getInstance().grid.isEmpty || DragManager.getInstance().grid.dataId == 1 || DragManager.getInstance().grid.dataId == 2)
					return;

//				trace(DragManager.getInstance().grid, DragManager.getInstance().grid.isEmpty);

				var data:Object=DragManager.getInstance().grid.data;

				if (data == null || !data.hasOwnProperty("tips"))
					return;

				var info:TipsInfo=data.tips;

				var pos:int;
				var pos1:int;

				if (!this.EquipGrid.isEmpty) {
					if (this.EquipGrid.data.hasOwnProperty("pos") && data.hasOwnProperty("pos")) {

						if (int(this.EquipGrid.data.pos) == data.pos) {
							e.preventDefault();
							e.stopImmediatePropagation();
							return;
						}

					} else if (!this.EquipGrid.data.hasOwnProperty("pos") && !data.hasOwnProperty("pos")) {

						pos=data.position;
						pos1=this.EquipGrid.data.position;

						if (pos == pos1) {
							e.preventDefault();
							e.stopImmediatePropagation();
							return;
						}

					}

				} else if (!this.CostGrid.isEmpty) {

					if (this.CostGrid.data.hasOwnProperty("pos") && data.hasOwnProperty("pos")) {

						if (int(this.CostGrid.data.pos) == data.pos) {
							e.preventDefault();
							e.stopImmediatePropagation();
							return;
						}

					} else if (!this.CostGrid.data.hasOwnProperty("pos") && !data.hasOwnProperty("pos")) {

						pos=data.position;
						pos1=this.CostGrid.data.position;

						if (pos == pos1) {
							e.preventDefault();
							e.stopImmediatePropagation();
							return;
						}

					}
				}

				if (e.target == this.EquipGrid) {
					this.clearData();
					this.update(info);
				}

				this.updateViewState(data);
			}
		}

		public function updateViewState(data:Object=null):void {

			var bagpos:int=-1;
			var bodypos:int=-1;
			var mountypos:int=-1;

			var info:Object=data;

			if (!this.EquipGrid.isEmpty) {

				if (this.EquipGrid.data.hasOwnProperty("pos"))
					if (this.EquipGrid.data.num == 0)
						mountypos=this.EquipGrid.data.info.subclassid;
					else
						bagpos=this.EquipGrid.data.pos;
				else
					bodypos=this.EquipGrid.data.position;

				info=this.EquipGrid.data;
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

//			if (info == null)
//				return;

			if (bagpos == -1 && bodypos == -1 && mountypos == -1 && data == null) {
				UIManager.getInstance().equipWnd.BagRender.updateBag([bagpos]);
				UIManager.getInstance().equipWnd.BagRender.updateMount([mountypos]);
				UIManager.getInstance().equipWnd.BagRender.updatebody([bodypos]);
			} else {
				UIManager.getInstance().equipWnd.BagRender.updateBag([bagpos], 0, 0, [int(info.info.quality), "<"], int(info.info.level));
				UIManager.getInstance().equipWnd.BagRender.updateMount([mountypos], 0, 0, [int(info.info.quality), "<"], int(info.info.level));
				UIManager.getInstance().equipWnd.BagRender.updatebody([bodypos], false, 0, 0, [int(info.info.quality), "<"], int(info.info.level));
			}

		}

		public function updateSuccess(o:Object):void {

//			this.succData=o;
			this.update(this.EquipGrid.data.tips, o);

			var data:Object;
			if (this.EquipGrid.data.hasOwnProperty("pos")) {
				if (this.EquipGrid.data.num == 0)
					data=MyInfoManager.getInstance().mountEquipArr[this.EquipGrid.data.info.subclassid-13];
				else
					data=MyInfoManager.getInstance().bagItems[this.EquipGrid.data.pos];
			} else {
				data=MyInfoManager.getInstance().equips[this.EquipGrid.data.position];
			}

//			UIManager.getInstance().equipWnd.BagRender.update();

			this.EquipGrid.updataInfo(data);
			EquipStrengGrid.selectState.updataInfo(data);

			this.CostGrid.resetGrid();
			this.updateViewState(data);

			if (EquipStrengGrid.selectStateII != null) {
				EquipStrengGrid.selectStateII.setSelectState(false);
				EquipStrengGrid.selectStateII.resetGrid();
				EquipStrengGrid.selectStateII=null;
			}

			this.confirmBtn.setActive(false, .6, true);
			this.confirmBtn.setToolTip(TableManager.getInstance().getSystemNotice(2609).content);

			SoundManager.getInstance().play(21);
		}

		private function update(info:TipsInfo, sd:Object=null):void {

			if (!this.EquipGrid.isEmpty && !this.CostGrid.isEmpty) {

				if (sd == null) {

					if (this.recastBar1.getUseGold() || this.recastBar1.getUseYb()) {
						this.recastBar2.setUseGold(this.recastBar1.getUseGold());
						this.recastBar2.setUseYb(this.recastBar1.getUseYb());
					}

					this.recastBar2.update(info);
					this.recastBar2.visible=true;
					this.recastBar1.visible=false;

				} else {

					if (this.recastBar2.getUseGold() || this.recastBar2.getUseYb()) {
						this.recastBar1.setUseGold(this.recastBar2.getUseGold());
						this.recastBar1.setUseYb(this.recastBar2.getUseYb());
					}

					this.recastBar1.update(info, sd);
					this.recastBar1.visible=true;
					this.recastBar2.visible=false;
				}

				this.confirmBtn.setActive(true, 1, true);
				this.confirmBtn.setToolTip("");
				this.descLbl.visible=false;

			} else if (!this.EquipGrid.isEmpty) {

				if (this.recastBar1.getUseGold() || this.recastBar1.getUseYb()) {
					this.recastBar2.setUseGold(this.recastBar1.getUseGold());
					this.recastBar2.setUseYb(this.recastBar1.getUseYb());
				} else {
					this.recastBar2.setUseGold(true);
				}

				this.recastBar2.update(info);
				this.recastBar2.visible=false;
				this.recastBar1.visible=false;
				this.descLbl.visible=true;

			} else {

				this.recastBar2.visible=false;
				this.recastBar1.visible=false;
				this.descLbl.visible=true;
			}
		}

		public function clearAllData():void {

			this.clearData();
			this.EquipGrid.resetGrid();
			this.CostGrid.resetGrid();

			this.confirmBtn.setActive(false, .6, true);
			this.confirmBtn.setToolTip(TableManager.getInstance().getSystemNotice(2609).content);
			this.descLbl.visible=true;

//			if (!this.CostGrid.isEmpty) {
//				if (this.CostGrid.gridType == ItemEnum.TYPE_GRID_EQUIP_BODY) {
//					UIManager.getInstance().equipWnd.BagRender.updateEmptyBodyGrid(this.CostGrid.data);
//				} else if (this.CostGrid.gridType == ItemEnum.TYPE_GRID_EQUIP_EQUIP) {
//					UIManager.getInstance().equipWnd.BagRender.updateEmptyBagGrid(this.CostGrid.data);
//				}
//			}
//			this.CostGrid.dropHandler();

			this.succData=null;
		}

		private function clearData():void {
			this.recastBar1.visible=false;
			this.recastBar2.visible=false;
		}

	}
}

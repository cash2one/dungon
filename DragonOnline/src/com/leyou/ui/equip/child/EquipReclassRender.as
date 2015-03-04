package com.leyou.ui.equip.child {

	import com.ace.enum.PlayerEnum;
	import com.ace.game.manager.DragManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.net.cmd.Cmd_Equip;
	import com.leyou.utils.PlayerUtil;

	import flash.events.MouseEvent;

	public class EquipReclassRender extends AutoSprite {

		private var confirmBtn:ImgButton;
		private var targetGrid:EquipStrengGrid;
		private var CostGrid:EquipStrengGrid;

		private var reclassBar:EquipReclassBar;
		private var descLbl:Label;

		private var targetEffect:SwfLoader;
		private var costEffect:SwfLoader;

		public function EquipReclassRender() {
			super(LibManager.getInstance().getXML("config/ui/equip/equipReclassRender.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {
			this.confirmBtn=this.getUIbyID("confirmBtn") as ImgButton;
			this.descLbl=this.getUIbyID("descLbl") as Label;

			this.targetGrid=new EquipStrengGrid();
			this.addChild(this.targetGrid);
			this.targetGrid.x=54;
			this.targetGrid.y=53;
			this.targetGrid.setSize(60, 60);
			this.targetGrid.dataId=1;

			this.CostGrid=new EquipStrengGrid();
			this.addChild(this.CostGrid);
			this.CostGrid.x=206;
			this.CostGrid.y=60;
			this.CostGrid.dataId=2;

			this.targetGrid.selectState();
			this.CostGrid.selectState();

			this.confirmBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.reclassBar=new EquipReclassBar();
			this.addChild(this.reclassBar);

			this.reclassBar.x=27;
			this.reclassBar.y=199;

			this.reclassBar.visible=false;
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp)

			this.targetEffect=new SwfLoader(99908);
			this.addChild(this.targetEffect);
			this.targetEffect.x=this.targetGrid.x - 14;
			this.targetEffect.y=this.targetGrid.y - 14;

			this.targetEffect.visible=false;

			this.costEffect=new SwfLoader(99907);
			this.addChild(this.costEffect);
			this.costEffect.x=this.CostGrid.x; // + 20;
			this.costEffect.y=this.CostGrid.y; // + 20;

			this.costEffect.visible=false;

			this.descLbl.wordWrap=true;
			this.descLbl.width=279;
			this.descLbl.htmlText="" + TableManager.getInstance().getSystemNotice(2615).content;

			this.y=1;
			this.x=-10;
		}

		private function onMouseUp(e:MouseEvent):void {

			if (e.target is EquipStrengGrid) {
				if (DragManager.getInstance().grid == null || DragManager.getInstance().grid.isEmpty || DragManager.getInstance().grid.dataId == 1 || DragManager.getInstance().grid.dataId == 2)
					return;

//				trace(DragManager.getInstance().grid, DragManager.getInstance().grid.isEmpty);

				var data:Object=DragManager.getInstance().grid.data;

				if (data == null || !data.hasOwnProperty("tips") || data.info.subclassid > 12)
					return;

				var info:TipsInfo=data.tips;

				var pos:int;
				var pos1:int;

				if (!this.targetGrid.isEmpty) {
					if (this.targetGrid.data.hasOwnProperty("pos") && data.hasOwnProperty("pos")) {

						if (int(this.targetGrid.data.pos) == data.pos) {
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

					}
				}

				if (e.target == this.targetGrid) {
//					this.clearData();
//					this.update(info);
				}

				this.updateViewState(data);
			}

		}

		private function onClick(e:MouseEvent):void {

			if (!this.targetGrid.isEmpty && !this.CostGrid.isEmpty) {

				if (this.CostGrid.data.tips.qh > 0) {
					PopupManager.showConfirm(StringUtil.substitute(TableManager.getInstance().getSystemNotice(2616).content, [this.CostGrid.data.tips.qh, this.CostGrid.data.info.name]), onStart, null, false, "equipbreakConfirm");
				} else
					this.onStart()

			}
		}

		private function onStart():void {

			this.reclassBar.setViewBuy();

			var arr:Array=this.reclassBar.getItemText().split(" x ");
			if (MyInfoManager.getInstance().getBagItemNumByName(arr[0]) < int(arr[1]) && UIManager.getInstance().quickBuyWnd.isAutoBuy(ConfigEnum.equip18, ConfigEnum.equip19)) {
				Cmd_Equip.cm_EquipReclass(this.targetGrid.data.pos, this.CostGrid.data.pos, this.reclassBar.getState(), (UIManager.getInstance().quickBuyWnd.getCost(ConfigEnum.equip18, ConfigEnum.equip19) == 0 ? 2 : 1));
			} else {
				Cmd_Equip.cm_EquipReclass(this.targetGrid.data.pos, this.CostGrid.data.pos, this.reclassBar.getState());
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

		public function updateList():void {



		}

		public function onSuccess(o:Object):void {

			var d:Baginfo=MyInfoManager.getInstance().bagItems[o.dpos];
			this.reclassBar.settargetPro(PlayerUtil.getPlayerRaceByIdx(d.info.limit));
			this.CostGrid.resetGrid();

			if (EquipStrengGrid.selectStateII != null) {
				EquipStrengGrid.selectStateII.setSelectState(false);
				EquipStrengGrid.selectStateII.resetGrid();
				EquipStrengGrid.selectStateII=null;
			}

			this.updateViewState();

			this.targetGrid.updataInfo(d);
			EquipStrengGrid.selectState.updataInfo(d);

		}

		public function setDownItem(g:EquipStrengGrid):void {

			var d:Object=g.data;
			var info:TipsInfo=d.tips;
			var einfo:TEquipInfo=TableManager.getInstance().getEquipInfo(info.itemid);

			if (einfo == null)
				return;

			if (this.targetGrid.isEmpty) {
				this.targetGrid.updataInfo(d);
//				this.clearData();
				this.updateViewState(d);
			} else if (this.CostGrid.isEmpty) {
				this.CostGrid.updataInfo(d);
			}

			this.updateViewState(d);

		}

		public function updateViewState(data:Object=null, isdrop:Boolean=false):void {

			var bagpos:int=-1;
			var bodypos:int=-1;

			var info:Object=data;

			if (!this.targetGrid.isEmpty) {

				if (this.targetGrid.data.hasOwnProperty("pos"))
					bagpos=this.targetGrid.data.pos;
				else
					bodypos=this.targetGrid.data.position;

				info=this.targetGrid.data;

				this.reclassBar.setPro(PlayerUtil.getPlayerRaceByIdx(info.info.limit));
				this.reclassBar.setneedItem(info.info);
			}

			if (!this.CostGrid.isEmpty) {

//				if (this.CostGrid.data.hasOwnProperty("pos"))
//					bagpos=this.CostGrid.data.pos;
//				else
//					bodypos=this.CostGrid.data.position;

//				info=this.CostGrid.data;
			}

//			if (info == null)
//				return;

			if (bagpos == -1 && data == null) {
				UIManager.getInstance().equipWnd.BagRender.updateBag([bagpos]);
				UIManager.getInstance().equipWnd.BagRender.updateMountEnable(true);
				UIManager.getInstance().equipWnd.BagRender.updatebody([bodypos], true);
				this.descLbl.visible=true;
			} else {

				UIManager.getInstance().equipWnd.BagRender.updateBag([bagpos], 0, 0, [int(info.info.quality), "<", 0], int(info.info.level));
				UIManager.getInstance().equipWnd.BagRender.updateMountEnable(true);
				UIManager.getInstance().equipWnd.BagRender.updatebody([bodypos], true);

				if (!this.targetGrid.isEmpty && !this.CostGrid.isEmpty) {
					this.reclassBar.visible=true;
					this.descLbl.visible=false;
					this.reclassBar.settargetPro();
					this.confirmBtn.setActive(true, 1, true);
				} else {
					this.confirmBtn.setActive(false, .6, true);
				}
			}

		}

		public function updateBagItems():void {
			this.clearAllData();
			TweenLite.delayedCall(.3, delcall);
		}

		private function delcall():void {
			UIManager.getInstance().equipWnd.BagRender.updateBagQuality2();
			UIManager.getInstance().equipWnd.BagRender.updatebody([-1], true);
		}

		public function clearAllData():void {
			this.targetGrid.resetGrid();
			this.CostGrid.resetGrid();
			this.reclassBar.visible=false;
			this.confirmBtn.setActive(false, .6, true);
			this.reclassBar.setSelectCb1();
			this.descLbl.visible=true;

			PopupManager.closeConfirm("equipbreakConfirm");
		}


	}
}

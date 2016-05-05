package com.leyou.ui.equip.child {

	import com.ace.enum.PlayerEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.game.manager.DragManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.LibManager;
	import com.ace.manager.SoundManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.lable.Label;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.utils.PnfUtil;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.data.role.EquipInfo;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.net.cmd.Cmd_Equip;

	import flash.events.MouseEvent;

	public class EquipTransRender extends AutoSprite {

		private var goldLbl:Label;
		private var ruleLbl:Label;
		private var descLbl:Label;
		private var confirmBtn:ImgButton;

		private var targetGrid:EquipStrengGrid;
		private var CostGrid:EquipStrengGrid;

		private var equipTransBar:EquipTransBar;

		private var succeffSwf:SwfLoader;
		
		private var targetEffect:SwfLoader;
		private var costEffect:SwfLoader;

		public function EquipTransRender() {
			super(LibManager.getInstance().getXML("config/ui/equip/equipTransRender.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
		}

		private function init():void {

			this.goldLbl=this.getUIbyID("goldLbl") as Label;
			this.descLbl=this.getUIbyID("descLbl") as Label;
			this.ruleLbl=this.getUIbyID("ruleLbl") as Label;
			this.confirmBtn=this.getUIbyID("confirmBtn") as ImgButton;
			
			this.succeffSwf=this.getUIbyID("succeffSwf") as SwfLoader;
			this.succeffSwf.visible=false;

			this.targetGrid=new EquipStrengGrid();
			this.addChild(this.targetGrid);
			this.targetGrid.x=45;
			this.targetGrid.y=139;
			this.targetGrid.setSize(60, 60);
			this.targetGrid.dataId=1;

			this.CostGrid=new EquipStrengGrid();
			this.addChild(this.CostGrid);
			this.CostGrid.x=244;
			this.CostGrid.y=41;
			this.CostGrid.dataId=2;
			this.CostGrid.setSize(38, 38);

			this.targetGrid.selectState();
			this.CostGrid.selectState();

			this.equipTransBar=new EquipTransBar();
			this.addChild(this.equipTransBar);

			this.equipTransBar.x=30;
			this.equipTransBar.y=237;

			this.confirmBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.equipTransBar.visible=false;
			this.confirmBtn.setActive(false, .6, true);

			this.confirmBtn.setToolTip(TableManager.getInstance().getSystemNotice(2508).content);

			this.targetEffect=new SwfLoader(99906);
			this.addChild(this.targetEffect);
			this.targetEffect.x=this.targetGrid.x - 17;
			this.targetEffect.y=this.targetGrid.y - 17;

			this.targetEffect.visible=false;

			this.costEffect=new SwfLoader(99905);
			this.addChild(this.costEffect);
			this.costEffect.x=this.CostGrid.x - 5; // + 20;
			this.costEffect.y=this.CostGrid.y - 5; // + 20;

			this.costEffect.visible=false;

			this.ruleLbl.setToolTip(TableManager.getInstance().getSystemNotice(2509).content);
//			this.descLbl.htmlText="" + TableManager.getInstance().getSystemNotice(2509).content;
//			this.descLbl.height=306;
//			this.descLbl.width=279;
//			this.descLbl.wordWrap=true;

			this.y=1;
			this.x=60;
		}

		private function onClick(e:MouseEvent):void {

			if (!this.targetGrid.getGridEmpty() && !this.CostGrid.getGridEmpty()) {

				if (UIManager.getInstance().backpackWnd.jb < this.equipTransBar.getGold()) {
					NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(2405));
					return;
				}

				if (this.targetGrid.data.tips.qh > this.CostGrid.data.tips.qh) {
					NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(2507));
					return;
				}

				if (this.targetGrid.data.hasOwnProperty("pos") && this.CostGrid.data.hasOwnProperty("pos")) { //背包---背包
//					if (this.targetGrid.data.info.num == 0 && this.CostGrid.data.info.num == 0)
//						Cmd_Equip.cm_EquipTransfer(40, this.CostGrid.data.position, 40, this.targetGrid.data.pos);
//					else
					if (this.CostGrid.data.num == 0)
						Cmd_Equip.cm_EquipTransfer(40, this.CostGrid.data.info.subclassid - 13, 1, this.targetGrid.data.pos);
					else if (this.targetGrid.data.num == 0)
						Cmd_Equip.cm_EquipTransfer(1, this.CostGrid.data.pos, 40, this.targetGrid.data.info.subclassid - 13);
					else
						Cmd_Equip.cm_EquipTransfer(1, this.CostGrid.data.pos, 1, this.targetGrid.data.pos);
				} else if (!this.targetGrid.data.hasOwnProperty("pos") && this.CostGrid.data.hasOwnProperty("pos")) { //人物--到背包
					if (this.CostGrid.data.num == 0)
						Cmd_Equip.cm_EquipTransfer(40, this.CostGrid.data.info.subclassid - 13, 1, this.targetGrid.data.position);
					else
						Cmd_Equip.cm_EquipTransfer(1, this.CostGrid.data.pos, 3, this.targetGrid.data.position);
				} else if (!this.targetGrid.data.hasOwnProperty("pos") && !this.CostGrid.data.hasOwnProperty("pos")) { //人物--人物
					Cmd_Equip.cm_EquipTransfer(3, this.CostGrid.data.position, 3, this.targetGrid.data.position);
				} else if (this.targetGrid.data.hasOwnProperty("pos") && !this.CostGrid.data.hasOwnProperty("pos")) { //背包--人物;
					if (this.targetGrid.data.num == 0)
						Cmd_Equip.cm_EquipTransfer(3, this.CostGrid.data.position, 40, this.targetGrid.data.info.subclassid - 13);
					else
						Cmd_Equip.cm_EquipTransfer(3, this.CostGrid.data.position, 1, this.targetGrid.data.pos);
				}

				this.targetEffect.visible=true;

				targetEffect.playAct(PlayerEnum.ACT_STAND, -1, false, function():void {
					targetEffect.visible=false;
				});

				this.costEffect.visible=true;

				costEffect.playAct(PlayerEnum.ACT_STAND, -1, false, function():void {
					costEffect.visible=false;
				});

				this.confirmBtn.setActive(false, .6, true);
			}

		}

		/**
		 *完成处理
		 *
		 */
		public function updateSucc():void {
			
			this.succeffSwf.visible=true;
			
			succeffSwf.playAct(PlayerEnum.ACT_STAND, -1, false, function():void {
				succeffSwf.visible=false;
			});
			
			this.targetGrid.resetGrid();
			this.CostGrid.resetGrid();

			if (EquipStrengGrid.selectState != null)
				EquipStrengGrid.selectState.setSelectState(false);

			if (EquipStrengGrid.selectStateII != null)
				EquipStrengGrid.selectStateII.setSelectState(false);

			EquipStrengGrid.selectState=null;
			EquipStrengGrid.selectStateII=null;

			SoundManager.getInstance().play(21);
			UIManager.getInstance().equipWnd.BagRender.update();

			this.clearAllData();
			this.equipTransBar.visible=false;
		}

		private function onMouseUp(e:MouseEvent):void {

//			this.goldLbl.text="";

			if (e.target is EquipStrengGrid) {
				if (DragManager.getInstance().grid == null || DragManager.getInstance().grid.isEmpty || DragManager.getInstance().grid.dataId == 1 || DragManager.getInstance().grid.dataId == 2)
					return;

				var g:GridBase=DragManager.getInstance().grid;
				var d:Object=g.data;

				if (d == null || !d.hasOwnProperty("tips"))
					return;

				var info:TipsInfo=d.tips;
				var einfo:TEquipInfo=TableManager.getInstance().getEquipInfo(info.itemid);

				if (einfo == null)
					return;

				var pos:int;
				var pos1:int;
				//判断类似是否同一个物品
//				for (var i:int=0; i < this.equipTransItemVec.length; i++) {
//					if (!this.equipTransItemVec[i].getGridEmpty()) {
//						if (this.equipTransItemVec[i].getGridData().hasOwnProperty("pos") && d.hasOwnProperty("pos")) {
//
//							if (int(this.equipTransItemVec[i].getGridData().pos) == d.pos) {
//								e.preventDefault();
//								e.stopImmediatePropagation();
//								return;
//							}
//
//						} else if (!this.equipTransItemVec[i].getGridData().hasOwnProperty("pos") && !d.hasOwnProperty("pos")) {
//
//							pos=MyInfoManager.getInstance().getRoleEquipPosById(d.id);
//							pos1=MyInfoManager.getInstance().getRoleEquipPosById(this.equipTransItemVec[i].getGridData().id);
//
//							if (pos == pos1) {
//								e.preventDefault();
//								e.stopImmediatePropagation();
//								return;
//							}
//
//						}
//					}
//				}

				//是否是其他待转移物品
				if ((EquipStrengGrid(e.target).dataId != -1 && g.dataId > -1)) {
					e.preventDefault();
					e.stopImmediatePropagation();
					return;
				}

//				this.goldLbl.text="" + einfo.dc;
				this.updateViewState(d);
			}

		}


		public function setDownItemOrBody(binfo:Baginfo, beinfo:EquipInfo):void {

			var d:Object=binfo;
			var info:TipsInfo=d.tips;
			var einfo:TEquipInfo=TableManager.getInstance().getEquipInfo(info.itemid);

			if (einfo == null)
				return;

			if (binfo.tips.qh != 0)
				throw new Error("目标强化等级不能大于0")

			this.targetGrid.updataInfo(binfo);
			this.CostGrid.updataInfo(beinfo);

			this.updateViewState(d);

			if (!this.CostGrid.getGridEmpty() && !this.targetGrid.getGridEmpty()) {

				this.equipTransBar.updateData(this.targetGrid.data.tips, 1);
				this.equipTransBar.updateData(this.CostGrid.data.tips, 2);

				this.equipTransBar.visible=true;
				this.confirmBtn.setActive(true, 1, true);
				this.confirmBtn.setToolTip("");
//				this.descLbl.visible=false;

			} else {

				this.equipTransBar.visible=false;
//				this.descLbl.visible=true;
				this.confirmBtn.setActive(false, .6, true);
				this.confirmBtn.setToolTip(TableManager.getInstance().getSystemNotice(2508).content);

			}
		}

		public function setDownItem(g:GridBase):void {

//			this.goldLbl.text="";

			var d:Object=g.data;
			var info:TipsInfo=d.tips;
			var einfo:TEquipInfo=TableManager.getInstance().getEquipInfo(info.itemid);

			if (einfo == null)
				return;

			if (this.targetGrid.isEmpty && this.CostGrid.isEmpty) {
				if (info.qh == 0)
					this.targetGrid.updataInfo(d);
				else
					this.CostGrid.updataInfo(d);

				this.updateViewState(d);
			} else {

				if (info.qh == 0)
					this.targetGrid.updataInfo(d);
				else
					this.CostGrid.updataInfo(d);

			}


			if (!this.CostGrid.getGridEmpty() && !this.targetGrid.getGridEmpty()) {

				this.equipTransBar.updateData(this.targetGrid.data.tips, 1);
				this.equipTransBar.updateData(this.CostGrid.data.tips, 2);

				this.equipTransBar.visible=true;
				this.confirmBtn.setActive(true, 1, true);
				this.confirmBtn.setToolTip("");
//				this.descLbl.visible=false;

			} else {

				this.equipTransBar.visible=false;
//				this.descLbl.visible=true;
				this.confirmBtn.setActive(false, .6, true);
				this.confirmBtn.setToolTip(TableManager.getInstance().getSystemNotice(2508).content);

			}

		}

		/**
		 * 更新数据,
		 * @param data
		 * @param isdrop
		 *
		 */
		public function updateViewState(data:Object=null, isdrop:Boolean=false):void {

			var bagpos:int=-1;
			var mountpos:int=-1;
			var bodypos:int=-1;
			var qu:int=-1;
			var info:Object=data;

			//如果不为空,重新获取原来数据
			if (!this.targetGrid.getGridEmpty()) {

				if (this.targetGrid.data.hasOwnProperty("pos")) {
					if (this.targetGrid.data.num == 0)
						mountpos=this.targetGrid.data.info.subclassid;
					else
						bagpos=this.targetGrid.data.pos;
				} else
					bodypos=this.targetGrid.data.position;

				info=this.targetGrid.data;
				qu=int(info.info.quality);
//				this.equipTransBar.updateData(info.tips, 1);

			} else {
				this.equipTransBar.updateData(null, 1);
			}


			if (!this.CostGrid.getGridEmpty()) {

				if (this.CostGrid.data.hasOwnProperty("pos")) {
					if (this.CostGrid.data.num == 0)
						mountpos=this.CostGrid.data.info.subclassid;
					else
						bagpos=this.CostGrid.data.pos;
				} else
					bodypos=this.CostGrid.data.position;

				info=this.CostGrid.data;

//				this.equipTransBar.updateData(info.tips, 2);
			} else {
				this.equipTransBar.updateData(null, 2);
			}

//			this.equipTransBar.visible=false;

			//判断是否是本类型的物品,
			if (bagpos == -1 && bodypos == -1 && mountpos == -1 && data == null) {

				UIManager.getInstance().equipWnd.BagRender.updateBag([bagpos]);
				UIManager.getInstance().equipWnd.BagRender.updatebody([bodypos]);
				UIManager.getInstance().equipWnd.BagRender.updateMount([mountpos]);
				this.clearAllData();

			} else { //如果不是,置灰



				if (data != null) {

					var isCost:Boolean=false;

//					if (!this.CostGrid.getGridEmpty() && !this.targetGrid.getGridEmpty()) {

//						if (data.hasOwnProperty("pos")) {
//
//							if (this.CostGrid.data.hasOwnProperty("pos") && data.pos == this.CostGrid.data.pos) {
//								info=this.targetGrid.data;
//							} else if (this.targetGrid.data.hasOwnProperty("pos") && data.pos == this.targetGrid.data.pos) {
//								info=this.CostGrid.data;
//								isCost=true;
//							}
//
//						} else {
//
//							if (this.CostGrid.data.hasOwnProperty("pos") && data.position == this.CostGrid.data.position)
//								info=this.targetGrid.data;
//							else if (this.CostGrid.data.hasOwnProperty("pos") && data.position ==this.targetGrid.data.position) {
//								info=this.CostGrid.data;
//								isCost=true;
//							}
//
//						}

//						info=this.targetGrid.data;

//					} else 

					if (!this.targetGrid.getGridEmpty()) {
//						info=this.targetGrid.data;
					} else if (!this.CostGrid.getGridEmpty()) {
//						info=this.CostGrid.data;
						isCost=true;
					}

					if (isCost) {
						UIManager.getInstance().equipWnd.BagRender.updateBag([bagpos], int(info.info.subclassid), int(info.info.position), [int(info.info.quality), "<"], -1, 1);
						UIManager.getInstance().equipWnd.BagRender.updatebody([bodypos], false, int(info.info.subclassid), int(info.info.position), [int(info.info.quality), "<"], -1, 1);
						UIManager.getInstance().equipWnd.BagRender.updateMount([mountpos], int(info.info.subclassid), int(info.info.position), [int(info.info.quality), "<"], -1, 1);
					} else {
						UIManager.getInstance().equipWnd.BagRender.updateBag([bagpos], int(info.info.subclassid), int(info.info.position), [int(info.info.quality), ">"], -1, 0);
						UIManager.getInstance().equipWnd.BagRender.updatebody([bodypos], false, int(info.info.subclassid), int(info.info.position), [int(info.info.quality), ">"], -1, 0);
						UIManager.getInstance().equipWnd.BagRender.updateMount([mountpos], int(info.info.subclassid), int(info.info.position), [int(info.info.quality), ">"], -1, 0);
					}

				}
			}

		}


		public function clearAllData():void {
			this.confirmBtn.setActive(false, .6, true);
			this.confirmBtn.setToolTip(TableManager.getInstance().getSystemNotice(2508).content);

			this.equipTransBar.clearData();
			this.equipTransBar.visible=false;
//			this.descLbl.visible=true;

			this.targetGrid.resetGrid();
			this.CostGrid.resetGrid();
		}


	}
}

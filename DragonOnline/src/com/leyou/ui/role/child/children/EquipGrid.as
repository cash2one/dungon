package com.leyou.ui.role.child.children {

	import com.ace.enum.ItemEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.notice.NoticeManager;
	import com.leyou.data.role.EquipInfo;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.net.cmd.Cmd_Bag;
	import com.leyou.net.cmd.Cmd_Role;
	import com.leyou.ui.backpack.child.GridModel;
	import com.leyou.utils.FilterUtil;

	import flash.geom.Point;

	public class EquipGrid extends GridModel {

		private var _type:int;
		private var moveFlag:Boolean;
		public var doubleEvent:Boolean;

		private var info:Object;

		public function EquipGrid() {
			super();
		}

		override protected function init(hasCd:Boolean=false):void {
			super.init();
			this.isLock=false;
			this.canMove=false;
			this.gridType=ItemEnum.TYPE_GRID_ROLE;
			this.bgBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/bg.png");
//			this.bgBmp.alpha=0;

			this.mouseEnabled=false;
			this.mouseChildren=true;

//			this.opaqueBackground=0xff0000;
		}

		override public function updataInfo(info:Object):void {

			this.reset();

			this.isLock=false;
			this.isEmpty=false;
			this.bgBmp.alpha=0;

			if (info == null)
				return;

			super.updataInfo(info);
			this.info=info;

			if (info.info != null && int(info.info.bind) == 1)
				this.bindingBmp.visible=true;
			else
				this.bindingBmp.visible=false;

			if (int(info.tips.qh) > 0)
				this.setIntensify("" + info.tips.qh);

//			if (this.gridType == ItemEnum.TYPE_GRID_EQUIP)
//				this.iconBmp.updateBmp("ico/items/" + info.info.icon + ".png");
//
//			if (this.gridType == ItemEnum.TYPE_GRID_OTHER_EQUIP) {
			this.iconBmp.updateBmp("ico/items/" + info.info.icon + ".png");
			this.canMove=false;
//			}

			this.iconBmp.x=(40 - 36) >> 1;
			this.iconBmp.y=(40 - 36) >> 1;
			this.iconBmp.setWH(36, 36);

			this.stopMc();
			if (info.info.effect != null && info.info.effect != "0")
				this.playeMc(int(info.info.effect), new Point(0, 0));

			this.addChild(this.intensifyLbl);
		}

		public function setSize(w:Number, h:Number):void {
			this.iconBmp.setWH(w, h);
		}

		override protected function reset():void {
			super.reset();
			this.isLock=false;
			this.isEmpty=true;
			this.bgBmp.alpha=0;
			this.iconBmp.bitmapData=null;
			this.enable=true;
			this.stopMc();
			this.intensifyLbl.bitmapData=null;
			this.bindingBmp.visible=false;
			this.info=null;
		}

		public function clearMe():void {
			this.reset();
		}

		//经过事件
		override public function mouseOverHandler($x:Number, $y:Number):void {
			super.mouseOverHandler($x, $y);

			if (this.isEmpty || this.info == null)
				return;

			var tips:TipsInfo=this.info.tips;

			if (this.info is EquipInfo)
				tips.playPosition=this.info.position;

			if (!this.doubleClickEnabled) {
				tips.otherPlayer=true;

				var einfo:Object;

				if (this.info.info.subclassid > 12) {

					einfo=MyInfoManager.getInstance().mountEquipArr[this.info.info.subclassid - 13];
				} else {

					var olist:Array=ItemEnum.ItemToRolePos[this.info.info.subclassid];

					var st:Boolean=false;
					var roleIndex:int;
					einfo=MyInfoManager.getInstance().equips[olist[0]];

					if (einfo != null) {

						if (olist.length == 2) {
							var einfo1:EquipInfo=MyInfoManager.getInstance().equips[olist[1]];
							if (einfo1 != null) {
								if (einfo.tips.zdl > einfo1.tips.zdl) {
									einfo=einfo1;
								}
							}
						}

					} else {
						if (olist.length == 2)
							einfo=MyInfoManager.getInstance().equips[olist[1]];
					}

				}

				if (einfo != null) {

					tips.isdiff=true;
					einfo.tips.isUse=true;
					einfo.tips.isdiff=false;
					einfo.tips.otherPlayer=false;
					
					if (this.info is EquipInfo)
						einfo.tips.playPosition=this.info.position;
					
					ToolTipManager.getInstance().showII([TipEnum.TYPE_EQUIP_ITEM, TipEnum.TYPE_EQUIP_ITEM_DIFF], [tips, einfo.tips], PlayerEnum.DIR_E, new Point(2, 0), new Point(this.stage.mouseX + this.width, this.stage.mouseY + this.height));

				} else {

					ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, tips, this.parent.localToGlobal(new Point(this.x + this.width, this.y + this.height)));
				}

			} else {

				tips.otherPlayer=false;
//				tips=this.info.tips;
				ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, tips, this.parent.localToGlobal(new Point(this.x + this.width, this.y + this.height)));
			}

		}

		//鼠标离开
		override public function mouseOutHandler():void {
			super.mouseOutHandler();
		}

		override public function switchHandler(fromItem:GridBase):void {
			if (this.gridType == ItemEnum.TYPE_GRID_OTHER_EQUIP) {
				fromItem.enable=true;
				return;
			}

//			super.switchHandler(fromItem);

			if (this.gridType != fromItem.gridType) {

//				if (fromItem.gridType == ItemEnum.TYPE_GRID_BACKPACK) {
//					var info:TClientItem=MyInfoManager.getInstance().backpackItems[fromItem.dataId];
//					if (info == null)
//						return;

//					if (ItemEnum.equipPos[info.s.type] == null)
//						return;

//					var pos:int=ItemEnum.equipPos[info.s.type];
//					if (pos == this.dataId) {
//						MyInfoManager.getInstance().waitItemUse=fromItem.dataId;
//						(fromItem as BackpackGrid).onUse();
//					} else if ((this.dataId == ItemEnum.U_ARMRINGL || this.dataId == ItemEnum.U_ARMRINGR) && (pos == ItemEnum.U_ARMRINGL || pos == ItemEnum.U_ARMRINGR)) {
//						UIManager.getInstance().roleWnd.dragWrisPos=this.dataId;
//						MyInfoManager.getInstance().waitItemUse=fromItem.dataId;
//						(fromItem as BackpackGrid).onUse();
//					} else if ((this.dataId == ItemEnum.U_RINGL || this.dataId == ItemEnum.U_RINGR) && (pos == ItemEnum.U_RINGL || pos == ItemEnum.U_RINGR)) {
//						UIManager.getInstance().roleWnd.dragRingPos=this.dataId;
//						MyInfoManager.getInstance().waitItemUse=fromItem.dataId;
//						(fromItem as BackpackGrid).onUse();
//					}
//				}

			}

			/**
			 * 来自背包
			 */
			if (fromItem.gridType == ItemEnum.TYPE_GRID_BACKPACK) {
				if (fromItem.dataId == -1)
					return;

				if (fromItem.data.info.classid != ItemEnum.ITEM_TYPE_EQUIP)
					return;

				if (ItemEnum.ItemToRolePos[fromItem.data.info.subclassid].indexOf(this.dataId) == -1)
					return;

				Cmd_Bag.cm_bagMoveTo(fromItem.dataId, 3, this.dataId);
			}

		}

		override public function doubleClickHandler():void {
			if (this.gridType != ItemEnum.TYPE_GRID_ROLE || this.isEmpty == true || !this.doubleClickEnabled)
				return;

			var i:int=MyInfoManager.getInstance().getBagEmptyGridIndex();

			if (i == -1) {
				NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(1610));
				return;
			}

			Cmd_Role.cm_offEquip(this.dataId);
		}

		override public function set enable(value:Boolean):void {
			super.enable=value;

			if (!value) {
				this.iconBmp.filters=[FilterUtil.enablefilter];
			} else {
				this.iconBmp.filters=[];
				this.moveFlag=false;
			}

		}

//		override public function mouseDownHandler($x:Number, $y:Number):void {
//			super.mouseDownHandler($x, $y);

//			this.moveFlag=true;
//		}
//
//		override public function mouseMoveHandler($x:Number, $y:Number):void {
////			ItemTip.getInstance().updataPs($x, $y);
//			if (this.moveFlag) {
//				this.enable=false;
//				this.moveFlag=false;
//			}
//
//		}

		override public function mouseUpHandler($x:Number, $y:Number):void {
			super.mouseUpHandler($x, $y);
			
			if(!this.doubleClickEnabled)
				return ;
			
			var pro:String;
			var arr:Array;
			for (pro in ItemEnum.ItemToRolePos) {
				if (ItemEnum.ItemToRolePos[pro].indexOf(this.dataId) > -1) {
					break;
				}
			}

			var p:Point=LayerManager.getInstance().windowLayer.globalToLocal(this.parent.localToGlobal(new Point(this.x + 40, this.y)));

			UIManager.getInstance().selectWnd.type=0;
			UIManager.getInstance().selectWnd.showPanel(int(pro), this.dataId, p);

		}


	}
}

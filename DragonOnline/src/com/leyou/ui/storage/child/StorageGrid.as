package com.leyou.ui.storage.child {

	import com.ace.config.Core;
	import com.ace.enum.ItemEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.game.manager.DragManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TStorageAdd;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.lable.Label;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.utils.StringUtil;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.data.role.EquipInfo;
	import com.leyou.data.store.StoreInfo;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.manager.TimerManager;
	import com.leyou.net.cmd.Cmd_Bag;
	import com.leyou.net.cmd.Cmd_Store;
	import com.leyou.ui.backpack.child.BackpackGrid;
	import com.leyou.utils.TimeUtil;

	import flash.geom.Point;

	public class StorageGrid extends BackpackGrid {

		private var opengridIndex:int=0;

		public function StorageGrid(id:int) {
			super(id);
		}

		override protected function init(hasCd:Boolean=false):void {
			super.init(true);

			this.isLock=false;
			this.gridType=ItemEnum.TYPE_GRID_STORAGE;

			this.bgBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/bg.png");
			this.iconBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/lock.png");
			this.selectBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/select.png");

			this.iconBmp.x=3;
			this.iconBmp.y=3;

			this.selectBmp.x=0; //-1.9;
			this.selectBmp.y=0; //-1.8;

			this.mouseChildren=true;
		}

		override public function updataInfo(info:Object):void {
			this.reset();
			this.unlocking();

			if (info == null) {
				this.cdMc.visible=false;
				return;
			}

			//super.updataInfo(info);

			if (StoreInfo(info).num > 1) {
				this.numLbl.htmlText="<font face='宋体' size='12'>" + StoreInfo(info).num + "</font>";
			} else {
				this.numLbl.text="";
			}

			this.numLbl.x=40 - this.numLbl.textWidth - 3;

			if (StoreInfo(info).num > 1) {
				this.numLbl.text=StoreInfo(info).num + "";
			} else {
				this.numLbl.text="";
			}

			this.numLbl.x=40 - this.numLbl.textWidth - 3;

			if (info.info != null && int(info.info.bind) == 1)
				this.bindingBmp.visible=true;
			else
				this.bindingBmp.visible=false;

			if (int(info.tips.qh) > 0)
				this.setIntensify("" + StoreInfo(info).tips.qh);

			this.iconBmp.updateBmp("ico/items/" + info.info.icon + ".png");
			this.dataId=info.pos;

			this.updateTopIconState();
			this.iconBmp.setWH(36, 36);

			if ((Core.me.info.profession != info.info.limit && info.info.limit != 0) || (Core.me.info.level < int(info.info.level)))
				this.reMask=true;

			if (info.info.effect != null && info.info.effect != "0")
				this.playeMc(int(info.info.effect));

			this.addChild(this.bindingBmp);
			this.addChild(this.numLbl);

			this.setLimitTimeByInfo(info);
		}

		private function updateTopIconState():void {

			var binfo:StoreInfo=this.data as StoreInfo;
			if (this.dataId == -1 || binfo.info.classid != 1)
				return;

			var einfo:Object;
			if (binfo.info.subclassid >= 13) {
				einfo=MyInfoManager.getInstance().mountEquipArr[binfo.info.subclassid - 13];

				if (einfo == null || einfo.tips.zdl < binfo.tips.zdl) {
					st=1;
				} else if (einfo.tips.zdl > binfo.tips.zdl) {
					st=0;
				}
			} else {

				var olist:Array=ItemEnum.ItemToRolePos[binfo.info.subclassid];

				var st:int=-1;
				var roleIndex:int;

				for each (roleIndex in olist) {
					einfo=MyInfoManager.getInstance().equips[roleIndex];

					if (einfo == null || einfo.tips.zdl < binfo.tips.zdl) {
						st=1;
						break;
					} else if (einfo.tips.zdl > binfo.tips.zdl) {
						st=0;
					}
				}
			}

			this.topBmp.visible=true;
			this.changeTopState(st);
		}

		override protected function reset():void {
			super.reset();


		}

		override public function dropHandler():void {

		}

//		override public function mouseDownHandler($x:Number, $y:Number):void {
		//仓库批量存取
		//			if (UIManager.getInstance().backPackWnd.visible && UIManager.getInstance().storageWnd.isbatchSave) {
		//
		//				if (this.dataId == -1 || MyInfoManager.getInstance().waitItemFromId != -1)
		//					return;
		//
		//				MyInfoManager.getInstance().waitItemFromId=this.dataId; //从仓库
		//				MyInfoManager.getInstance().waitItemToId=MyInfoManager.getInstance().findEmptyPs(ItemEnum.TYPE_GRID_BACKPACK);
		//				Cmd_backPack.cm_userTakeBackStorageItem(MyInfoManager.getInstance().talkNpcId, this.data);
		//				UIManager.getInstance().storageWnd.mouseChildren=false;
		//			} else {
		//				if (DragManager.getInstance().grid != null && this.data != null && this.data.s != null) {
		//					UIManager.getInstance().backPackWnd.showDragGlowFilter(true);
		//					if (ItemUtil.EQUIP_TYPE.concat(ItemUtil.ITEM_TOOL).indexOf(this.data.s.type) > -1)
		//						UIManager.getInstance().toolsWnd.showDragGlowFilter(true);
		//				}
		//			}
//		}


		override public function switchHandler(fromItem:GridBase):void {

			if (this.gridType == fromItem.gridType) {

				if (fromItem.dataId == -1)
					return;

				Cmd_Store.cm_storeMove(fromItem.dataId, this.initId);
				return;

			} else {

				if (fromItem.gridType == ItemEnum.TYPE_GRID_BACKPACK) {

					if (fromItem.dataId == -1)
						return;

					fromItem.enable=true;

					if (BackpackGrid.menuState == 3) {
						BackpackGrid.menuState=-1;
					}

					var i:int=0;
					if (UIManager.getInstance().storageWnd.getTabberIndex() == 0) {
						i=this.initId;
					} else {
						i=MyInfoManager.getInstance().getStoreEmptyGridIndex();
						if (i == -1) {
							NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(1609));
							return;
						}
					}

					Cmd_Bag.cm_bagMoveTo(fromItem.dataId, 2, i);
					return;
				}

			}

		}

		override public function mouseMoveHandler($x:Number, $y:Number):void {
			super.mouseMoveHandler($x, $y);
		}

		override public function doubleClickHandler():void {
//			super.doubleClickHandler(); md

			if (UIManager.getInstance().storageWnd.visible && UIManager.getInstance().backpackWnd.visible) {

				if (this.dataId == -1)
					return;

				Cmd_Store.cm_storeMoveTo(this.dataId, 1, MyInfoManager.getInstance().getBagEmptyGridIndex());
			}

		}

		override public function mouseOverHandler($x:Number, $y:Number):void {
			super.mouseOverHandler($x, $y);

			if (this.isEmpty) {
				var badd:TStorageAdd=TableManager.getInstance().getStorAddInfo(this.initId + 1);

				if (UIManager.getInstance().storageWnd.itemCount == this.initId) {
					openPoint=new Point($x, $y);
					this.openExeTime(this.opengridIndex);
					TimerManager.getInstance().add(openExeTime, "openStorekey");
				} else
					ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(9906).content, [this.initId + 1, badd.addHP, badd.addExp, badd.addMoney]), new Point($x, $y));

			} else {

				if (this.isEmpty || data == null)
					return;

				var binfo:StoreInfo=this.data as StoreInfo;
				if (this.dataId == -1 || binfo == null)
					return;

				var tips:TipsInfo=binfo.tips;
				var einfo:Object;
				if (binfo.info.classid == 1) {
					if (binfo.info.subclassid < 13) {
						var olist:Array=ItemEnum.ItemToRolePos[binfo.info.subclassid];

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
					} else {
						einfo=MyInfoManager.getInstance().mountEquipArr[binfo.info.subclassid - 13];
					}
				}

				if (einfo != null) {
					tips.isdiff=true;
					einfo.tips.isUse=true;
					einfo.tips.isdiff=false;
					ToolTipManager.getInstance().showII([TipEnum.TYPE_EQUIP_ITEM, TipEnum.TYPE_EQUIP_ITEM_DIFF], [tips, einfo.tips], PlayerEnum.DIR_E, new Point(2, 0), this.parent.localToGlobal(new Point(this.x + this.width, this.y + this.height)));
				} else {
					
					var type:int=TipEnum.TYPE_EQUIP_ITEM;
					
					if (binfo.info.classid == 10) {
						type=TipEnum.TYPE_GEM_OTHER;
					}
					
					tips.isdiff=false;
					ToolTipManager.getInstance().show(type, tips, this.parent.localToGlobal(new Point(this.x + this.width, this.y + this.height)));
				}

			}
		}

		override public function get data():* {
			if (this.dataId == -1)
				return null;

			return MyInfoManager.getInstance().storeItems[this.dataId];
		}

		/**
		 *开格子倒计时
		 *
		 */
		private function openExeTime(i:int):void {

			var badd:TStorageAdd=TableManager.getInstance().getStorAddInfo(UIManager.getInstance().storageWnd.itemCount + 1);

			var st:String=TimeUtil.getIntToDateTime(this.opengridIndex);
//			trace("====", st, UIManager.getInstance().backpackWnd.openGridTime)
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(9905).content, [UIManager.getInstance().storageWnd.itemCount + 1, st, badd.addHP, badd.addExp, badd.addMoney]), openPoint);

			if (this.opengridIndex > 0)
				this.opengridIndex=UIManager.getInstance().storageWnd.openGridTime - (i % UIManager.getInstance().storageWnd.openGridTime);
			else {
				TimerManager.getInstance().removeBykey("openStorekey");
				this.setShow(false);
			}
		}

		override public function mouseOutHandler():void {
			super.mouseOutHandler();
			TimerManager.getInstance().removeBykey("openStorekey");
		}

		override public function mouseDownHandler($x:Number, $y:Number):void {

			if (UIManager.getInstance().storageWnd.visible && UIManager.getInstance().storageWnd.isbatchSave) {

				if (this.dataId == -1)
					return;

				var i:int=MyInfoManager.getInstance().getBagEmptyGridIndex();
				if (i == -1) {
					NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(1610));
					return;
				}

				//				trace("store",this.dataId,i)
				Cmd_Store.cm_storeMoveTo(this.dataId, 1, i);
			}

		}

		override public function mouseUpHandler($x:Number, $y:Number):void {

			if (this.initId >= ItemEnum.STORAGE_GRIDE_OPEN) {
				UIManager.getInstance().storageWnd.openGrid=true;
				Cmd_Store.cm_storeOpenGrid(this.initId + 1 - UIManager.getInstance().storageWnd.itemCount);
				return;
			}

		}

		override public function get width():Number {
			return 40;
		}


	}
}

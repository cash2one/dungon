package com.leyou.ui.backpack.child {

	import com.ace.ICommon.IMenu;
	import com.ace.config.Core;
	import com.ace.enum.ItemEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.game.manager.DragManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TBackpackAdd;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.KeysManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.MenuManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.ace.ui.lable.Label;
	import com.ace.ui.menu.data.MenuInfo;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenMax;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.data.role.EquipInfo;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.manager.PopupManager;
	import com.leyou.manager.TimerManager;
	import com.leyou.net.cmd.Cmd_Bag;
	import com.leyou.net.cmd.Cmd_Gem;
	import com.leyou.net.cmd.Cmd_LDW;
	import com.leyou.net.cmd.Cmd_Role;
	import com.leyou.net.cmd.Cmd_Store;
	import com.leyou.net.cmd.Cmd_Wig;
	import com.leyou.ui.aution.child.AutionSaleItemGrid;
	import com.leyou.ui.gem.child.GemGrid;
	import com.leyou.ui.luckDraw.LuckPackGrid;
	import com.leyou.ui.shop.child.GridShop;
	import com.leyou.ui.storage.child.StorageGrid;
	import com.leyou.utils.FilterUtil;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.TimeUtil;

	import flash.display.Shape;
	import flash.geom.Point;
	import flash.ui.Keyboard;

	public class BackpackGrid extends GridModel implements IMenu {

		private var isCDIng:Boolean;

		//private var cd:CDTimer;

		public static var menuState:int=-1;
		private var startName:Label;

		private var shap:Shape;

		private var msgBox:MessageInputWnd;

		protected var openPoint:Point;

		public var enableMouseUpEvent:Boolean=true;

		private var opengridIndex:int=0;

		public function BackpackGrid(id:int) {
			super(id, true);
		}

		override protected function init(hasCd:Boolean=false):void {
			super.init(hasCd);

			this.isLock=false;
			this.gridType=ItemEnum.TYPE_GRID_BACKPACK;

			this.numLbl.x=22;
			this.numLbl.y=24;

			this.bgBmp.updateBmp("ui/backpack/bg.png");
			this.iconBmp.updateBmp("ui/backpack/lock.png");
			this.selectBmp.updateBmp("ui/backpack/select.png");

			this.selectBmp.x=-1.9;
			this.selectBmp.y=-1.8;

			//			this.shap=new Shape();
//			this.shap.graphics.beginFill(0xff0000, .3);
//			this.shap.graphics.drawRect(0, 0, 40, 40);
//			this.shap.graphics.endFill();
//
//			this.addChild(this.shap);
//			this.shap.visible=false;

			this.dataId=-1;

			this.startName=new Label();
			this.startName.x=(40 - this.startName.width) / 2;
			this.startName.y=(40 - this.startName.height) / 2;
			this.addChild(this.startName);
			this.startName.htmlText="<font color='#f6d654'>开启中</font>";
			this.startName.visible=false;

			if (hasCd) {
				this.cdMc.y=1;
				this.cdMc.updateUI(40, 39);
			}

		}

		override public function updataInfo(info:Object):void {
			this.reset();
			this.unlocking();

			super.updataInfo(info);

			if (info == null) {
				this.cdMc.visible=false;
				return;
			}

			if (Baginfo(info).num > 1) {
				this.numLbl.text=Baginfo(info).num + "";
			} else {
				this.numLbl.text="";
			}

			this.numLbl.x=40 - this.numLbl.textWidth - 5;

			if (info.info != null && int(info.info.bind) == 1)
				this.bindingBmp.visible=true;
			else
				this.bindingBmp.visible=false;

			this.iconBmp.updateBmp("ico/items/" + Baginfo(info).info.icon + ".png");
			this.iconBmp.x=this.iconBmp.y=(ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) / 2;
			this.iconBmp.setWH(36, 36);
			this.dataId=info.pos;

			if (info.cdtime > 0) {
				this.startCD(info.cdtime);
			}

			if ((Core.me.info.profession != info.info.limit && info.info.limit != 0) || (Core.me.info.level < int(info.info.level)))
				this.reMask=true;

			this.updateTopIconState();

			if (info.info.effect != null && info.info.effect != "0")
				this.playeMc(int(info.info.effect));

			if (int(info.tips.qh) > 0)
				this.setIntensify("" + Baginfo(info).tips.qh);

			this.addChild(this.bindingBmp);
			this.addChild(this.disableBmp);
			this.addChild(this.numLbl);
		}

		override protected function reset():void {
			super.reset();
			super.updataInfo(null);

			this.numLbl.text="";
			this.dataId=-1;
			this.reMask=false;
			this.setShow(false);
			this.topBmp.visible=false;
			this.iconBmp.bitmapData=null;
			this.stopMc();
			this.cdMc.visible=false;
			this.cdMc.clearCD();
			this.cdMc.play(0, 0)

		}

		public function setSize(w:Number, h:Number):void {

			this.bgBmp.setWH(w + 5, h + 5);
			this.bgBmp.visible=false;
			this.selectBmp.bitmapData=null;
			this.iconBmp.setWH(w, h);

			this.updateTopIconState();

			if ((Core.me.info.profession != this.data.info.limit && this.data.info.limit != 0) || (Core.me.info.level < int(this.data.info.level)))
				this.reMask=true;

			if (this.data.info.effect != null && this.data.info.effect != "0") {
				this.stopMc();

				if (w == 40)
					this.playeMc(int(this.data.info.effect));
				else
					this.playeMc(int(this.data.info.effect1), new Point(0.5, 0));
			}

			this.numLbl.x=22 + (this.bgBmp.width - 40 - 3);
			this.numLbl.y=24 + (this.bgBmp.height - 40 - 3);

			if (int(this.data.tips.qh) > 0)
				this.setIntensify("" + Baginfo(this.data).tips.qh);

			this.bindingBmp.y=26 + (this.bgBmp.height - 40 - 5);
			this.disableBmp.y=26 + (this.bgBmp.height - 40 - 5);

			this.addChild(this.bindingBmp);
			this.addChild(this.disableBmp);
			this.addChild(this.numLbl);
		}

		//经过事件
		override public function mouseOverHandler($x:Number, $y:Number):void {
			super.mouseOverHandler($x, $y);

			if (this.isEmpty) {
				var badd:TBackpackAdd=TableManager.getInstance().getBagAddInfo(this.initId + 1);

				if (UIManager.getInstance().backpackWnd.itemCount == this.initId) {
					openPoint=new Point($x, $y);
					Cmd_Bag.cm_bagOpenGrid();
					this.openExeTime(this.opengridIndex);
					TimerManager.getInstance().add(openExeTime, "openBagkey");
				} else {
					ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(9906).content, [this.initId + 1, badd.addHP, badd.addExp, badd.addMoney]), new Point($x, $y));
				}

			} else {

				if (this.isEmpty || data == null)
					return;

				var binfo:Baginfo=this.data as Baginfo;
				if (this.dataId == -1 || binfo == null)
					return;

				var tips:TipsInfo=binfo.tips;
				if (binfo.info.classid == 1) {

					var einfo:Object;
					var index:int=0;
					if (binfo.info.subclassid < 13) {
						var olist:Array=ItemEnum.ItemToRolePos[binfo.info.subclassid];

						var st:Boolean=false;
						var roleIndex:int=olist[0];
						einfo=MyInfoManager.getInstance().equips[olist[0]];

						if (einfo != null) {

							if (olist.length == 2) {
								var einfo1:EquipInfo=MyInfoManager.getInstance().equips[olist[1]];

								if (einfo1 != null) {

									if (einfo.tips.zdl > einfo1.tips.zdl) {
										einfo=einfo1;
										roleIndex=olist[1];
									}

								}

							}

						} else {
							if (olist.length == 2)
								einfo=MyInfoManager.getInstance().equips[olist[1]];
							roleIndex=olist[1];
						}
					} else {
						einfo=MyInfoManager.getInstance().mountEquipArr[binfo.info.subclassid - 13];
					}
				}

				tips.istype=3;
				if (einfo != null) {
					tips.isdiff=true;
					einfo.tips.isUse=true;
					einfo.tips.isdiff=false;

					if (binfo.info.subclassid < 13)
						einfo.tips.playPosition=roleIndex;

					ToolTipManager.getInstance().showII([TipEnum.TYPE_EQUIP_ITEM, TipEnum.TYPE_EQUIP_ITEM_DIFF], [tips, einfo.tips], PlayerEnum.DIR_E, new Point(2, 0), new Point(this.stage.mouseX + this.width, this.stage.mouseY + this.height));
				} else {

					var type:int=TipEnum.TYPE_EQUIP_ITEM;

					if (binfo.info.classid == 10) {
						type=TipEnum.TYPE_GEM_OTHER;
					}

//						this.parent.localToGlobal(new Point(this.x + this.width, this.y + this.height))
					tips.isdiff=false;
					tips.isShowPrice=true;
					ToolTipManager.getInstance().show(type, tips, new Point(this.stage.mouseX + this.width, this.stage.mouseY + this.height));

				}
			}

		}

		/**
		 *开格子倒计时
		 */
		private function openExeTime(i:int):void {

			var badd:TBackpackAdd=TableManager.getInstance().getBagAddInfo(UIManager.getInstance().backpackWnd.itemCount + 1);

			var st:String=TimeUtil.getIntToDateTime(this.opengridIndex);
//			trace("====", st, UIManager.getInstance().backpackWnd.openGridTime)
			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(9905).content, [UIManager.getInstance().backpackWnd.itemCount + 1, st, badd.addHP, badd.addExp, badd.addMoney]), openPoint);

			if (UIManager.getInstance().backpackWnd.openGridTime - (i % UIManager.getInstance().backpackWnd.openGridTime) > 0)
				this.opengridIndex=UIManager.getInstance().backpackWnd.openGridTime - (i % UIManager.getInstance().backpackWnd.openGridTime);
			else {
				TimerManager.getInstance().removeBykey("openBagkey");
				this.setShow(false);
			}

		}

		override public function mouseDownHandler($x:Number, $y:Number):void {
			if (!enableMouseUpEvent) {
				return;
			}

			super.mouseDownHandler($x, $y);

			//快速卖出
			if (UIManager.getInstance().backpackWnd.fastState) {
				Cmd_Bag.cm_bagSell(this.dataId);
				return;
			} else if (UIManager.getInstance().isCreate(WindowEnum.STOREGE) && UIManager.getInstance().storageWnd.visible && UIManager.getInstance().storageWnd.isbatchSave) {
				//批量存取			
				if (this.dataId == -1)
					return;

				var i:int=MyInfoManager.getInstance().getStoreEmptyGridIndex();
				if (i == -1)
					return;

				Cmd_Bag.cm_bagMoveTo(this.dataId, 2, i);
				return;
			}

		}

		public function set enableClick(v:Boolean):void {

			if (!v) {
				this.filters=[FilterUtil.enablefilter];
			} else {
				this.filters=[];
			}

//			enableMouseUpEvent=v;
			this.mouseChildren=v;
			this.mouseEnabled=v;
//			this.isLock=!v;
			this.canMove=v;
		}

		public function onMenuClick(index:int):void {

			switch (index) {
				case 1: //使用
					if (data != null) {
						if (this.cdMc && !this.cdMc.isOver())
							NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(4006));
						else
//							Cmd_Bag.cm_bagUse(int(this.data.pos));
							if (this.cdMc.isOver())
								this.onUse();
					}
					break;
				case 2: //移除
					UIManager.getInstance().backLotUseWnd.showPanel(this.dataId);
					break;
				case 3: //移动
//					this.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
					this.moveFromMenu();
					break;
				case 4: //拆分
					UIManager.getInstance().backPackSplitWnd.showPanel(data);
					break;
				case 5: //展示
					UIManager.getInstance().chatWnd.generateItemLink(this.data.info.name, this.data.tips);
					break;
				case 6: //丢弃
					UIManager.getInstance().backPackDropWnd.showPanel(this);
					break;
			}

		}

		//鼠标离开
		override public function mouseOutHandler():void {
			super.mouseOutHandler();

			TimerManager.getInstance().removeBykey("openBagkey");
		}

		public function set numLable(i:int):void {
			this.numLbl.text=i + "";
		}

		public function get numLable():int {
			return int(this.numLbl.text);
		}

		override public function get data():* {
			if (this.dataId == -1)
				return null;

			return MyInfoManager.getInstance().bagItems[this.dataId];
		}

		override public function dropHandler():void {
			if (this.data == null || this.data.info == null || !this.enableMouseUpEvent)
				return;

			this.enable=false;

			UIManager.getInstance().backPackDropWnd.showPanel(this);
		}

		private function updateTopIconState():void {

			var binfo:Baginfo=this.data as Baginfo;
			if (this.dataId == -1 || binfo.info.classid != 1 || this.disableBmp.visible)
				return;

			var st:int=-1;
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

		override public function switchHandler(fromItem:GridBase):void {

//			UIManager.getInstance().backpackWnd.cancelFastBuy();

			// 寄售拖拽处理
			if (ItemEnum.TYPE_GRID_AUTIONSALE == fromItem.gridType) {
				var autionGrid:AutionSaleItemGrid=fromItem as AutionSaleItemGrid;
				fromItem=autionGrid.linkGrid;
				fromItem.enable=true;
				UIManager.getInstance().autionWnd.clearSale();
			}
			// 抽奖仓库
			if (ItemEnum.TYPE_GRID_LUCKDRAW == fromItem.gridType) {
				var luckGrid:LuckPackGrid=fromItem as LuckPackGrid;
				Cmd_LDW.cm_LDW_T(luckGrid.pos, initId);
			}

			if (this.gridType == fromItem.gridType) {

				var g:GridBase=fromItem;
				var info1:Baginfo=g.data;

				if (info1 == null || info1.info == null || this.initId == info1.pos)
					return;

				ToolTipManager.getInstance().hide();
				fromItem.enable=true;

				Cmd_Bag.cm_bagMove(info1.pos, this.initId)
			} else if (fromItem.gridType == ItemEnum.TYPE_GRID_SHOP) { //商店拖拽过来的  直接购买
				UIManager.getInstance().shopWnd.gridDoubleClick((fromItem as GridShop).id, GridShop(fromItem).itemNum);
			} else {

				//如果是是从仓库来的，
				if (fromItem.gridType == ItemEnum.TYPE_GRID_STORAGE) {
					if (fromItem.dataId == -1)
						return;

					var i:int=0;
					if (UIManager.getInstance().backpackWnd.getTabberIndex() == 0) {
						i=this.initId;
					} else {
						i=MyInfoManager.getInstance().getBagEmptyGridIndex();
						if (i == -1) {
							NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(1610));
							return;
						}
					}

					Cmd_Store.cm_storeMoveTo(fromItem.dataId, 1, i);
					return;
				}

				//翅膀
				if (fromItem.gridType == ItemEnum.TYPE_GRID_WING) {
					Cmd_Wig.cm_WigAddEquipToSlot(this.initId, fromItem.initId + 1);
					return;
				}

				if (fromItem.gridType == ItemEnum.TYPE_GRID_EQUIP) {

					if (fromItem.dataId == -1)
						return;

					Cmd_Role.cm_offEquip(fromItem.dataId);
				}

				if (fromItem.gridType == ItemEnum.TYPE_GRID_GEM) {

					if (fromItem.dataId == -1 || GemGrid(fromItem).selectIndex == -1)
						return;

					Cmd_Gem.cmGemQuit(GemGrid(fromItem).selectIndex, fromItem.dataId);
				}
			}

			if (menuState == 3) {
				menuState=-1;
				return;
			}
		}


		/**
		 *
		 * @param s
		 *
		 */
		public function startCD(s:int=0):void {
			var info:Baginfo=this.data;
			if (info == null || info.info == null || info.info.classid != ItemEnum.ITEM_TYPE_YAOSHUI || s == 0)
				return;

			this.cdMc.visible=true;
			var ctime:int=int(info.info.cooltime) * 1000;

			this.playCD(ctime, ctime - s);
		}

		public function getCDTime():int {

			if (this.cdMc.visible && this.cdMc.surplusTime() >= 0)
				return this.cdMc.surplusTime();

			return 0;
		}

		/**
		 * 清除cd数字
		 *
		 */
		public function clearCDData():void {
			if (this.cdMc != null && this.cdMc.visible)
				this.cdMc.isShowTxtCD=false;
		}

		override public function mouseUpHandler($x:Number, $y:Number):void {

			if (!this.enableMouseUpEvent || this is StorageGrid)
				return;

			if (menuState == 3) {
				var g:GridBase=DragManager.getInstance().grid;
				if (g == null || g.data == null || g.data.info == null)
					return;

				Cmd_Bag.cm_bagMove(g.data.pos, this.initId);
				return;
			}

			//是否开启格子
			if (this.initId >= UIManager.getInstance().backpackWnd.itemCount) {
				//Cmd_Bag.cm_bagOpenGrid(this.initId+1);
				UIManager.getInstance().backpackWnd.openGrid=true;
				Cmd_Bag.cm_bagOpenGrid(this.initId + 1 - UIManager.getInstance().backpackWnd.itemCount);
				return;
			}


			if (KeysManager.getInstance().isDown(Keyboard.SHIFT)) {

				if (this.dataId == -1)
					return;

				UIManager.getInstance().chatWnd.generateItemLink(this.data.info.name, this.data.tips);
				return;
			}

			if (data == null || data.info == null || !UIManager.getInstance().backpackWnd.visible)
				return;

			var menuArr:Vector.<MenuInfo>=new Vector.<MenuInfo>;

			if (ItemUtil.itemFilter.indexOf(this.data.info.id) == -1)
				menuArr.push(new MenuInfo("使用", 1));
			else if (this.data.info.classid == ItemEnum.ITEM_TYPE_GEM)
				menuArr.push(new MenuInfo("装备", 1));

			if (data.info is TItemInfo && data.info.lotuse == "1")
				menuArr.push(new MenuInfo("批量", 2));

			menuArr.push(new MenuInfo("移动", 3));

			if (data.info is TItemInfo && data.info.maxgroup > "1" && data.num > 1)
				menuArr.push(new MenuInfo("拆分", 4));

			menuArr.push(new MenuInfo("展示", 5));

			//if (data.boBind < 1)
			menuArr.push(new MenuInfo("丢弃", 6));

			MenuManager.getInstance().show(menuArr, this, new Point($x - 30, $y));
			ToolTipManager.getInstance().hide();
		}

		override public function set enable(value:Boolean):void {

			super.enable=value;
			this.mouseChildren=value;
			this.mouseEnabled=value;

			if (!value) {
				this.filters=[FilterUtil.enablefilter];
			} else {
				this.filters=[];
			}

//			this.canMove=value;
		}

		override public function mouseMoveHandler($x:Number, $y:Number):void {

			if (!enableMouseUpEvent)
				return;

			super.mouseMoveHandler($x, $y);

			if (this.isEmpty)
				return;

			//ItemTip.getInstance().updataPs($x, $y);
		}

		public function selectstate(v:Boolean):void {
			this.selectBmp.visible=v;
		}

		override public function doubleClickHandler():void {

			if (!this.enableMouseUpEvent)
				return;

			if (this.dataId == -1 || this.isEmpty || UIManager.getInstance().backpackWnd.fastState)
				return;

			super.doubleClickHandler();

			if ((this.cdMc.isOver() && ItemUtil.itemFilter.indexOf(this.data.info.id) == -1) || (UIManager.getInstance().isCreate(WindowEnum.STOREGE) && UIManager.getInstance().storageWnd.visible))
				this.openUse();
		}

		private function onUse():void {
			if (this.dataId == -1 || this.isEmpty)
				return;

			var binfo:Baginfo;

			//翅膀
//			if (UIManager.getInstance().roleWnd.visible && UIManager.getInstance().roleWnd.getTabIndex() == 3 && int(this.data.info.classid) == 1 && int(this.data.info.classid) == ItemEnum.TYPE_EQUIP_CHIBAN) {
			if (int(this.data.info.classid) == 1 && int(this.data.info.subclassid) == ItemEnum.TYPE_EQUIP_CHIBAN) {

				binfo=this.data as Baginfo;

				var i:int=MyInfoManager.getInstance().getWingSlotIndex();
				if (i == -1)
					return;

				Cmd_Wig.cm_WigAddEquipToSlot(this.initId, i, 2);
//			} else if (UIManager.getInstance().isCreate(WindowEnum.AUTION)) {
//				UIManager.getInstance().autionWnd.switchHandler(this);
			} else {

				if (this.data.info.classid == ItemEnum.ITEM_TYPE_EQUIP) {

					if (this.data.info.subclassid < 13) {

						var olist:Array=ItemEnum.ItemToRolePos[this.data.info.subclassid];

						var st:Boolean=false;
						var roleIndex:int=-1;
						var einfo:EquipInfo=MyInfoManager.getInstance().equips[olist[0]];

						if (einfo != null) {

							if (this.data.tips.zdl > einfo.tips.zdl) {
								roleIndex=olist[0];
							}

							if (olist.length == 2) {

								var einfo1:EquipInfo=MyInfoManager.getInstance().equips[olist[1]];
								if (einfo1 != null) {

									if (einfo.info.name == this.data.info.name && einfo1.info.name != this.data.info.name)
										roleIndex=olist[1];
									else if (einfo1.info.name == this.data.info.name && einfo.info.name != this.data.info.name)
										roleIndex=olist[0];
//									else if (this.data.tips.zdl > einfo1.tips.zdl) 
//										roleIndex=olist[1];
									else {

										if (einfo.tips.zdl > einfo1.tips.zdl)
											roleIndex=olist[1];
										else
											roleIndex=olist[0];

									}
								} else {

									roleIndex=olist[1];

								}

							} else {
								roleIndex=olist[0];
							}

						} else {
							roleIndex=olist[0];

						}

						//					if (roleIndex != -1)
						Cmd_Bag.cm_bagMoveTo(this.dataId, 3, roleIndex);
					} else {
						Cmd_Bag.cm_bagMoveTo(this.dataId, 40, this.data.info.subclassid - 13);
					}
				} else if (this.data.info.classid == ItemEnum.ITEM_TYPE_DAOJU) {

					if (this.data.info.subclassid == 5) {
						if (ConfigEnum.EquipIntensifyOpenLv > Core.me.info.level) {
							NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(9938));
							return;
						}

						UILayoutManager.getInstance().show_II(WindowEnum.EQUIP);

					} else if (this.data.info.subclassid == 6 || this.data.info.subclassid == 7 || this.data.info.subclassid == 8) {

						switch (int(this.data.info.subclassid)) {
							case 6:
								if (ConfigEnum.MountOpenLv > Core.me.info.level) {
									NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(9938));
									return;
								}

								if (!UIManager.getInstance().roleWnd.visible)
									UILayoutManager.getInstance().show_II(WindowEnum.ROLE);

								TweenMax.delayedCall(.6, function():void {
									UIManager.getInstance().roleWnd.setTabIndex(1);

									if (!UIManager.getInstance().roleWnd.mountIsTopLv())
										UILayoutManager.getInstance().show_II(WindowEnum.ROLE, WindowEnum.MOUTLVUP, -20);

								});

								break;
							case 7:
								if (!UIManager.getInstance().roleWnd.openWing()) {
									NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(9938));
									return;
								}

								if (!UIManager.getInstance().roleWnd.visible)
									UILayoutManager.getInstance().show_II(WindowEnum.ROLE);

								TweenMax.delayedCall(.6, function():void {
									UIManager.getInstance().roleWnd.setTabIndex(6);

									if (!UIManager.getInstance().roleWnd.wingIsTopLv())
										UILayoutManager.getInstance().show_II(WindowEnum.ROLE, WindowEnum.WINGLVUP, -20);

								});
								break;
							case 8:
								if (ConfigEnum.ElementOpenLv > Core.me.info.level) {
									NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(9938));
									return;
								}

								UILayoutManager.getInstance().show_II(WindowEnum.ROLE);
								TweenMax.delayedCall(.6, function():void {
									UIManager.getInstance().roleWnd.setTabIndex(3);
								});
								break;
						}
						
					} else if (this.data.info.subclassid == 26) {
						if (!UIManager.getInstance().roleWnd.openWing()) {
							NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(9938));
							return;
						}
						
						if (UIManager.getInstance().roleWnd.wingLv() < ConfigEnum.wing17) {
							NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(1220));
							return;
						}
						
						if (!UIManager.getInstance().roleWnd.visible)
							UILayoutManager.getInstance().show_II(WindowEnum.ROLE);
						
						TweenMax.delayedCall(.6, function():void {
							UIManager.getInstance().roleWnd.setTabIndex(6);
							UILayoutManager.getInstance().show_II(WindowEnum.ROLE, WindowEnum.WING_FLY, -20);
							
						});
					} else if (this.data.info.subclassid == 14) {
						UILayoutManager.getInstance().show_II(WindowEnum.SKILL);
					} else if (this.data.info.id == 30401) {
						UILayoutManager.getInstance().show_II(WindowEnum.MYSTORE);
					} else if (this.data.info.id == 31508 || this.data.info.id == 31509) {
						if (ConfigEnum.EquipReclassOpenLv > Core.me.info.level) {
							NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(9938));
							return;
						}

						UILayoutManager.getInstance().show_II(WindowEnum.EQUIP);
						TweenMax.delayedCall(.3, UIManager.getInstance().equipWnd.changeTable, [3]);
					} else if (this.data.info.id == 30403) {
						UIOpenBufferManager.getInstance().open(WindowEnum.LUCKDRAW);
					} else if (this.data.info.pay > 0) {
						PopupManager.showConfirm(StringUtil.substitute(TableManager.getInstance().getSystemNotice(9975).content, [this.data.info.pay, this.data.info.name]), function():void {
							Cmd_Bag.cm_bagUse(dataId);
						}, null, false, "backUsePay")

					} else if (int(this.data.info.subclassid) == 21) {
						if (this.msgBox == null) {
							this.msgBox=new MessageInputWnd();
							LayerManager.getInstance().windowLayer.addChild(this.msgBox);
						}

						this.msgBox.showPanel(this.dataId)
					} else {
						Cmd_Bag.cm_bagUse(this.dataId);
					}

				} else if (this.data.info.classid == ItemEnum.ITEM_TYPE_GEM) {

					if (ConfigEnum.Gem1 > Core.me.info.level) {
						NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(9938));
						return;
					}

					if (!UIManager.getInstance().roleWnd.visible)
						UILayoutManager.getInstance().show_II(WindowEnum.ROLE);
					else
						UIManager.getInstance().roleWnd.setGemSlot(dataId);

					TweenMax.delayedCall(.6, function():void {

						UIManager.getInstance().roleWnd.setTabIndex(2);


						UILayoutManager.getInstance().show_II(WindowEnum.ROLE, WindowEnum.GEM_LV, -20);
					});


				} else {
					Cmd_Bag.cm_bagUse(this.dataId);
				}

			}

		}

		/**
		 *打开使用功能
		 */
		private function openUse():void {
			if (this.dataId == -1 || this.isEmpty)
				return;

			var binfo:Baginfo;

			//翅膀
//			if (UIManager.getInstance().roleWnd.visible && UIManager.getInstance().roleWnd.getTabIndex() == 3 && int(this.data.info.classid) == 1 && int(this.data.info.classid) == ItemEnum.TYPE_EQUIP_CHIBAN) {
			if (int(this.data.info.classid) == 1 && int(this.data.info.subclassid) == ItemEnum.TYPE_EQUIP_CHIBAN) {
				binfo=this.data as Baginfo;

				var i:int=MyInfoManager.getInstance().getWingSlotIndex();
				if (i == -1)
					return;

				Cmd_Wig.cm_WigAddEquipToSlot(this.initId, i, 2);
			} else if (UIManager.getInstance().isCreate(WindowEnum.STOREGE) && UIManager.getInstance().storageWnd.visible) {
				Cmd_Bag.cm_bagMoveTo(this.dataId, 2, MyInfoManager.getInstance().getStoreEmptyGridIndex());
			} else if (UIManager.getInstance().isCreate(WindowEnum.SHOP) && UIManager.getInstance().shopWnd.visible) {
				Cmd_Bag.cm_bagSell(this.dataId);
			} else if (UIManager.getInstance().isCreate(WindowEnum.AUTION) && UIManager.getInstance().autionWnd.visible) {
				UIManager.getInstance().autionWnd.switchHandler(this);
			} else {

				if (this.data.info.classid == ItemEnum.ITEM_TYPE_EQUIP) {

					if (this.data.info.subclassid < 13) {

						var olist:Array=ItemEnum.ItemToRolePos[this.data.info.subclassid];

						var st:Boolean=false;
						var roleIndex:int=-1;
						var einfo:EquipInfo=MyInfoManager.getInstance().equips[olist[0]];

						if (einfo != null) {

							if (this.data.tips.zdl > einfo.tips.zdl) {
								roleIndex=olist[0];
							}

							if (olist.length == 2) {

								var einfo1:EquipInfo=MyInfoManager.getInstance().equips[olist[1]];
								if (einfo1 != null) {

									if (einfo.info.name == this.data.info.name && einfo1.info.name != this.data.info.name)
										roleIndex=olist[1];
									else if (einfo1.info.name == this.data.info.name && einfo.info.name != this.data.info.name)
										roleIndex=olist[0];
//									else if (this.data.tips.zdl > einfo1.tips.zdl) 
//										roleIndex=olist[1];
									else {

										if (einfo.tips.zdl > einfo1.tips.zdl)
											roleIndex=olist[1];
										else
											roleIndex=olist[0];

									}
								} else {
									roleIndex=olist[1];
								}

							} else {
								roleIndex=olist[0];
							}

						} else {
							roleIndex=olist[0];
						}

//					if (roleIndex != -1)
						Cmd_Bag.cm_bagMoveTo(this.dataId, 3, roleIndex);
					} else {
						Cmd_Bag.cm_bagMoveTo(this.dataId, 40, this.data.info.subclassid - 13);
					}
				} else if (this.data.info.classid == ItemEnum.ITEM_TYPE_DAOJU) {

					if (this.data.info.subclassid == 5) {
						if (ConfigEnum.EquipIntensifyOpenLv > Core.me.info.level) {
							NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(9938));
							return;
						}

						UILayoutManager.getInstance().show_II(WindowEnum.EQUIP);

					} else if (this.data.info.subclassid == 6 || this.data.info.subclassid == 7 || this.data.info.subclassid == 8) {

						switch (int(this.data.info.subclassid)) {
							case 6:
								if (ConfigEnum.MountOpenLv > Core.me.info.level) {
									NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(9938));
									return;
								}

								if (!UIManager.getInstance().roleWnd.visible)
									UILayoutManager.getInstance().show_II(WindowEnum.ROLE);

								TweenMax.delayedCall(.6, function():void {
									UIManager.getInstance().roleWnd.setTabIndex(1);

									if (!UIManager.getInstance().roleWnd.mountIsTopLv())
										UILayoutManager.getInstance().show_II(WindowEnum.ROLE, WindowEnum.MOUTLVUP, -20);

								});
								break;
							case 7:
								if (!UIManager.getInstance().roleWnd.openWing()) {
									NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(9938));
									return;
								}

								if (!UIManager.getInstance().roleWnd.visible)
									UILayoutManager.getInstance().show_II(WindowEnum.ROLE);

								TweenMax.delayedCall(.6, function():void {
									UIManager.getInstance().roleWnd.setTabIndex(6);
									if (!UIManager.getInstance().roleWnd.wingIsTopLv())
										UILayoutManager.getInstance().show_II(WindowEnum.ROLE, WindowEnum.WINGLVUP, -20);

								});

								break;
							case 8:
								if (ConfigEnum.ElementOpenLv > Core.me.info.level) {
									NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(9938));
									return;
								}

								UILayoutManager.getInstance().show_II(WindowEnum.ROLE);

								TweenMax.delayedCall(.6, function():void {
									UIManager.getInstance().roleWnd.setTabIndex(3);
								});

								break;
						}

					} else if (this.data.info.subclassid == 26) {
						if (!UIManager.getInstance().roleWnd.openWing()) {
							NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(9938));
							return;
						}

						if (UIManager.getInstance().roleWnd.wingLv() < ConfigEnum.wing17) {
							NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(1220));
							return;
						}

						if (!UIManager.getInstance().roleWnd.visible)
							UILayoutManager.getInstance().show_II(WindowEnum.ROLE);

						TweenMax.delayedCall(.6, function():void {
							UIManager.getInstance().roleWnd.setTabIndex(6);

							UILayoutManager.getInstance().show_II(WindowEnum.ROLE, WindowEnum.WING_FLY, -20);

						});
					} else if (this.data.info.subclassid == 14) {
						UILayoutManager.getInstance().show_II(WindowEnum.SKILL);
					} else if (this.data.info.id == 30401) {
						UILayoutManager.getInstance().show_II(WindowEnum.MYSTORE);
					} else if (this.data.info.id == 31508 || this.data.info.id == 31509) {
						if (ConfigEnum.EquipReclassOpenLv > Core.me.info.level) {
							NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(9938));
							return;
						}

						UILayoutManager.getInstance().show_II(WindowEnum.EQUIP);
						TweenMax.delayedCall(.3, UIManager.getInstance().equipWnd.changeTable, [3]);
					} else if (this.data.info.pay > 0) {
						PopupManager.showConfirm(StringUtil.substitute(TableManager.getInstance().getSystemNotice(9975).content, [this.data.info.pay, this.data.info.name]), function():void {
							Cmd_Bag.cm_bagUse(dataId);
						}, null, false, "backUsePay")
					} else if (int(this.data.info.subclassid) == 21) {
						if (this.msgBox == null) {
							this.msgBox=new MessageInputWnd();
							LayerManager.getInstance().windowLayer.addChild(this.msgBox);
						}

						this.msgBox.showPanel(this.dataId)
					} else {
						Cmd_Bag.cm_bagUse(this.dataId);
					}

				} else if (this.data.info.classid == ItemEnum.ITEM_TYPE_GEM) {

					if (ConfigEnum.Gem1 > Core.me.info.level) {
						NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(9938));
						return;
					}

					if (!UIManager.getInstance().roleWnd.visible)
						UILayoutManager.getInstance().show_II(WindowEnum.ROLE);
					else
						UIManager.getInstance().roleWnd.setGemSlot(dataId);

					TweenMax.delayedCall(.6, function():void {
						UIManager.getInstance().roleWnd.setTabIndex(2);
						UILayoutManager.getInstance().show_II(WindowEnum.ROLE, WindowEnum.GEM_LV, -20);
					});

				} else {
					Cmd_Bag.cm_bagUse(this.dataId);
				}
			}

		}

		/**
		 * open
		 * @param v
		 *
		 */
		public function setShow(v:Boolean):void {
			this.clearCDData();
			this.startName.visible=v;
			this.startName.x=(40 - this.startName.width) / 2;
			this.startName.y=(40 - this.startName.height) / 2;
		}

		public function set reMask(v:Boolean):void {
//			this.shap.visible=v;
			this.setDisable(v);
		}

	}
}

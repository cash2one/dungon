package com.leyou.ui.tools.child {

	import com.ace.enum.FontEnum;
	import com.ace.enum.ItemEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TSkillInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.SoundManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.utils.DebugUtil;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.data.playerSkill.SkillInfo;
	import com.leyou.data.playerSkill.TipSkillInfo;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.net.cmd.Cmd_Link;

	import flash.geom.Point;

	public class ShortcutsGrid extends GridBase {

		private var numLbl:Label;
		private var shortcutKeyLbl:Label;

		private var num:int=0;

		public var cloneGridType:String; //克隆的格子类型：技能、背包

		/**
		 *是否是自动释放的技能
		 */
		public var autoMagic:Boolean=false;

		private var autoEffect:SwfLoader;

		/**
		 *药水类型
		 */
		public var autoType:int=2;

		public var autoItem:Boolean=false;

		public var autoid:int=0;

		private var isDown:Boolean=false;
		private var isFirstMove:Boolean=true;

		private var cdLbl:Label;

		public function ShortcutsGrid(id:int=-1) {
			super(id, true);
		}

		override protected function init(hasCd:Boolean=false):void {
			super.init(hasCd);

			this.isLock=false;
			this.dataId=-1;
			this.gridType=ItemEnum.TYPE_GRID_SHORTCUT;

			this.numLbl=new Label("", FontEnum.getTextFormat("White10right"));
			this.numLbl.x=30;
			this.numLbl.y=23;
			this.addChild(this.numLbl);

			this.shortcutKeyLbl=new Label(this.gridId.toString(), FontEnum.getTextFormat("GreenBold12"));
			shortcutKeyLbl.x=2;
			shortcutKeyLbl.y=2;
			this.addChild(shortcutKeyLbl);

			this.shortcutKeyLbl.cacheAsBitmap=true;

//			this.bgBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/bg.png");
			this.bgBmp.bitmapData=LibManager.getInstance().getImg("ui/mainUI/icon_skill.jpg");
			this.iconBmp.bitmapData=LibManager.getInstance().getImg("ui/backpack/lock.png");

//			this.bgBmp.setWH(35, 35);
			this.iconBmp.setWH(36, 36);
//			this.bgBmp.alpha=0;

			this.cdMc.y=2;
			this.cdMc.x=2;
			this.cdMc.updateUI(36, 36);

			this.autoEffect=new SwfLoader();
			this.autoEffect.update(99969);
//			this.autoEffect.x=-3;
//			this.autoEffect.y=-2;

			this.cdLbl=new Label();
			this.cdLbl.width=37;
			this.cdLbl.x=0;
			this.cdLbl.y=37 - this.cdLbl.height >> 1;
			this.addChild(this.cdLbl);

			DebugUtil.cacheLabel(this);
		}

		public function set BgBmpalpha(v:Number):void {
			this.bgBmp.alpha=v;
		}

		override public function updataInfo(info:Object):void {
			this.reset();
			this.unlocking();

			super.updataInfo(info);
		}

		public function updateYaoshui(info:TItemInfo, item:Boolean=false):void {
			this.playCD(0, 0);

			this.setAutoMagic(false);
			this.autoItem=item;
			this.autoid=int(info.id)

			this.cloneGridType=ItemEnum.TYPE_GRID_BACKPACK;
			this.updataInfo(null);
			this.autoType=int(info.subclassid);
			this.shortcutKeyLbl.text="";
			this.dataId=-1;
			this.iconBmp.updateBmp("ico/items/" + info.icon + ".png");

			var _num:int=MyInfoManager.getInstance().getBagItemNumByName(info.name);
			this.numLbl.text=_num + ""; //显示总药品数量
			if (_num == 0)
				this.numLbl.textColor=0xff0000;
			else
				this.numLbl.textColor=0xffffff;

			this.iconBmp.x=((40 - 28) >> 1) - 4;
			this.iconBmp.y=((40 - 30) >> 1) - 2;

			this.selectBmp.updateBmp("ui/backpack/select.png");
			this.selectBmp.setWH(40, 40);

			this.selectBmp.x=-1;
			this.selectBmp.y=-1;
		}

		public function updateItem(info:Object, dataid:int=-1):void {

			this.setAutoMagic(false);

			if (info is Baginfo) {

				this.autoType=int(info.info.subclassid);
				this.cloneGridType=ItemEnum.TYPE_GRID_BACKPACK;
				this.updataInfo(null);
				this.dataId=info.pos;
				this.iconBmp.updateBmp("ico/items/" + info.info.icon + ".png");
				this.numLbl.text=MyInfoManager.getInstance().getBagItemNumByName(Baginfo(info).info.name) + ""; //显示总药品数量
				this.iconBmp.x=((40 - 28) >> 1) - 4;
				this.iconBmp.y=((40 - 30) >> 1) - 2;

			} else if (info is TSkillInfo) {

				this.cloneGridType=ItemEnum.TYPE_GRID_SKILL;
				this.updataInfo(null);
				this.dataId=dataid;
				this.numLbl.text="";
				this.iconBmp.updateBmp("ico/skills/" + info.icon + ".png");

				this.iconBmp.x=((40 - 36) >> 1);
				this.iconBmp.y=((40 - 36) >> 1);
			}

			this.numLbl.textColor=0xffffff;

			this.filters=[];
			this.autoItem=false;
			this.selectBmp.bitmapData=null;
			this.autoid=0;
		}

		public function get icon():Image {
			return this.iconBmp;
		}

		public function setSelectBmpEnable(v:Boolean):void {
			this.selectBmp.bitmapData=null;
		}

		override public function set gridId(value:int):void {
			super.gridId=value;

//			if (value < 4) {
//				this.shortcutKeyLbl.text=value + 1 + "";
//			} else {
//
//				if (value == 4)
//					this.shortcutKeyLbl.text="Q";
//
//				if (value == 5)
//					this.shortcutKeyLbl.text="W";
//
//				if (value == 6)
//					this.shortcutKeyLbl.text="E";
//
//				if (value == 7)
//					this.shortcutKeyLbl.text="R";
//
//				if (value == 8)
//					this.shortcutKeyLbl.text="T";
//
//			}

			this.shortcutKeyLbl.text="";
		}

		override public function switchHandler(fromItem:GridBase):void {

			if (fromItem.gridType == ItemEnum.TYPE_GRID_BACKPACK) {
				fromItem.enable=true;
				return;
			}

			if (ShortcutsGrid(fromItem).isDown) {
				SoundManager.getInstance().play(33);
				ShortcutsGrid(fromItem).isDown=false;
			}


			UIManager.getInstance().toolsWnd.hidGridList();

			var skidata:SkillInfo;

			if (this.cloneGridType == ItemEnum.TYPE_GRID_BACKPACK && this.autoid != 0 && !this.autoItem)
				return;

			//如果是同类
			if (fromItem.gridType == ItemEnum.TYPE_GRID_SHORTCUT) {

				var obj:Object;

				this.numLbl.text="";

				var ctime:int=0;
				var ctime1:int=0;
				var ctime2:int=0;
				var binfo:Baginfo;

				var _autoid:int=0;

				if ((fromItem as ShortcutsGrid).cloneGridType == ItemEnum.TYPE_GRID_SKILL) {

					Cmd_Link.cm_linkSet(this.initId, 1, fromItem.dataId);

					if (!this.cdOver())
						ctime1=this.getCDTime();

					if (!ShortcutsGrid(fromItem).cdOver()) {
						ctime=int(UIManager.getInstance().skillWnd.getOpenSkill(fromItem.dataId).CD)
						this.playCD(ctime, ctime - ShortcutsGrid(fromItem).getCDTime());
					}

					if (this.dataId != -1) {

						if (this.cloneGridType == ItemEnum.TYPE_GRID_BACKPACK) {

							binfo=MyInfoManager.getInstance().bagItems[this.dataId];
							ctime=int(binfo.info.cooltime) * 1000;

							Cmd_Link.cm_linkSet(fromItem.initId, 2, (binfo.aid % 2 == 0 ? binfo.aid : binfo.aid - 1));

						} else if (this.cloneGridType == ItemEnum.TYPE_GRID_SKILL) {

							ctime=int(UIManager.getInstance().skillWnd.getOpenSkill(this.dataId).CD)
							Cmd_Link.cm_linkSet(fromItem.initId, 1, this.dataId);

						}

						if (ctime1 > 0) {

							if (ShortcutsGrid(fromItem).cdOver()) {
								this.delGrid();
							}

							fromItem.playCD(ctime, ctime - ctime1);
						} else {
							ShortcutsGrid(fromItem).delGrid();
						}

					} else if (this.autoItem) {

						ShortcutsGrid(fromItem).delGrid();
						ShortcutsGrid(fromItem).updateYaoshui(TableManager.getInstance().getItemInfo(this.autoid), true);
						ShortcutsGrid(fromItem).setSelectBmpEnable(false);
//						this.delGrid();

					} else {

						ShortcutsGrid(fromItem).delGrid();
					}

				} else if ((fromItem as ShortcutsGrid).cloneGridType == ItemEnum.TYPE_GRID_BACKPACK) {

					if (ShortcutsGrid(fromItem).autoItem) {

						//如果单前格子是空,
					} else {

						binfo=MyInfoManager.getInstance().bagItems[fromItem.dataId];
						Cmd_Link.cm_linkSet(this.initId, 2, (binfo.aid % 2 == 0 ? binfo.aid : binfo.aid - 1));

					}

					if (!this.cdOver())
						ctime1=this.getCDTime();

					if (!ShortcutsGrid(fromItem).cdOver()) {
						binfo=MyInfoManager.getInstance().bagItems[fromItem.dataId];
						ctime=int(binfo.info.cooltime) * 1000;

						this.playCD(ctime, ctime - ShortcutsGrid(fromItem).getCDTime());
					}


					if (this.dataId != -1) {

						if (this.cloneGridType == ItemEnum.TYPE_GRID_BACKPACK) {
							binfo=MyInfoManager.getInstance().bagItems[this.dataId];
							ctime=int(binfo.info.cooltime) * 1000;

							Cmd_Link.cm_linkSet(fromItem.initId, 2, (binfo.aid % 2 == 0 ? binfo.aid : binfo.aid - 1));
						} else if (this.cloneGridType == ItemEnum.TYPE_GRID_SKILL) {
							ctime=int(UIManager.getInstance().skillWnd.getOpenSkill(this.dataId).CD)
							Cmd_Link.cm_linkSet(fromItem.initId, 1, this.dataId);
						}

						if (ctime1 > 0) {

							if (ShortcutsGrid(fromItem).cdOver()) {
								this.delGrid();
							}

							fromItem.playCD(ctime, ctime - ctime1);

						} else {

							if (ShortcutsGrid(fromItem).autoItem) {
								this.updateYaoshui(TableManager.getInstance().getItemInfo(ShortcutsGrid(fromItem).autoid), true);
//								this.filters=[FilterUtil.enablefilter]
								this.setSelectBmpEnable(false);
							}

							ShortcutsGrid(fromItem).delGrid();
						}

					} else if (ShortcutsGrid(fromItem).autoItem && !this.autoItem) {

						this.updateYaoshui(TableManager.getInstance().getItemInfo(ShortcutsGrid(fromItem).autoid), true);
//						this.filters=[FilterUtil.enablefilter]
						this.setSelectBmpEnable(false);
						ShortcutsGrid(fromItem).delGrid();

					} else if (this.autoItem) {

						if (ShortcutsGrid(fromItem).autoItem) {
							_autoid=this.autoid;

							this.updateYaoshui(TableManager.getInstance().getItemInfo(ShortcutsGrid(fromItem).autoid), true);
//							this.filters=[FilterUtil.enablefilter]
							this.setSelectBmpEnable(false);

							ShortcutsGrid(fromItem).updateYaoshui(TableManager.getInstance().getItemInfo(_autoid), true);
						} else
							ShortcutsGrid(fromItem).updateYaoshui(TableManager.getInstance().getItemInfo(this.autoid), true);

//						ShortcutsGrid(fromItem).filters=[FilterUtil.enablefilter]
						ShortcutsGrid(fromItem).setSelectBmpEnable(false);

					} else {
						ShortcutsGrid(fromItem).delGrid();
					}

				}
			}

//			//如果是主动技能
//			if (fromItem.gridType == ItemEnum.TYPE_GRID_SKILL) {
//				var idx:int=UIManager.getInstance().skillWnd.currentIdx;
//				skidata=MyInfoManager.getInstance().skilldata;
//				Cmd_Link.cm_linkSet(this.gridId, 1, skidata.skillItems[idx][1]);
//			}

//			如果是药品
//			if (fromItem.gridType == ItemEnum.TYPE_GRID_BACKPACK) {
//				
//
//				if (fromItem.data == null || fromItem.data.info == null || fromItem.data.info is TEquipInfo || fromItem.data.info.classid != ItemEnum.ITEM_TYPE_YAOSHUI)
//					return;
//
//				if (fromItem.data.info.subclassid != ItemEnum.TYPE_YAOSHUI_MOMENT_BLUE && fromItem.data.info.subclassid != ItemEnum.TYPE_YAOSHUI_MOMENT_RED)
//					return;
//
//				this.cloneGridType=ItemEnum.TYPE_GRID_BACKPACK;
//				this.updataInfo(null);
//				this.dataId=fromItem.dataId;
//				this.iconBmp.bitmapData=fromItem.itemBmp;
//
//				Cmd_Link.cm_linkSet(this.gridId, 2, fromItem.data.info.id);
//
//			}

			this.iconBmp.x=(this.bgBmp.bitmapData.width - this.iconBmp.width) >> 1;
			this.iconBmp.y=(this.bgBmp.bitmapData.height - this.iconBmp.height) >> 1;

		}

		public function updateskill(fromItem:GridBase):void {

			//如果是主动技能
			if (fromItem.gridType == ItemEnum.TYPE_GRID_SKILL) {

				this.cloneGridType=ItemEnum.TYPE_GRID_SKILL;
				this.updataInfo(null);
				this.dataId=fromItem.dataId;

				super.switchHandler(fromItem);

				var tinfo:TSkillInfo=TableManager.getInstance().getSkill(MyInfoManager.getInstance().skilldata.skillItems[fromItem.dataId][1])[0]

				this.iconBmp.updateBmp("ico/skills/" + tinfo.icon + ".png");
				this.numLbl.text="";

			}

			this.iconBmp.x=((40 - 28) >> 1) - 4;
			this.iconBmp.y=((40 - 30) >> 1) - 2;
		}

		public function set numLblText(str:String):void {
			this.numLbl.text=str;
			this.numLbl.textColor=0xffffff;
			num=int(str);
		}

		public function get ItemNum():int {
			return num;
		}

		public function cdOver():Boolean {
			return this.cdMc.isOver();
		}

		public function getCDTime():int {
			return this.cdMc.surplusTime();
		}

		override public function playCD($totalTime:int, $startTime:int=0):void {
			super.playCD($totalTime, $startTime);

//			if ($totalTime != $startTime && this.cloneGridType == ItemEnum.TYPE_GRID_BACKPACK)
//				trace("ggg");
		}

		public function delGrid():void {
			this.iconBmp.bitmapData=null;
			this.reset();
			this.unlocking();
			this.updataInfo(null);
			this.dataId=-1;
			this.isEmpty=true;
			this.numLblText="";
			this.autoid=0;
			this.autoType=-1;
			this.autoItem=false;
			this.setAutoMagic(false);

			this.cloneGridType=null;

			this.playCD(0, 0);
		}

		override public function dropHandler():void {
//			super.dropHandler();
		}

		public function setAutoMagic(v:Boolean):void {

			if (this.cloneGridType != ItemEnum.TYPE_GRID_SKILL)
				return;

			this.autoMagic=v;

			if (this.autoMagic) {

				if (this.autoEffect.parent == null)
					this.addChild(this.autoEffect);

			} else {

				if (this.autoEffect.parent == this)
					this.removeChild(this.autoEffect);

			}
		}

		public function clearCD():void {
			if (this.cdMc != null)
				this.cdMc.clearCD();
		}

		override public function mouseUpHandler($x:Number, $y:Number):void {
			super.mouseUpHandler($x, $y);

			if (this.cloneGridType == ItemEnum.TYPE_GRID_SKILL && this.dataId != -1) {
				this.autoMagic=!this.autoMagic;

				var sk:TSkillInfo=UIManager.getInstance().skillWnd.getOpenSkill(this.dataId);

				if (this.autoMagic) {

					if (sk.auto == 0) {
						NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(2118))
						this.autoMagic=!this.autoMagic;
						return;
					}

					this.addChild(this.autoEffect);
					NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(2113), [sk.name]);

					GuideManager.getInstance().removeGuide(68);
				} else {

					this.removeChild(this.autoEffect);
					NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(2114), [sk.name]);

				}

				UIManager.getInstance().toolsWnd.setAutoMagicList();
				UIManager.getInstance().toolsWnd.hidGridList();
			} else if (this.cloneGridType == ItemEnum.TYPE_GRID_BACKPACK && (this.parent != null && !(this.parent.parent is ToolsGridItemRender))) {
				UIManager.getInstance().toolsWnd.showSelectItemPanel(this.autoType, this.initId, this.parent.localToGlobal(new Point(this.x, this.y)))
			}


		}

		override public function mouseDownHandler($x:Number, $y:Number):void {
			super.mouseDownHandler($x, $y);
			this.isDown=true;

			SoundManager.getInstance().play(32);
		}


		override public function mouseOverHandler($x:Number, $y:Number):void {
			super.mouseOverHandler($x, $y);

			if (this.isEmpty || this.dataId == -1) {

				if (this.autoid > 0) {
					var tinfo2:TipsInfo=new TipsInfo();
					tinfo2.itemid=this.autoid;
					ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, tinfo2, new Point(this.stage.mouseX + 15, this.stage.mouseY + 15));
				}

				return;
			}


			if (this.cloneGridType == ItemEnum.TYPE_GRID_SKILL) {

				var tipInfo:TipSkillInfo=new TipSkillInfo();
				tipInfo.skillInfo=UIManager.getInstance().skillWnd.getOpenSkill(this.dataId)

				tipInfo.hasRune=false;
				tipInfo.level=int(tipInfo.skillInfo.autoLv);
				tipInfo.skillLv=UIManager.getInstance().skillWnd.getSkillArrByID(this.dataId)[2];

				var tarr:Array=TableManager.getInstance().getSkillArr(this.dataId);
				tipInfo.runde=tarr.indexOf(tipInfo.skillInfo);

				if (tipInfo.runde == 0)
					ToolTipManager.getInstance().show(TipEnum.TYPE_SKILL, tipInfo, new Point(this.stage.mouseX + 15, this.stage.mouseY + 15));
				else
					ToolTipManager.getInstance().showII([TipEnum.TYPE_SKILL, TipEnum.TYPE_RUNE], [tipInfo, tipInfo], PlayerEnum.DIR_S, new Point(0, 0), new Point(this.stage.mouseX + 15, this.stage.mouseY + 15));

			} else {

				var tinfo:TipsInfo=new TipsInfo();
				if (MyInfoManager.getInstance().bagItems[this.dataId] != null) {
					tinfo.itemid=MyInfoManager.getInstance().bagItems[this.dataId].aid;
				} else {
					return;
				}

				ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, tinfo, new Point(this.stage.mouseX + 15, this.stage.mouseY + 15));
			}

		}

	}
}

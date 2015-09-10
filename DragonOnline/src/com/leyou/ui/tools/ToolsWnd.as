package com.leyou.ui.tools {

	import com.ace.config.Core;
	import com.ace.enum.ItemEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.manager.SceneKeyManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.SettingManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TSkillInfo;
	import com.ace.loader.child.SwfLoader;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LayerManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.notice.NoticeManager;
	import com.ace.ui.setting.AssistWnd;
	import com.ace.utils.StringUtil;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.MoldEnum;
	import com.leyou.net.cmd.Cmd_Assist;
	import com.leyou.net.cmd.Cmd_Bag;
	import com.leyou.net.cmd.Cmd_Link;
	import com.leyou.net.cmd.Cmd_Wig;
	import com.leyou.ui.tools.child.ShortcutsGrid;
	import com.leyou.ui.tools.child.ToolsGridItemRender;
	import com.leyou.ui.tools.child.ToolsHpAndMpProgress;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.Keyboard;

	public class ToolsWnd extends AutoSprite {

		static private const ICO_GAP:Number=39;

		public var toolsKey:Object={};
		public var toolsPreUse:Array=[];
		private var shortCutDic:Object;

		public var playerBtn:ImgButton;
		public var backpackBtn:ImgButton;
		public var skillBtn:ImgButton;
		public var missionBtn:ImgButton;
		public var wenZBtn:ImgButton;
		public var duanZBtn:ImgButton;
		private var shiCBtn:ImgButton;
		private var shopBtn:ImgButton;

		private var friendBtn:ImgButton;
		public var teamBtn:ImgButton;
		public var guildBtn:ImgButton;
		public var daZBtn:ImgButton;
		public var mountBtn:ImgButton;
		private var guaJBtn:ImgButton;
		private var mercenaryBtn:ImgButton;
		private var framBtn:ImgButton;
		private var collectBtn:ImgButton;
		private var alchmyBtn:ImgButton;

		private var expImg:Image;
		private var hunImg:Image;
		private var quickImg:Image;
		private var hpSwf:SwfLoader;
		private var mpSwf:SwfLoader;

		private var expBg:Image;
		private var hunBg:Image;

		private var bbsBtn2:ImgButton;
		private var bbsBtn1:ImgButton;

		private var hpAndmp:ToolsHpAndMpProgress;

		public var autoMagicArr:Array=[];

		private var gridList:ToolsGridItemRender;

		private var firstOpen:Boolean=true;

		/**
		 * 单前使用药水,红0,蓝1
		 */
		private var currentYaoshui:Array=[];

		private var tweMax:TweenMax;

		public function ToolsWnd() {
			super(LibManager.getInstance().getXML("config/ui/ToolsWnd.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
//			this.cacheAsBitmap=true;
		}

		private function init():void {
			this.playerBtn=this.getUIbyID("playerBtn") as ImgButton;
			this.backpackBtn=this.getUIbyID("backpackBtn") as ImgButton;
			this.skillBtn=this.getUIbyID("skillBtn") as ImgButton;
			this.missionBtn=this.getUIbyID("missionBtn") as ImgButton;
			this.wenZBtn=this.getUIbyID("wenZBtn") as ImgButton;
			this.duanZBtn=this.getUIbyID("duanZBtn") as ImgButton;
			this.shiCBtn=this.getUIbyID("shiCBtn") as ImgButton;
			this.shopBtn=this.getUIbyID("shopBtn") as ImgButton;
			this.mercenaryBtn=this.getUIbyID("mercenaryBtn") as ImgButton;
			this.framBtn=this.getUIbyID("framBtn") as ImgButton;
			this.collectBtn=this.getUIbyID("collectBtn") as ImgButton;
			this.alchmyBtn=this.getUIbyID("alchmyBtn") as ImgButton;

			this.friendBtn=this.getUIbyID("friendBtn") as ImgButton;
			this.teamBtn=this.getUIbyID("teamBtn") as ImgButton;
			this.guildBtn=this.getUIbyID("guildBtn") as ImgButton;
			this.daZBtn=this.getUIbyID("daZBtn") as ImgButton;
			this.mountBtn=this.getUIbyID("mountBtn") as ImgButton;
			this.guaJBtn=this.getUIbyID("guaJBtn") as ImgButton;

			this.bbsBtn2=this.getUIbyID("bbsBtn2") as ImgButton;
			this.bbsBtn1=this.getUIbyID("bbsBtn1") as ImgButton;

			this.bbsBtn1.addEventListener(MouseEvent.CLICK, onClick);
			this.bbsBtn2.addEventListener(MouseEvent.CLICK, onClick);

			this.bbsBtn1.visible=false;
			this.bbsBtn2.visible=false;

			this.expImg=this.getUIbyID("expImg") as Image;
			this.hunImg=this.getUIbyID("hunImg") as Image;

			this.quickImg=this.getUIbyID("quickImg") as Image;

			this.expBg=this.getUIbyID("expBg") as Image;
			this.hunBg=this.getUIbyID("hunBg") as Image;

			var arr:Array=[this.teamBtn, this.guildBtn, this.friendBtn, this.daZBtn, this.mountBtn, this.guaJBtn, this.playerBtn, this.backpackBtn, this.skillBtn, this.missionBtn, // 
				this.duanZBtn, this.wenZBtn, this.shiCBtn, this.shopBtn, this.mercenaryBtn, this.framBtn, this.collectBtn, this.alchmyBtn];

			var tipid:int=0;
			for (var i:int=0; i < arr.length; i++) {
				if (arr[i] != null) {
					ImgButton(arr[i]).addEventListener(MouseEvent.CLICK, onBtnClick);
					if (i + 1 == arr.length)
						tipid=10048;
					else
						tipid=10017 + i;

					ImgButton(arr[i]).setToolTip(TableManager.getInstance().getSystemNotice(tipid).content);
				}
			}

//			this.mercenaryBtn.visible=false;

//			this.jingliBtn.addEventListener(MouseEvent.CLICK, onJinliClick);
//			this.jingliBtn.addEventListener(MouseEvent.MOUSE_OVER, onjinMouseOver);
//			this.jingliBtn.addEventListener(MouseEvent.MOUSE_OUT, onjinMouseOut);
//
//			this.jingliBtn.mouseChildren=this.jingliBtn.mouseEnabled=true;

			this.hpAndmp=new ToolsHpAndMpProgress();
			this.addChild(this.hpAndmp);
			this.addShoruCutKey();
			this.addChild(this.quickImg);

			this.hpAndmp.x=349;


			this.addChild(this.expBg);
			this.addChild(this.hunBg);

			var einfo:MouseEventInfo=new MouseEventInfo();
			einfo.onMouseMove=onExpMouseOver;
			einfo.onMouseOut=onExpMouseOut;

			MouseManagerII.getInstance().addEvents(this.expBg, einfo);

			var einfo1:MouseEventInfo=new MouseEventInfo();
			einfo1.onMouseMove=onhunMouseOver;
			einfo1.onMouseOut=onhunMouseOut;

			MouseManagerII.getInstance().addEvents(this.hunBg, einfo1);

			this.expBg.alpha=0;
			this.hunBg.alpha=0;



			this.x=(UIEnum.WIDTH - this.width) >> 1;

			this.mountBtn.setActive(false, .6, true);
			
		}

		private function onClick(e:MouseEvent):void {
			switch (e.target.name) {
				case "bbsBtn2":
					navigateToURL(new URLRequest(Core.URL_BBS), "_blank");
					break;
				case "bbsBtn1":
					navigateToURL(new URLRequest(Core.URL_BUG), "_blank");
					break;
			}

		}

		override public function get width():Number {
			return 836;
		}

		public function updateHpAndMpProgress():void {
			if (Core.me == null || Core.me.info == null || Core.me.info.baseInfo == null)
				return;

			this.hpAndmp.updateProgress();
			
			this.openFuncToLevel();
		}

		public function stopAddMp():void {
			this.hpAndmp.stopAddMp();
		}

		public function updateSlider(progress:Number):void {
			this.hpAndmp.updateSlider(progress);
		}

//		private function onJinliClick(e:MouseEvent):void {
//			trace("精力 use click")
//		}

//		private function onjinMouseOver(e:MouseEvent):void {
//			if (Core.me == null || Core.me.info == null || Core.me.info.baseInfo == null)
//				return;
//
//			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(9903).content, [Core.me.info.baseInfo.jingL, Core.me.info.baseInfo.maxJingL, int(Core.me.info.baseInfo.jingL / Core.me.info.baseInfo.maxJingL * 100) + "%"]), new Point(this.stage.mouseX, this.stage.mouseY));
//		}
//
//		private function onjinMouseOut(e:MouseEvent):void {
//			ToolTipManager.getInstance().hide();
//		}

		private function onhunMouseOver(e:DisplayObject):void {

			if (Core.me == null || Core.me.info == null || Core.me.info.baseInfo == null)
				return;

			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(9902).content, [Core.me.info.baseInfo.hunL, Core.me.info.baseInfo.maxHunL, int(Core.me.info.baseInfo.hunL / Core.me.info.baseInfo.maxHunL * 100) + "%"]), new Point(this.stage.mouseX, this.stage.mouseY));
		}

		private function onhunMouseOut(e:DisplayObject):void {
			ToolTipManager.getInstance().hide();
		}

		private function onExpMouseOver(e:DisplayObject):void {
			if (Core.me == null || Core.me.info == null || Core.me.info.baseInfo == null)
				return;

			ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, StringUtil.substitute(TableManager.getInstance().getSystemNotice(9901).content, [Core.me.info.baseInfo.exp, Core.me.info.baseInfo.maxExp, int(Core.me.info.baseInfo.exp / Core.me.info.baseInfo.maxExp * 100) + "%"]), new Point(this.stage.mouseX, this.stage.mouseY));
		}

		private function onExpMouseOut(e:DisplayObject):void {
			ToolTipManager.getInstance().hide();
		}

		public function updataPropUI():void {
			this.expImg.scaleX=Core.me.info.baseInfo.exp / Core.me.info.baseInfo.maxExp;
			var h:Number=Core.me.info.baseInfo.hunL / Core.me.info.baseInfo.maxHunL;
			h=(h > 1 ? 1 : h);

			if (h >= 1) {
				if (tweMax == null)
					tweMax=TweenMax.to(this.hunImg, 2, {glowFilter: {color: 0x6136e9, alpha: 1, blurX: 12, blurY: 12, strength: 3}, yoyo: true, repeat: -1});
			} else {
				if (tweMax != null) {
					tweMax.pause();
					tweMax.kill();
				}

				tweMax=null;
				this.hunImg.filters=[];
			}

			this.hunImg.scaleX=h;

			this.updateHpAndMpProgress();
			this.x=(UIEnum.WIDTH - this.width) >> 1;
		}

		/**
		 * <T>锁定未开启功能按钮</T>
		 *
		 * @param type 功能类型
		 *
		 */
		public function lockButton(type:int):void {
			var btn:ImgButton=getButtonByType(type);
			if (null != btn) {
				btn.setActive(false, 1, true);
			}
		}

		/**
		 * <T>解锁功能呢按钮</T>
		 * @param type 功能类型
		 */
		public function unlockButton(type:int):void {
			var btn:ImgButton=getButtonByType(type);
			if (null != btn) {
				btn.setActive(true, 1, true);
			}
		}

		/**
		 * <T>根据功能类型获得功能按钮</T>
		 *
		 * @param type 功能类型
		 * @return     功能按钮
		 *
		 */
		public function getButtonByType(type:int):ImgButton {
			switch (type) {
				case MoldEnum.AUTION:
					return shiCBtn;
				case MoldEnum.GUlID:
					return guildBtn;
				case MoldEnum.MARKET:
					return shopBtn;
				case MoldEnum.MEDAL:
					return wenZBtn;
				case MoldEnum.STRENGTHEN:
					return duanZBtn;
				case MoldEnum.SERVENT:
					return mercenaryBtn;
				case MoldEnum.COLLECTION:
					return collectBtn;
				case MoldEnum.FARM:
					return framBtn;
				default:
					return null;
//				case MoldEnum.SHOP:
//					return null;
//				case MoldEnum.WING:
//					return null;
//				case MoldEnum.DIVERT:
//					return null;
//				case MoldEnum.ELEMENT:
//					return null;
//				case MoldEnum.RECASTING:
//					return null;
//				case MoldEnum.RIDE:
//					return null;
//				case MoldEnum.TITLE:
//					return null;
			}
			return null;
		}

		public function getBagBtn():ImgButton {
			return this.backpackBtn;
		}

		public function getSkillBtn():ImgButton {
			return this.skillBtn;
		}

		//添加快捷键
		private function addShoruCutKey():void {
			this.shortCutDic={};

			var keyGrid:ShortcutsGrid;
			for (var i:int=0; i < 8; i++) {

				keyGrid=new ShortcutsGrid(i);
				keyGrid.updataInfo(null);
				keyGrid.x=40 + (i * ICO_GAP);
				keyGrid.y=76;
				keyGrid.gridId=i;

				this.addChild(keyGrid);
				this.shortCutDic[i]=keyGrid;
			}

			this.gridList=new ToolsGridItemRender();
//			this.gridList.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			LayerManager.getInstance().windowLayer.addChild(this.gridList);

		}

		public function delGrid(i:int):void {

			this.shortCutDic[i].delGrid();

		}

		/**
		 *更新默认药水
		 */
		public function updateDefaultYaoshui():void {

			var isexist:Boolean=false;
			var isbagExist:Boolean=false;

			var item:TItemInfo;
			var binfo:Baginfo;
			var num:int=0;

			var keyGrid:ShortcutsGrid;
			var index:int=-1;

			for each (keyGrid in this.shortCutDic) {

				if (keyGrid != null && keyGrid.cloneGridType == ItemEnum.TYPE_GRID_BACKPACK) {

					if (keyGrid.autoType == ItemEnum.TYPE_YAOSHUI_MOMENT_BLUE) {
						isexist=true;

						if (this.toolsKey[keyGrid.initId] == null)
							break;

						this.currentYaoshui[1]=this.toolsKey[keyGrid.initId];
						break;
					}
				}
			}

			if (!isexist) {

				index=this.findEmptyIndex(false, 1);
				index=(index == -1 ? this.findEmptyIndex(false) : index)

				if (index != -1) {
					var redYao:Array=TableManager.getInstance().getItemListArrByClass(ItemEnum.ITEM_TYPE_YAOSHUI, ItemEnum.TYPE_YAOSHUI_MOMENT_BLUE);

					redYao=redYao.filter(function(item:Object, i:int, arr:Array):Boolean {
						if (item.bind == "1")
							return false;

						return true;
					});

					redYao.sortOn("id", Array.DESCENDING | Array.NUMERIC);

					if (this.firstOpen) {

						for each (item in redYao) {
							num=MyInfoManager.getInstance().getBagItemNumByName(item.name);
							if (num > 0) {
								Cmd_Link.cm_linkSet(index, 2, int(item.id));
								isbagExist=true;
								break;
							}

						}

						if (!isbagExist) {
							redYao.reverse();
							this.shortCutDic[index].updateYaoshui(redYao[0], true);
						}

					} else {

						if (this.currentYaoshui[1] != null) {
							item=TableManager.getInstance().getItemInfo(this.currentYaoshui[1][1]);
							num=MyInfoManager.getInstance().getBagItemNumByName(item.name);
							if (num == 0)
								this.shortCutDic[index].updateYaoshui(item, true);
						} else {
							redYao.reverse();
							this.shortCutDic[index].updateYaoshui(redYao[0], true);
						}

					}

					this.shortCutDic[index].setSelectBmpEnable(false);
				}
			}

			isexist=false;
			isbagExist=false;

			for each (keyGrid in this.shortCutDic) {

				if (keyGrid != null && keyGrid.cloneGridType == ItemEnum.TYPE_GRID_BACKPACK) {

					if (keyGrid.autoType == ItemEnum.TYPE_YAOSHUI_MOMENT_RED) {
						isexist=true;

						if (this.toolsKey[keyGrid.initId] == null)
							break;

						this.currentYaoshui[0]=this.toolsKey[keyGrid.initId];
						break;
					}
				}
			}

			if (!isexist) {

				var oindex:int=index;
				index=this.findEmptyIndex(false, 2, oindex);
				index=(index == -1 ? this.findEmptyIndex(false, 0, oindex) : index)

				if (index != -1) {
					redYao=TableManager.getInstance().getItemListArrByClass(ItemEnum.ITEM_TYPE_YAOSHUI, ItemEnum.TYPE_YAOSHUI_MOMENT_RED);

					redYao=redYao.filter(function(item:Object, i:int, arr:Array):Boolean {
						if (item.bind == "1")
							return false;
						return true;
					});

					redYao.sortOn("id", Array.DESCENDING | Array.NUMERIC);

					if (this.firstOpen) {

						for each (item in redYao) {

							num=MyInfoManager.getInstance().getBagItemNumByName(item.name);

							if (num > 0) {
								Cmd_Link.cm_linkSet(index, 2, int(item.id));
								isbagExist=true;
								break;
							}

						}

						if (!isbagExist) {

							redYao.reverse();
							this.shortCutDic[index].updateYaoshui(redYao[0], true);

						}

					} else {

						if (this.currentYaoshui[0] != null) {

							item=TableManager.getInstance().getItemInfo(this.currentYaoshui[0][1]);
							num=MyInfoManager.getInstance().getBagItemNumByName(item.name);

							if (num == 0)
								this.shortCutDic[index].updateYaoshui(item, true);

						} else {

							redYao.reverse();
							this.shortCutDic[index].updateYaoshui(redYao[0], true);

						}

					}

					this.shortCutDic[index].setSelectBmpEnable(false);

				}
			}

			this.firstOpen=false;
		}

		/**
		 *激活单前道具
		 * @param aid
		 *
		 */
		public function setActiveCurrentItem(binfo:Baginfo):void {

			if (binfo == null || binfo.info.classid != ItemEnum.ITEM_TYPE_YAOSHUI)
				return;

			if (binfo.info.subclassid != ItemEnum.TYPE_YAOSHUI_MOMENT_RED && binfo.info.subclassid != ItemEnum.TYPE_YAOSHUI_MOMENT_BLUE)
				return;

			var ysItem:Vector.<TItemInfo>;
//			arr.reverse();
//			TableManager.getInstance().getItemListByClass(ItemEnum.ITEM_TYPE_YAOSHUI, ItemEnum.TYPE_YAOSHUI_CONTINUE_BLUE);

			var iinfo:TItemInfo;
			var keyGrid:ShortcutsGrid;
			var baginfo:Baginfo;
			var arr:Array=[];
			for each (keyGrid in this.shortCutDic) {
				if (keyGrid != null && keyGrid.cloneGridType == ItemEnum.TYPE_GRID_BACKPACK) {

					if (keyGrid.autoType == ItemEnum.TYPE_YAOSHUI_MOMENT_RED || keyGrid.autoType == ItemEnum.TYPE_YAOSHUI_MOMENT_BLUE) {

						if (keyGrid.autoItem) {

							arr=MyInfoManager.getInstance().getBagItemIDArrByID(keyGrid.autoid);

							if (arr.indexOf(binfo.aid) > -1) {
								Cmd_Link.cm_linkSet(keyGrid.initId, 2, keyGrid.autoid);
							} else {

								if (keyGrid.autoType == ItemEnum.TYPE_YAOSHUI_MOMENT_RED)
									ysItem=TableManager.getInstance().getItemListByClass(ItemEnum.ITEM_TYPE_YAOSHUI, ItemEnum.TYPE_YAOSHUI_MOMENT_RED);
								else if (keyGrid.autoType == ItemEnum.TYPE_YAOSHUI_MOMENT_BLUE)
									ysItem=TableManager.getInstance().getItemListByClass(ItemEnum.ITEM_TYPE_YAOSHUI, ItemEnum.TYPE_YAOSHUI_MOMENT_BLUE);

								ysItem.reverse();

								for each (iinfo in ysItem) {
									arr=MyInfoManager.getInstance().getBagItemIDArrByID(int(iinfo.id));

									if (arr.length != 0) {
										Cmd_Link.cm_linkSet(keyGrid.initId, 2, (int(iinfo.id) % 2 == 0 ? int(iinfo.id) : int(iinfo.id) - 1));
										break;
									}

								}

							}

						} else {

							Cmd_Link.cm_linkSearch();

						}

					}

				}
			}
		}

		/**
		 *清除空道具
		 */
		public function clearEmptyItem(binfo:Baginfo):void {

			if (binfo == null || binfo.info.classid != ItemEnum.ITEM_TYPE_YAOSHUI)
				return;

			if (binfo.info.subclassid != ItemEnum.TYPE_YAOSHUI_MOMENT_RED && binfo.info.subclassid != ItemEnum.TYPE_YAOSHUI_MOMENT_BLUE)
				return;

			var keyGrid:ShortcutsGrid;
			var num:int=0;

			for each (keyGrid in this.shortCutDic) {

				if (keyGrid != null && keyGrid.cloneGridType == ItemEnum.TYPE_GRID_BACKPACK) {

					if (int(binfo.info.subclassid) == keyGrid.autoType && keyGrid.dataId == binfo.pos) {

						num=MyInfoManager.getInstance().getBagItemNumByName(binfo.info.name);

						if (num <= binfo.num) {

							Cmd_Link.cm_linkClear(keyGrid.initId);
							Cmd_Link.cm_linkSearch();

						} else {

							keyGrid.numLblText="" + (num - binfo.num);
							keyGrid.dataId=int(MyInfoManager.getInstance().getBagItemPosArrById(binfo).shift());
						}

					}

				}
			}

		}

		/**
		 *选药菜单
		 * @param i
		 * @param pos
		 * @param pt
		 *
		 */
		public function showSelectItemPanel(i:int, pos:int, pt:Point):void {

			var yaoshui:Array=TableManager.getInstance().getItemListArrByClass(ItemEnum.ITEM_TYPE_YAOSHUI, i);
			yaoshui.sortOn("id", Array.CASEINSENSITIVE | Array.NUMERIC);

			this.gridList.updateGridList(yaoshui, pos);

			this.gridList.show();

			this.gridList.x=pt.x;
			this.gridList.y=pt.y - this.gridList.height - 5;

		}

		public function hidGridList():void {
			this.gridList.hide();
		}

		public function setAutoMagicGrid(grid:int, st:Boolean):void {
			var sk:TSkillInfo
			var keyGrid:ShortcutsGrid;
			for each (keyGrid in this.shortCutDic) {
				if (keyGrid != null && keyGrid.dataId == grid && keyGrid.cloneGridType == ItemEnum.TYPE_GRID_SKILL) {
					keyGrid.setAutoMagic(st);
				}
			}

			this.setAutoMagicList();
		}

		/**
		 *自动技能列表
		 *
		 */
		public function setAutoMagicList():void {

			this.autoMagicArr.length=0;

			var si:int=0;
			var arr:Array=TableManager.getInstance().getSkillByLimit(Core.me.info.profession);
			arr=arr.sortOn("id", Array.CASEINSENSITIVE | Array.NUMERIC);

			var sk:TSkillInfo
			var keyGrid:ShortcutsGrid;
			for each (keyGrid in this.shortCutDic) {
				if (keyGrid != null && keyGrid.cloneGridType == ItemEnum.TYPE_GRID_SKILL) {

					sk=UIManager.getInstance().skillWnd.getOpenSkill(keyGrid.dataId);

					if (sk == null)
						continue;

					if (keyGrid.autoMagic || int(sk.id) == arr[0].id) {

						if (sk.auto == 0) {
							NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(2118))
							return;
						}

						if (this.autoMagicArr.indexOf(int(sk.id)) == -1) {
							this.autoMagicArr.push(int(sk.id));
						}

					} else {
//						si=this.autoMagicArr.indexOf(int(sk.id));
//						this.autoMagicArr.splice(si, 1);
					}
				}
			}


			if (this.autoMagicArr.length == 0) {

				var skNum:int=0;

				for each (keyGrid in this.shortCutDic) {
					if (keyGrid != null && keyGrid.cloneGridType == ItemEnum.TYPE_GRID_SKILL) {

						sk=UIManager.getInstance().skillWnd.getOpenSkill(keyGrid.dataId);
						skNum=TableManager.getInstance().getSkillArr(keyGrid.dataId).length;

						if (sk == null)
							continue;

						if (int(sk.id) >= arr[0].id && int(sk.id) <= int(arr[0].id) + skNum) {
//						if (int(sk.id) == arr[0].id) {

							keyGrid.setAutoMagic(true);
							NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(2113), [sk.name]);

							if (this.autoMagicArr.indexOf(int(sk.id)) == -1) {
								this.autoMagicArr.push(int(sk.id));
								break;
							}

						}
					}
				}

			}

			SettingManager.getInstance().assitInfo.skills=this.autoMagicArr;
			Cmd_Assist.cm_Ass_S(SettingManager.getInstance().assitInfo.serialize());
			Cmd_Assist.cm_Ass_I();

//			trace("=======", this.autoMagicArr)
		}

		public function updateAutoMagicList():void {

			this.autoMagicArr=SettingManager.getInstance().assitInfo.skills;
			SettingManager.getInstance().assitInfo.serialize();

			if (this.autoMagicArr.indexOf(-1) > -1) {
				this.setAutoMagicList();
			} else {

				var sk:TSkillInfo
				var keyGrid:ShortcutsGrid;
				for each (keyGrid in this.shortCutDic) {
					if (keyGrid != null && keyGrid.cloneGridType == ItemEnum.TYPE_GRID_SKILL) {

						sk=UIManager.getInstance().skillWnd.getOpenSkill(keyGrid.dataId);
						if (sk == null)
							continue;

						if (this.autoMagicArr.indexOf(int(sk.id)) > -1) {

							keyGrid.setAutoMagic(true);
							UIManager.getInstance().skillWnd.setautoMagic(keyGrid.dataId, true);
						} else {
							UIManager.getInstance().skillWnd.setautoMagic(keyGrid.dataId, false);
						}
					}
				}

			}

		}

		public function openFuncToLevel():void {

			if (Core.me == null || Core.me.info == null)
				return;

			if (Core.me.info.level >= ConfigEnum.Alchemy1)
				this.alchmyBtn.setActive(true, 1, true);
			else
				this.alchmyBtn.setActive(false, 0.6, true);

//			this.wenZBtn.setActive((ConfigEnum.BadgeOpenLv <= Core.me.info.level));
		}

		private var tmpFun:Function;

		private function onBtnClick(evt:MouseEvent):void {
			switch (evt.target.name) {
				case "daZBtn":
					SceneKeyManager.getInstance().onKeyDown(Keyboard.Z);
					GuideManager.getInstance().showGuides([77, 78], [this, this]);
					break;
				case "shiCBtn":
					UIOpenBufferManager.getInstance().open(WindowEnum.AUTION)
//					UILayoutManager.getInstance().open(WindowEnum.AUTION);
					break;
				case "shopBtn":
					UIOpenBufferManager.getInstance().open(WindowEnum.MARKET);
					break;
				case "wenZBtn":

					UILayoutManager.getInstance().open_II(WindowEnum.BADAGE);

					break;
				case "duanZBtn":

					UILayoutManager.getInstance().open_II(WindowEnum.EQUIP);

					break;
				case "guildBtn":

					UILayoutManager.getInstance().open_II(WindowEnum.GUILD);

					break;
				case "playerBtn":

					UILayoutManager.getInstance().open_II(WindowEnum.ROLE)

					break;
				case "backpackBtn":

					UILayoutManager.getInstance().open_II(WindowEnum.BACKPACK);

					break;
				case "skillBtn":

					UILayoutManager.getInstance().open_II(WindowEnum.SKILL);

					break;
				case "friendBtn":
					UIOpenBufferManager.getInstance().open(WindowEnum.FRIEND);
//					UILayoutManager.getInstance().open(WindowEnum.FRIEND);
					break;
				case "settingBtn":
					UIManager.getInstance().quickBuyWnd.open();
					break;
				case "teamBtn":
					//UIManager.getInstance().teamWnd.open();

					UILayoutManager.getInstance().open_II(WindowEnum.TEAM)

					break;
				case "missionBtn":

					UILayoutManager.getInstance().open_II(WindowEnum.TASK)

					break;
				case "tradeBtn":
					break;
				case "mountBtn":
					UIManager.getInstance().roleWnd.mountUpAndDown();
					break;
				case "mercenaryBtn": //佣兵
					UIOpenBufferManager.getInstance().open(WindowEnum.PET);
					break;
				case "framBtn": //农场
					UIOpenBufferManager.getInstance().open(WindowEnum.FARM);
					break;
				case "collectBtn": //采集
					UIOpenBufferManager.getInstance().open(WindowEnum.COLLECTION);
					break;
				case "biGBtn":
					Cmd_Wig.cm_WigOverLoad();
					break;
				case "guaJBtn":
					var mod:int=AssistWnd.getInstance().visible ? 2 : 1;
					UILayoutManager.getInstance().singleMove(AssistWnd.getInstance(), "assistWnd", mod, evt.target.localToGlobal(new Point(0, 0)));
//					AssistWnd.getInstance().open();
					break;
				case "alchmyBtn":
					if (Core.me.info.level >= ConfigEnum.Alchemy1)
						UILayoutManager.getInstance().open(WindowEnum.GEM_LV);
					break;
			}

			evt.stopImmediatePropagation();
		}


		public function useGrid(key:String, isDown:Boolean=false):int {

			if (this.shortCutDic == null)
				return -1;

			var num:int=int(key);

			switch (key) {
				case "Q":
					num=5;
					break;
				case "W":
					num=6;
					break;
				case "E":
					num=7;
					break;
				case "R":
					num=8;
					break;
				case "T":
					num=10;
					break;
			}

			var grid:ShortcutsGrid=ShortcutsGrid(this.shortCutDic[num - 1]);
			if (grid == null || grid.dataId == -1)
				return -1;

			if (isDown) {
				grid.y+=2;
			} else {
				grid.y-=2;

				if (grid.cloneGridType == ItemEnum.TYPE_GRID_BACKPACK) {

					if (!grid.cdOver())
						NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(4006));
					else {

						var binfo:Baginfo=MyInfoManager.getInstance().bagItems[grid.dataId];
						var binfo2:Baginfo=MyInfoManager.getInstance().getBagItemNegationByID(binfo.aid);

						if (binfo2 != null)
							Cmd_Bag.cm_bagUse(binfo2.pos, 1);
						else
							Cmd_Bag.cm_bagUse(grid.dataId, 1);

						var bginfo:Baginfo=binfo || binfo2;

						if (MyInfoManager.getInstance().getBagItemNumByName(bginfo.info.name) <= 1) {
							Cmd_Link.cm_linkClear(grid.initId);
							Cmd_Link.cm_linkSearch();
						}

					}

				} else if (grid.cloneGridType == ItemEnum.TYPE_GRID_SKILL) {

					var sk:TSkillInfo=UIManager.getInstance().skillWnd.getOpenSkill(grid.dataId);

					if (!grid.cdOver()) {
						NoticeManager.getInstance().broadcast(TableManager.getInstance().getSystemNotice(4006));
						return -1;
					}

					return int(sk.id);
				}
			}

			return -1;
		}

		/**
		 * 重新登陆后的cd
		 * @param gid
		 * @param cdtime
		 *
		 */
		public function updateCD(gid:String, cdtime:int):void {

			var grid:ShortcutsGrid;

			for (var i:int=0; i < 8; i++) {

				grid=ShortcutsGrid(this.shortCutDic[i]);
				if (grid == null)
					continue;

				if (gid.indexOf("_") == -1 && grid.cloneGridType == ItemEnum.TYPE_GRID_SKILL) {

					var skdata:Array=MyInfoManager.getInstance().skilldata.skillItems[grid.dataId];
					if (skdata == null)
						continue;

					var sk:TSkillInfo=TableManager.getInstance().getSkill(skdata[1])[0];
					if (sk.group == int(gid))
						grid.playCD(int(sk.CD), cdtime);

				} else if (grid.cloneGridType == ItemEnum.TYPE_GRID_BACKPACK) {

					var binfo:Baginfo=MyInfoManager.getInstance().bagItems[grid.dataId];
					if (binfo == null)
						continue;

					if (binfo.info.classid + "_" + binfo.info.subclassid == gid) {
						var ctime:int=int(binfo.info.cooltime) * 1000;
						grid.playCD(ctime, ctime - cdtime);
						grid.numLblText="" + MyInfoManager.getInstance().getBagItemNumByName(binfo.info.name);
					}

				}
			}

		}

		/**
		 *清除所以skillcd
		 *
		 */
		public function clearSkillAllCD():void {
			var grid:ShortcutsGrid;

			for (var i:int=0; i < 8; i++) {

				grid=ShortcutsGrid(this.shortCutDic[i]);
				if (grid == null)
					continue;

				if (grid.cloneGridType == ItemEnum.TYPE_GRID_SKILL) {
					grid.clearCD();
				}
			}

		}

		/**
		 * 其他的公共cd
		 * @param _i
		 *
		 */
		private function updateOtherCD(_i:int):void {
			var grid:ShortcutsGrid;

//			trace("publish cd", _i);

			for (var i:int=0; i < 8; i++) {

				if (_i == i)
					continue;

				grid=this.shortCutDic[i];
				if (grid == null || grid.dataId == -1 || grid.cloneGridType == ItemEnum.TYPE_GRID_BACKPACK)
					continue;

				if (grid.cdOver())
					grid.playCD(1000);
			}
		}

		public function updateAllKey():void {

			var key:String;
			var value:Object;
			for (var i:int=0; i < 8; i++) {
				if (this.toolsKey[i] != null) {

					value=this.toolsKey[i];

					if (value[0] == 1) {
						this.shortCutDic[i].updataInfo(UIManager.getInstance().skillWnd.getOpenSkill(value[1]), value[1]);
					} else if (value[0] == 2) {

					}

				}
			}
		}

		private function onMouseMove(e:MouseEvent):void {
//			trace(e.target)
//			e.stopImmediatePropagation();
		}

		public function updateYaoshuiKey(index:int, info:Baginfo):void {
			this.shortCutDic[index].updateItem(info);
		}

		public function updateSkillKey(index:int, skid:int):void {

			if (this.toolsPreUse.indexOf(index) > -1)
				this.toolsPreUse.splice(this.toolsPreUse.indexOf(index), 1);

			var sk:TSkillInfo=UIManager.getInstance().skillWnd.getOpenSkill(skid);
			this.shortCutDic[index].updateItem(sk, skid);

			if (this.autoMagicArr.indexOf(int(sk.id)) > -1) {
				this.shortCutDic[index].setAutoMagic(true);
			} else if (UIManager.getInstance().skillWnd.getSkillObIndex() == index && !this.shortCutDic[UIManager.getInstance().skillWnd.getSkillObIndex()].autoMagic && sk.auto == 1) {
				UIManager.getInstance().skillWnd.setSkillObIndex();
				this.shortCutDic[index].mouseUpHandler(0, 0);
//				this.shortCutDic[index].setAutoMagic(true);
			}

		}

		public function reUpdateMenuList():void {
			if (this.gridList.visible) {
//				this.gridList.reupdateList();
			}

			//第一次登陆,新帐号
			if (this.firstOpen) {

				if (this.autoMagicArr.length == 0)
					Cmd_Assist.cm_Ass_I();

				var sk:Array=MyInfoManager.getInstance().skilldata.skillItems;
				var skiArr:Array=[];
				var keyGrid:ShortcutsGrid;
				var isexist:Boolean=false;
				var idx:int=-1;

				for (var i:int=1; i < sk.length; i++) {

					isexist=false;

					if (sk[i][0] == 0)
						continue;

					for each (keyGrid in this.shortCutDic) {
						if (keyGrid != null && keyGrid.cloneGridType == ItemEnum.TYPE_GRID_SKILL && keyGrid.dataId == sk[i][1]) {
							isexist=true;
							break;
						}
					}

					if (!isexist) {
						skiArr=TableManager.getInstance().getSkillArr(sk[i][1]);
						skiArr.sortOn("id", Array.CASEINSENSITIVE | Array.NUMERIC);

						idx=UIManager.getInstance().toolsWnd.searchEmptyIndex((int(skiArr[0].id) % 100 == 4));
						if (idx == -1)
							continue;

						Cmd_Link.cm_linkSet(idx, 1, sk[i][1]);

//						break;
					}

				}
			}

			this.updateDefaultYaoshui()
		}

		/**
		 *
		 * @param type 1:hp; 2:mp;
		 *
		 */
		public function getGuidGrid(type:int):DisplayObjectContainer {
			var grid:ShortcutsGrid;

			for (var i:int=0; i < 8; i++) {

				grid=ShortcutsGrid(this.shortCutDic[i]);
				if (grid == null || grid.cloneGridType != ItemEnum.TYPE_GRID_BACKPACK)
					continue;

				var binfo:Baginfo=MyInfoManager.getInstance().bagItems[grid.dataId];
				if (binfo == null)
					continue;

				if (binfo.info.classid == ItemEnum.ITEM_TYPE_YAOSHUI) {
					if ((type == 1 && binfo.info.subclassid == ItemEnum.TYPE_YAOSHUI_MOMENT_RED) || (type == 2 && binfo.info.subclassid == ItemEnum.TYPE_YAOSHUI_MOMENT_BLUE))
						return grid;

				}

			}


			return null;
		}

		/**
		 *搜索没有使用的grid----skill
		 * @return
		 *
		 */
		public function searchEmptyIndex(right:Boolean=false):int {

			if (right && this.toolsKey[7] == null && this.toolsPreUse.indexOf(7) == -1) {
				return 7;
			}

			var key:String;
			var value:Object;
			for (var i:int=0; i < 8; i++) {
				if (this.toolsKey[i] == null && this.toolsPreUse.indexOf(i) == -1) {
					this.toolsPreUse.push(i);
					return i;
				}
			}

			return -1;
		}

		/**
		 * 查找空格子
		 * @param order 顺序还是逆序
		 * @return
		 */
		public function findEmptyIndex(order:Boolean=true, sindex:int=0, sky:int=-1):int {

			var key:String;
			var value:Object;
			var i:int=0;

			var keyGrid:ShortcutsGrid;

			if (order) {

				for (i=sindex; i < 8; i++) {
					if (this.shortCutDic[i].dataId == -1 && !this.shortCutDic[i].autoItem && i != sky) {
						return i;
					}
				}

			} else {

				for (i=7 - sindex; i >= 0; i--) {
					if (this.shortCutDic[i].dataId == -1 && !this.shortCutDic[i].autoItem && i != sky) {
						return i;
					}
				}

			}

			return -1;
		}


		public function updateCurrentCD(num:int):void {

			var sk:TSkillInfo=TableManager.getInstance().getSkillById(num);

			var grid:ShortcutsGrid;
			var i:int=-1;
			for each (grid in this.shortCutDic) {
				i++;
				if (grid != null && grid.cloneGridType == ItemEnum.TYPE_GRID_SKILL && grid.dataId == int(sk.skillId))
					break;
			}

			if (grid == null)
				return;

			grid.playCD(int(sk.CD));

			if (grid.cloneGridType == ItemEnum.TYPE_GRID_SKILL)
				this.updateOtherCD(i);
		}


		public function updateYaoshuiData(tpos:int):void {

			var bitem:Baginfo=MyInfoManager.getInstance().bagItems[tpos];

			var key:String;
			var value:Object;

			for (var i:int=0; i < 8; i++) {
				if (this.toolsKey[i] != null) {

					value=this.toolsKey[i];
					if (value[0] == 1) {

//						this.shortCutDic[i].updataInfo(UIManager.getInstance().skillWnd.getOpenSkill(value[1]), value[1]);

					} else if (value[0] == 2) {

						if (value[1] == (bitem.aid % 2 == 0 ? bitem.aid : bitem.aid - 1)) {
							this.shortCutDic[i].dataId=bitem.pos;
							this.shortCutDic[i].numLblText=MyInfoManager.getInstance().getBagItemNumByName(bitem.info.name);
						} else {


						}

					}
				}
			}

		}

		public function get shortCutGrid():Object {
			return this.shortCutDic;
		}

		public function resize():void {
			this.x=(UIEnum.WIDTH - this.width) >> 1; //933=真实宽度
			this.y=UIEnum.HEIGHT - 131; //107=真实高度
		}
	}
}

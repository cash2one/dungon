package com.leyou.ui.equip {

	import com.ace.config.Core;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.manager.GuideArrowDirectManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.TweenManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.greensock.TweenLite;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.data.role.EquipInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.TaskEnum;
	import com.leyou.ui.equip.child.EquipBagRender;
	import com.leyou.ui.equip.child.EquipBreakRender;
	import com.leyou.ui.equip.child.EquipElementRender;
	import com.leyou.ui.equip.child.EquipIntensifyRender;
	import com.leyou.ui.equip.child.EquipLvupRender;
	import com.leyou.ui.equip.child.EquipRecastRender;
	import com.leyou.ui.equip.child.EquipReclassRender;
	import com.leyou.ui.equip.child.EquipStrengGrid;
	import com.leyou.ui.equip.child.EquipTransRender;

	import flash.display.DisplayObject;
	import flash.events.Event;

	public class EquipWnd extends AutoWindow {

		private var bagTabBar:TabBar;

		private var equipTransRender:EquipTransRender;
		private var equipIntensifyRender:EquipIntensifyRender;
		private var equipRecastRender:EquipRecastRender;
		private var equipReclassRender:EquipReclassRender;
		private var equipBreakRender:EquipBreakRender;
		private var equipLvupRender:EquipLvupRender;
		private var equipElementRender:EquipElementRender;

		private var equipBagRender:EquipBagRender;

		private var currentIndex:int=0;

		private var gridArr:Array=[];

		public function EquipWnd() {
			super(LibManager.getInstance().getXML("config/ui/EquipWnd.xml"));
			this.init();
			this.mouseEnabled=true;
		}

		private function init():void {
			this.bagTabBar=this.getUIbyID("equipTabBar") as TabBar;

			this.equipTransRender=new EquipTransRender();
			this.equipIntensifyRender=new EquipIntensifyRender();
			this.equipRecastRender=new EquipRecastRender();
			this.equipReclassRender=new EquipReclassRender();
			this.equipBreakRender=new EquipBreakRender();
			this.equipLvupRender=new EquipLvupRender();
			this.equipElementRender=new EquipElementRender();

			this.bagTabBar.addToTab(this.equipIntensifyRender, 0);
			this.bagTabBar.addToTab(this.equipTransRender, 1);
			this.bagTabBar.addToTab(this.equipRecastRender, 2);
//			this.bagTabBar.addToTab(this.equipReclassRender, 3);
			this.bagTabBar.addToTab(this.equipBreakRender, 4);
			this.bagTabBar.addToTab(this.equipLvupRender, 5);
			this.bagTabBar.addToTab(this.equipElementRender, 6);

			this.bagTabBar.addEventListener(TabbarModel.changeTurnOnIndex, onChangeTab);

			//右侧数据
			this.equipBagRender=new EquipBagRender();
			this.addChild(this.equipBagRender);

			this.equipBagRender.x=467;
			this.equipBagRender.y=97;

			this.addChild(this.bagTabBar);
			this.bagTabBar.turnToTab(0);

//			var eq:Object=MyInfoManager.getInstance().equips;
//			var grid:EquipGrid;
//			var eqinfo:EquipInfo;
//			var i:int=0;
//			for (i=0; i < 14; i++) {
//
//				if (eq[i] == null)
//					continue;
//
//				grid=new EquipGrid();
//
//				if (i < 7) {
//					grid.x=19;
//					grid.y=127 + i * 52;
//				} else {
//					grid.x=397;
//					grid.y=127 + (i - 7) * 52;
//				}
//
//				grid.updataInfo(eq[i]);
//				this.addChild(grid);
//			}

//			this.scrollRect=new Rectangle(0, 0, 698, 544);
		}

		private function onChangeTab(e:Event):void {

			if (currentIndex == this.bagTabBar.turnOnIndex)
				return;

			switch (this.bagTabBar.turnOnIndex) {
				case 0:
					this.equipTransRender.clearAllData();
					this.equipRecastRender.clearAllData();
					this.equipReclassRender.clearAllData();
					this.equipBreakRender.clearAllData();
					this.LvupRender.clearAllData();
					this.equipElementRender.clearAllData();

					this.updateEquipIntensify();
					break;
				case 1:
					this.equipIntensifyRender.clearAllData();
					this.equipRecastRender.clearAllData();
					this.equipReclassRender.clearAllData();
					this.equipBreakRender.clearAllData();
					this.LvupRender.clearAllData();
					this.equipElementRender.clearAllData();
					break;
				case 2:
					this.equipIntensifyRender.clearAllData();
					this.equipTransRender.clearAllData();
					this.equipReclassRender.clearAllData();
					this.equipBreakRender.clearAllData();
					this.LvupRender.clearAllData();
					this.equipElementRender.clearAllData();
					GuideManager.getInstance().removeGuide(115);

					break;
				case 3:
					this.equipIntensifyRender.clearAllData();
					this.equipTransRender.clearAllData();
					this.equipRecastRender.clearAllData();
					this.equipReclassRender.updateBagItems();
					this.equipBreakRender.clearAllData();
					this.LvupRender.clearAllData();
					this.equipElementRender.clearAllData();
					break;
				case 4:
					this.equipIntensifyRender.clearAllData();
					this.equipTransRender.clearAllData();
					this.equipRecastRender.clearAllData();
					this.equipReclassRender.clearAllData();
					this.LvupRender.clearAllData();
					this.equipBreakRender.setChange();
					this.equipElementRender.clearAllData();
					GuideManager.getInstance().removeGuide(114);

					break;
				case 5:
					this.equipIntensifyRender.clearAllData();
					this.equipTransRender.clearAllData();
					this.equipRecastRender.clearAllData();
					this.equipReclassRender.clearAllData();
					this.equipBreakRender.clearAllData();
					this.LvupRender.clearAllData();
					this.equipElementRender.clearAllData();
					GuideManager.getInstance().removeGuide(113);

					break;
				case 6:
					this.equipIntensifyRender.clearAllData();
					this.equipTransRender.clearAllData();
					this.equipRecastRender.clearAllData();
					this.equipReclassRender.clearAllData();
					this.equipBreakRender.clearAllData();
					this.LvupRender.clearAllData();

					break;
			}


			if (this.bagTabBar.turnOnIndex != this.currentIndex) {

				this.equipBagRender.update();

				if (this.bagTabBar.turnOnIndex == 6)
					this.equipElementRender.setChangeBag();

				if (EquipStrengGrid.selectState != null) {
					EquipStrengGrid.selectState.setSelectState(false);
					EquipStrengGrid.selectState=null;
				}

				if (EquipStrengGrid.selectStateII != null) {
					EquipStrengGrid.selectStateII.setSelectState(false);
					EquipStrengGrid.selectStateII=null;
				}
			}

			this.equipBagRender.mouseChildren=true;
			UILayoutManager.getInstance().hide(WindowEnum.QUICK_BUY);
			currentIndex=this.bagTabBar.turnOnIndex;
		}

		public function get BagRender():EquipBagRender {
			return this.equipBagRender;
		}

		public function get IntensifyRender():EquipIntensifyRender {
			return this.equipIntensifyRender;
		}

		public function get TransRender():EquipTransRender {
			return this.equipTransRender;
		}

		public function get RecastRender():EquipRecastRender {
			return this.equipRecastRender;
		}

		public function get ReclassRender():EquipReclassRender {
			return this.equipReclassRender;
		}

		public function get BreakRender():EquipBreakRender {
			return this.equipBreakRender;
		}

		public function get LvupRender():EquipLvupRender {
			return this.equipLvupRender;
		}

		public function get ElementRender():EquipElementRender {
			return this.equipElementRender;
		}

		public function setDownItem(binfo:Baginfo, beinfo:EquipInfo):void {
			if (ConfigEnum.EquipTransOpenLv > Core.me.info.level) {
				return;
			}

			this.bagTabBar.turnToTab(1);
			this.equipTransRender.setDownItemOrBody(binfo, beinfo);
		}

		/**
		 * 自动填充装备
		 *
		 */
		private function updateEquipIntensify():void {

			var bvec:Vector.<EquipStrengGrid>=this.equipBagRender.getBodyGridAll();
			var i:int=0;
			var idx:int=0;
			var qh:int=int.MAX_VALUE;
			for (i=0; i < bvec.length; i++) {

				if (bvec[i] != null && bvec[i].data != null && bvec[i].data.tips.qh < 16) {
					this.equipIntensifyRender.setDownItem(bvec[i]);
					break;
				}

			}


		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);

//			this.equipBagRender.update();
//			UIManager.getInstance().backpackWnd.hide();
//			UIManager.getInstance().roleWnd.hide();

			if (ConfigEnum.EquipIntensifyOpenLv > Core.me.info.level) {
				this.hide();
				this.bagTabBar.setTabVisible(0, false);
			} else {
				this.bagTabBar.setTabVisible(0, true);
			}

			if (ConfigEnum.EquipTransOpenLv > Core.me.info.level) {
				this.bagTabBar.setTabVisible(1, false);
			} else {
				this.bagTabBar.setTabVisible(1, true);
			}

			if (ConfigEnum.EquipRecastOpenLv > Core.me.info.level) {
				this.bagTabBar.setTabVisible(2, false);
			} else {
				this.bagTabBar.setTabVisible(2, true);
				GuideManager.getInstance().showGuide(115, this.bagTabBar.getTabButton(2));
			}

			if (ConfigEnum.EquipReclassOpenLv > Core.me.info.level) {
				this.bagTabBar.setTabVisible(3, false);
			} else {
				this.bagTabBar.setTabVisible(3, false);
			}

			if (ConfigEnum.EquipBreakOpenLv > Core.me.info.level) {
				this.bagTabBar.setTabVisible(4, false);
			} else {
				this.bagTabBar.setTabVisible(4, true);
				GuideManager.getInstance().showGuide(114, this.bagTabBar.getTabButton(4));
			}


			if (ConfigEnum.equip24 > Core.me.info.level) {
				this.bagTabBar.setTabVisible(5, false);
			} else {
				this.bagTabBar.setTabVisible(5, true);
				GuideManager.getInstance().showGuide(113, this.bagTabBar.getTabButton(5));
			}

			if (ConfigEnum.ElementOpenLv > Core.me.info.level) {
				this.bagTabBar.setTabVisible(6, false);
			} else {
				this.bagTabBar.setTabVisible(6, true);
			}

			if (EquipStrengGrid.selectState != null) {
				EquipStrengGrid.selectState.setSelectState(false);
				EquipStrengGrid.selectState=null;
			}

			if (EquipStrengGrid.selectStateII != null) {
				EquipStrengGrid.selectStateII.setSelectState(false);
				EquipStrengGrid.selectStateII=null;
			}

			this.equipBagRender.update();

			GuideManager.getInstance().removeGuide(21);
			GuideManager.getInstance().removeGuide(22);
			GuideManager.getInstance().removeGuide(62);
			GuideManager.getInstance().removeGuide(94);

			GuideManager.getInstance().removeGuide(105);
			GuideManager.getInstance().removeGuide(106);

			UIManager.getInstance().taskTrack.setGuideViewhide(TaskEnum.taskType_EquitTopLv);

			this.updateEquipIntensify();

			if (!MyInfoManager.getInstance().isTaskOk && MyInfoManager.getInstance().currentTaskId == 39)
				TweenLite.delayedCall(ConfigEnum.autoTask3, this.autoTaskComplete);
		}

		private function autoTaskComplete():void {
			if (this.bagTabBar.turnOnIndex == 0 && this.visible)
				this.equipIntensifyRender.dispatAutoTaskEvent();
		}

		public function updateBagRender():void {
			this.equipBagRender.update();
		}

		public function changeState(i:int):void {
			this.equipIntensifyRender.changeState(i);
		}

		public function clearItem():void {
			if (EquipStrengGrid.selectState != null) {
				EquipStrengGrid.selectState.setSelectState(false);
				EquipStrengGrid.selectState=null;
			}

			if (EquipStrengGrid.selectStateII != null) {
				EquipStrengGrid.selectStateII.setSelectState(false);
				EquipStrengGrid.selectStateII=null;
			}


			this.equipIntensifyRender.clearAllData();
			this.equipTransRender.clearAllData();
			this.equipRecastRender.clearAllData();
			this.equipReclassRender.clearAllData();
			this.equipBreakRender.clearAllData();
			this.LvupRender.clearAllData();
			this.equipElementRender.clearAllData();

			this.equipBagRender.update();
//			this.equipBagRender.updateBag([-1]);
//			this.equipBagRender.updateMount([-1]);
//			this.equipBagRender.updatebody([-1]);

		}

		/**
		 * @return
		 */
		public function getTabIndex():int {
			return this.bagTabBar.turnOnIndex;
		}


		override public function hide():void {
			super.hide();

			this.equipTransRender.clearAllData();
			this.equipIntensifyRender.clearAllData();
			this.equipRecastRender.clearAllData();
			this.equipReclassRender.clearAllData();

			this.equipBagRender.clearEffect();
			this.equipBagRender.mouseChildren=true;

			UIManager.getInstance().hideWindow(WindowEnum.QUICK_BUY);
			UILayoutManager.getInstance().composingWnd(WindowEnum.EQUIP);

			TweenManager.getInstance().lightingCompnent(UIManager.getInstance().toolsWnd.duanZBtn);

			this.bagTabBar.turnToTab(0);
			UIManager.getInstance().taskTrack.setGuideView(TaskEnum.taskType_EquitTopLv);

			GuideManager.getInstance().removeGuide(113);
			GuideManager.getInstance().removeGuide(114);
			GuideManager.getInstance().removeGuide(115);

			GuideArrowDirectManager.getInstance().delArrow(WindowEnum.EQUIP + "");
		}

		override public function sendOpenPanelProtocol(... parameters):void {
			this.dataModel=parameters;

			UIManager.getInstance().showPanelCallback(WindowEnum.EQUIP);
		}

		public function updateAllGrid():void {
			if (this.visible)
				this.BagRender.update();
		}

		public function resise():void {
			this.x=(UIEnum.WIDTH - this.width) / 2;
			this.y=(UIEnum.HEIGHT - this.height) / 2;
		}

		override public function get height():Number {
			return 544;
		}

		override public function get width():Number {
			return 698;
		}

		public function changeTable(index:int):void {
			this.bagTabBar.turnToTab(index);
		}

		override public function getUIbyID(id:String):DisplayObject {
			var ds:DisplayObject=super.getUIbyID(id);

			if (ds == null)
				ds=equipIntensifyRender.getUIbyID(id);

			return ds;
		}

	}
}

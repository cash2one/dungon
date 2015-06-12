package com.leyou.ui.equip {

	import com.ace.config.Core;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.TweenManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.data.role.EquipInfo;
	import com.leyou.enum.ConfigEnum;
	import com.leyou.enum.TaskEnum;
	import com.leyou.ui.equip.child.EquipBagRender;
	import com.leyou.ui.equip.child.EquipBreakRender;
	import com.leyou.ui.equip.child.EquipIntensifyRender;
	import com.leyou.ui.equip.child.EquipLvupRender;
	import com.leyou.ui.equip.child.EquipRecastRender;
	import com.leyou.ui.equip.child.EquipReclassRender;
	import com.leyou.ui.equip.child.EquipStrengGrid;
	import com.leyou.ui.equip.child.EquipTransRender;

	import flash.events.Event;
	import flash.geom.Rectangle;

	public class EquipWnd extends AutoWindow {

		private var bagTabBar:TabBar;

		private var equipTransRender:EquipTransRender;
		private var equipIntensifyRender:EquipIntensifyRender;
		private var equipRecastRender:EquipRecastRender;
		private var equipReclassRender:EquipReclassRender;
		private var equipBreakRender:EquipBreakRender;
		private var equipLvupRender:EquipLvupRender;

		private var equipBagRender:EquipBagRender;

		private var currentIndex:int=0;

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

			this.bagTabBar.addToTab(this.equipIntensifyRender, 0);
			this.bagTabBar.addToTab(this.equipTransRender, 1);
			this.bagTabBar.addToTab(this.equipRecastRender, 2);
//			this.bagTabBar.addToTab(this.equipReclassRender, 3);
			this.bagTabBar.addToTab(this.equipBreakRender, 4);
			this.bagTabBar.addToTab(this.equipLvupRender, 5);

			this.bagTabBar.addEventListener(TabbarModel.changeTurnOnIndex, onChangeTab);

			//右侧数据
			this.equipBagRender=new EquipBagRender();
			this.addChild(this.equipBagRender);

			this.equipBagRender.x=346;
			this.equipBagRender.y=60;

			this.bagTabBar.turnToTab(0);

			this.scrollRect=new Rectangle(0, 0, 614, 522);
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
					break;
				case 1:
					this.equipIntensifyRender.clearAllData();
					this.equipRecastRender.clearAllData();
					this.equipReclassRender.clearAllData();
					this.equipBreakRender.clearAllData();
					this.LvupRender.clearAllData();
					break;
				case 2:
					this.equipIntensifyRender.clearAllData();
					this.equipTransRender.clearAllData();
					this.equipReclassRender.clearAllData();
					this.equipBreakRender.clearAllData();
					this.LvupRender.clearAllData();
					break;
				case 3:
					this.equipIntensifyRender.clearAllData();
					this.equipTransRender.clearAllData();
					this.equipRecastRender.clearAllData();
					this.equipReclassRender.updateBagItems();
					this.equipBreakRender.clearAllData();
					this.LvupRender.clearAllData();
					break;
				case 4:
					this.equipIntensifyRender.clearAllData();
					this.equipTransRender.clearAllData();
					this.equipRecastRender.clearAllData();
					this.equipReclassRender.clearAllData();
					this.LvupRender.clearAllData();
					this.equipBreakRender.setChange();
					break;
				case 5:
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

		public function setDownItem(binfo:Baginfo, beinfo:EquipInfo):void {
			if (ConfigEnum.EquipTransOpenLv > Core.me.info.level) {
				return;
			}

			this.bagTabBar.turnToTab(1);
			this.equipTransRender.setDownItemOrBody(binfo, beinfo);
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
			}

			if (ConfigEnum.equip24 > Core.me.info.level) {
				this.bagTabBar.setTabVisible(5, false);
			} else {
				this.bagTabBar.setTabVisible(5, true);
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

			UIManager.getInstance().taskTrack.setGuideViewhide(TaskEnum.taskType_EquitTopLv);
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
			return 522;
		}

		override public function get width():Number {
			return 614;
		}

		public function changeTable(index:int):void {
			this.bagTabBar.turnToTab(index);
		}
	}
}

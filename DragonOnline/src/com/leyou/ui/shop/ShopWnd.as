package com.leyou.ui.shop {

	import com.ace.config.Core;
	import com.ace.delayCall.DelayCallManager;
	import com.ace.enum.ItemEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.game.manager.DragManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TShop;
	import com.ace.manager.LibManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.enum.ShopEnum;
	import com.leyou.net.cmd.Cmd_Bag;
	import com.leyou.net.cmd.Cmd_Shp;
	import com.leyou.ui.shop.child.GridShop;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ShopWnd extends AutoWindow {

		private var gridList:ScrollPane;
		private var tabbar:TabBar;
		private var hideItemCheckBox:CheckBox;
		private var selectedIdx:int=-1;
		private var overIdx:int=-1;
		private var renderArr:Vector.<GridShop>;
		private var doubleClick:Boolean;
		private var _evt:MouseEvent;
		private var currentTabIdx:int;
		private var downFlag:Boolean;

		/**
		 * （shopid == 0 为回购商店）
		 * 1 普通
		 */
		public var shopID:int=1;

		private var shop_id:int=shopID;
		private var eventBg:Sprite;

		public function ShopWnd() {
			super(LibManager.getInstance().getXML("config/ui/ShopWnd.xml"));
			this.init();
			this.mouseChildren=true;
		}

		private function init():void {
			this.renderArr=new Vector.<GridShop>;

			this.gridList=this.getUIbyID("gridList") as ScrollPane;
			this.tabbar=this.getUIbyID("tabbar") as TabBar;
			this.hideItemCheckBox=this.getUIbyID("hideItemCheckBox") as CheckBox;

			this.tabbar.addEventListener(TabbarModel.changeTurnOnIndex, onTabBarClick);
			this.tabbar.turnToTab(0);

			this.hideItemCheckBox.addEventListener(MouseEvent.CLICK, onCheckBoxClick);
			this.hideItemCheckBox.turnOn();

			this.eventBg=new Sprite();
			this.eventBg.graphics.beginFill(0x000000);
			this.eventBg.graphics.drawRect(0, 0, 360, 392);
			this.eventBg.graphics.endFill();

			this.eventBg.alpha=0;
			this.eventBg.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);

			this.gridList.addToPane(this.eventBg);

		}

		private function onMouseUp(e:MouseEvent):void {

			if (DragManager.getInstance().grid != null) {

				var g:GridBase=DragManager.getInstance().grid;
				if (g.gridType == ItemEnum.TYPE_GRID_BACKPACK) {
					var tc:Baginfo=MyInfoManager.getInstance().bagItems[g.dataId] as Baginfo;
					if (tc != null)
						Cmd_Bag.cm_bagSell(tc.pos);
				}
			}
		}

		public function updateInfo():void {
			if (!this.visible)
				return;

			var infoXml:XML=LibManager.getInstance().getXML("config/table/shop.xml");
			var xmllist:XMLList=infoXml.shop;

			var render:GridShop;
			for each (render in this.renderArr) {
				if (render != null) {
					this.gridList.delFromPane(render);
					render.die();
				}
			}

			this.renderArr.length=0;

			var i:int=-1;
			var xml:XML
			var infoItem:Object;
			for each (xml in xmllist) {

				i++;

				if (xml.@shopId != this.shopID)
					continue;

				if (xml.@tagId == "3") {
					infoItem=TableManager.getInstance().getItemInfo(xml.@itemId);
				} else {
					infoItem=TableManager.getInstance().getEquipInfo(xml.@itemId);
				}

				if (infoItem == null) {
					throw Error("没有物品id:" + xml.@itemId)
					return;
				}

				if (xml.@tagId != this.currentTabIdx + 1 || xml.@shopId != this.shopID || (((Core.me.info.profession != xml.@Class && xml.@Class != 0) || Core.me.info.level < int(infoItem.level)) && hideItemCheckBox.isOn))
					continue;

				render=new GridShop();
				render.x=(this.renderArr.length % 2) * (render.width) + 5;
				render.y=Math.floor(this.renderArr.length / 2) * (render.height + 1) + 5;
				render.id=i;

				render.updataInfo(new TShop(xml));

				if ((Core.me.info.profession != xml.@Class && xml.@Class != 0) || Core.me.info.level < int(infoItem.level))
					render.redMask=true;

				this.gridList.addToPane(render);
				this.renderArr.push(render);
			}

			this.gridList.scrollTo(0);
			DelayCallManager.getInstance().add(this, this.gridList.updateUI, "updateUI", 4);
		}

		/**
		 * 回购
		 * @param o
		 *
		 */
		public function updateRepo(o:Array):void {

			var render:GridShop;
			for each (render in this.renderArr) {
				if (render != null) {
					this.gridList.delFromPane(render);
					render.die();
				}
			}

			this.renderArr.length=0;

			var i:int=o.length - 1;
			var str:String;
			var table:Object;

			while (i >= 0) {

				render=new GridShop();
				render.x=(this.renderArr.length % 2) * (render.width) + 5;
				render.y=Math.floor(this.renderArr.length / 2) * render.height + 5;
				render.id=int(i);

				if (int(int(o[i][0]) / 10000) == 0)
					table=TableManager.getInstance().getEquipInfo(o[i][0]);
				else
					table=TableManager.getInstance().getItemInfo(o[i][0]);

				if (o[i][2] != null)
					render.tipsInfo=new TipsInfo(o[i][2]);

				render.updataInfo(table);

				if (o[i][1] > 1)
					render.setNum(int(o[i][1]));

				if (o[i][1] > 1)
					render.priceTxt="" + (int(o[i][1]) * int(table.price));

				this.gridList.addToPane(render);
				this.renderArr.push(render);

				i--;
			}

//			if (this.renderArr.length == 0) {
//				render=new GridShop();
//				render.x=(this.renderArr.length % 2) * (render.width) + 5;
//				render.y=Math.floor(this.renderArr.length / 2) * render.height + 5;
//				this.gridList.addToPane(render);
//				this.renderArr.push(render);
//			}

			this.gridList.scrollTo(0);
			DelayCallManager.getInstance().add(this, this.gridList.updateUI, "updateUI", 4);

		}


		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);

			UIManager.getInstance().hideWindow(WindowEnum.EQUIP);
			UIManager.getInstance().hideWindow(WindowEnum.ROLE);
			UIManager.getInstance().hideWindow(WindowEnum.STOREGE);

//			if (!UIManager.getInstance().backpackWnd.fastState)
//				UIManager.getInstance().backpackWnd.show();
//			else

//			UIManager.getInstance().backpackWnd.show(true, UIManager.getInstance().backpackWnd.layer);
//			UIManager.getInstance().roleWnd.hide();

//			this.x=(UIEnum.WIDTH - UIManager.getInstance().backpackWnd.width - this.width) / 2;
//			this.y=(UIEnum.HEIGHT - this.height) / 2;
//
//			UIManager.getInstance().backpackWnd.x=this.x + this.width;
//			UIManager.getInstance().backpackWnd.y=this.y;

			if (this.currentTabIdx == 3) {
				this.shopID=0;
				Cmd_Shp.cm_shpRepo();
			} else {
				this.updateInfo();
			}
		}

		private function onTabBarClick(evt:Event):void {
			if (this.currentTabIdx != this.tabbar.turnOnIndex) {
				UIManager.getInstance().buyWnd.hide();
			}

			this.currentTabIdx=this.tabbar.turnOnIndex;

			if (this.currentTabIdx == 3) {
				this.shopID=0;
				Cmd_Shp.cm_shpRepo();
			} else {
				this.shopID=this.shop_id;
				this.updateInfo();
			}
		}

		public function setTabIndex(i:int):void {
			this.tabbar.turnToTab(i);
		}

		private function onCheckBoxClick(evt:MouseEvent):void {
			if (this.currentTabIdx != 3)
				this.updateInfo();
		}

		public function getCurrentTabIndex():int {
			return this.currentTabIdx;
		}

		public function gridSingleClick(info:Object, id:int):void {

			if (this.currentTabIdx != ShopEnum.TAB_BUYRETURN_IDX) {

				UIManager.getInstance().buyWnd.show();
				UIManager.getInstance().buyWnd.update(info, id);
			} else {
				//回购不弹购买窗口直接购买 等协议
				Cmd_Shp.cm_shpBuy(0, id);
			}

		}

		public function shopId(id:int):void {
			this.shopID=this.shop_id=id;
		}

		public function gridDoubleClick(idx:int, num:int):void {
			//双击直接购买 等协议
			Cmd_Shp.cm_shpBuy(this.shopID, idx, num);
		}

		override public function get width():Number {
			return 408;
		}

		override public function get height():Number {
			return 527;
		}

		override public function hide():void {
			super.hide();
			UIManager.getInstance().buyWnd.hide();

			UILayoutManager.getInstance().composingWnd(WindowEnum.SHOP);

			var render:GridShop;
			for each (render in this.renderArr) {
				if (render != null)
					render.stopMc();
			}

		}

	}
}

package com.leyou.ui.storage {

	import com.ace.delayCall.DelayCallManager;
	import com.ace.enum.CursorEnum;
	import com.ace.enum.ItemEnum;
	import com.ace.enum.UIEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TStorageAdd;
	import com.ace.manager.CursorManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.greensock.TweenMax;
	import com.greensock.core.TweenCore;
	import com.leyou.data.store.StoreInfo;
	import com.leyou.manager.TimerManager;
	import com.leyou.net.cmd.Cmd_Store;
	import com.leyou.ui.backpack.child.BackpackGrid;
	import com.leyou.ui.storage.child.StorageGrid;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class StorageWndView extends AutoWindow {

		private var gridList:ScrollPane;
		private var neatenBtn:NormalButton;
		private var batchSaveBtn:NormalButton;
		private var bagCapacity:Label;
		private var storageTabBar:TabBar;
		private var storebg:Image;

		/**
		 * 是否批量存取
		 */
		public var isbatchSave:Boolean=false;
		public var gridVec:Vector.<StorageGrid>;
		public var showEff:TweenCore;
		public var showbatchEff:TweenCore;

		/**
		 * 金币
		 */
		public var jb:int=0;

		/**
		 * 绑定金币
		 */
		public var bjb:int=0;

		/**
		 * 元宝
		 */
		public var yb:int=0;

		/**
		 * 绑定元宝
		 */
		public var byb:int=0;

		/**
		 * 当前开启的格子数
		 */
		public var itemCount:int=0;

		/**
		 * 当前使用的数量
		 */
		public var currentItemCount:int=0;

		public var openGrid:Boolean=false;
		public var openGridTime:int=0;

		private var neatTimer:int=0;

		public function StorageWndView() {
			super(LibManager.getInstance().getXML("config/ui/StorageWnd.xml"));
			this.init();
		}

		private function init():void {
			//根据数据显示格子，格子用索引保存
			this.gridList=this.getUIbyID("gridList") as ScrollPane;
			this.neatenBtn=this.getUIbyID("neatenBtn") as NormalButton;
			this.batchSaveBtn=this.getUIbyID("batchSaveBtn") as NormalButton;
			this.bagCapacity=this.getUIbyID("bagCapacity") as Label;
			this.storageTabBar=this.getUIbyID("storageTabBar") as TabBar;
			this.storebg=this.getUIbyID("storebg") as Image;

			this.neatenBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.batchSaveBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.storageTabBar.addEventListener(TabbarModel.changeTurnOnIndex, onChangeTab);

			this.gridVec=new Vector.<StorageGrid>();

			var g:StorageGrid;
			for (var i:int=0; i < ItemEnum.BACKPACK_GRID_TOTAL; i++) {
				g=new StorageGrid(i);

				g.x=8 + (i % ItemEnum.GRID_HORIZONTAL) * (ItemEnum.ITEM_BG_WIDTH + ItemEnum.GRID_SPACE);
				g.y=2 + int(i / ItemEnum.GRID_HORIZONTAL) * (ItemEnum.ITEM_BG_HEIGHT + ItemEnum.GRID_SPACE);

				//DragManager.getInstance().addGrid(g);

				this.gridList.addToPane(g);
				this.gridVec.push(g);
			}

			this.storebg.alpha=0;
			this.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		}

		private function onStageMouseUp(e:MouseEvent):void {
			showDragGlowFilter();

			if (!(e.target is StorageGrid))
				return;

			var i:int=this.gridVec.indexOf(e.target as StorageGrid);

		}

		private function onMouseRoll(e:MouseEvent):void {
			if (this.isbatchSave && !this.contains(e.target as DisplayObjectContainer) && !UIManager.getInstance().backpackWnd.contains(e.target as DisplayObjectContainer)) {
				this.batchSaveBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}

		//填充数据
		public function initData(arr:Array):void {

			var store:Array;
			var g:GridBase;
			for (var i:int=0; i < ItemEnum.STORAGE_GRIDE_TOTAL; i++) {

				g=gridVec[i];

				if (this.storageTabBar.turnOnIndex > 0 && (arr.length <= i || arr[0].info == null))
					g.visible=false;
				else
					g.visible=true;

				if (i < ItemEnum.STORAGE_GRIDE_OPEN) {
					if (arr.length <= i)
						g.updataInfo(null);
					else
						g.updataInfo(arr[i]);

					g.canMove=true;
				} else {
					g.isLock=false;
				}
			}

//			this.gridList.scrollTo(0);
//			DelayCallManager.getInstance().add(this, this.gridList.updateUI, "updateUI", 4);

			this.mouseChildren=true;
		}

		public function refresh():void {
			this.updateTab();
		}

		private function updateTab():void {

			switch (this.storageTabBar.turnOnIndex) {
				case -1:
					this.initData(MyInfoManager.getInstance().storeItems);
					break;
				case 0:
					this.initData(MyInfoManager.getInstance().storeItems);
					break;
				case 1:
					changeTab([1]);
					break;
				case 2:
					changeTab([2]);
					break;
				case 3:
					changeTab([3, 10]);
					break;
			}

		}

		/**
		 *
		 *
		 */
		public function updateItemCount():void {
			this.bagCapacity.text=currentItemCount + "/" + itemCount;

			if (itemCount != ItemEnum.STORAGE_GRIDE_OPEN) {
				var len:int=itemCount - ItemEnum.STORAGE_GRIDE_OPEN;
				var g:GridBase;

				for (var i:int=0; i < len; i++) {
					g=this.gridVec[ItemEnum.STORAGE_GRIDE_OPEN + i];
					g.updataInfo(null);
				}

				ItemEnum.STORAGE_GRIDE_OPEN=itemCount;
			}
		}

		private function onChangeTab(e:Event):void {
			updateTab();
		}

		private function changeTab(type:Array, reverse:Boolean=false):void {
			var arr:Array=MyInfoManager.getInstance().storeItems;

			var tmp2:Array=arr.filter(function(item:StoreInfo, _i:int, arr:Array):Boolean {
				if (item != null && item.info != null && type.indexOf(item.info.classid) > -1) {
					return true;
				}
				return false;
			});

			this.initData(tmp2);
		}

		/**
		 *	显示拖拽光圈
		 *
		 */
		public function showDragGlowFilter(v:Boolean=false):void {
			if (!this.visible)
				return;

			//			if (v) {
			//				if (tw == null)
			//					tw=FilterUtil.showGlowFilter(this.glowBg);
			//
			//				tw.play();
			//			} else {
			//				if (tw != null) {
			//					tw.pause();
			//						//tw.kill();
			//				}
			//				this.glowBg.filters=[];
			//			}

		}

		/**
		 * @param e
		 */
		private function onClick(e:MouseEvent):void {
			switch (e.target.name) {
				case "neatenBtn":
					Cmd_Store.cm_storeNeatan();
					this.neatenBtn.setActive(false, .6, true);
					this.neatTimer=30;
					TimerManager.getInstance().add(neatTime);
					break;
				case "getMoneyBtn":

					break;
				case "storageBtn":

					break;
				case "batchSaveBtn":

					isbatchSave=!isbatchSave;

					if (isbatchSave) {
						this.stage.addEventListener(MouseEvent.CLICK, onMouseRoll);
						this.batchSaveBtn.text="取消批量存取";
						CursorManager.getInstance().updataCursor(CursorEnum.CURSOR_HAND);

						this.show(true, UIEnum.WND_LAYER_TOP, false);
						UIManager.getInstance().backpackWnd.show(true, UIEnum.WND_LAYER_TOP, false);
						UIManager.getInstance().backpackWnd.setBatchEnable(false);
						this.neatenBtn.setActive(false, .6, true);
						this.showEffect(true);

					} else {

						this.stage.removeEventListener(MouseEvent.CLICK, onMouseRoll);
						this.batchSaveBtn.text="批量存取";
						this.show(true, UIEnum.WND_LAYER_NORMAL, false);
						UIManager.getInstance().backpackWnd.show(true, UIEnum.WND_LAYER_NORMAL, false);
						CursorManager.getInstance().resetGameCursor();
						UIManager.getInstance().backpackWnd.setBatchEnable(true);

						if (this.neatTimer == 0)
							this.neatenBtn.setActive(true, 1, true);

						this.showEffect(false);
					}

					this.x=(UIEnum.WIDTH - UIManager.getInstance().backpackWnd.width - UIManager.getInstance().storageWnd.width) / 2;
					UIManager.getInstance().backpackWnd.x=UIManager.getInstance().storageWnd.x + UIManager.getInstance().storageWnd.width + 5;
					UIManager.getInstance().storageWnd.y=UIManager.getInstance().backpackWnd.y;

					break;
			}
		}

		public function showEffect(v:Boolean):void {

			if (v) {

				this.storebg.alpha=1;
				showEff=TweenMax.to(this.storebg, 2, {alpha: 0, yoyo: true, repeat: -1});
				if (this.batchSaveBtn.isActive)
					showbatchEff=TweenMax.to(this.batchSaveBtn, 2, {glowFilter: {color: 0xfa9611, alpha: 1, blurX: 12, blurY: 12, strength: 2}, yoyo: true, repeat: -1});

			} else {

				if (showEff != null)
					showEff.kill();

				if (showbatchEff != null)
					showbatchEff.kill();

				showEff=null;
				showbatchEff=null;
				this.batchSaveBtn.filters=[];
				this.storebg.filters=[];
				this.storebg.alpha=0;
			}
		}

		private function neatTime(i:int):void {

			if (this.neatTimer - i == 0) {
				TimerManager.getInstance().remove(neatTime);
				this.neatenBtn.text="整理";
				this.neatenBtn.setActive(true, 1, true);
				this.neatTimer=0;
				return;
			}

			this.neatenBtn.text=(this.neatTimer - i) + "秒";

		}

		//更新一个格子
		public function updatOneGrid(pos:int):void {

			if (this.storageTabBar.turnOnIndex == 0) {
				if (pos > -1)
					this.gridVec[pos].updataInfo(MyInfoManager.getInstance().storeItems[pos]);
			} else {
				this.updateTab();
			}

		}

		public function getTabberIndex():int {
			return this.storageTabBar.turnOnIndex;
		}

		/**
		 * 开启中
		 */
		public function updateOpenGrid():void {
			var badd:TStorageAdd=TableManager.getInstance().getStorAddInfo(this.itemCount + 1);
			this.gridVec[this.itemCount].playCD(badd.addTime * 1000, (badd.addTime - this.openGridTime) * 1000);
			StorageGrid(this.gridVec[this.itemCount]).setShow(true);
		}


		private function getDragIdByDataID(id:int):int {
			var i:int=0;
			var g:GridBase;

			var did:int=-1;
			for (i=ItemEnum.BACKPACK_GRID_TOTAL; i < (ItemEnum.BACKPACK_GRID_TOTAL + ItemEnum.STORAGE_GRIDE_TOTAL); i++) {

				g=this.gridVec[i];

				if (g.dataId == id)
					return g.initId;

				if (did == -1 && g.dataId == -1)
					did=g.initId;
			}

			return did;
		}


		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			//Cmd_Task.cm_merchantDlgSelect(MyInfoManager.getInstance().talkNpcId, TaskEnum.CMD_GETBACK);
			this.setStopPrg(false);
			super.show(toTop, $layer, toCenter);
			this.storageTabBar.turnToTab(0);
//			UIManager.getInstance().roleWnd.hide();
		}

		override public function hide():void {
			super.hide();
			this.cancelBatchStore();

			UIManager.getInstance().backAddWnd.hidewnd(2);
		}

		override public function get width():Number {
			return 369;
		}

		public function cancelBatchStore():void {
			if (this.isbatchSave)
				this.batchSaveBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}

		public function resize():void {
			this.y=(UIEnum.HEIGHT - this.height) / 2;
		}

	}
}

package com.leyou.ui.backpack {

	import com.ace.config.Core;
	import com.ace.delayCall.DelayCallManager;
	import com.ace.enum.CursorEnum;
	import com.ace.enum.FontEnum;
	import com.ace.enum.ItemEnum;
	import com.ace.enum.TipEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TBackpackAdd;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.CursorManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.greensock.TweenMax;
	import com.greensock.data.TransformAroundPointVars;
	import com.greensock.plugins.TransformAroundCenterPlugin;
	import com.greensock.plugins.TransformAroundPointPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.transform.utils.MatrixTools;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.manager.TimerManager;
	import com.leyou.net.cmd.Cmd_Bag;
	import com.leyou.ui.backpack.child.BackpackGrid;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PayUtil;
	import com.leyou.utils.PropUtils;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;

	public class BackpackWndView extends AutoWindow {

		private var gridList:ScrollPane;
		private var storageBtn:NormalButton;
		private var fastShopBtn:NormalButton;
		private var stallBtn:ImgLabelButton;
		private var bagTabBar:TabBar;
		private var coinLbl:Label;
		private var goldLbl:Label;
		private var BagcapacityLbl:Label;
		private var weightLbl:Label;
		private var neatenBtn:NormalButton;
		private var goldbuyLbl:Label;
		private var bgGlow:Sprite;
		private var shopBtn:NormalButton;
		private var goldBoundLbl:Label;
		private var ybBuyLbl:Label;

		private var coinImg:Image;
		private var ybbindImg:Image;
		private var ybImg:Image;
		private var bagbg:Image;
		private var gridVec:Vector.<GridBase>;

		public var selectGridIndex:int=-1;

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
		 *真气
		 */
		public var zq:int=0;

		/**
		 *  荣誉
		 */
		public var honour:int=0;
		
		/**
		 *  巨龙点数
		 */
		public var jl:int=0;
		
		/**
		 *龙魂 
		 */		
		public var lh:int=0;

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

		public var fastState:Boolean=false;

		private var effRect:Sprite;
		public var showEff:TweenMax;
		public var showfastEff:TweenMax;
		private var neatTimer:int=0;

		private var cdType:Array=[];

		/**
		 *bind 显示状态
		 */
		private var bind:Boolean=false;

		/**
		 *禁用类型
		 */
		private var disableType:int=0;

		private var currData:Array=[];

		private var tweenArr:Array=[];


		public function BackpackWndView() {
			super(LibManager.getInstance().getXML("config/ui/BackpackWnd.xml"));
			this.init();
		}

		private function init():void {

			//根据数据显示格子，格子用索引保存
			this.gridList=this.getUIbyID("gridList") as ScrollPane;
			this.storageBtn=this.getUIbyID("storageBtn") as NormalButton;
//			this.stallBtn=this.getUIbyID("stallBtn") as ImgLabelButton;
			this.bagbg=this.getUIbyID("bagbg") as Image;
			this.coinImg=this.getUIbyID("coinImg") as Image;
			this.ybbindImg=this.getUIbyID("ybbindImg") as Image;
			this.ybImg=this.getUIbyID("ybImg") as Image;

			this.fastShopBtn=this.getUIbyID("fastShopBtn") as NormalButton;

			this.neatenBtn=this.getUIbyID("neatenBtn") as NormalButton;
			this.shopBtn=this.getUIbyID("shopBtn") as NormalButton;
			this.bagTabBar=this.getUIbyID("BagTabBar") as TabBar;
			this.coinLbl=this.getUIbyID("coinLbl") as Label;
			this.goldLbl=this.getUIbyID("goldLbl") as Label;
			this.BagcapacityLbl=this.getUIbyID("Bagcapacity") as Label;
			this.weightLbl=this.getUIbyID("weightLbl") as Label;
			this.goldbuyLbl=this.getUIbyID("goldbuyLbl") as Label;
			this.goldBoundLbl=this.getUIbyID("goldBoundLbl") as Label;
			this.ybBuyLbl=this.getUIbyID("ybBuyLbl") as Label;

			this.storageBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.fastShopBtn.addEventListener(MouseEvent.CLICK, onClick);
//			this.stallBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.neatenBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.shopBtn.addEventListener(MouseEvent.CLICK, onClick);

//			this.goldbuyLbl.addEventListener(TextEvent.LINK, onTextLink);
			this.ybBuyLbl.htmlText="<u><a href='event:url_pay' target='_blank'>" + PropUtils.getStringById(1620) + "</a></u>";
			this.ybBuyLbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.ybBuyLbl.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.ybBuyLbl.addEventListener(TextEvent.LINK, onTextLink);
			this.ybBuyLbl.styleSheet=FontEnum.DEFAULT_LINK_STYLE;
			this.ybBuyLbl.mouseEnabled=true;

			this.bagTabBar.addEventListener(TabbarModel.changeTurnOnIndex, onChangeIndex);
			this.gridVec=new Vector.<GridBase>();

			//填充格子
			var g:BackpackGrid;
			for (var i:int=0; i < ItemEnum.BACKPACK_GRID_TOTAL; i++) {

				g=new BackpackGrid(i);

				g.x=4 + (i % ItemEnum.GRID_HORIZONTAL) * (ItemEnum.ITEM_BG_WIDTH + ItemEnum.GRID_SPACE);
				g.y=3 + int(i / ItemEnum.GRID_HORIZONTAL) * (ItemEnum.ITEM_BG_HEIGHT + ItemEnum.GRID_SPACE);

//				DragManager.getInstance().addGrid(g);

				this.gridVec.push(g);
				this.gridList.addToPane(g);
			}

			this.bagbg.alpha=0;

			this.gridList.mouseEnabled=false;
			this.mouseChildren=true;

			var einfo:MouseEventInfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.coinImg, einfo);

			einfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.ybbindImg, einfo);

			einfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.ybImg, einfo);

			this.neatenBtn.scrollRect=new Rectangle(0, 0, 101, 31);

			TweenPlugin.activate([TransformAroundCenterPlugin, TransformAroundPointPlugin]);

		}

		private function onMouseOver(e:MouseEvent):void {
			CursorManager.getInstance().updataCursor(CursorEnum.CURSOR_HAND);
		}

		private function onMouseOut(e:MouseEvent):void {
			CursorManager.getInstance().resetGameCursor();
		}

		private function onTipsMouseOver(e:DisplayObject):void {
			if (e == this.coinImg)
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9555).content, new Point(this.stage.mouseX, this.stage.mouseY));
			else if (e == this.ybbindImg)
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9558).content, new Point(this.stage.mouseX, this.stage.mouseY));
			else if (e == this.ybImg)
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(9559).content, new Point(this.stage.mouseX, this.stage.mouseY));

		}

		private function onTipsMouseOut(e:DisplayObject):void {
			ToolTipManager.getInstance().hide();
		}

		private function onMouseRoll(e:MouseEvent):void {

			if (this.fastState && !this.contains(e.target as DisplayObjectContainer) && e.target.name != "up0CheckBox" && e.target.name != "up1CheckBox" && e.target.name != "up2CheckBox") {
				this.fastShopBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}

		}

		public function cancelFastBuy():void {
			if (this.fastState) {
				this.fastShopBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}

		private function onTextLink(e:TextEvent):void {
//			trace(e.text);
			PayUtil.openPayUrl();
		}

		private function onClick(evt:MouseEvent):void {

			switch (evt.target.name) {
				case "storageBtn":
					UIManager.getInstance().hideWindow(WindowEnum.SHOP);

					if (!UIManager.getInstance().isCreate(WindowEnum.STOREGE))
						UIManager.getInstance().creatWindow(WindowEnum.STOREGE);

					if (UIManager.getInstance().storageWnd.visible)
						UIManager.getInstance().storageWnd.hide();
					else {
//						UIManager.getInstance().storageWnd.visible=true;
						UIManager.getInstance().storageWnd.show(true, UIEnum.WND_LAYER_NORMAL, true);
						UILayoutManager.getInstance().composingWnd(WindowEnum.STOREGE);
					}

					break;
				case "stallBtn":
					UIManager.getInstance().autionWnd.open();
					break;
				case "fastShopBtn":

					GuideManager.getInstance().removeGuide(79);

					this.fastState=!this.fastState;
					evt.stopImmediatePropagation();

					if (this.fastState) {
						this.show(true, UIEnum.WND_LAYER_TOP, false);
						this.stage.addEventListener(MouseEvent.CLICK, onMouseRoll);

						this.shopBtn.setActive(false, .6, true);
						this.storageBtn.setActive(false, .6, true);
						this.neatenBtn.setActive(false, .6, true);
						this.fastShopBtn.text=PropUtils.getStringById(1621);

						CursorManager.getInstance().updataCursor(CursorEnum.CURSOR_SELL);

						UIManager.getInstance().backLotUseWnd.hide();
						UIManager.getInstance().backPackDropWnd.hide();
						UIManager.getInstance().backPackSplitWnd.hide();
						UIManager.getInstance().backAddWnd.hide();

					} else {

						this.stage.removeEventListener(MouseEvent.CLICK, onMouseRoll);
						this.show(true, 1, false);
						this.fastShopBtn.text=PropUtils.getStringById(1622);

						this.shopBtn.setActive(true, 1, true);
						this.storageBtn.setActive(true, 1, true);

						if (this.neatTimer == 0)
							this.neatenBtn.setActive(true, 1, true);

						CursorManager.getInstance().resetGameCursor();
					}

					this.showEffect(this.fastState);

					break;
				case "neatenBtn":
					MyInfoManager.getInstance().bagItems.length=0;
					Cmd_Bag.cm_bagNeatan();
					this.neatenBtn.setActive(false, .6, true);
					this.neatTimer=30;
					TimerManager.getInstance().add(neatTime);
					break;
				case "shopBtn":
					UIManager.getInstance().hideWindow(WindowEnum.STOREGE);

					if (!UIManager.getInstance().isCreate(WindowEnum.SHOP))
						UIManager.getInstance().creatWindow(WindowEnum.SHOP);

					if (UIManager.getInstance().shopWnd.visible)
						UIManager.getInstance().shopWnd.hide();
					else {
						if (this.fastState)
							UIManager.getInstance().shopWnd.show(true, UIEnum.WND_LAYER_TOP);
						else {
//							UIManager.getInstance().shopWnd.visible=true;
							UIManager.getInstance().shopWnd.show(true, UIEnum.WND_LAYER_NORMAL, true);
							UILayoutManager.getInstance().composingWnd(WindowEnum.SHOP);

						}
					}

					break;
			}
		}

		/**
		 * 开启中
		 */
		public function updateOpenGrid():void {
			var badd:TBackpackAdd=TableManager.getInstance().getBagAddInfo(this.itemCount + 1);
			this.gridVec[this.itemCount].playCD(badd.addTime * 1000, (badd.addTime - this.openGridTime) * 1000);
			BackpackGrid(this.gridVec[this.itemCount]).setShow(true);
		}

		/**
		 * tab 选项
		 * @param evt
		 */
		private function onChangeIndex(evt:Event):void {
			updateTab();
		}

		private function updateTab():void {
			switch (this.bagTabBar.turnOnIndex) {
				case -1:
					this.initData(MyInfoManager.getInstance().bagItems);
					break;
				case 0:
					this.currData=this.getBagItemByType([0]); //MyInfoManager.getInstance().bagItems;
					this.initData(this.currData);
					break;
				case 1:
					this.currData=this.getBagItemByType([1]);
					this.initData(this.currData);
					break;
				case 2:
					this.currData=this.getBagItemByType([2]);
					this.initData(this.currData);
					break;
				case 3:
					this.currData=this.getBagItemByType([3, 10]);
					this.initData(this.currData);
					break;
			}
		}

		/**
		 * 更新已有格子时间
		 */
		public function updateItemData():void {

			var binfo:Baginfo;
			var tmp1:Array=this.currData;
			var tmp2:Array=[];

			for (var i:int=0; i < tmp1.length; i++) {
				binfo=tmp1[i];

				if (binfo != null && binfo.info != null) {
//					trace(binfo.aid,BackpackGrid(gridVec[i]).getCDTime())
					if (BackpackGrid(gridVec[i]).getCDTime() > 0) {
						binfo.cdtime=BackpackGrid(gridVec[i]).getCDTime();
//						trace(binfo.cdtime, BackpackGrid(gridVec[i]).getCDTime(), i);
					} else if (BackpackGrid(gridVec[i]).getCDTime() < 0) {
						binfo.cdtime=0;
					}
				}
			}

		}

		public function getBagItemByType(type:Array):Array {

			var binfo:Baginfo;
			var tmp1:Array=this.currData;
			var tmp2:Array=[];

//			for (var i:int=0; i < tmp1.length; i++) {
//				binfo=tmp1[i];
//
//				if (binfo != null && binfo.info != null) {
////					trace(binfo.aid, binfo.cdtime, BackpackGrid(gridVec[i]).getCDTime(), i);
//					if (BackpackGrid(gridVec[i]).getCDTime() > 0) {
//						binfo.cdtime=BackpackGrid(gridVec[i]).getCDTime();
//					} else if (BackpackGrid(gridVec[i]).getCDTime() < 0) {
//						binfo.cdtime=0;
//					}
//				}
//
//			}

			if (type.indexOf(0) > -1) {
				tmp2=MyInfoManager.getInstance().bagItems;
			} else {

				tmp1=MyInfoManager.getInstance().bagItems;
				tmp2=tmp1.filter(function(item:Baginfo, _i:int, arr:Array):Boolean {

					if (item != null && item.info != null && (type.indexOf(item.info.classid) > -1)) {
						return true;
					}

					return false;
				});

			}

			return tmp2;
		}

		/**
		 *
		 */
		public function hidBind(v:Boolean=false):void {
			this.bind=v;
//			this.initData(MyInfoManager.getInstance().bagItems);
			this.updateTab();
		}

		public function getTabberIndex():int {
			return this.bagTabBar.turnOnIndex;
		}

		//填充数据
		public function initData(arr:Array):void {

			var tw:TweenMax;
			for (var t:int=0; i < this.tweenArr.length; i++) {
				tw=this.tweenArr[i] as TweenMax;
				tw.pause();
				tw.kill();
				tw=null;
			}

			this.tweenArr.length=0;

			var carr:Array=[];
			var ctime:int=0;
			var ctx:String;
			var g:GridBase;

			var cross:Boolean=false;
			for (var i:int=0; i < ItemEnum.BACKPACK_GRID_TOTAL; i++) {

				cross=false;
				g=this.gridVec[i] as GridBase;
				if ((this.bagTabBar.turnOnIndex > 0) && (arr[i] == null || arr[i].info == null)){
//					g.visible=false;
					
					BackpackGrid(g).setLockState();
					
				} else {

					if (i < ItemEnum.BACKPACK_GRID_OPEN) {
						if (arr.length > i && arr[i] != null) {
							g.updataInfo(arr[i]); //有数据则填充，无数据则开锁

//							if (arr[i].cdtime > 0)
//								BackpackGrid(g).startCD(arr[i].cdtime);

							ctx=this.cdType[arr[i].info.classid + "_" + arr[i].info.subclassid];
							if (ctx != null) {

								carr=ctx.split("_");
								ctime=getTimer();

								if (ctime - int(carr[0]) < int(carr[1])) {
									BackpackGrid(g).startCD(int(carr[1]) - (ctime - int(carr[0])));
									UIManager.getInstance().toolsWnd.updateCD(arr[i].info.classid + "_" + arr[i].info.subclassid, int(carr[1]) - (ctime - int(carr[0])));
								}

							}

							if (this.bind && arr[i].info.bind == 1) {
								BackpackGrid(g).enableClick=false;
							} else {
								if (this.disableType != 0 && arr[i].info.classid == this.disableType)
									cross=true;

								if (cross)
									g.enable=false;
								else
									g.enable=true;
							}

						} else
							g.updataInfo(null);
					}

					g.visible=true;
				}

				g.scaleX=g.scaleY=1;

				g.x=4 + (i % ItemEnum.GRID_HORIZONTAL) * (ItemEnum.ITEM_BG_WIDTH + ItemEnum.GRID_SPACE);
				g.y=3 + int(i / ItemEnum.GRID_HORIZONTAL) * (ItemEnum.ITEM_BG_HEIGHT + ItemEnum.GRID_SPACE);
			}

			var p:Number=this.gridList.scrollBar_Y.progress;

			this.gridList.updateUI();

			DelayCallManager.getInstance().add(this, this.gridList.scrollTo, "scrollTo", 4, [p]);
			this.gridList.scrollTo(p);

			this.mouseChildren=true;
		}

		/**
		 * 更新数量
		 */
		public function updateItemCount():void {
			this.BagcapacityLbl.text=currentItemCount + "/" + itemCount;

			if (itemCount != ItemEnum.BACKPACK_GRID_OPEN) {

				var len:int=itemCount - ItemEnum.BACKPACK_GRID_OPEN;
				var g:GridBase;

				for (var i:int=0; i < len; i++) {
					g=this.gridVec[ItemEnum.BACKPACK_GRID_OPEN + i];
					g.updataInfo(null);
				}

				ItemEnum.BACKPACK_GRID_OPEN=itemCount;
			}

			MyInfoManager.getInstance().bagItems.length=itemCount;

			if (currentItemCount >= itemCount && this.visible)
				GuideManager.getInstance().showGuide(79, this.fastShopBtn);
			else
				GuideManager.getInstance().removeGuide(79);
		}

		/**
		 *获取剩余cd时间
		 * @param i
		 * @return
		 *
		 */
		public function getGridsCD(i:int):int {
			return BackpackGrid(this.gridVec[i]).getCDTime();
		}

		public function updataMoney():void {
			this.coinLbl.text=ItemUtil.getSplitMoneyTextTo4(jb.toString()); //金币
			this.goldLbl.text=ItemUtil.getSplitMoneyTextTo4(yb.toString()); //元宝
			this.goldBoundLbl.text=ItemUtil.getSplitMoneyTextTo4(byb.toString());
		}

		public function refresh():void {
			updateTab();
		}

		/**
		 *	cd 和 工具栏
		 * @param pos
		 * @param s
		 *
		 */
		public function startGridCD(o:Array):void {

			var tinfo:TItemInfo;
			var _type:String=o[0];

			this.cdType[_type]=getTimer() + "_" + o[1];

			var binfo:Baginfo;
			//工具栏
			UIManager.getInstance().toolsWnd.updateCD(_type, o[1]);

			var vinfo:Array=MyInfoManager.getInstance().bagItems;

			for each (binfo in vinfo) {
				if (binfo != null && binfo.info is TItemInfo) {

					tinfo=TItemInfo(binfo.info);

					if (tinfo.classid + "_" + tinfo.subclassid == _type) {
						BackpackGrid(this.gridVec[binfo.pos]).startCD(int(o[1]));
					}
				}
			}

		}

		/**
		 * 更新cd
		 * @param id
		 * @param s
		 *
		 */
		public function updateGridCD(id:int, s:int=0):void {
			var pos:int=MyInfoManager.getInstance().getBagItemPosByID(id).pos;
			if (pos == -1)
				return;

			BackpackGrid(this.gridVec[pos]).startCD(s);
		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
			this.bagTabBar.turnToTab(0);
		}

		public function setBatchEnable(v:Boolean):void {

			if (v) {
				this.shopBtn.setActive(v, 1, true);
				this.storageBtn.setActive(v, 1, true);

				if (this.neatTimer == 0)
					this.neatenBtn.setActive(v, 1, true);

				this.fastShopBtn.setActive(v, 1, true);
			} else {
				this.shopBtn.setActive(v, .6, true);
				this.storageBtn.setActive(v, .6, true);
				this.neatenBtn.setActive(v, .6, true);
				this.fastShopBtn.setActive(v, .6, true);
			}

			this.showEffect(!v);
		}

		/**
		 * 光圈效果
		 * @param v
		 */
		public function showEffect(v:Boolean):void {

			if (v) {

				this.bagbg.alpha=1;
				showEff=TweenMax.to(this.bagbg, 2, {alpha: 0, yoyo: true, repeat: -1});
				if (this.fastShopBtn.isActive)
					showfastEff=TweenMax.to(this.fastShopBtn, 2, {glowFilter: {color: 0xfa9611, alpha: 1, blurX: 12, blurY: 12, strength: 2}, yoyo: true, repeat: -1});

			} else {

				if (showEff != null)
					showEff.kill();

				if (showfastEff != null)
					showfastEff.kill();

				showEff=null;
				showfastEff=null;
				this.bagbg.filters=[];
				this.fastShopBtn.filters=[];
				this.bagbg.alpha=0;
			}
		}

		private function neatTime(i:int):void {

			if (this.neatTimer - i <= 0) {
				TimerManager.getInstance().remove(neatTime);
				this.neatenBtn.text=PropUtils.getStringById(1623);

				if (this.bagbg.alpha == 0)
					this.neatenBtn.setActive(true, 1, true);

				this.neatTimer=0;
				return;
			} else {
				this.neatenBtn.setActive(false, .6, true);
			}

			this.neatenBtn.text=(this.neatTimer - i) + PropUtils.getStringById(2146);

		}

		public function updateGridEffect(oldArr:Array, newArr:Array):void {

			var arr:Array=[];

			for (var i:int=0; i < ItemEnum.BACKPACK_GRID_TOTAL; i++) {

				if ((newArr[i] != null && (oldArr[i] == null || oldArr[i].aid != newArr[i].aid || oldArr[i].num != newArr[i].num))) {
					arr.push(newArr[i].pos);
				}

			}

			for (i=0; i < arr.length; i++) {
//				this.gridVec[arr[i]].scaleX=this.gridVec[arr[i]].scaleY=1;
//
//				this.gridVec[arr[i]].x=4 + (this.gridVec[arr[i]].dataId % ItemEnum.GRID_HORIZONTAL) * (ItemEnum.ITEM_BG_WIDTH + ItemEnum.GRID_SPACE);
//				this.gridVec[arr[i]].y=3 + int(this.gridVec[arr[i]].dataId / ItemEnum.GRID_HORIZONTAL) * (ItemEnum.ITEM_BG_HEIGHT + ItemEnum.GRID_SPACE);

				this.tweenArr.push(TweenMax.to(this.gridVec[arr[i]], 0.3, {transformAroundCenter: {scaleX: 1.2, scaleY: 1.2}, repeat: 3, yoyo: true}));
			}

		}

		public function updateOneGrid(pos:int):void {
			if (this.bagTabBar.turnOnIndex == 0) {
				if (pos > -1) {
					var binfo:Baginfo=MyInfoManager.getInstance().bagItems[pos];
					this.gridVec[pos].updataInfo(binfo);

					if (binfo == null)
						return;

					var carr:Array=[];
					var ctime:Number=0;
					var ctx:String=this.cdType[binfo.info.classid + "_" + binfo.info.subclassid];

					if (ctx != null) {
						carr=ctx.split("_");
						ctime=getTimer();
						if (ctime - int(carr[0]) < int(carr[1])) {
							BackpackGrid(this.gridVec[pos]).startCD(int(carr[1]) - (ctime - int(carr[0])));
							UIManager.getInstance().toolsWnd.updateCD(binfo.info.classid + "_" + binfo.info.subclassid, int(carr[1]) - (ctime - int(carr[0])));
						}
					}

//					TweenMax.to(this.gridVec[pos], 1, {transformAroundCenter: {scaleX: 1.2,scaleY: 1.2},repeat:3,yoyo:true});
				}


			} else {
				this.updateTab();
			}
		}

		public function setToolsKey(arr:Array):void {

			var info:Baginfo=MyInfoManager.getInstance().getBagItemByID(arr[1]);
			if (info == null || arr[0] > 7)
				return;

			UIManager.getInstance().toolsWnd.updateYaoshuiKey(arr[0], info);

			var carr:Array=[];
			var ctime:Number=0;
			var ctx:String=this.cdType[info.info.classid + "_" + info.info.subclassid];

			if (ctx != null) {
				carr=ctx.split("_");
				ctime=getTimer();
				if (ctime - int(carr[0]) < int(carr[1])) {
					UIManager.getInstance().toolsWnd.updateCD(info.info.classid + "_" + info.info.subclassid, int(carr[1]) - (ctime - int(carr[0])));
				}
			}
		}

		/**
		 * @param type 大类
		 */
		public function setEnableItems(type:int=0):void {
			this.disableType=type;
			this.updateTab();
		}

		override public function hide():void {
			if (this.fastState)
				this.fastShopBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));

			super.hide();

//			var render:GridBase;
//			for each (render in this.gridVec) {
//				if (render != null)
//					render.stopMc();
//			}

		}

	}
}

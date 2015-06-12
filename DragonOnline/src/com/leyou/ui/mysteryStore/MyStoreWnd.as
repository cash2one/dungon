package com.leyou.ui.mysteryStore {

	import com.ace.config.Core;
	import com.ace.delayCall.DelayCallManager;
	import com.ace.enum.TipEnum;
	import com.ace.enum.UIEnum;
	import com.ace.enum.WindowEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.gameData.table.TShop;
	import com.ace.manager.LibManager;
	import com.ace.manager.MouseManagerII;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.child.MouseEventInfo;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.dropMenu.children.ComboBox;
	import com.ace.ui.dropMenu.event.DropMenuEvent;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.ui.tabbar.TabbarModel;
	import com.ace.ui.tabbar.children.TabBar;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.ui.mysteryStore.child.MyStoreRender;
	import com.leyou.utils.PropUtils;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class MyStoreWnd extends AutoWindow {

		private var lvCb:ComboBox;
		private var useCb:CheckBox;
		private var itemList:ScrollPane;
		private var itemCountLbl:Label;
		private var icoImg:Image;

		private var mystorTabar:TabBar;
		private var ryCountLbl:Label;
		private var ryImg:Image;

		private var renderArr:Vector.<MyStoreRender>;

		private var selectLv:int=0;

		private var shopID:int=2;
		private var tagID:int=1;

		private var tips:TipsInfo;

		public function MyStoreWnd() {
			super(LibManager.getInstance().getXML("config/ui/mysteryStore/myStoreWnd.xml"));
			this.init();
			this.mouseChildren=true;
			this.mouseEnabled=true;
			this.hideBg();
			this.titleLbl.visible=false;
		}

		private function init():void {

//			this.lvCb=this.getUIbyID("lvCb") as ComboBox;
			this.useCb=this.getUIbyID("useCb") as CheckBox;
			this.itemCountLbl=this.getUIbyID("itemCountLbl") as Label;
			this.itemList=this.getUIbyID("itemList") as ScrollPane;
			this.icoImg=this.getUIbyID("icoImg") as Image;

			this.mystorTabar=this.getUIbyID("mystorTabar") as TabBar;
			this.ryCountLbl=this.getUIbyID("ryCountLbl") as Label;
			this.ryImg=this.getUIbyID("ryImg") as Image;

			this.addChild(this.icoImg);
			this.addChild(this.ryImg);

//			var infoXml:XML=LibManager.getInstance().getXML("config/table/shop.xml");
//			var xmllist:XMLList=infoXml.shop;

//			var xml:XML;
//			var larr:Array=[{label: PropUtils.getStringById(2148), uid: 0}];
//			var lvarr:Array=[];
//			for each (xml in xmllist) {
//				if (xml.@shopId != this.shopID || int(xml.@tagId) != this.tagID) {
//					continue;
//				}
//
//				if (lvarr.indexOf(int(xml.@itemLv)) == -1) {
//					larr.push({label: int(xml.@itemLv) + PropUtils.getStringById(1812), uid: int(xml.@itemLv)});
//					lvarr.push(int(xml.@itemLv));
//				}
//			}

//			this.lvCb.list.addRends([{label: "全部", uid: 0}, {label: "1级", uid: 1}, {label: "20级", uid: 20}, {label: "40级", uid: 40}, {label: "60级", uid: 60}, {label: "70级", uid: 70}, {label: "80级", uid: 80}, {label: "90级", uid: 90}]);
//			this.lvCb.list.addRends(larr);
//			this.lvCb.addEventListener(DropMenuEvent.Item_Selected, onItemClick);
			this.useCb.addEventListener(MouseEvent.CLICK, onItemSelected);

			var einfo:MouseEventInfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.icoImg, einfo);

			einfo=new MouseEventInfo();
			einfo.onMouseMove=onTipsMouseOver;
			einfo.onMouseOut=onTipsMouseOut;

			MouseManagerII.getInstance().addEvents(this.ryImg, einfo);

			this.tips=new TipsInfo();
			this.tips.itemid=30401;

			this.renderArr=new Vector.<MyStoreRender>();
			this.clsBtn.y=30;

			this.mystorTabar.addEventListener(TabbarModel.changeTurnOnIndex, onChangeIndex);

			var infor:TItemInfo=TableManager.getInstance().getItemInfo(30401);
			this.icoImg.updateBmp("ico/items/" + infor.icon + ".png");
		}

		private function onChangeIndex(e:Event):void {

			if (this.tagID != this.mystorTabar.turnOnIndex + 1) {
				this.selectLv=0;
			}

			this.tagID=this.mystorTabar.turnOnIndex + 1;

//			var infoXml:XML=LibManager.getInstance().getXML("config/table/shop.xml");
//			var xmllist:XMLList=infoXml.shop;
//
//			var xml:XML;
//			var larr:Array=[{label: PropUtils.getStringById(2148), uid: 0}];
//			var lvarr:Array=[];
//			lvarr.length=0;
//
//			for each (xml in xmllist) {
//
//				if (xml.@shopId != this.shopID || int(xml.@tagId) != this.tagID) {
//					continue;
//				}
//
//				if ((((Core.me.info.profession != xml.@Class && xml.@Class != 0) || Core.me.info.level < int(xml.@itemLv)) && useCb.isOn))
//					continue;
//
//				if (lvarr.indexOf(int(xml.@itemLv)) == -1) {
//					larr.push({label: int(xml.@itemLv) + PropUtils.getStringById(1812), uid: int(xml.@itemLv)});
//					lvarr.push(int(xml.@itemLv));
//				}
//
//			}

//			this.lvCb.list.removeRenders();
//			this.lvCb.list.addRends(larr);
//			this.lvCb.list.selectByUid("0");

			this.updateInfo();
		}

		private function onTipsMouseOver(e:DisplayObject):void {
			if (e == this.icoImg) {
				this.tips.isShowPrice=false;
				ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, this.tips, new Point(this.stage.mouseX, this.stage.mouseY));
			} else if (e == this.ryImg)
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, TableManager.getInstance().getSystemNotice(10001).content, new Point(this.stage.mouseX, this.stage.mouseY));
		}

		private function onTipsMouseOut(e:DisplayObject):void {
			ToolTipManager.getInstance().hide();
		}

		private function onItemClick(e:Event):void {

			this.selectLv=this.lvCb.list.value.uid;
			this.updateInfo();
		}

		private function onItemSelected(e:Event):void {

			this.updateInfo();
		}

		public function updateItemNum():void {
			this.itemCountLbl.text="" + MyInfoManager.getInstance().getBagItemNumById(30401);
			this.ryCountLbl.text="" + UIManager.getInstance().backpackWnd.honour;

			if (this.visible)
				this.updateInfo();
		}

		private function updateInfo():void {

			var infoXml:XML=LibManager.getInstance().getXML("config/table/shop.xml");
			var xmllist:XMLList=infoXml.shop;

			var render:MyStoreRender;
			for each (render in this.renderArr) {
				if (render != null && render.parent != null) {
//					render.die();
					this.itemList.delFromPane(render);
				}
			}

			this.renderArr.length=0;

			this.itemCountLbl.text="" + MyInfoManager.getInstance().getBagItemNumById(30401);
			this.ryCountLbl.text="" + UIManager.getInstance().backpackWnd.honour;

			var i:int=-1;
			var xml:XML;
			var infoItem:Object;
			for each (xml in xmllist) {

				i++;

//				if (xml.@shopId != this.shopID || (int(xml.@itemLv) != this.selectLv && this.selectLv != 0) || (Core.me.info.profession != xml.@Class && xml.@Class != 0) || int(xml.@tagId) != this.tagID)
				if (xml.@shopId != this.shopID || int(xml.@tagId) != this.tagID)
					continue;

				infoItem=TableManager.getInstance().getEquipInfo(xml.@itemId);

				if (infoItem == null) {
					throw Error("没有物品id:" + xml.@itemId)
					return;
				}


				if ((((Core.me.info.profession != xml.@Class && xml.@Class != 0) || Core.me.info.level < int(infoItem.level)) && useCb.isOn))
					continue;

				render=new MyStoreRender();
				render.x=(this.renderArr.length % 3) * (render.width + 7) + 5;
				render.y=Math.floor(this.renderArr.length / 3) * (render.height + 7) + 5;
				render.index=i;

				if (xml.@tagId == "2") {
					render.updataInfo(new TShop(xml), int(this.ryCountLbl.text));
				} else if (xml.@tagId == "1") {
					render.updataInfo(new TShop(xml), int(this.itemCountLbl.text));
				}

				this.itemList.addToPane(render);
				this.renderArr.push(render);
			}

			this.itemList.scrollTo(0);
			DelayCallManager.getInstance().add(this, this.itemList.updateUI, "updateUI", 4);
		}

		override public function show(toTop:Boolean=true, $layer:int=1, toCenter:Boolean=true):void {
			super.show(toTop, $layer, toCenter);
			this.updateInfo();
		}

		override public function sendOpenPanelProtocol(... parameters):void {
			this.dataModel=parameters;
			UIManager.getInstance().showPanelCallback(WindowEnum.MYSTORE);
		}

		public function setTabIndex(i:int):void {
			this.mystorTabar.turnToTab(i);
		}

		public function resise():void {
			this.x=(UIEnum.WIDTH - this.width) / 2;
			this.y=(UIEnum.HEIGHT - this.height) / 2;
		}

		override public function hide():void {
			super.hide();

			UIManager.getInstance().buyWnd.hide();
		}

		override public function get width():Number {
			return 874;
		}

	}
}

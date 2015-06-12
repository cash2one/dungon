package com.leyou.ui.shop.child {

	import com.ace.config.Core;
	import com.ace.enum.FontEnum;
	import com.ace.enum.ItemEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.gameData.table.TShop;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.data.role.EquipInfo;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.net.cmd.Cmd_Bag;
	import com.leyou.ui.backpack.child.GridModel;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PropUtils;
	
	import flash.display.Shape;
	import flash.geom.Point;

	public class GridShop extends GridModel {

		private var nameLbl:Label;
//		private var moneyKindLbl:Label;
		private var priceLbl:Label;
		private var _id:int;
		private var lockImg:Image;
		private var unUseImg:Image;
		private var priceImg:Image;
		private var shap:Shape;

		private var info:Object;

		public var itemNum:int=0;

		public var tipsInfo:TipsInfo;

		public function GridShop() {
			super(0);
		}

		override protected function init(hasCd:Boolean=false):void {
			super.init();

			this.isLock=false;
			this.canMove=false;
			this.gridType=ItemEnum.TYPE_GRID_SHOP;

			this.bgBmp.updateBmp("ui/shop/shop_item.jpg");
			this.selectBmp.updateBmp("ui/shop/shop_item_up.jpg");

			this.setChildIndex(this.selectBmp, 1);

			this.topBmp.x=32;
			this.topBmp.y=25;

			this.numLbl.x=30;
			this.numLbl.y=30;

			this.iconBmp.x=8.5;
			this.iconBmp.y=9;

			this.nameLbl=new Label();
			this.nameLbl.x=55;
			this.nameLbl.y=5;
			this.nameLbl.text=PropUtils.getStringById(1877)
			this.addChild(this.nameLbl);

			this.priceImg=new Image("ui/backpack/moneyIco.png");
			this.priceImg.x=55;
			this.priceImg.y=30;
			this.addChild(this.priceImg);

			this.priceLbl=new Label();
			this.priceLbl.x=80;
			this.priceLbl.y=30;
//			this.priceLbl.text="300";
			this.priceLbl.defaultTextFormat=FontEnum.getTextFormat("Gode12ForMoney");

			this.addChild(this.priceLbl);

			this.canMove=true;

			this.shap=new Shape();
			this.shap.graphics.beginFill(0xff0000, .3);
			this.shap.graphics.drawRect(0, 0, 40, 40);
			this.shap.graphics.endFill();

			this.addChild(this.shap);
			this.shap.visible=false;

			this.shap.x=8.5;
			this.shap.y=9;

//			this.tipsInfo=new TipsInfo();

		}

		override public function updataInfo(info:Object):void {

			if (info == null)
				return;

			this.info=info;

			if (info is TShop) {
				this.updateShopInfo(info);
				if (this.tipsInfo == null)
					this.tipsInfo=new TipsInfo();
			} else
				this.updateRepoInfo(info);

			this.disableBmp.x=7;
			this.disableBmp.y=35;

			this.intensifyLbl.y=6;
			this.intensifyLbl.x=50 - this.intensifyLbl.width;

			if (this.disableBmp.visible) {
				this.bindingBmp.x=this.disableBmp.x + this.disableBmp.width;
				this.bindingBmp.y=35;
			} else {
				this.bindingBmp.x=7;
				this.bindingBmp.y=35;
			}

		}

		/**
		 * 普通
		 * @param info
		 *
		 */
		private function updateShopInfo(info:Object):void {

			var infoItem:Object;

			if (info.tagId == "3") {
				infoItem=TableManager.getInstance().getItemInfo(info.itemId);
			} else {
				infoItem=TableManager.getInstance().getEquipInfo(info.itemId);
			}

			super.updataInfo(info);

			this.itemNum=infoItem.maxgroup;

			this.iconBmp.updateBmp("ico/items/" + infoItem.icon + ".png");
			this.iconBmp.setWH(36, 36);
			this.priceImg.updateBmp(ItemUtil.getExchangeIcon(info.moneyId));

			this.nameLbl.text=infoItem.name;
			this.nameLbl.textColor=ItemUtil.getColorByQuality(infoItem.quality);

//			if (Core.me.info.level < int(infoItem.level))
//				this.redMask=true;

			this.priceLbl.text="" + info.moneyNum;

			if (infoItem != null && infoItem.classid == 1)
				this.updateTopIconState(infoItem as TEquipInfo);

			if (infoItem != null && int(infoItem.bind) == 1)
				this.bindingBmp.visible=true;
			else
				this.bindingBmp.visible=false;

			this.topBmp.x=29;
			this.topBmp.y=25;

//			this.canMove=false;

			if (infoItem.effect != null && infoItem.effect != "0") {
				this.playeMc(int(infoItem.effect), new Point(5, 5));
				this.setChildIndex(this.effectMc, 2);
			} else {
				this.stopMc();
			}

		}

		/**
		 * 回购
		 * @param info
		 *
		 */
		private function updateRepoInfo(info:Object):void {

			super.updataInfo(info);

			this.iconBmp.updateBmp("ico/items/" + info.icon + ".png");
			this.iconBmp.setWH(36, 36);
			this.priceImg.updateBmp(ItemUtil.getExchangeIcon(0));

			if (info != null && int(info.bind) == 1)
				this.bindingBmp.visible=true;
			else
				this.bindingBmp.visible=false;

			if (int(this.tipsInfo.qh) > 0)
				this.setIntensify("" + this.tipsInfo.qh);

			if (this.info != null && this.info.classid == 1)
				this.updateTopIconState();

			this.topBmp.x=29; //+ (this.bgBmp.width - 40 - 3);
			this.topBmp.y=25; // + (this.bgBmp.height - 40 - 3);

			this.nameLbl.text=info.name;
			this.nameLbl.textColor=ItemUtil.getColorByQuality(info.quality);

			this.priceLbl.text=info.price;

//			this.canMove=false;

//			if (Core.me.info.profession != info.limit && info.limit != 0)
//				this.reMask=true;

			if (info.effect != null && info.effect != "0") {
				this.playeMc(int(info.effect), new Point(5, 5));
				this.setChildIndex(this.effectMc, 2);
			} else
				this.stopMc();
		}

		private function updateTopIconState(e:TEquipInfo=null):void {

			this.topBmp.visible=true;

			var olist:Array=[];

			if (e != null) {
				olist=ItemEnum.ItemToRolePos[e.subclassid];
			} else {
				olist=ItemEnum.ItemToRolePos[info.subclassid];
			}

			var st:int=-1;
			var roleIndex:int;
			var einfo:EquipInfo;
			var zdl:Number=(e == null ? this.tipsInfo.zdl : PropUtils.getWhiteFighting(e));

			for each (roleIndex in olist) {
				einfo=MyInfoManager.getInstance().equips[roleIndex];

				if (einfo == null || (einfo.tips.zdl < zdl)) {
					st=1;
					break;
				} else if (einfo.tips.zdl > zdl) {
					st=0;
				}
			}

			this.changeTopState(st);
		}

		//经过事件
		override public function mouseOverHandler($x:Number, $y:Number):void {
			super.mouseOverHandler($x, $y);

			if (this.isEmpty)
				return;

			if (this.info is TShop) {
				this.tipsInfo.itemid=this.info.itemId;
				this.tipsInfo.moneyType=this.info.moneyId;
				this.tipsInfo.moneyNum=this.info.moneyNum;
			} else {
				this.tipsInfo.itemid=this.info.id;
				this.tipsInfo.moneyNum=int(this.priceLbl.text);
			}

			this.tipsInfo.istype=1;

			var binfo:Object=TableManager.getInstance().getItemInfo(tipsInfo.itemid);

			if (binfo == null)
				binfo=TableManager.getInstance().getEquipInfo(tipsInfo.itemid);

			var einfo:EquipInfo;
			if (binfo != null && binfo.classid == 1 && binfo.subclassid<13) {

				var olist:Array=ItemEnum.ItemToRolePos[binfo.subclassid];

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

			}

			if (einfo != null) {
				tipsInfo.isdiff=true;
				einfo.tips.isUse=true;
				einfo.tips.isdiff=false;
				ToolTipManager.getInstance().showII([TipEnum.TYPE_EMPTY_ITEM, TipEnum.TYPE_EQUIP_ITEM_DIFF], [this.tipsInfo, einfo.tips], PlayerEnum.DIR_E, new Point(2, 0), this.parent.localToGlobal(new Point(this.x + this.width, this.y + this.height)));
			} else {
				var type:int=TipEnum.TYPE_EMPTY_ITEM;
				
				if (!(info is TShop) &&  info.classid == 10) {
					type=TipEnum.TYPE_GEM_OTHER;
				}
				
				ToolTipManager.getInstance().show(type, tipsInfo, this.parent.localToGlobal(new Point(this.x + this.width, this.y + this.height)));
			}

		}

		override public function mouseMoveHandler($x:Number, $y:Number):void {
			super.mouseMoveHandler($x, $y);
			if (this.isEmpty)
				return;

			var binfo:Object=TableManager.getInstance().getItemInfo(tipsInfo.itemid);

			if (binfo == null)
				binfo=TableManager.getInstance().getEquipInfo(tipsInfo.itemid);

			var einfo:EquipInfo;
			if (binfo != null && binfo.classid == 1 && binfo.subclassid<13) {

				var olist:Array=ItemEnum.ItemToRolePos[binfo.subclassid];

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

				}

			}

			var _type:int=(UIManager.getInstance().shopWnd.getCurrentTabIndex() == 3 ? TipEnum.TYPE_EQUIP_ITEM : TipEnum.TYPE_EMPTY_ITEM);

			if (einfo != null) {
				tipsInfo.isdiff=true;
				einfo.tips.isUse=true;
				einfo.tips.isdiff=false;
				ToolTipManager.getInstance().showII([_type, TipEnum.TYPE_EQUIP_ITEM_DIFF], [this.tipsInfo, einfo.tips], PlayerEnum.DIR_E, new Point(2, 0), this.parent.localToGlobal(new Point(this.x + this.width, this.y + this.height)));
			} else {
				
				if (!(info is TShop) &&  info.classid == 10) {
					_type=TipEnum.TYPE_GEM_OTHER;
				}
				
//				this.tipsInfo.isdiff=false;
				ToolTipManager.getInstance().show(_type, tipsInfo, this.parent.localToGlobal(new Point(this.x + this.width, this.y + this.height)));
			}
		}

		//鼠标离开
		override public function mouseOutHandler():void {
			super.mouseOutHandler();
//			ItemTip.getInstance().hide();
		}

		override public function switchHandler(fromItem:GridBase):void {
//			super.switchHandler(fromItem);
			if (fromItem.gridType == ItemEnum.TYPE_GRID_BACKPACK) {
				if (fromItem) {

					var tc:Baginfo=MyInfoManager.getInstance().bagItems[fromItem.dataId] as Baginfo;
//					var win:WindInfo=WindInfo.getAlertInfo("确认卖出?");
//					win.okFun=okFun;
//					win.showClose=true;
//					PopWindow.showWnd(UIEnum.WND_TYPE_CONFIRM, win, "sell_alert");
//
//					function okFun():void {
					if (tc != null)
						Cmd_Bag.cm_bagSell(tc.pos);
//					}
				}
			}

		}

		public function set reMask(v:Boolean):void {
//			this.shap.visible=v;
		}

		override public function doubleClickHandler():void {
			UIManager.getInstance().shopWnd.gridDoubleClick(this._id, this.itemNum);
		}

		override public function mouseUpHandler($x:Number, $y:Number):void {
			UIManager.getInstance().shopWnd.gridSingleClick(this.info, this._id);
		}

		override public function get data():* {
			return info;
		}

		public function set id(i:int):void {
			this._id=i;
		}

		public function get id():int {
			return this._id;
		}

		public function set priceTxt(p:String):void {
			this.priceLbl.text=p;
		}

		public function setNum(n:int):void {
			this.numLbl.text=n + "";
		}

		public function set selectedFlag(f:Boolean):void {
			if (f)
				this.selectBmp.bitmapData=LibManager.getInstance().getImg("ui/shop/shop_item_up.png");
			else
				this.selectBmp.bitmapData=LibManager.getInstance().getImg("ui/shop/shop_item.png");
		}

		public function set redMask(f:Boolean):void {
//			this.shap.visible=f;
			this.disableBmp.visible=f;
		}

		override public function get width():Number {
			return 168;
		}

		override public function get height():Number {
			return 54;
		}

	}
}

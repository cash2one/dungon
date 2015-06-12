package com.leyou.ui.market.child {
	import com.ace.enum.FilterEnum;
	import com.ace.enum.FontEnum;
	import com.ace.enum.GameFileEnum;
	import com.ace.enum.TipEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TBuffInfo;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.market.MarketItemInfo;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.utils.FilterUtil;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.PropUtils;

	import flash.geom.Point;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class MarketGrid extends GridBase {

		private var rebateImg:Image;
		private var tips:TipsInfo;
		private var numLbl:Label;
//		private var effect:SwfLoader;
		private var count:int;
		public var moneyType:int;
		public var moneyNum:int;
		public var isShowPrice:Boolean=true;
		protected var limitTimeLbl:Label;

		public function MarketGrid() {
		}

		override protected function init(hasCd:Boolean=false):void {
			super.init();

			iconBmp.x=4;
			iconBmp.y=4;
//			var bmp:ScaleBitmap=new ScaleBitmap(LibManager.getInstance().getImg("ui/backpack/bg.png"));
//			bmp.scale9Grid=new Rectangle(3, 3, 20, 20);
//			bmp.setSize(68,68);
//			bgBmp.bitmapData=bmp.bitmapData;
			tips=new TipsInfo();

			rebateImg=new Image("ui/IBShop/market_banner2.png");
			rebateImg.x=19;
			rebateImg.y=20;
			rebateImg.visible=false;
			addChild(rebateImg);

			limitTimeLbl=new Label();
			limitTimeLbl.x=32;
			limitTimeLbl.y=0;
			addChild(limitTimeLbl);

			limitTimeLbl.defaultTextFormat=FontEnum.getTextFormat("Red12");
			limitTimeLbl.filters=[FilterUtil.showBorder(0x000000)];

			limitTimeLbl.text=PropUtils.getStringById(1632);
			limitTimeLbl.visible=false;

//			var bm:ScaleBitmap=new ScaleBitmap(LibManager.getInstance().getImg("ui/backpack/select.png"));
//			bm.scale9Grid=new Rectangle(3,3,20,20);
//			bm.setSize(67,67);
//			selectBmp.bitmapData=bm.bitmapData;

			numLbl=new Label();
			numLbl.textColor=0xffffff;
			numLbl.autoSize=TextFieldAutoSize.NONE;
			numLbl.filters=[FilterEnum.hei_miaobian];
			var tf:TextFormat=numLbl.defaultTextFormat;
			tf.align=TextFormatAlign.RIGHT;
			numLbl.defaultTextFormat=tf;
			numLbl.x=0;
			numLbl.y=45;
			numLbl.width=64;
			numLbl.height=20;
		}

//		public function addEffect():void{
//			if(!effect){
//				effect = new SwfLoader(PnfUtil.getAvatarUrl(99972), null,99972);
////				effect.x = 10;
////				effect.y = 10;
//			}
//			addChild(effect);
//		}

//		public function removeEffect():void{
//			if(effect && contains(effect)){
//				removeChild(effect);
//			}
//		}

		/**
		 * <T>鼠标移入显示TIP</T>
		 *
		 * @param $x 事件坐标X
		 * @param $y 事件坐标Y
		 *
		 */
		public override function mouseOverHandler($x:Number, $y:Number):void {
			this.selectBmp.visible=true;
			var tb:TBuffInfo=TableManager.getInstance().getBuffInfo(dataId);
			if (null != tb) {
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, tb.des, new Point(stage.mouseX, stage.mouseY));
				return;
			}
			// 找到物品信息
			var itemInfo:TItemInfo=TableManager.getInstance().getItemInfo(dataId);
			if ((null != itemInfo) && (6 == itemInfo.classid)) {
				var content:String=itemInfo.name;
				if (count > 10) {
					content+=":" + count;
				}
				ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(this.stage.mouseX + 5, this.stage.mouseY + 5));
			} else {
				//					ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, tips, new Point(this.stage.mouseX + 5, this.stage.mouseY + 5));
				tips.moneyType=moneyType;
				tips.moneyNum=moneyNum;
				tips.isShowPrice=isShowPrice;
				tips.isdiff=false;
				var info:TEquipInfo=TableManager.getInstance().getEquipInfo(tips.itemid);
				if (null != info) {
					if (10 == info.classid) {
						ToolTipManager.getInstance().show(TipEnum.TYPE_GEM_OTHER, tips, new Point(stage.mouseX, stage.mouseY));
						return;
					}
					var wear:Boolean=ItemUtil.showDiffTips(TipEnum.TYPE_EMPTY_ITEM, tips, new Point(stage.mouseX, stage.mouseY));
					if (!wear) {
						ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, tips, new Point(stage.mouseX, stage.mouseY));
					}
				} else {
					ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, tips, new Point(stage.mouseX, stage.mouseY));
				}
			}
		}

		public function udpateByBuff(buffId:int):void {
			dataId=buffId;
			var tb:TBuffInfo=TableManager.getInstance().getBuffInfo(buffId);
			var iconUrl:String=null;
			if (null != tb) {
				iconUrl=GameFileEnum.URL_SKILL_ICO + tb.icon + ".png";
			}
			stopMc();
			iconBmp.updateBmp(iconUrl);
			addChild(numLbl);
		}

		public function updataById(itemId:int):void {
			dataId=itemId;
//			addEffect();
			// 找到物品信息
			var itemInfo:Object=TableManager.getInstance().getItemInfo(dataId);
			if (null == itemInfo) {
				itemInfo=TableManager.getInstance().getEquipInfo(dataId);
			} else {
				limitTimeLbl.visible=(itemInfo.limitTime > 0);
			}
			if (itemInfo.effect1 != null && itemInfo.effect1 != "0") {
				stopMc();
				playeMc(int(itemInfo.effect1));
			} else {
				stopMc();
			}
			tips.itemid=itemId;
			var iconUrl:String=GameFileEnum.URL_ITEM_ICO + itemInfo.icon + ".png";
			iconBmp.updateBmp(iconUrl);
			addChild(numLbl);
		}

		public override function updataInfo(info:Object):void {
//			addEffect();
			dataId=info.itemId;
			rebateImg.visible=info.discount;
			tips.itemid=info.itemId;
			// 找到物品信息
			var itemInfo:Object=TableManager.getInstance().getItemInfo(dataId);
			if (null == itemInfo) {
				itemInfo=TableManager.getInstance().getEquipInfo(dataId);
			} else {
				limitTimeLbl.visible=(itemInfo.limitTime > 0);
			}
			if (itemInfo.effect1 != null && itemInfo.effect1 != "0") {
				stopMc();
				playeMc(int(itemInfo.effect1));
			} else {
				stopMc();
			}
			var iconUrl:String=GameFileEnum.URL_ITEM_ICO + itemInfo.icon + ".png";
			iconBmp.updateBmp(iconUrl);
			if (info is MarketItemInfo) {
				numLbl.visible=false;
				return;
			}
			numLbl.visible=true;
			count=info.count;
			if (info.count > 1 && info.count < 10000) {
				numLbl.text=info.count + "";
			} else if (info.count >= 10000 && info.count < 1000000) {
				numLbl.text=(info.count / 10000).toFixed(1) + PropUtils.getStringById(1532);
			} else if (info.count >= 1000000) {
				numLbl.text=int(info.count / 10000) + PropUtils.getStringById(1532);
			} else if (info.count <= 1) {
				numLbl.text="";
			}
			addChild(numLbl);
		}

		public function clear():void {
			reset();
			dataId=0;
			iconBmp.fillEmptyBmd();
			limitTimeLbl.visible=false;
//			removeEffect();
			numLbl.visible=false;
			filters=null;
			stopMc();
		}
	}
}

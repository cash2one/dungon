package com.leyou.ui.aution.child
{
	import com.ace.enum.FilterEnum;
	import com.ace.enum.GameFileEnum;
	import com.ace.enum.ItemEnum;
	import com.ace.enum.TipEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.manager.UIManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.role.EquipInfo;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.ui.backpack.child.BackpackGrid;
	import com.leyou.utils.ColorUtil;
	import com.leyou.utils.ItemUtil;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * @class 寄售物品格子
	 * @author Administrator
	 * 
	 */	
	public class AutionSaleItemGrid extends GridBase
	{
		private static const NUM_TEXT_FORMAT:TextFormat = new TextFormat("SinSum", 12, 0xffffff, null, null, null, null, null, TextFormatAlign.LEFT);
		
		/**
		 * <T>物品拖入时触发函数</T>
		 */		
		public var dragInListener:Function;
		
		/**
		 * <T>被拖入物品格子连接</T>
		 */		
		public var linkGrid:GridBase;
		
		/**
		 * <T>数量</T>
		 */		
		private var numLbl:Label;
		
		/**
		 * <T>战斗力标识</T>
		 */		
		private var topBmp:Image;
		
		/**
		 * <T>TIP</T>
		 */		
		private var tips:TipsInfo;
		
		// 强化等级显示
		protected var intensifyLbl:Image;
		
		protected var count:int;
		
		public var canDragIn:Boolean;
		
//		private var effectSwf:SwfLoader;
		
		public function AutionSaleItemGrid(id:int=-1){
			super(id);
			init();
		}
		
		/**
		 * <T>初始化</T>
		 * 
		 */		
		protected override function init(hasCd:Boolean=false):void{
			super.init();
			bgBmp.updateBmp("ui/aution/sale_goods_bg.png");
			iconBmp.x = 3;
			iconBmp.y = 3;
			isLock = false;
			canMove = false;
			canDragIn = false;
			topBmp = new Image();
			addChild(topBmp);
			topBmp.visible = false;
			topBmp.x = 24;
			topBmp.y = 24;
			
			numLbl = new Label();
			numLbl.y = 25;
			numLbl.autoSize = TextFieldAutoSize.RIGHT;
			numLbl.defaultTextFormat = NUM_TEXT_FORMAT;
			numLbl.filters = [FilterEnum.hei_miaobian];
			var select:ScaleBitmap = new ScaleBitmap(LibManager.getInstance().getImg("ui/backpack/select.png"));
			select.scale9Grid = new Rectangle(2, 2, 20, 20);
			select.setSize(41, 41);
			selectBmp.bitmapData = select.bitmapData;
			
			this.intensifyLbl=new Image();
			this.addChild(this.intensifyLbl);
			this.intensifyLbl.x=22;
			this.intensifyLbl.y=0;
		}
		
		public function setType(type:String):void{
			gridType = type;
		}
		
		/**
		 * <T>转换物品所属格子</T>
		 * 
		 * @param fromItem 源格子
		 * 
		 */		
		public override function switchHandler(fromItem:GridBase):void{
			if(!canDragIn){
				return;
			}
			if((ItemEnum.TYPE_GRID_AUTIONBUY == gridType) || !(ItemEnum.TYPE_GRID_BACKPACK == fromItem.gridType)){
				return;
			}
			dataId = fromItem.data.info.id;
			var itemInfo:Object = TableManager.getInstance().getItemInfo(dataId);
			if(null == itemInfo){
				itemInfo = TableManager.getInstance().getEquipInfo(dataId);
			}
			if(itemInfo.bind == 1){
				return;
			}
			super.switchHandler(fromItem);
			stopMc();
			fromItem.enable = false;
			if(null != linkGrid){
				linkGrid.enable = true;
			}
			linkGrid = fromItem;
			tips = fromItem.data.tips;
			// 找到物品信息
			if(fromItem is BackpackGrid){
				count = (fromItem as BackpackGrid).data.num;
				numLbl.text = (dataId != 65535 && count > 1) ? (count+"") : "";
				numLbl.x = ItemEnum.ITEM_BG_WIDTH - numLbl.width;
			}
			var iconUrl:String = GameFileEnum.URL_ITEM_ICO + itemInfo.icon + ".png";
			iconBmp.updateBmp(iconUrl, null, false, 36, 36);
			// 执行触发函数
			if(null != dragInListener){
				dragInListener.call(this, dataId);
			}
			if (int(tips.qh) > 0){
				setIntensify("" + tips.qh);
			}
			if (itemInfo.effect != null && itemInfo.effect != "0"){
				stopMc();
				playeMc(int(itemInfo.effect));
			}
			addChild(numLbl);
		}
		
		protected function setIntensify(s:String):void {
			this.intensifyLbl.bitmapData=ColorUtil.getEquipBitmapDataByInt(s);
			this.intensifyLbl.x=40 - this.intensifyLbl.width;
			this.addChild(this.intensifyLbl)
		}
		
		/**
		 * <T>鼠标移入显示TIP</T>
		 * 
		 * @param $x 事件坐标X
		 * @param $y 事件坐标Y
		 * 
		 */		
		public override function mouseOverHandler($x:Number, $y:Number):void{
			this.selectBmp.visible = true;
			if(null != tips){
				// 找到物品信息
				var itemInfo:TItemInfo = TableManager.getInstance().getItemInfo(dataId);
				if((null != itemInfo) && (6 == itemInfo.classid)){
					var content:String = itemInfo.name;
					if(count > 10){
						content += ":"+count;
					}
					ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(this.stage.mouseX + 5, this.stage.mouseY + 5));
				}else{
//					ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, tips, new Point(this.stage.mouseX + 5, this.stage.mouseY + 5));
					var info:TEquipInfo = TableManager.getInstance().getEquipInfo(tips.itemid);
					if(null != info){
						var wear:Boolean = ItemUtil.showDiffTips(TipEnum.TYPE_EQUIP_ITEM, tips, new Point(stage.mouseX, stage.mouseY));
						if(!wear){
							ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, tips, new Point(stage.mouseX, stage.mouseY));							
						}
					}else{
						ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, tips, new Point(stage.mouseX, stage.mouseY));
					}
				}
//				ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, tips, new Point(this.stage.mouseX + 15, this.stage.mouseY + 15));
			}
		}
		
		/**
		 * <T>双击取消寄售</T>
		 * 
		 */		
		public override function doubleClickHandler():void{
			super.doubleClickHandler();
			UIManager.getInstance().autionWnd.clearSale();
		}
		
		/**
		 * <T>更新素物品信息</T>
		 * 
		 * @param info 数据	
		 * 
		 */		
		public override function updataInfo(info:Object):void{
			stopMc();
			// 找到物品信息
			dataId = info.itemId;
			if(0 == dataId){
				dataId = 65535;
			}
			var itemInfo:Object = TableManager.getInstance().getItemInfo(dataId);
			if(null == itemInfo){
				itemInfo = TableManager.getInstance().getEquipInfo(dataId);
			}
			var iconUrl:String = GameFileEnum.URL_ITEM_ICO + itemInfo.icon + ".png";
			iconBmp.updateBmp(iconUrl, null, false, 36, 36);
			count = info.itemCount;
			numLbl.text = (dataId != 65535 && info.itemCount > 1) ? (info.itemCount+"") : "";
			numLbl.x = ItemEnum.ITEM_BG_WIDTH - numLbl.width;
			tips = info.tips;
			tips.itemid = info.itemId;
			updateTopIconState();
			if (int(tips.qh) > 0){
				setIntensify("" + tips.qh);
			}else{
				this.intensifyLbl.bitmapData = null;
			}
			if (itemInfo.effect != null && itemInfo.effect != "0"){
				playeMc(int(itemInfo.effect));
			}
			addChild(numLbl);
			addChild(intensifyLbl);
		}
		
//		private function addEffect(itemInfo:Object):void{
//			if(0 != itemInfo.effect){
//				if(null == effectSwf){
//					effectSwf = new SwfLoader(PnfUtil.getAvatarUrl(itemInfo.effect), null, itemInfo.effect);
//				}
//				effectSwf.update(PnfUtil.getAvatarUrl(itemInfo.effect), null, itemInfo.effect);
//				effectSwf.x = iconBmp.x;
//				effectSwf.y = iconBmp.y;
//				addChild(effectSwf);
//			}else{
//				if(effectSwf && contains(effectSwf)){
//					removeChild(effectSwf);
//				}
//			}
//		}
		
		private function updateTopIconState():void {
			var info:TEquipInfo = TableManager.getInstance().getEquipInfo(dataId);
			if((null == info) || (0 == tips.zdl)){
				topBmp.visible = false;
				return;
			}
			topBmp.visible = true;
			var state:Boolean = false;
			var olist:Array = ItemEnum.ItemToRolePos[info.subclassid];
			for each(var roleIdx:int in olist){
				var equipInfo:EquipInfo = MyInfoManager.getInstance().equips[roleIdx];
				if ((null == equipInfo) || (equipInfo.tips.zdl < tips.zdl)){
					state = true;
					break;
				}
			}
			topBmp.visible = true;
			if(!state){
				topBmp.updateBmp("ui/common/icon_down.png");
			}else{
				topBmp.updateBmp("ui/common/icon_up.png");
			}
		}
		
		/**
		 * <T>清除数据</T>
		 * 
		 */		
		public function clear():void{
			if(null != linkGrid){
				linkGrid.enable = true;
				linkGrid = null;
			}
			tips = null;
//			dragInListener = null;
			intensifyLbl.visible = false;
			iconBmp.fillEmptyBmd();
			numLbl.text = "";
			stopMc();
		}
	}
}
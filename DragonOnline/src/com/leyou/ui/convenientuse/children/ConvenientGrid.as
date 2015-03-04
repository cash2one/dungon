package com.leyou.ui.convenientuse.children
{
	import com.ace.enum.FilterEnum;
	import com.ace.enum.ItemEnum;
	import com.ace.enum.TipEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.lable.Label;
	import com.leyou.data.bag.Baginfo;
	import com.leyou.data.convenient.ConvenientItem;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.utils.ItemUtil;
	
	import flash.geom.Point;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class ConvenientGrid extends GridBase
	{
		private static const NUM_TEXT_FORMAT:TextFormat = new TextFormat("SinSum", 12, 0xffffff, null, null, null, null, null, TextFormatAlign.LEFT);
		
		/**
		 * <T>数量</T>
		 */		
		private var numLbl:Label;

//		private var tips:TipsInfo;
		
		public var bitem:ConvenientItem;
		
		public function ConvenientGrid(id:int=-1){
			super(id);
			init();
		}
		
		/**
		 * <T>初始化</T>
		 * 
		 */		
		protected override function init(hasCd:Boolean=false):void{
			super.init();
			bgBmp.updateBmp("ui/tips/TIPS_bg_frame.png");
			iconBmp.x = 3;
			iconBmp.y = 3;
			
			numLbl = new Label();
			addChild(numLbl);
			numLbl.y = 50;
			numLbl.autoSize = TextFieldAutoSize.RIGHT;
			numLbl.defaultTextFormat = NUM_TEXT_FORMAT;
			numLbl.filters = [FilterEnum.hei_miaobian];
//			var select:ScaleBitmap = new ScaleBitmap(LibManager.getInstance().getImg("ui/backpack/select.png"));
//			select.scale9Grid = new Rectangle(2, 2, 20, 20);
//			select.setSize(67, 67);
//			selectBmp.bitmapData = select.bitmapData;
		}
		
		/**
		 * <T>鼠标移入显示TIP</T>
		 * 
		 * @param $x 事件坐标X
		 * @param $y 事件坐标Y
		 * 
		 */		
		public override function mouseOverHandler($x:Number, $y:Number):void{
			if(dataId <= 0){
				return;
			}
			super.mouseOverHandler($x, $y);
			if(null != item){
				var info:TEquipInfo = TableManager.getInstance().getEquipInfo(bitem.bagInfo.tips.itemid);
				if(null != info){
					var wear:Boolean = ItemUtil.showDiffTips(TipEnum.TYPE_EQUIP_ITEM, bitem.bagInfo.tips, new Point(stage.mouseX, stage.mouseY));
					if(!wear){
						ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, bitem.bagInfo.tips, new Point(stage.mouseX, stage.mouseY));							
					}
				}else{
					ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, bitem.bagInfo.tips, new Point(stage.mouseX, stage.mouseY));
				}
//				ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, tips, new Point(stage.mouseX + 15, stage.mouseY + 15));
			}
		}
		
		/**
		 * <T>更新素物品信息</T>
		 * 
		 * @param info 数据	
		 * 
		 */		
		public override function updataInfo(info:Object):void{
			if(info==null){
				return;
			}
			reset();
			unlocking();
			bitem = info as ConvenientItem;
			var bagInfo:Baginfo = info.bagInfo;
//			tips = MyInfoManager.getInstance().bagItems[bagInfo.pos];
			numLbl.x = 65 - numLbl.textWidth-3;
			numLbl.text = (bagInfo.num > 1) ? bagInfo.num + "" : "";
			iconBmp.updateBmp("ico/items/" + bagInfo.info.icon + ".png");
			iconBmp.x = (ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) >> 1;
			iconBmp.y = (ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) >> 1
			dataId = bitem.bagInfo.pos;
			if (bagInfo.info.effect1 != null && bagInfo.info.effect1 != "0"){
				stopMc();
				playeMc(int(bagInfo.info.effect1));
				addChild(numLbl);
			}
		}
	}
}
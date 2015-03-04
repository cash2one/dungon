package com.leyou.ui.copy.child
{
	import com.ace.enum.FilterEnum;
	import com.ace.enum.GameFileEnum;
	import com.ace.enum.ItemEnum;
	import com.ace.enum.TipEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.lable.Label;
	import com.leyou.data.tips.TipsInfo;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class CopyRewardGrid extends GridBase
	{
		private static const NUM_TEXT_FORMAT:TextFormat = new TextFormat("SinSum", 12, 0xffffff, null, null, null, null, null, TextFormatAlign.LEFT);
		
		private var numLbl:Label;
		
		private var tips:TipsInfo;
		
		public var type:String;
		
		public var count:int;
		
		public function CopyRewardGrid(id:int=-1, hasCd:Boolean=false){
			super(id, hasCd);
			init();
		}
		
		
		/**
		 * <T>初始化</T>
		 * 
		 */		
		protected override function init(hasCd:Boolean=false):void{
			super.init();
			numLbl = new Label();
			addChild(numLbl);
			numLbl.y = 25;
			numLbl.autoSize = TextFieldAutoSize.RIGHT;
			numLbl.defaultTextFormat = NUM_TEXT_FORMAT;
			numLbl.filters = [FilterEnum.hei_miaobian];
			
			tips = new TipsInfo();
			
			gridType = ItemEnum.TYPE_GRID_COPYREWARD;
			bgBmp.updateBmp("ui/common/common_icon_bg.png");
			var select:ScaleBitmap = new ScaleBitmap(LibManager.getInstance().getImg("ui/backpack/select.png"));
			select.scale9Grid = new Rectangle(2, 2, 20, 20);
			select.setSize(41, 41);
			selectBmp.bitmapData = select.bitmapData;
		}
		
		public function setCount($count:int):void{
			numLbl.text = $count+"";
			count = $count;
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
			if((null != tips) && (0 < dataId)){
				// 找到物品信息
				var itemInfo:TItemInfo = TableManager.getInstance().getItemInfo(dataId);
				if((null != itemInfo) && (6 == itemInfo.classid) && (count > 99)){
					var content:String = itemInfo.name;
					//					if(count > 10){
					content += ":"+count;
					//					}
					ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(this.stage.mouseX + 15, this.stage.mouseY + 15));
				}else{
					tips.isShowPrice = (null == itemInfo);
					ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, tips, new Point(this.stage.mouseX + 15, this.stage.mouseY + 15));
				}
			}
		}
		
		
		/**
		 * <T>设置格子的物品信息</T>
		 * 
		 */
		public override function updataInfo(info:Object):void {
			reset();
			dataId = info.itemId;
			tips.itemid = dataId;
			var sourceName:String;
			// 找到物品信息
			var itemInfo:Object = TableManager.getInstance().getItemInfo(dataId);
			if(null != itemInfo){
				sourceName = itemInfo.icon + ".png";
			}else{
				itemInfo = TableManager.getInstance().getEquipInfo(dataId);
				//				if(null != equInfo){
				sourceName = itemInfo.icon + ".png";
				//				}else{
				//					itemInfo = TableManager.getInstance().getItemInfo(65535);
				//					sourceName = itemInfo.icon + ".png";
				//				}
			}
			if(info.count > 1 && info.count < 10000){
				numLbl.text = info.count+"";
			}else if(info.count >= 10000 && info.count < 1000000){
				numLbl.text = (info.count/10000).toFixed(1) + "万";
			}else if(info.count >= 1000000){
				numLbl.text = int(info.count/10000) + "万";
			}else if(info.count <= 0){
				numLbl.text = "";
			}
			count = info.count;
			var iconUrl:String = GameFileEnum.URL_ITEM_ICO + sourceName;
			iconBmp.updateBmp(iconUrl, null, false, 35, 35);
			numLbl.x = ItemEnum.ITEM_BG_WIDTH - numLbl.width;
			iconBmp.x = (ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) >> 1;
			iconBmp.y = (ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) >> 1;
			if (itemInfo && (null != itemInfo.effect) && (itemInfo.effect != "0")){
				stopMc();
				playeMc(int(itemInfo.effect));
			}
			addChild(numLbl);
		}
		
		public function clear():void{
			tips.itemid = 0;
			iconBmp.fillEmptyBmd();
			dataId = 0;
		}
	}
}
package com.leyou.ui.mail.child
{
	import com.ace.enum.FilterEnum;
	import com.ace.enum.FontEnum;
	import com.ace.enum.GameFileEnum;
	import com.ace.enum.ItemEnum;
	import com.ace.enum.TipEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.utils.ColorUtil;
	import com.leyou.utils.FilterUtil;
	import com.leyou.utils.ItemUtil;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class MaillGrid extends GridBase
	{
		private static const NUM_TEXT_FORMAT:TextFormat = new TextFormat("SinSum", 12, 0xffffff, null, null, null, null, null, TextFormatAlign.LEFT);
		
		private var numLbl:Label;
		
		private var tips:TipsInfo;
		
		public var type:String="";
		
		private var count:int;
		
		protected var limitTimeLbl:Label;
		
		// 强化等级显示
		protected var intensifyLbl:Image;
		
		public var isShowPrice:Boolean;
		
		public function MaillGrid(id:int=0) {
			super(id);
		}
		
		override protected function init(hasCd:Boolean=false):void {
			super.init();
			numLbl = new Label();
			addChild(numLbl);
			numLbl.y = 25;
			numLbl.autoSize = TextFieldAutoSize.RIGHT;
			numLbl.defaultTextFormat = NUM_TEXT_FORMAT;
			numLbl.filters = [FilterEnum.hei_miaobian];
			
			limitTimeLbl=new Label();
			limitTimeLbl.x=12;
			limitTimeLbl.y=0;
			addChild(limitTimeLbl);
			
			limitTimeLbl.defaultTextFormat=FontEnum.getTextFormat("Red12");
			limitTimeLbl.filters=[FilterUtil.showBorder(0x000000)];
			
			limitTimeLbl.text="限时";
			limitTimeLbl.visible=false;
			
			tips = new TipsInfo();
			
			gridType = ItemEnum.TYPE_GRID_MAIL;
			bgBmp.updateBmp("ui/icon/icon_bg_0.png");
			var select:ScaleBitmap = new ScaleBitmap(LibManager.getInstance().getImg("ui/backpack/select.png"));
			select.scale9Grid = new Rectangle(2, 2, 20, 20);
			select.setSize(41, 41);
			selectBmp.bitmapData = select.bitmapData;
			
			intensifyLbl=new Image();
			addChild(intensifyLbl);
			intensifyLbl.x=22;
			intensifyLbl.y=0;
			isShowPrice = false;
		}
		
		/**
		 * <T>鼠标移入显示TIP</T>
		 * 
		 * @param $x 事件坐标X
		 * @param $y 事件坐标Y
		 * 
		 */		
		public override function mouseOverHandler($x:Number, $y:Number):void{
			selectBmp.visible = true;
			if((null != tips) && (0 != dataId)){
				// 找到物品信息
				var itemInfo:TItemInfo = TableManager.getInstance().getItemInfo(dataId);
				if((null != itemInfo) && (6 == itemInfo.classid)){
					var content:String = itemInfo.name;
					if(count > 10){
						content += ":"+count;
					}
					ToolTipManager.getInstance().show(TipEnum.TYPE_DEFAULT, content, new Point(stage.mouseX + 5, stage.mouseY + 5));
				}else{
					//					ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, tips, new Point(stage.mouseX + 5, stage.mouseY + 5));
					tips.isShowPrice = isShowPrice;
					var info:TEquipInfo = TableManager.getInstance().getEquipInfo(tips.itemid);
					if(null != info){
						if(10 == info.classid){
							ToolTipManager.getInstance().show(TipEnum.TYPE_GEM_OTHER, tips, new Point(stage.mouseX, stage.mouseY));
							return;
						}
						var tipType:int = tips.hasOwner() ? TipEnum.TYPE_EQUIP_ITEM : TipEnum.TYPE_EMPTY_ITEM;
						var wear:Boolean = ItemUtil.showDiffTips(tipType, tips, new Point(stage.mouseX, stage.mouseY));
						if(!wear){
							if(tips.hasOwner()){
								ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, tips, new Point(stage.mouseX, stage.mouseY));							
							}else{
								ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, tips, new Point(stage.mouseX, stage.mouseY));
							}
						}
					}else{
						ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, tips, new Point(stage.mouseX, stage.mouseY));
					}
				}
//				ToolTipManager.getInstance().show(TipEnum.TYPE_EMPTY_ITEM, tips, new Point(stage.mouseX + 15, stage.mouseY + 15));
			}
		}
		
		public function updateInfo(itemId:int,$count:int=0):void{
			count = $count;
			dataId = itemId;
			tips.itemid = dataId;
			var sourceName:String;
			var itemInfo:Object = TableManager.getInstance().getItemInfo(dataId);
			if(null != itemInfo){
				sourceName = itemInfo.icon + ".png";
				limitTimeLbl.visible = (itemInfo.limitTime > 0);
			}else{
				itemInfo = TableManager.getInstance().getEquipInfo(dataId);
				if(null != itemInfo){
					sourceName = itemInfo.icon + ".png";
				}else{
					itemInfo = TableManager.getInstance().getItemInfo(65535);
					sourceName = itemInfo.icon + ".png";
				}
			}
			var iconUrl:String = GameFileEnum.URL_ITEM_ICO + sourceName;
			iconBmp.updateBmp(iconUrl, null, false, 35, 35);
			if(count > 10000){
				numLbl.text = int(count/10000) + "万";
			}else if(count > 1){
				numLbl.text = count+"";
			}else{
				numLbl.text = "";
			}
			numLbl.x = ItemEnum.ITEM_BG_WIDTH - numLbl.width;
			iconBmp.x = (ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) >> 1;
			iconBmp.y = (ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) >> 1;
			if (itemInfo.effect != null && itemInfo.effect != "0"){
				stopMc();
				playeMc(int(itemInfo.effect));
			}
			addChild(numLbl);
		}
		
		
		/**
		 * <T>设置格子的物品信息</T>
		 * 
		 */
		public  function setProperty($type:String, $dataId:uint, $count:int, qh:int=0):void {
			reset();
			count = $count;
			type = $type;
			dataId = $dataId;
			tips.itemid = dataId;
			var sourceName:String;
			// 找到物品信息
			var itemInfo:Object = TableManager.getInstance().getItemInfo(dataId);
			if(null != itemInfo){
				sourceName = itemInfo.icon + ".png";
				limitTimeLbl.visible = (itemInfo.limitTime > 0);
			}else{
				itemInfo = TableManager.getInstance().getEquipInfo(dataId);
				sourceName = itemInfo.icon + ".png";
			}
			var iconUrl:String = GameFileEnum.URL_ITEM_ICO + sourceName;
			iconBmp.updateBmp(iconUrl, null, false, 35, 35);
			if(count > 10000){
				numLbl.text = int(count/10000) + "万";
			}else if(count > 1){
				numLbl.text = count+"";
			}else{
				numLbl.text = "";
			}
			numLbl.x = ItemEnum.ITEM_BG_WIDTH - numLbl.width;
			iconBmp.x = (ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) >> 1;
			iconBmp.y = (ItemEnum.ITEM_BG_WIDTH - ItemEnum.ITEM_ICO_WIDTH) >> 1;
			if (itemInfo.effect != null && itemInfo.effect != "0"){
				stopMc();
				playeMc(int(itemInfo.effect));
			}
			if (qh > 0){
				setIntensify("" + qh);
			}else{
				intensifyLbl.bitmapData = null;
			}
			addChild(numLbl);
		}
		
		protected function setIntensify(s:String):void {
			intensifyLbl.bitmapData=ColorUtil.getEquipBitmapDataByInt(s);
			intensifyLbl.x=40 - intensifyLbl.width;
			addChild(intensifyLbl)
		}
		
		/**
		 * <T>清除现有数据</T>
		 *
		 */
		public function clear():void{
			dataId = 0;
			type = null;
			numLbl.htmlText = "";
			limitTimeLbl.visible = false;
			iconBmp.fillEmptyBmd();
			stopMc();
			intensifyLbl.bitmapData = null;
		}
	}
}
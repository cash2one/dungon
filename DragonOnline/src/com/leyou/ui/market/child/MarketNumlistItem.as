package com.leyou.ui.market.child {
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.LibManager;
	import com.ace.manager.ToolTipManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.utils.ItemUtil;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class MarketNumlistItem extends AutoSprite {
		
		private var nameLbl:Label;
		private var rankLbl:Label;
		private var applyNumLbl:Label;
		private var dataId:uint;
		public var id:int;
		private var tips:TipsInfo;
		
		public function MarketNumlistItem() {
			super(LibManager.getInstance().getXML("config/ui/market/marketNumlist.xml"));
			this.init();
		}

		/**
		 * <T>加载</T>
		 * 
		 */		
		private function init():void {
			mouseChildren = true;
			tips = new TipsInfo();
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.rankLbl=this.getUIbyID("rankLbl") as Label;
			this.applyNumLbl=this.getUIbyID("applyNumLbl") as Label;
			nameLbl.mouseEnabled = true;
			nameLbl.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			if((null != tips) && (0 < dataId)){
				tips.itemid = dataId;
				ToolTipManager.getInstance().show(TipEnum.TYPE_EQUIP_ITEM, tips, new Point(this.stage.mouseX + 15, this.stage.mouseY + 15));
			}
		}
		
		/**
		 * <T>更新数据信息</T>
		 * 
		 * @param info 数据
		 * 
		 */		
		public function updateInfo($dataId:uint, rank:int, applyCount:uint):void{
			dataId = $dataId;
			var itemName:String;
			var color:uint;
			// 找到物品信息
			var itemInfo:TItemInfo = TableManager.getInstance().getItemInfo(dataId);
			if(null != itemInfo){
				itemName = itemInfo.name;
				color = ItemUtil.getColorByQuality((itemInfo.quality));
			}else{
				var equInfo:TEquipInfo = TableManager.getInstance().getEquipInfo(dataId);
				if(null != equInfo){
					itemName = equInfo.name;
					color = ItemUtil.getColorByQuality((equInfo.quality));
				}
			}
			rankLbl.text = rank+"";
			applyNumLbl.text = applyCount+"";
			nameLbl.htmlText = "<Font face='SimSun' size = '12' color='#"+ color.toString(16).replace("0x") + "'>" + itemName + "</Font>";
		}
		
		public override function die():void{
			nameLbl = null;
			rankLbl = null;
			applyNumLbl = null;
		}
		
	}
}
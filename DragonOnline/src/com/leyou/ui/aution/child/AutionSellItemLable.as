package com.leyou.ui.aution.child {
	import com.ace.enum.ItemEnum;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.ImgLabelButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.aution.AutionItemData;
	import com.leyou.net.cmd.Cmd_Aution;
	import com.leyou.utils.ItemUtil;
	import com.leyou.utils.StringUtil_II;
	
	import flash.events.MouseEvent;
	
	public class AutionSellItemLable extends AutoSprite {
		
		private var lvLbl:Label;
		private var nameLbl:Label;
		private var goldLbl:Label;
		private var grid:AutionSaleItemGrid;
		private var cancelBtn:ImgLabelButton;
		private var bgImg:Image;
		private var currencyImg:Image;
		private var dataLink:AutionItemData;
		
		public function AutionSellItemLable() {
			super(LibManager.getInstance().getXML("config/ui/aution/autionSellItemLable.xml"));
			this.init();
		}
		
		/**
		 * <T>初始化</T>
		 * 
		 */		
		private function init():void{
			this.mouseChildren = true;
			this.lvLbl = this.getUIbyID("lvLbl") as Label;
			this.nameLbl = this.getUIbyID("nameLbl") as Label;
			this.goldLbl = this.getUIbyID("goldLbl") as Label;
			this.cancelBtn = this.getUIbyID("cancelBtn") as ImgLabelButton;
			this.bgImg = this.getUIbyID("bgImg") as Image;
			this.currencyImg = this.getUIbyID("currencyImg") as Image;
			this.cancelBtn.addEventListener(MouseEvent.CLICK, onClick);
			
			grid = new AutionSaleItemGrid();
			grid.setType(ItemEnum.TYPE_GRID_AUTIONBUY);
			addChild(grid);
		}
		
		/**
		 * <T>设置背景图</T>
		 * 
		 * @param id 所在列表编号
		 * 
		 */
		public function setBackGround(id:int):void{
			var path:String = ((id&1) == 0) ? "ui/aution/sale_log_bg_01.png" : "ui/aution/sale_log_bg_02.png";
			bgImg.updateBmp(path);
		}
		
		/**
		 * <T>取消出售按钮监听</T>
		 * 
		 * @param evt 事件
		 * 
		 */
		private function onClick(evt:MouseEvent):void{
			Cmd_Aution.cm_Aution_C(dataLink.id);
		}
		
		/**
		 * <T>更新出售项信息</T>
		 * 
		 * @param info 数据
		 * 
		 */	
		public function updateInfo(data:AutionItemData):void{
			dataLink = data;
			grid.updataInfo(data);
			var color:uint;
			// 找到物品信息
			var info:Object = TableManager.getInstance().getItemInfo(data.itemId);
			if(null == info){
				info = TableManager.getInstance().getEquipInfo(data.itemId);
			}
			var n:String = info.name;
			n = (65535 == data.itemId) ? ""+n+data.itemCount : ""+n;
			color = ItemUtil.getColorByQuality(parseInt(info.quality));
			nameLbl.htmlText = "<Font face='SimSun' size = '12' color='#"+ color.toString(16).replace("0x") + "'>" + n + "</Font>";
			if(65535 == data.itemId){
				lvLbl.text = "1";
			}else{
				lvLbl.text = data.level+"";
			}
			var sourcePath:String = ItemUtil.getExchangeIcon(data.moneyType);
			currencyImg.updateBmp(sourcePath);
			goldLbl.text = StringUtil_II.sertSign(data.price);
			
		}
	}
}

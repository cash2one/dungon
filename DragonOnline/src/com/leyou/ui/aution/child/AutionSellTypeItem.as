package com.leyou.ui.aution.child {
	import com.ace.enum.ItemEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.manager.TableManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.button.children.RadioButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.Label;
	import com.leyou.net.cmd.Cmd_Aution;
	import com.leyou.utils.ItemUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class AutionSellTypeItem extends AutoSprite {

		public var nameLbl:Label;
		private var goldLbl:Label;
//		private var ybLbl:Label;
//		private var typeCb:ComboBox;
		private var goldTxt:TextInput;
		private var confirmBtn:NormalButton;
//		private var moneyImg:Image;
		private var selectMoneyImg:Image;
//		private var jbBtn:RadioButton;
//		private var ybBtn:RadioButton;
//		private var ybImg:Image;

		private var grid:AutionSaleItemGrid;
		public var switchGrid:Boolean;
		
		private const currencyType:int = 2;
		
		public function AutionSellTypeItem() {
			super(LibManager.getInstance().getXML("config/ui/aution/autionSellTypeItem.xml"));
			this.init();
		}

		/**
		 * <T>初始化</T>
		 * 
		 */		
		private function init():void {
			this.mouseChildren = true;
			this.nameLbl = this.getUIbyID("nameLbl") as Label;
			this.goldLbl = this.getUIbyID("goldLbl0") as Label;
//			this.typeCb = this.getUIbyID("typeCb") as ComboBox;
			this.goldTxt = this.getUIbyID("goldTxt") as TextInput;
			this.confirmBtn = this.getUIbyID("confirmBtn") as NormalButton;
//			this.moneyImg = this.getUIbyID("moneyImg") as Image;
			this.selectMoneyImg = this.getUIbyID("selectMoneyImg") as Image;
//			this.jbBtn = this.getUIbyID("jbBtn") as RadioButton;
//			this.ybBtn = this.getUIbyID("ybBtn") as RadioButton;
//			this.ybLbl = this.getUIbyID("ybLbl") as Label;
//			this.ybBtn.visible = false;
//			this.ybImg = this.getUIbyID("ybImg") as Image;
//			this.ybImg.visible = false;
//			this.jbBtn.turnOn();
			this.nameLbl.text = "";
//			this.goldLbl.text = "0";
			this.goldTxt.text = "0";
//			this.ybLbl.text = "0";
			this.goldTxt.restrict = "[0-9]";
			this.goldTxt.input.maxChars = 9;
			this.goldTxt.addEventListener(MouseEvent.CLICK, onTextSelect);

			this.grid = new AutionSaleItemGrid();
			this.addChild(this.grid);

			this.grid.x = 10;
			this.grid.y = 10;
			this.grid.canMove = true;
			this.grid.canDragIn = true;
			this.grid.setType(ItemEnum.TYPE_GRID_AUTIONSALE);
			this.grid.dragInListener = onGridDragIn;
			this.confirmBtn.addEventListener(MouseEvent.CLICK, onClick);
//			this.ybBtn.addEventListener(MouseEvent.CLICK, onTypeCbClick);
//			this.jbBtn.addEventListener(MouseEvent.CLICK, onTypeCbClick);
//			this.typeCb.setDataByArr([{str: "金币", val: 0}, {str: "元宝", val: 2}]);
//			this.typeCb.addEventListener(DropMenuEvent.Item_Selected, onTypeCbClick);
		}
		
		/**
		 * <T>文本框选中</T>
		 * 
		 * @param event 鼠标事件
		 * 
		 */		
		protected function onTextSelect(event:MouseEvent):void{
			this.goldTxt.input.setSelection(0, goldTxt.text.length);
		}
		
		/**
		 * <T>金钱类型变更</T>
		 * 
		 * @param event 事件
		 * 
		 */		
//		protected function onTypeCbClick(event:Event):void{
//			if("jbBtn" == event.target.name){
//				currencyType = 0;
//			}else if("ybBtn" == event.target.name){
//				currencyType = 2;
//			}
//			var sourcePath:String = ItemUtil.getExchangeIcon(currencyType)
//			selectMoneyImg.updateBmp(sourcePath);
//		}
		
		/**
		 * <T>物品拖入格子触发</T>
		 * 
		 * @param dataId 拖入物品编号
		 * 
		 */		
		protected function onGridDragIn(dataId:uint):void{
			// 找到物品信息
			var itemInfo:Object = TableManager.getInstance().getItemInfo(dataId);
			if(null == itemInfo){
				itemInfo = TableManager.getInstance().getEquipInfo(dataId);
			}
			var color:uint = ItemUtil.getColorByQuality(parseInt(itemInfo.quality));
			nameLbl.htmlText = "<Font face='SimSun' size = '12' color='#"+ color.toString(16).replace("0x") + "'>" + itemInfo.name + "</Font>";
			Cmd_Aution.cm_Aution_R(dataId);
		}
		
		public function switchHandler(fromItem:GridBase):void{
			switchGrid = true;
			grid.switchHandler(fromItem);
		}
		
		/**
		 * <T>确认按钮监听</T>
		 * 
		 * @param evt 事件
		 * 
		 */		
		private function onClick(evt:MouseEvent):void{
			if(null != grid.linkGrid){
				switchGrid = false;
				Cmd_Aution.cm_Aution_S(grid.linkGrid.dataId, 0, currencyType, uint(goldTxt.text));
			}
		}

		/**
		 * <T>更新格子信息</T>
		 * 
		 * @param info 数据
		 * 
		 */		
		public function updateGrid():void{
			this.grid.updataInfo(null);
		}
		/**
		 * <T>加载最后一次价格</T>
		 *  
		 * @param o 数据
		 * 
		 */
		public function loadLastPrice(o:Object):void{
			var price:uint = o.pr;
//			var currentLbl:Label = (0 == o.tp) ? goldLbl : ybLbl;
			goldLbl.text = (0 == price) ? "???????" : (price+"");
			goldLbl.text = price+"";
//			var iconPath:String = ItemUtil.getExchangeIcon(o.tp);
//			moneyImg.updateBmp(iconPath);
		}
		
		/**
		 * <T>清理</T>
		 * 
		 */		
		public function clear():void{
			this.grid.clear();
			this.nameLbl.text = "";
			this.goldLbl.text = "0";
			this.goldTxt.text = "0";
		}
	}
}

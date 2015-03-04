package com.leyou.ui.aution.child {
	import com.ace.manager.LibManager;
	import com.ace.manager.UIManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.Label;
	import com.leyou.data.aution.AutionItemData;
	import com.leyou.net.cmd.Cmd_Aution;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class AutionSellTypeGold extends AutoSprite {
		
		private var goldLbl:Label;
		private var ingotLbl:Label;
		private var ingotTxt:TextInput;
		private var confirmBtn:NormalButton;
		private var numTxt:TextInput;
		private var equalLbl:Label;
		private var ybImg:Image;
		
		private var rate:Number;

		private var grid:AutionSaleItemGrid;
		
		public function AutionSellTypeGold() {
			super(LibManager.getInstance().getXML("config/ui/aution/autionSellTypeGold.xml"));
			this.init();
		}
		
		/**
		 * <T>初始化</T>
		 * 
		 */		
		private function init():void{
			this.mouseChildren=true;
			this.goldLbl = this.getUIbyID("goldLbl") as Label;
			this.ingotLbl = this.getUIbyID("ingotLbl") as Label;
			this.numTxt = this.getUIbyID("numTxt") as TextInput;
			this.ingotTxt = this.getUIbyID("ingotTxt") as TextInput;
			this.confirmBtn = this.getUIbyID("confirmBtn") as NormalButton;
			this.equalLbl = this.getUIbyID("equalLbl") as Label;
			this.ybImg = this.getUIbyID("ybImg") as Image;
			
			this.numTxt.restrict = "[0-9]";
			this.ingotTxt.restrict = "[0-9]";
			this.numTxt.input.maxChars = 9;
			this.ingotTxt.input.maxChars = 9;
			this.numTxt.text = "0";
			this.ingotTxt.text = "0";
			this.goldLbl.text = "0";
			this.ingotLbl.text = "0";
			this.numTxt.input.addEventListener(Event.CHANGE, onInputChange);
			this.numTxt.input.addEventListener(MouseEvent.CLICK, onInputSelect);
			this.ingotTxt.input.addEventListener(MouseEvent.CLICK, onInputSelect);
			this.grid = new AutionSaleItemGrid();
			this.addChild(this.grid);
			
			this.grid.x = 10;
			this.grid.y = 10;
			
			this.confirmBtn.addEventListener(MouseEvent.CLICK,onClick);
			updateGrid();
		}
		
		/**
		 * <T>点击输入框监听</T>
		 * 
		 * @param evt 点击事件
		 * 
		 */		
		protected function onInputSelect(evt:MouseEvent):void{
			evt.target.setSelection(0, numTxt.text.length);
		}
		
		/**
		 * <T>输入监听</T>
		 * 
		 * @param evt 事件 
		 * 
		 */		
		private function onInputChange(evt:Event):void {
			var coin:uint = uint(numTxt.text);
			var ownCoin:uint = UIManager.getInstance().backpackWnd.jb;
			if (coin > ownCoin){
				numTxt.text = ownCoin+"";
			}
			goldLbl.text = numTxt.text;
			var v:Number = rate*coin;
			if(v < 1){
				v = Number(v.toFixed(4));
			}else if(v > 1 && v < 100){
				v = Number(v.toFixed(2));
			}else if(v >= 100){
				v = uint(v);
			}
			ingotLbl.text = v+"";
			equalLbl.x = goldLbl.x + goldLbl.width;
			ybImg.x = equalLbl.x + equalLbl.width;
			ingotLbl.x = ybImg.x + ybImg.width;
		}
		
		/**
		 * <T>确认按钮监听</T>
		 *  
		 * @param evt 事件
		 * 
		 */		
		private function onClick(evt:MouseEvent):void{
			Cmd_Aution.cm_Aution_S(-1, uint(numTxt.text), 2, uint(ingotTxt.text));
			numTxt.text = "0";
		}
		
		/**
		 * <T>更新格子信息</T>
		 * 
		 */		
		public function updateGrid():void {
			var data:AutionItemData = new AutionItemData();
			data.itemId = 65535;
			grid.updataInfo(data);
		}
		
		public function loadRate(mc:uint, gc:uint):void{
			if(0 != mc){
				rate = gc/mc;
				goldLbl.text = "1";
				ingotLbl.text = (gc/mc).toFixed(4);
			}else{
				goldLbl.text = "???????";
				ingotLbl.text = "??????";
			}
			equalLbl.x = goldLbl.x + goldLbl.width;
			ybImg.x = equalLbl.x + equalLbl.width;
			ingotLbl.x = ybImg.x + ybImg.width;
		}
	}
}

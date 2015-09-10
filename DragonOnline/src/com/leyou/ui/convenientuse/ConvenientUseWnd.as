package com.leyou.ui.convenientuse
{
	import com.ace.enum.UIEnum;
	import com.ace.gameData.manager.DataManager;
	import com.ace.manager.GuideManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.CheckBox;
	import com.ace.ui.button.children.ImgButton;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.lable.Label;
	import com.leyou.data.convenient.ConvenientItem;
	import com.leyou.net.cmd.Cmd_Bag;
	import com.leyou.ui.convenientuse.children.ConvenientGrid;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ConvenientUseWnd extends AutoWindow
	{
		private var grid:ConvenientGrid;
		
		private var useBtn:ImgButton;
		
		private var maxBtn:NormalButton;
		
		private var clickHandler:Function;
		
		private var numLbl:TextInput;
		
		private var maxCount:int;
		
		private var nameLbl:Label;
		
		private var item:ConvenientItem;
		
		private var promptChk:CheckBox;
		
		public function ConvenientUseWnd(){
			super(LibManager.getInstance().getXML("config/ui/convenient/itemMessage.xml"));
			init();
		}
		
		private function init():void{
			hideBg();
			mouseEnabled = true;
			mouseChildren = true;
			useBtn = getUIbyID("useBtn") as ImgButton;
			maxBtn = getUIbyID("maxBtn") as NormalButton;
			promptChk = getUIbyID("promptChk") as CheckBox;
			useBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			maxBtn.addEventListener(MouseEvent.CLICK, onMouseClick);
			promptChk.addEventListener(MouseEvent.CLICK, onMouseClick);
			numLbl = getUIbyID("numLbl") as TextInput;
			nameLbl = getUIbyID("nameLbl") as Label;
			numLbl.restrict = "[0-9]";
			numLbl.addEventListener(Event.CHANGE, onTextInput);
			
			grid = new ConvenientGrid();
			addChild(grid);
			grid.x = 26;
			grid.y = 55;
			clsBtn.x -= 6;
			clsBtn.y -= 14;
		}
		
		/**
		 * <T>输入监听</T>
		 * 
		 * @param event 事件
		 * 
		 */		
		protected function onTextInput(event:Event):void{
			var value:int = int(numLbl.text);
			if(value > maxCount){
				numLbl.text = maxCount+"";
			}
		}
		
		/**
		 * <T>注册使用监听</T>
		 * 
		 * @param $clickHandler 监听函数
		 * 
		 */		
		public function registeredUse($clickHandler:Function):void{
			clickHandler = $clickHandler;
		}
		
		/**
		 * <T>显示下一个</T>
		 * 
		 */		
		public function showItem($item:ConvenientItem):void{
			resize();
			show(true, 1, false);
			item = $item;
			grid.updataInfo(item);
			numLbl.text = item.bagInfo.num+"";
			maxCount = item.bagInfo.num;
			nameLbl.text = item.bagInfo.info.name;
			if(DataManager.getInstance().convenientData.isPrompt(item.bagInfo.info.name)){
				promptChk.turnOff(false);
			}else{
				promptChk.turnOn(false);
			}
		}
		
		/**
		 * <T>点击使用</T>
		 * 
		 * @param event 点击事件
		 * 
		 */		
		protected function onMouseClick(event:MouseEvent):void{
			var n:String = event.target.name;
			switch(n){
				case "useBtn":
					Cmd_Bag.cm_bagUse(grid.dataId, int(numLbl.text));
					hide();
					break;
				case "maxBtn":
					numLbl.text = maxCount+"";
					break;
				case "promptChk":
					DataManager.getInstance().convenientData.setPrompt(item.bagInfo.info.name, promptChk.isOn);
					break;
			}
		}
		
		/**
		 * <T>检查是否需要替换</T>
		 * 
		 * @param item 替换源
		 * @return     是否替换
		 * 
		 */		
		public function checkReplace($item:ConvenientItem):Boolean{
			if((null != item) && (item.bagInfo.pos == $item.bagInfo.pos)){
				showItem($item);
				return true;
			}
			return false;
		}
		
		public override function hide():void{
			super.hide();
			if(null != clickHandler){
				clickHandler.call(this, null);
			}
		}
		
		public override function set visible(value:Boolean):void{
			super.visible = value;
			if(value){
				GuideManager.getInstance().showGuide(55, useBtn);
			}else{
				GuideManager.getInstance().removeGuide(55);
			}
		}
		
		public function resize():void{
			x = UIEnum.WIDTH - width;
			y = UIEnum.HEIGHT - height - 100;
		}
	}
}
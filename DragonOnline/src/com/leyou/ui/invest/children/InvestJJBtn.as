package com.leyou.ui.invest.children
{
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	
	public class InvestJJBtn extends AutoSprite
	{
		private var bgImg:Image;
		
		private var receiveImg:Image;
		
		private var countLbl:Label;
		
		public function InvestJJBtn(){
			super(LibManager.getInstance().getXML("config/ui/invest/cajhBtn.xml"));
			init();
		}
		
		private function init():void{
			bgImg = getUIbyID("bgImg") as Image;
			receiveImg = getUIbyID("receiveImg") as Image;
			countLbl = getUIbyID("countLbl") as Label;
		}
		
		public function updateStatus(value:Boolean):void{
			receiveImg.visible = value;
		}
		
		public function updateValue(value:int):void{
			countLbl.text = value+"";
		}
	}
}
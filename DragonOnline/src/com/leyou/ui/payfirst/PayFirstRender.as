package com.leyou.ui.payfirst
{
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	
	public class PayFirstRender extends AutoSprite
	{
		private var payLbl:Label;
		
		private var returnLbl:Label;
		
		public function PayFirstRender(){
			super(LibManager.getInstance().getXML("config/ui/firstpay/kffzRender.xml"));
			init();
		}
		
		private function init():void{
			payLbl = getUIbyID("payLbl") as Label;
			returnLbl = getUIbyID("returnLbl") as Label;
		}
		
		public function updateInfo(cz:int, fz:int):void{
			payLbl.text = cz+"";
			returnLbl.text = fz+"";
		}
	}
}
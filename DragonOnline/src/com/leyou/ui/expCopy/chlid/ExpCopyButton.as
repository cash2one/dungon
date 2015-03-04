package com.leyou.ui.expCopy.chlid
{
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.lable.Label;
	
	public class ExpCopyButton extends AutoSprite
	{
		private var levelLbl:Label;
		
		public var pointId:int;
		
		public function ExpCopyButton(){
			super(LibManager.getInstance().getXML("config/ui/sceneCopy/monsterScPBtn.xml"));
			init();
		}
		
		private function init():void{
			mouseEnabled = true;
			mouseChildren = true;
			levelLbl = getUIbyID("levelLbl") as Label;
		}
		
		public function setLv(lv:int):void{
			levelLbl.text = lv+"";
		}
	}
}
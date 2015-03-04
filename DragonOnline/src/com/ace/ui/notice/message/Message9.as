package com.ace.ui.notice.message
{
	import com.ace.enum.NoticeEnum;
	import com.ace.enum.UIEnum;
	import com.ace.ui.component.RollNumWidget;
	import com.ace.ui.notice.NoticeManager;

	/**
	 * @class 战斗力显示
	 * @author Administrator
	 * 
	 */	
	public class Message9
	{
		private var rollWidget:RollNumWidget;
		
		public function Message9(){
			init();
		}
		
		private function init():void{
			rollWidget = new RollNumWidget();
			rollWidget.loadSource("ui/num/{num}_zdl.png", "ui/num/zdl_bg.png");
			rollWidget.alignCenter();
			rollWidget.visible = false;
			rollWidget.x = (UIEnum.WIDTH - rollWidget.width) * .5;
			rollWidget.y = UIEnum.HEIGHT - NoticeEnum.MESSAGE9_PY;
			rollWidget.mouseEnabled = false;
			rollWidget.mouseChildren = false;
			NoticeManager.getInstance().con.addChild(rollWidget);
		}
		
		public function setNum(num:int):void{
			rollWidget.setNum(num);
		}
		
		public function rollToNum(num:int):void{
			rollWidget.rollToNum(num, true);
		}
		
		public function resize():void{
			rollWidget.x = (UIEnum.WIDTH - rollWidget.width) * .5;
			rollWidget.y = UIEnum.HEIGHT - NoticeEnum.MESSAGE9_PY;
		}
	}
}
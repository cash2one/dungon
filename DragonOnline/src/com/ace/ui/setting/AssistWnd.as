package com.ace.ui.setting
{
	import com.ace.game.utils.AutoUtil;

	public class AssistWnd extends AssistView
	{
		private static var instance:AssistWnd;
		
		public static function getInstance():AssistWnd {
			if (!instance)
				instance=new AssistWnd();
			
			return instance;
		}
		
		public function AssistWnd(){
		}
		
		protected override function autoEat():void{
			AutoUtil.autoEat();
		}
		
	}
}
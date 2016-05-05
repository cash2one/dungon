package com.ace.ui.setting
{
	public class AssistWnd extends AssistView
	{
		private static var instance:AssistWnd;
		
		public static function getInstance():AssistWnd {
			if (!instance)
				instance=new AssistWnd();
			
			return instance;
		}
		
	}
}
package com.leyou.data
{
	public class CommonData
	{
		// 首冲界面显示状态
		private var _payStatus:int;
		
		public function CommonData(){
		}

		public function get payStatus():int
		{
			return _payStatus;
		}

		public function set payStatus(value:int):void
		{
			_payStatus = value;
		}

	}
}
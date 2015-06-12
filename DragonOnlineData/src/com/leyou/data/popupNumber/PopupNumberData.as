package com.leyou.data.popupNumber
{
	public class PopupNumberData
	{
		public var teamCyNum:int;
		
		public var bossCyNum:int;
		
		public var storyCyNum:int;
		
		public function PopupNumberData(){
		}
		
		public function get cyNum():int{
			return (teamCyNum + bossCyNum + storyCyNum);
		}
	}
}
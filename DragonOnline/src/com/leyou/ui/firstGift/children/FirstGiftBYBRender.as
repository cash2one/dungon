package com.leyou.ui.firstGift.children
{
	import com.ace.manager.LibManager;
	import com.ace.ui.lable.Label;
	import com.leyou.enum.ConfigEnum;
	
	public class FirstGiftBYBRender extends FirstGiftRender
	{
		private var day1RewardLbl:Label;
		
		private var day2RewardLbl:Label;
		
		private var day3RewardLbl:Label;
		
		public function FirstGiftBYBRender(){
			super(LibManager.getInstance().getXML("config/ui/firstGift/schl4Render.xml"));
			init();
		}
		
		protected override function init():void{
			super.init();
			day1RewardLbl = getUIbyID("day1RewardLbl") as Label;
			day2RewardLbl = getUIbyID("day2RewardLbl") as Label;
			day3RewardLbl = getUIbyID("day3RewardLbl") as Label;
			var rewardArr:Array = ConfigEnum.dayMoney2.split("|");
			day1RewardLbl.text = rewardArr[0]+"绑钻";
			day2RewardLbl.text = rewardArr[1]+"绑钻";
			day3RewardLbl.text = rewardArr[2]+"绑钻";
		}
	}
}
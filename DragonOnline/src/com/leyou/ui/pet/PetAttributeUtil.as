package com.leyou.ui.pet
{
	import com.leyou.utils.PropUtils;

	public class PetAttributeUtil
	{
		public static function getRaceUrl(race:int):String{
			var raceUrl:String = null;
			switch(race){
				case 1:
					// 野兽
					raceUrl = "ui/servent/yeshou.png";
					break;
				case 2:
					// 元素
					raceUrl = "ui/servent/yuansu.png";
					break;
				case 3:
					// 人形
					raceUrl = "ui/servent/renxing.png";
					break;
				case 4:
					// 亡灵
					raceUrl = "ui/servent/wangling.png";
					break;
				case 5:
					// 龙类
					raceUrl = "ui/servent/longzu.png";
					break;
			}
			return raceUrl;
		}
		
		public static function getRaceName(race:int):String{
			var raceName:String = null;
			switch(race){
				case 1:
					// 野兽
					raceName = PropUtils.getStringById(2158);
					break;
				case 2:
					// 元素
					raceName = PropUtils.getStringById(26);
					break;
				case 3:
					// 人形
					raceName = PropUtils.getStringById(2160);
					break;
				case 4:
					// 亡灵
					raceName = PropUtils.getStringById(2161);
					break;
				case 5:
					// 龙类
					raceName = PropUtils.getStringById(2162);
					break;
				default:
					raceName = "UNKNOW";
					break;
			}
			return raceName;
		}
		
		public static function getSmartLv(rate:int):String{
			var smartName:String = null;
			if(rate >= 500 && rate < 700){
				smartName = PropUtils.getStringById(2163);
			}else if(rate >= 700 && rate < 900){
				smartName = PropUtils.getStringById(2164);
			}else if(rate >= 900 && rate < 1100){
				smartName = PropUtils.getStringById(2165);
			}else if(rate >= 1100 && rate < 1300){
				smartName = PropUtils.getStringById(2166);
			}else if(rate >= 1300 && rate < 1500){
				smartName = PropUtils.getStringById(2167);
			}else{
				smartName = PropUtils.getStringById(2168);
			}
			return smartName;
		}
	}
}
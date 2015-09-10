package com.leyou.ui.pet
{
	import com.leyou.enum.ConfigEnum;
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
			var span1:Array = ConfigEnum.servent25.split("|");
			var span2:Array = ConfigEnum.servent26.split("|");
			var span3:Array = ConfigEnum.servent27.split("|");
			var span4:Array = ConfigEnum.servent28.split("|");
			var span5:Array = ConfigEnum.servent29.split("|");
			var smartName:String = null;
			if(rate >= int(span1[0]) && rate < int(span1[1])){
				smartName = PropUtils.getStringById(2163);
			}else if(rate >= int(span2[0]) && rate < int(span2[1])){
				smartName = PropUtils.getStringById(2164);
			}else if(rate >= int(span3[0]) && rate < int(span3[1])){
				smartName = PropUtils.getStringById(2165);
			}else if(rate >= int(span4[0]) && rate < int(span4[1])){
				smartName = PropUtils.getStringById(2166);
			}else if(rate >= int(span5[0]) && rate < int(span5[1])){
				smartName = PropUtils.getStringById(2167);
			}else{
				smartName = PropUtils.getStringById(2168);
			}
			return smartName;
		}
	}
}
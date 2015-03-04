package com.ace.gameData.table
{
	public class TVIPInfo
	{
		public var des:String;
		
//		0 不可见
//		1 数字
//		2 数字+级
//		3 数字+次
//		4 数字+%
//		5 对钩
		public var type:int;
		
		private var vipLv:Vector.<int>;
		
		public function TVIPInfo(xml:XML){
			des = xml.@des;
			type = xml.@visible;
			vipLv = new Vector.<int>();
			vipLv.push(xml.@VIP0);
			vipLv.push(xml.@VIP1);
			vipLv.push(xml.@VIP2);
			vipLv.push(xml.@VIP3);
			vipLv.push(xml.@VIP4);
			vipLv.push(xml.@VIP5);
			vipLv.push(xml.@VIP6);
			vipLv.push(xml.@VIP7);
			vipLv.push(xml.@VIP8);
			vipLv.push(xml.@VIP9);
			vipLv.push(xml.@VIP10);
		}
		
		public function getVipValue(lv:int):int{
			return vipLv[lv];
		}
	}
}
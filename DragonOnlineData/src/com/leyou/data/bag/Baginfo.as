package com.leyou.data.bag {
	import com.leyou.data.tips.TipsInfo;
	

	public class Baginfo {

		public var aid:int;
		public var info:Object;
		public var pos:int=0;
		public var tips:TipsInfo;
		public var num:int=0;
		
		public var cdtime:int=0;
		
		public function Baginfo(data:Object=null) {
			if (data == null)
				return;

			this.aid=data.aid;
			this.pos=data.pos;
			this.num=data.num;
			this.tips=data.tips;
		}
	}
}

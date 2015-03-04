package com.leyou.data.store {
	import com.leyou.data.tips.TipsInfo;

	public class StoreInfo {

		public var aid:int;
		public var info:Object;
		public var pos:int=0;
		public var num:int=0;
		public var tips:TipsInfo;

		public function StoreInfo(data:Object=null) {
			if (data == null)
				return;

			this.aid=data.aid;
			this.pos=data.pos;
			this.num=data.num;
			this.tips=data.tips;
		}

	}
}

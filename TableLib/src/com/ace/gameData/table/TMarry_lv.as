package com.ace.gameData.table {

	public class TMarry_lv {

		public var lv:int;
		public var useLovePoint:int;
		public var money:int;
		public var lovePointLimit:int;
		public var transCD:int;
		public var ringAddRate:int;
		public var buffID:int;

		public function TMarry_lv(xml:XML) {
			this.lv=xml.@lv;
			this.useLovePoint=xml.@useLovePoint;
			this.money=xml.@money;
			this.lovePointLimit=xml.@lovePointLimit;
			this.transCD=xml.@transCD;
			this.ringAddRate=xml.@ringAddRate;
			this.buffID=xml.@buffID;
		}
	}
}

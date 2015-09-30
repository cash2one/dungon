package com.ace.gameData.table {

	public class TRing_intensify {

		public var RI_Lv:int;
		public var RI_Happy:int;
		public var RI_money:int;
		public var RI_Add:int;

		public function TRing_intensify(xml:XML) {
			this.RI_Lv=xml.@RI_Lv;
			this.RI_Happy=xml.@RI_Happy;
			this.RI_money=xml.@RI_money;
			this.RI_Add=xml.@RI_Add;
		}
		
		
	}
}

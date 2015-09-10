package com.ace.gameData.table {

	public class TUnion_Bless {



		public var ID:int;
		public var build_Obj:int;
		public var build_Name:String;
		public var build_Lv:int;
		public var build_Buff:int;
		public var Buff_Spend:int;
		public var Upgrade_Time:int;
		public var Upgrade_at:int;
		public var build_Pic:String;


		public function TUnion_Bless(data:XML=null) {

			if (data == null)
				return;

			this.ID=data.@ID;
			this.build_Obj=data.@build_Obj;
			this.build_Name=data.@build_Name;
			this.build_Lv=data.@build_Lv;
			this.build_Buff=data.@build_Buff;
			this.Buff_Spend=data.@Buff_Spend;
			this.Upgrade_Time=data.@Upgrade_Time;
			this.Upgrade_at=data.@Upgrade_at;
			this.build_Pic=data.@build_Pic;


		}
	}
}

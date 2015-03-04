package com.leyou.data.creatUser {

	public class CreatUserInfoT {
		public function CreatUserInfoT(xml:XML) {
			this.race=xml.@race;
			this.des=xml.@des;
			this.skill1=xml.@skill1;
			this.skill2=xml.@skill2;
			this.skill3=xml.@skill3;
			this.skill4=xml.@skill4;
			this.hpPer=xml.@hpPer;
			this.atPer=xml.@atPer;
			this.defPer=xml.@defPer;
		}
		public var race:int;
		public var des:String;
		public var skill1:int;
		public var skill2:int;
		public var skill3:int;
		public var skill4:int;
		public var hpPer:int;
		public var atPer:int;
		public var defPer:int;
	}
}
package com.ace.gameData.table {

	public class TMarry_ring {

		/**
		 *	ID
		 */
		public var ID:int;

		/**
		 *	戒指名称
		 */
		public var Ring_Name:String;

		/**
		 *	戒指价格(钻石)
		 */
		public var Ring_Tag:int;

		/**
		 *	戒指图片
		 */
		public var Ring_Pic:String;

		/**
		 *	图片特效
		 */
		public var Ring_Eff:int;
		public var Ring_Eff2:int;

		/**
		 *	攻击
		 */
		public var Att:int;

		/**
		 *	防御
		 */
		public var Def:int;

		/**
		 *	生命
		 */
		public var Hp:int;

		/**
		 *	暴击
		 */
		public var Crit:int;

		/**
		 *	韧性
		 */
		public var Tenacity:int;

		/**
		 *	命中
		 */
		public var Hit:int;

		/**
		 *	闪避
		 */
		public var Dodge:int;

		/**
		 *	必杀
		 */
		public var Slay:int;

		/**
		 *	守护
		 */
		public var Guard:int;

		/**
		 *	戒指说明1
		 */
		public var Ring_Dic1:String;

		/**
		 *	戒指说明2
		 */
		public var Ring_Dic2:String;



		public function TMarry_ring(data:XML=null) {
			if (data == null)
				return;

			this.ID=data.@ID;
			this.Ring_Name=data.@Ring_Name;
			this.Ring_Tag=data.@Ring_Tag;
			this.Ring_Pic=data.@Ring_Pic;
			this.Ring_Eff=data.@Ring_Eff;
			this.Ring_Eff2=data.@Ring_Eff2;
			this.Att=data.@Att;
			this.Def=data.@Def;
			this.Hp=data.@Hp;
			this.Crit=data.@Crit;
			this.Tenacity=data.@Tenacity;
			this.Hit=data.@Hit;
			this.Dodge=data.@Dodge;
			this.Slay=data.@Slay;
			this.Guard=data.@Guard;
			this.Ring_Dic1=data.@Ring_Dic1;
			this.Ring_Dic2=data.@Ring_Dic2;


		}


	}
}

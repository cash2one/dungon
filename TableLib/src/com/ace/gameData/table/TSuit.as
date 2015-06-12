package com.ace.gameData.table {

	public class TSuit {

		/**
		 *	套装组ID
		 */
		public var Suit_Group:int;

		/**
		 *	激活所需件数
		 */
		public var Suit_Num:int;

		/**
		 *	激活属性
		 */
		public var Suit_Att:int;

		/**
		 *	属性值
		 */
		public var SA_Num:int;

		/**
		 *	激活技能/雕文
		 */
		public var SA_Skill:int;

		/**
		 *	文字描述(技能相关)
		 */
		public var SA_txt:String;



		public function TSuit(data:XML=null) {
			if (data == null)
				return;

			this.Suit_Group=data.@Suit_Group;
			this.Suit_Num=data.@Suit_Num;
			this.Suit_Att=data.@Suit_Att;
			this.SA_Num=data.@SA_Num;
			this.SA_Skill=data.@SA_Skill;
			this.SA_txt=data.@SA_txt;


		}



	}
}

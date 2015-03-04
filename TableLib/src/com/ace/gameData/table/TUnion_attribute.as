package com.ace.gameData.table {

	public class TUnion_attribute {

		/**
		 */
		public var id:int;

		/**
		 *	技能名称
		 */
		public var name:String;

		/**
		 *	技能图标
		 */
		public var ico:int;

		/**
		 *	属性ID
		 *
		 *	1.生命上限
		 *	4.物攻
		 *	5.物防
		 *	6.法攻
		 *	7.法防
		 */
		public var att:int;

		/**
		 *	属性等级
		 */
		public var lv:int;

		/**
		 *	解锁所需行会等级
		 *
		 *	表示行会达到该级别是才会解锁对应的行会属性等级；
		 */
		public var uLv:int;

		/**
		 *	属性数值
		 */
		public var uAtt:int;

		/**
		 *	花费金钱
		 *
		 *	升级该等级所花费的金钱；
		 */
		public var uMoney:int;

		/**
		 *	花费行会贡献
		 *
		 *	升级该等级所花费的行会贡献；
		 */
		public var uCon:int;



		public function TUnion_attribute(data:XML=null) {
			if (data == null)
				return;

			this.id=data.@id;
			this.name=data.@name;
			this.ico=data.@ico;
			this.att=data.@att;
			this.lv=data.@lv;
			this.uLv=data.@uLv;
			this.uAtt=data.@uAtt;
			this.uMoney=data.@uMoney;
			this.uCon=data.@uCon;


		}



	}
}

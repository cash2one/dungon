package com.leyou.data.element {

	public class Elements {
		public function Elements() {
		}

		/**
		 *元素id 0金 1木 2水 3火 4土
		 */
		public var id:int;
		/**
		 *等级
		 */
		public var lv:int;
		/**
		 *当前经验
		 */
		public var exp:int;
		/**
		 *经验上限
		 */
		public var sumExp:int;
		/**
		 *是否守护元素
		 */
		public var flag:Boolean;


		public function clone():Elements {
			var e:Elements=new Elements();

			e.id=id
			e.lv=lv;
			e.exp=exp;
			e.sumExp=sumExp;
			e.flag=flag;

			return e;
		}
	}
}

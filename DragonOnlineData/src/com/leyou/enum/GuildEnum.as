package com.leyou.enum {

	public class GuildEnum {

		/**
		 *帮主
		 */
		public static const ADMINI_1:int=1;

		/**
		 * 副帮主
		 */
		public static const ADMINI_2:int=2;

		/**
		 * 长老
		 */
		public static const ADMINI_3:int=3;

		/**
		 *帮众
		 */
		public static const ADMINI_4:int=4;


		/**
		 * r -- 收人 (0,1)
		 */
		public static const ADMINI_PRICE_GET_PEOPLE:int=0;
		/**
		 *tr -- 踢人 (0,1)
		 */
		public static const ADMINI_PRICE_KILL_PEOPLE:int=1;
		/**
		 * sj -- 升级 (0,1)
		 */
		public static const ADMINI_PRICE_UPGRADE:int=2;
		/**
		 *xz -- 宣战 (0,1)
		 */
		public static const ADMINI_PRICE_PK:int=3;

		/**
		 *gl -- 管理 (0,1)
		 */
		public static const ADMINI_PRICE_MANAGER:int=4;


		public function GuildEnum() {
		}
	}
}

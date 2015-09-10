package com.leyou.utils {



	public class GuildUtil {



		public function GuildUtil() {
		}

		/**
		 *	job        -- 职务(1帮主 2副帮主 3长老 4帮众)  会长，副会长，长老，会员
		 * @param i
		 * @return 
		 * 
		 */		
		public static function getOfficeNameByIndex(i:int):String {

			switch (i) {
				case 1:
					return PropUtils.getStringEasyById(36);
				case 2:
					return PropUtils.getStringEasyById(37);
				case 3:
					return PropUtils.getStringEasyById(38);
				case 4:
					return PropUtils.getStringEasyById(39);
			}

			return "";
		}

	}
}

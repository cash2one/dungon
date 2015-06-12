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
					return PropUtils.getStringById(36);
				case 2:
					return PropUtils.getStringById(37);
				case 3:
					return PropUtils.getStringById(38);
				case 4:
					return PropUtils.propArr[37];
			}

			return "";
		}

	}
}

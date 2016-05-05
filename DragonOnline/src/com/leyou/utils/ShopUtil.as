package com.leyou.utils {


	import com.ace.gameData.manager.DataManager;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.manager.UIManager;


	public class ShopUtil {


		public function ShopUtil() {

		}

		/**
		 *货币ID
		*	0 游戏币
		*	1 绑定元宝
		*	2 元宝
		*	3 真气
		 * @param i
		 * @return
		 *
		 */
		public static function getIndexTotMoney(i:int):Number {

			if (i > 10) {
				return MyInfoManager.getInstance().getBagItemNumById(i);
			} else {

				switch (i) {
					case 0:
						return UIManager.getInstance().backpackWnd.jb;
						break;
					case 1:
						return UIManager.getInstance().backpackWnd.byb;
						break;
					case 2:
						return UIManager.getInstance().backpackWnd.yb;
						break;
					case 3:
						return UIManager.getInstance().backpackWnd.zq;
						break;
					case 4:
						return UIManager.getInstance().backpackWnd.honour;
						break;
					case 5:
						return UIManager.getInstance().guildWnd.guildContribute;
						break;
					case 6:
						return DataManager.getInstance().integralData.integral;
					case 7:
						return UIManager.getInstance().backpackWnd.jl;
						break;
					case 8:
						return UIManager.getInstance().backpackWnd.gx;
						break;
					case 9:
						return UIManager.getInstance().backpackWnd.lh;
						break;
				}
			}

			return 0;
		}

		/**
		 *
		 * @param type
		 * @param curPrice
		 * @return
		 *
		 */
		public static function getBuyCountByMoneyOrBagNum(type:int, curPrice:int, maxgroup:int=1):int {

			var priceCount:int=(getIndexTotMoney(type) / curPrice);
			var bagCount:int=MyInfoManager.getInstance().getBagEmptyNum() * maxgroup;

			return Math.min(priceCount, bagCount);
		}


		public static function getCurrencyString(i:int):String {

			if (i > 10000) {
				var rate:Number=parseFloat(((i / 10000) - int(i / 10000)).toPrecision(1));
				return (int(i / 10000) + int(rate * 10) / 10) + PropUtils.getStringById(1532);
			}

			return i + "";

		}

	}
}

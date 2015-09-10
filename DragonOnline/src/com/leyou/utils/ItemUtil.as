package com.leyou.utils {

	import com.ace.enum.ItemEnum;
	import com.ace.enum.PlayerEnum;
	import com.ace.enum.TipEnum;
	import com.ace.gameData.manager.MyInfoManager;
	import com.ace.gameData.manager.TableManager;
	import com.ace.gameData.table.TEquipInfo;
	import com.ace.gameData.table.TItemInfo;
	import com.ace.manager.ToolTipManager;
	import com.ace.utils.StringUtil;
	import com.leyou.data.role.EquipInfo;
	import com.leyou.data.tips.TipsInfo;
	import com.leyou.enum.QualityEnum;

	import flash.geom.Point;
	import flash.globalization.NumberFormatter;

	public class ItemUtil {

		/**
		 *物品使用过滤, ----复活
		 */
		public static var itemFilter:Array=[31500, 31501];



		public function ItemUtil() {
		}

		/**
		 * 货币 icon
		 *
		 * 0 游戏币
1 绑定元宝
2 元宝
3 真气
4 荣耀
6 巨龙点数
*
* @param i
	   * @return
			*
		 */
		public static function getExchangeIcon(i:int):String {

			if (i == 0) {
				return "ui/backpack/moneyIco.png";
			} else if (i == 1) {
				return "ui/backpack/yuanbaoIco_bound.png";
			} else if (i == 2) {
				return "ui/backpack/yuanbaoIco.png";
			} else if (i == 3) {
				return "ui/guild/guild_money.png";
			} else if (i == 4) {
				return "ui/backpack/honor.png";
			} else if (i == 6) {
				return "ui/common/jlbz.png";
			}


			return "";
		}

		/**
		 * 返回货币的按4位
		 * @param str
		 * @return
		 *
		 */
		public static function getSplitMoneyTextTo4(mon:String, count:int=4, separator:String=","):String {
			if (mon == null || mon == "" || mon == "0")
				return "0";

			var num:uint=uint(mon);
			var nf:NumberFormatter=new NumberFormatter("en-EN");
			nf.groupingPattern=count + ";*";
			nf.groupingSeparator=separator;

			nf.trailingZeros=false;

			return nf.formatUint(num);

		}

		/**
		 *0	白
1	绿
2	蓝
3	紫
4	金
5   红
* @param i
* @return
	   *
			*/
		public static function getColorByQuality(i:int):uint {

			switch (i) {
				case QualityEnum.QUA_COMMON:
					return 0xffffff;
				case QualityEnum.QUA_EXCELLENT:
					return 0x69e053;
				case QualityEnum.QUA_TERRIFIC:
					return 0x3fa6ed;
				case QualityEnum.QUA_INCREDIBLE:
					return 0xcc54ea;
				case QualityEnum.QUA_LEGEND:
					return 0xf6d654;
				case QualityEnum.QUA_ARTIFACT:
					return 0xee2211;
			}
			return 0xffffff;
		}

		/**
		 * <T>转换为货币类型名称</T>
		 *
		 * @param type 货币类型
		 * @return     类型名称
		 *
		 */
		public static function parseCurrencyStr(type:int):String {
			switch (type) {
				case 0:
					return PropUtils.getStringById(32);
				case 1:
					return PropUtils.getStringById(33);
				case 2:
					return PropUtils.getStringById(40);
			}
			return null;
		}

		/**
		 * wing tips
		 * @param p
		 * @param num
		 * @return
		 *
		 */
		public static function getWingTipsByPos(p:int, num:int):String {

			switch (p) {
				case 0:
					break;
				case 1:
					return StringUtil.substitute(PropUtils.getStringById(2017), [num]);
				case 2:
					return StringUtil.substitute(PropUtils.getStringById(2018), [num]);
				case 3:
					return StringUtil.substitute(PropUtils.getStringById(2019), [num]);
				case 4:
					return StringUtil.substitute(PropUtils.getStringById(2019), [num]);
				case 5:
					return StringUtil.substitute(PropUtils.getStringById(2019), [num]);
			}

			return "";
		}

		/**
		 *
		 * @param type
		 * @param tips
		 * @param p
		 * @return
		 *
		 */
		public static function showDiffTips(type:int, tips:TipsInfo, p:Point):Boolean {


			var binfo:TEquipInfo=TableManager.getInstance().getEquipInfo(tips.itemid);

//			if (binfo.classid == 1) {
//
//				var olist:Array=ItemEnum.ItemToRolePos[binfo.subclassid];
//
//				var roleIndex:int;
//				var einfo:EquipInfo;
//
//				for each (roleIndex in olist) {
//					einfo=MyInfoManager.getInstance().equips[roleIndex];
//					if (einfo != null) {
//						break;
//					}
//				}
//			 
//			}

			if (binfo.classid == 1) {

				var einfo:Object;
				var index:int=0;
				if (binfo.subclassid < 13) {
					var olist:Array=ItemEnum.ItemToRolePos[binfo.subclassid];

					var st:Boolean=false;
					var roleIndex:int=olist[0];
					einfo=MyInfoManager.getInstance().equips[olist[0]];

					if (einfo != null) {

						if (olist.length == 2) {
							var einfo1:EquipInfo=MyInfoManager.getInstance().equips[olist[1]];

							if (einfo1 != null) {

								if (einfo.tips.zdl > einfo1.tips.zdl) {
									einfo=einfo1;
									roleIndex=olist[1];
								}

							}

						}

					} else {
						if (olist.length == 2)
							einfo=MyInfoManager.getInstance().equips[olist[1]];
						roleIndex=olist[1];
					}
				} else {
					einfo=MyInfoManager.getInstance().mountEquipArr[binfo.subclassid - 13];
				}
			}


			if (einfo != null) {
				tips.isdiff=true;
				einfo.tips.isUse=true;
				einfo.tips.isdiff=false;

				if (binfo.subclassid < 13)
					einfo.tips.playPosition=roleIndex;

				ToolTipManager.getInstance().showII([type, TipEnum.TYPE_EQUIP_ITEM_DIFF], [tips, einfo.tips], PlayerEnum.DIR_E, new Point(2, 0), p);
				return true;
			}

			return false;
		}

		public static function getColorName(id:int, size:int=14):String {
			var item:TItemInfo=TableManager.getInstance().getItemInfo(id);
			var color:String="#" + getColorByQuality(item.quality).toString(16).replace("0x");
			return StringUtil_II.getColorStrByFace(item.name, color, "微软雅黑", size);
		}

	}
}

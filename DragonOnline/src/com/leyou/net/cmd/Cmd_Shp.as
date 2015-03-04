package com.leyou.net.cmd {
	import com.ace.enum.WindowEnum;
	import com.ace.manager.UIManager;
	import com.leyou.net.NetGate;

	public class Cmd_Shp {


		public function Cmd_Shp() {

		}

		public static function sm_shp(o:Object):void {
			if (o == null)
				return;

		}

		/**
		 *打开商店界面  （服务器要求客户端打开商店界面，npc挂商店等功能会用到）
下行：shp|{mk:O,shopid:num}

* @param o
*
	   */
		public static function sm_shp_O(o:Object):void {
			if (o == null || !o.hasOwnProperty("shopid"))
				return;

			UIManager.getInstance().shopWnd.shopId(o.shopid);
			UIManager.getInstance().shopWnd.updateInfo();
		}

		/**
		 * 回购 callback
		 * @param o
		 *
		 */
		public static function sm_shp_I(o:Object):void {
			if (o == null || !o.hasOwnProperty("s"))
				return;

			if (!UIManager.getInstance().isCreate(WindowEnum.SHOP))
				UIManager.getInstance().creatWindow(WindowEnum.SHOP);

			if (UIManager.getInstance().shopWnd.shopID == 0)
				UIManager.getInstance().shopWnd.updateRepo(o.s);

		}


		/**
		 *----------------------------------------------------------------------------------
商店回购物品信息
上行：shp|I
下行：shp|{mk:I,"index":{id,num,tips}...}
index -- 物品的位置序号（0 - 13）
id    -- 物品id
num   --物品数量
tips  -- tips协议内容
----------------------------------------------------------------------------------

*
*/
		public static function cm_shpRepo():void {
			NetGate.getInstance().send("shp|I");
		}

		/**
		 *商店买物品
上行：shp|Bshopid,index,num
（shopid == 0 为回购商店）
index --道具在商店列表的位置 从0开始一直累加
下行：bag协议处理 背包里的物品信息

*
*/
		public static function cm_shpBuy(shopId:int, index:int, num:int=1):void {
			NetGate.getInstance().send("shp|B" + shopId + "," + index + "," + num);
		}

		/**
		 *--------------------------------------------------------------------------------
商店购买道具后剩余塑料
下行:shp|{"mk":"N","num":num}
 * @param o
	   *
			*/
		public static function sm_shp_N(o:Object):void {

			if (!UIManager.getInstance().isCreate(WindowEnum.SHOP))
				UIManager.getInstance().creatWindow(WindowEnum.SHOP);

			UIManager.getInstance().myStore.updateItemNum();
		}

	}
}

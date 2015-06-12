package com.leyou.net.cmd {


	import com.ace.config.Core;
	import com.ace.enum.WindowEnum;
	import com.ace.manager.UIManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	/**
	 *
	 */
	public class Cmd_Yct {


		public static function sm_Delivery_I(o:Object):void {

			if (!o.hasOwnProperty("cart") || o.cart.length != 3)
				return;

			UIManager.getInstance().deliveryWnd.updateInfo(o);
		}

		/**
		 *--------------------------------------------------------------------------
运镖信息
上行:yct|I
下行:yct|{"mk":"I", "cart":[[color,st,exp,money]...],ynum,zynum,rtime}
cart -- 镖车列表信息
			 color -- 镖车颜色 (白绿蓝紫金 12345)
			   st    -- 镖车状态 (0未领取，1已领取)
			   exp   -- 经验奖励
			   money -- 金币奖励

		   ynum  -- 已经运镖次数
		   zynum -- 总运镖次数
		   rtime -- 剩余刷新时间 (秒数)
		 *
		 */
		public static function cm_DeliveryInit():void {
			NetGate.getInstance().send("yct|I");
		}

		/**
		 *--------------------------------------------------------------------------
开始运镖
上行:yct|Sindex
index --第几个镖车(1,2,3)

*
   */
		public static function cm_DeliveryStart(index:int):void {
			NetGate.getInstance().send(CmdEnum.CM_YCT_S + index);
		}

		/**
		 *--------------------------------------------------------------------------
托运镖车
上行:yct|Tindex
index --第几个镖车(1,2,3)

*
   */
		public static function cm_DeliveryConsign(index:int):void {
			NetGate.getInstance().send(CmdEnum.CM_YCT_T + index);
		}

		/**
		 *--------------------------------------------------------------------------
刷新镖车
上行:yct|F
 * -- 刷新镖车
-- 上行:yct|Fbtype (0钻石 1绑定钻石)
*
   */
		public static function cm_DeliveryRefresh(type:int=0):void {
			NetGate.getInstance().send(CmdEnum.CM_YCT_F+type);
		}


		/**
		 *--------------------------------------------------------------------------
继续运镖
上行:yct|C
*
   */
		public static function cm_DeliveryContinue():void {
			NetGate.getInstance().send(CmdEnum.CM_YCT_C);
		}

		/**
		 *追踪镖车
		 上行:yct|Ztype (1寻路,2飞鞋)

		 *
		 */
		public static function cm_DeliveryTrackCart(type:int=1):void {
			NetGate.getInstance().send("yct|Z" + type);
		}

		/**
		 *--------------------------------------------------------------------------
运镖结算
下行:yct|{"mk":"R","synum":num,"shp":hp,"dmoney":num,"money":num,"exp":num}
synum  -- 剩余运镖次数
		 shp    -- 剩余血量百分比（0 未运镖失败，其他为成功）
		   dmoney -- 掉落金币
		   money  -- 护送获得金币
		   exp    -- 护送获得经验
		 * @param o
		 *
		 */
		public static function sm_Delivery_R(o:Object):void {
			if (!UIManager.getInstance().isCreate(WindowEnum.DELIVERYFINISH))
				UIManager.getInstance().creatWindow(WindowEnum.DELIVERYFINISH);

			UIManager.getInstance().deliveryFinish.updateInfo(o);
		}

		/**
		 *运镖任务追踪信息
		下行:yct|{"mk":"K","ynum":num,"zynum":num,"yst":num,"shp"num,"cpos":str}

		   ynum  -- 已经运镖次数
		   zynum -- 总运镖次数
		   yst   -- 运镖状态(0未领取, 1护送中, 2已完成)
		   shp   -- 剩余血量百分比
		   cpos  -- 当前镖车所在位置
		 * @param o
		 *
		 */
		public static function sm_Delivery_K(o:Object):void {
			if(Core.me==null || Core.me.info==null)
				return ;
			
			Core.me.info.isTransport=(o.yst == 1);
			UIManager.getInstance().taskTrack.updateDelivery(o);
		}

		/**
		 * --------------------------------------------------------------------------
进入镖车
上行:yct|J

	 *
		  */
		public static function cm_DeliveryEnterCart():void {
			NetGate.getInstance().send(CmdEnum.CM_YCT_J);
		}

		/**
		 * --------------------------------------------------------------------------
离开镖车
上行:yct|Q

	 *
		  */
		public static function cm_DeliveryQuitCart():void {
			NetGate.getInstance().send(CmdEnum.CM_YCT_Q);
		}

	}
}

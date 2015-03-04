package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Market
	{
		public function Cmd_Market()
		{
		}
		
		/**
		 * <T>查询页面信息</T>
		 * 
		 * @param type 页面类型
		 * 
		 */		
		public static function cm_Mak_I(type:int):void{
			NetGate.getInstance().send(CmdEnum.CM_MAK_I + type);
		}
		
		/**
		 * <T>查询折扣排名信息</T>
		 * 
		 */		
		public static function cm_Mak_L():void{
			NetGate.getInstance().send(CmdEnum.CM_MAK_L);
		}
		
		/**
		 * <T>申请折扣</T>
		 * 
		 * @param itemId 申请物品编号
		 * 
		 */		
		public static function cm_Mak_A(type:int, itemId:uint):void{
			NetGate.getInstance().send(CmdEnum.CM_MAK_A + type + "," + itemId);
		}
		
		/**
		 * <T>购买商品</T>
		 * @param type   物品所在页面
		 * @param itemId 物品编号
		 * @param num    物品数量
		 * 
		 */		
		public static function cm_Mak_B(type:int, itemId:uint, num:int):void{
			NetGate.getInstance().send(CmdEnum.CM_MAK_B + type + "," + itemId + "," + num);
		}
		
		/**
		 * <T>快速购买查询</T>
		 */		
		public static function cm_Mak_F(itemId1:uint, itemId2:uint):void{
			NetGate.getInstance().send(CmdEnum.CM_MAK_F +itemId1 + "," + itemId2);
		}
		
		/**
		 * <T>查询页面信息回应</T>
		 * 
		 * @param o 数据
		 * 
		 */		
		public static function sm_Mak_I(o:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.MARKET, CmdEnum.SM_MAK_I);
			if(o.hasOwnProperty("list")){
				UIManager.getInstance().marketWnd.onItemListResponse(o);
			}
		}
		
		/**
		 * <T>查询折扣排名信息回应</T>
		 * 
		 * @param o 数据
		 * 
		 */		
		public static function sm_Mak_L(o:Object):void{
			if(o.hasOwnProperty("list")){
				UIManager.getInstance().marketWnd.onDiscountListResponse(o);
			}
		}
		
		/**
		 * 商城翅膀
		 * 
		 * @param o
		 * 
		 */		
		public static function sm_Mak_W(o:Object):void{
//			if(null == Core.me){
//				throw new Error("角色尚未初始化");
//				return;
//			}
			UIManager.getInstance().roleHeadWnd.updateWingInfo(o);
			if(UIManager.getInstance().marketWnd){
				UIManager.getInstance().marketWnd.setWingInfo(o);
			}
		}
		
		public static function cm_Mak_W(type:int):void{
			NetGate.getInstance().send(CmdEnum.CM_MAK_W+type);
		}
		
		/**
		 * <T>申请折扣回应</T>
		 * 
		 * @param o 数据
		 * 
		 */		
		public static function sm_Mak_A(o:Object):void{
			if(o.hasOwnProperty("one")){
				UIManager.getInstance().marketWnd.onApplyDiscountResponse(o);
			}
		}
		
		/**
		 * <T>快速购买查询</T>
		 * 
		 * @param o 数据
		 * 
		 */		
		public static function sm_Mak_F(o:Object):void{
			UIManager.getInstance().quickBuyWnd.loadItem(o);
		}
	}
}
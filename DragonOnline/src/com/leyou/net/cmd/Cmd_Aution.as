package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;
	import com.leyou.utils.PropUtils;
	import com.leyou.utils.StringUtil_II;

	public class Cmd_Aution
	{
		public function Cmd_Aution()
		{
		}
		
		/**
		 * <T>寄售查询信息请求</T>
		 * 
		 */		
		public static function cm_Aution_I(page:int):void{
			NetGate.getInstance().send(CmdEnum.CM_CGT_I + "," + page);
		}
		
		/**
		 * <T>寄售查询信息回应</T>
		 * 
		 * @param o 数据
		 * 
		 */		
		public static function sm_Aution_I(o:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.AUTION, CmdEnum.SM_CGT_I);
			if(o.hasOwnProperty("tb")){
				UIManager.getInstance().autionWnd.loadAll(o);
			}
		}

		/**
		 * <T>寄售物品请求</T>
		 * 
		 */		
		public static function cm_Aution_S(itemPos:int, goldCount:uint, moneyType:int, price:uint):void{
			NetGate.getInstance().send(CmdEnum.CM_CGT_S + "," + itemPos + "," + goldCount + "," + moneyType + "," + price);
		}
		
		/**
		 * <T>寄售物品回应</T>
		 * 
		 * @param o 数据
		 * 
		 */		
		public static function sm_Aution_S(o:Object):void{
			if(o.hasOwnProperty("mb")){
				UIManager.getInstance().autionWnd.loadSelf(o);
			}
		}
		
		/**
		 * <T>取消寄售物品请求</T>
		 * 
		 */		
		public static function cm_Aution_C(saleId:uint):void{
			NetGate.getInstance().send(CmdEnum.CM_CGT_C + "," + saleId);
		}
		
		/**
		 * <T>取消寄售物品回应</T>
		 * 
		 * @param o 数据
		 * 
		 */		
		public static function sm_Aution_C(o:Object):void{
			if(o.hasOwnProperty("mb")){
				UIManager.getInstance().autionWnd.loadSelf(o);
			}
		}
		
		/**
		 * <T>购买物品请求</T>
		 * 
		 */		
		public static function cm_Aution_B(saleId:uint, page:uint):void{
			var message:String = CmdEnum.CM_CGT_B + ",{1},{2}";
			NetGate.getInstance().send(StringUtil_II.translate(message, saleId, page));
		}
		
		/**
		 * <T>购买物品成功回应</T>
		 * 
		 * @param o 数据
		 * 
		 */		
		public static function sm_Aution_B(o:Object):void{
			UIManager.getInstance().autionWnd.refreshPage();
		}
		
		/**
		 * <T>物品排序请求</T>
		 * 
		 */		
		public static function cm_Aution_F(sortType:int, type:int, profession:int, quality:int, lv_low:int, lv_max:int, currenPage:int, order:int):void{
			var message:String = CmdEnum.CM_CGT_F + ",{1},{2},{3},{4},{5},{6},{7},{8}";
			NetGate.getInstance().send(StringUtil_II.translate(message, sortType, type, profession, quality, lv_low, lv_max, currenPage, order));
		}
		
		/**
		 * <T>物品排序回应</T>
		 * 
		 * @param o 数据
		 * 
		 */		
		public static function sm_Aution_F(o:Object):void{
			if(o.hasOwnProperty("cb")){
				UIManager.getInstance().autionWnd.loadSortList(o);
			}
		}
		
//		/**
//		 * <T>物品排序回应</T>
//		 * 
//		 * @param o 数据
//		 * 
//		 */		
//		public static function sm_Aution_D(o:Object):void{
//			if(o.hasOwnProperty("cb")){
//				UIManager.getInstance().autionWnd.loadSortListByMoney(o);
//			}
//		}
		
		/**
		 * <T>日志查询请求</T>
		 * 
		 */		
		public static function cm_Aution_G():void{
			NetGate.getInstance().send(CmdEnum.CM_CGT_G);
		}
		
		/**
		 * <T>日志查询回应</T>
		 * 
		 * @param o 数据
		 * 
		 */		
		public static function sm_Aution_G(o:Object):void{
			if(o.hasOwnProperty("lb")){
				UIManager.getInstance().autionWnd.loadLog(o);
			}
		}
		
		/**
		 * <T>自己的出售列表查询请求</T>
		 * 
		 */		
		public static function cm_Aution_M():void{
			NetGate.getInstance().send(CmdEnum.CM_CGT_M);
		}
		
		/**
		 * <T>自己的出售列表查询回应</T>
		 * 
		 * @param o 数据
		 * 
		 */		
		public static function sm_Aution_M(o:Object):void{
			if(o.hasOwnProperty("mb")){
				if(UIManager.getInstance().autionWnd){
					UIManager.getInstance().autionWnd.loadSelf(o);
				}
			}
		}
		
		/**
		 * <T>查询物品最近出售价格请求</T>
		 * 
		 */		
		public static function cm_Aution_R(itemId:uint):void{
			NetGate.getInstance().send(CmdEnum.CM_CGT_R + "," + itemId);
		}
		
		/**
		 * <T>查询物品最近出售价格回应</T>
		 * 
		 * @param o 数据
		 * 
		 */		
		public static function sm_Aution_R(o:Object):void{
			UIManager.getInstance().autionWnd.loadLastPrice(o);
		}
		
		/**
		 * <T>搜索物品</T>
		 * 
		 * @param name 物品名称
		 * 
		 */		
		public static function cm_Aution_L(name:String):void{
			name.replace(PropUtils.getStringById(1550), PropUtils.getStringById(1551));
			NetGate.getInstance().send(CmdEnum.CM_CGT_L + "," + name);
		}
		
		/**
		 * <T>搜索物品回应</T>
		 * 
		 * @param o 数据
		 * 
		 */		
		public static function sm_Aution_L(o:Object):void{
			UIManager.getInstance().autionWnd.loadAll(o);
		}
	}
}
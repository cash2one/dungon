package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.manager.UILayoutManager;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Welfare
	{
		public static function sm_SIGN_I(obj:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.WELFARE, CmdEnum.SM_SIGN_I);
			UIManager.getInstance().welfareWnd.updateSign(obj);
		}
		
		public static function cm_SIGN_I():void{
			if(UIManager.getInstance().isCreate(WindowEnum.WELFARE)){
				UIManager.getInstance().welfareWnd.loginRequest = false;
			}
			NetGate.getInstance().send(CmdEnum.CM_SIGN_I);
		}
		
		public static function cm_SIGN_S(day:int):void{
			NetGate.getInstance().send(CmdEnum.CM_SIGN_S + day);
		}
		
		public static function cm_SIGN_J(sc:int):void{
			if(sc <= 0){
				throw new Error("领取奖励 sc = " + sc);
			}
			NetGate.getInstance().send(CmdEnum.CM_SIGN_J + sc);
		}
		
		public static function cm_SIGN_V(vc:int):void{
			NetGate.getInstance().send(CmdEnum.CM_SIGN_V + vc);
		}
		
		public static function sm_SIGN_Z(obj:Object):void{
			UIManager.getInstance().welfareWnd.flyItem(1);
		}
		
		public static function sm_OL_I(obj:Object):void{
			UIManager.getInstance().welfareWnd.updateOL(obj);
		}
		
		public static function cm_OL_I():void{
			if(UIManager.getInstance().isCreate(WindowEnum.WELFARE)){
				UIManager.getInstance().welfareWnd.timeRequest = false;
			}
			NetGate.getInstance().send(CmdEnum.CM_OL_I);
		}
		
		public static function sm_OL_J(obj:Object):void{
			UIManager.getInstance().welfareWnd.receiveOLReward(obj);
		}
		
		public static function cm_OL_J(otype:int):void{
			NetGate.getInstance().send(CmdEnum.CM_OL_J+otype);
		}
		
		public static function sm_ULV_I(obj:Object):void{
			UIManager.getInstance().welfareWnd.updateLV(obj);
		}
		
		public static function sm_ULV_Z(obj:Object):void{
			UIManager.getInstance().welfareWnd.flyItem(3);
		}
		
		public static function cm_ULV_I():void{
			if(UIManager.getInstance().isCreate(WindowEnum.WELFARE)){
				UIManager.getInstance().welfareWnd.lvRequest = false;
			}
			NetGate.getInstance().send(CmdEnum.CM_ULV_I);
		}
		
		public static function cm_ULV_J(lv:int):void{
			NetGate.getInstance().send(CmdEnum.CM_ULV_J + lv);
		}
		
		public static function cm_CDK_J(key:String):void{
			NetGate.getInstance().send(CmdEnum.CM_CDK_J + key);
		}
		
		public static function sm_OFL_I(obj:Object):void{
			if(obj.baseexp > 0){
				if(!UIManager.getInstance().welfareWnd){
					UIManager.getInstance().creatWindow(WindowEnum.WELFARE);
				}
				UIManager.getInstance().welfareWnd.changeTable(3);
				if(!UIManager.getInstance().welfareWnd.visible){
					UILayoutManager.getInstance().show(WindowEnum.WELFARE);
				}
			}
			if(UIManager.getInstance().welfareWnd){
				UIManager.getInstance().welfareWnd.updateOFL(obj);
			}
		}
		
		public static function cm_OFL_I():void{
			NetGate.getInstance().send(CmdEnum.CM_OFL_I);
		}
		
		public static function cm_OFL_L(type:int):void{
			NetGate.getInstance().send(CmdEnum.CM_OFL_L+type);
		}
	}
}
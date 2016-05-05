package com.leyou.net.cmd {
	import com.ace.config.Core;
	import com.ace.manager.UIManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;
	
	import flash.utils.ByteArray;

	public class Cmd_Login {

		static private var preIp:String;
		static private var prePort:int;

		public static function sm_dv_o(obj:Object):void {
			Core.isDvt=true;
			preIp=Core.serverIp;
			prePort=Core.loginPort;
			
			Core.serverIp=obj.ip;
			Core.loginPort=obj.port;
			clearState();
		}

		public static function sm_dv_i(obj:Object):void {
			Core.isDvt=false;
			Core.serverIp=preIp;
			Core.loginPort=prePort;
			clearState();
		}

		private static function clearState():void {
			Core.isChangeIp=true;
			Core.isFirstLogin=true;
			NetGate.getInstance().isManualClose=true;
			cm_quit();
//			NetGate.getInstance().changeConnect(Core.serverIp, Core.loginPort); //自己主动断开
//			if (Cmd_Scene.PRE_PS) {
//				Cmd_Scene.PRE_PS.x=Cmd_Scene.PRE_PS.y=0;
//			}
		}

		public static function cm_quit():void {
			NetGate.getInstance().send(CmdEnum.CM_QUIT);
		}

		public static function sm_alogin(obj:Object):void {
			Core.IS_RE_LOGIN=true;
		}

		// 登陆连接串
		public static function cm_lgn(str:String):void {
			NetGate.getInstance().send(str);
		}

		public static function sm_1017(br:ByteArray):void {
			UIManager.getInstance().loginWnd.onConnect();
		}

		// Session ID  通知客户端本次连接的session id
		public static function sm_sid(obj:Object):void {

		}

		// 服务器判断此用户无角色 进入创建角色流程 
		public static function sm_covN(obj:Object):void {
			UIManager.getInstance().loginWnd.die();
			UIManager.getInstance().addCreatUserWnd();
			var wName:String=obj.x;
			var mName:String=obj.y;
		}

		//错误提示
		public static function sm_covE(obj:Object):void {
			UIManager.getInstance().creatUserWnd.serError(obj);
		}

		//有角色-登陆场景
		public static function sm_covP(obj:Object):void {
			//MyInfoManager.getInstance().loginSuccess=true;
			UIManager.getInstance().loginWnd.die();
			if (UIManager.getInstance().creatUserWnd != null)
				UIManager.getInstance().creatUserWnd.die();
			UIManager.getInstance().addSceneWnd();
		}

		//获取角色随机名称-ok
		public static function sm_covL(obj:Object):void {
		}

		//获取角色随机名称		
		public static function cm_covU():void {
			NetGate.getInstance().send(CmdEnum.CM_COV_U);
		}

		//创建角色
		public static function cm_createRole(name:String, sex:int=0, vocation:int=0):void {
			NetGate.getInstance().send(CmdEnum.CM_COV_C + name + "," + sex + "," + vocation);
		}

	}
}

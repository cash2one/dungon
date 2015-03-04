package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Worship
	{
//		wsp
//		上行:wsp|I
//		下行:wsp|{"mk":"I", "master":["avt":str, "name":str,"level":num,"vocation":num,"gender":num], "wnum":num, "moneyw":[cc,mc],"bybw":[cc,mc],"ybw":[cc,mc]}
//		master  -- 城主信息
//			avt      -- avt字符串(p协议中的avt字符串)	
//		name     -- 玩家名字		
//			level    -- 等级	
//			vocation -- 职业	
//			gender  --玩家性别 （0男 1女）
//		wnum   -- 膜拜次数
//			moneyw  -- 金币膜拜      (cc 当前次数 mc 总次数)
//			bybw    -- 绑定元宝膜拜
//			ybw     -- 元宝膜拜
		public static function sm_WSP_I(obj:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.WORSHIP, CmdEnum.SM_WSP_I);
			UIManager.getInstance().worshipWnd.updateInfo(obj);
		}
		
		
		public static function cm_WSP_I():void{
			NetGate.getInstance().send(CmdEnum.CM_WSP_I);
			
		}
		
//		膜拜城主
//		上行:wsp|Mwtype  
//		wtype -- 膜拜类型 (1金币 2 绑定元宝 3元宝)
		public static function cm_WSP_M(type:int):void{
			NetGate.getInstance().send(CmdEnum.CM_WSP_M + type);
		}
	}
}
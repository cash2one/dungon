package com.leyou.net.cmd
{
	import com.ace.enum.WindowEnum;
	import com.ace.manager.UIManager;
	import com.ace.manager.UIOpenBufferManager;
	import com.leyou.data.mail.MailInfo;
	import com.leyou.enum.CmdEnum;
	import com.leyou.net.NetGate;

	public class Cmd_Mail
	{
		public function Cmd_Mail()
		{
		}
		
		/**
		 * <T>查询邮件请求</T>
		 * 
		 */
		public static function cm_MailMsg_I():void{
			NetGate.getInstance().send(CmdEnum.CM_SMA_I);
		}
		
		/**
		 * <T>提取邮件附件请求</T>
		 * 
		 */
		public static function cm_MailMsg_A(mailId:uint, itemId:String="0"):void{
			NetGate.getInstance().send(CmdEnum.CM_SMA_A + "," + mailId + "," + itemId);
		}
		
		/**
		 * <T>阅读邮件上行通知</T>
		 * 
		 */
		public static function cm_MailMsg_R(mailId:uint):void{
			NetGate.getInstance().send(CmdEnum.CM_SMA_R + "," + mailId);
		}
		
		/**
		 * <T>删除邮件请求</T>
		 * 
		 */
		public static function cm_MailMsg_D(mailIdList:Array):void{
			NetGate.getInstance().send(CmdEnum.CM_SMA_D + ",{" + mailIdList.join(",") + "}");
		}
		
		/**
		 * <T>查询邮件列表回应</T>
		 * 
		 */
		public static function sm_MailMsg_I(o:Object):void{
			UIOpenBufferManager.getInstance().removeCmd(WindowEnum.MAILL, CmdEnum.SM_SMA_I);
			if(o.hasOwnProperty("ml")){
				var mailList:Array = o.ml;
				MailInfo.serverTime = o.ost;
				UIManager.getInstance().maillWnd.onMailListResponse(mailList);
			}
		}
		
		/**
		 * <T>系统邮件下行通知</T>
		 * 
		 */
		public static function sm_MailMsg_N(o:Object):void{
			if(o.hasOwnProperty("id")){
				UIManager.getInstance().maillWnd.onSystemMailNotify(o);
			}
		}
		
		/**
		 * <T>提取附件回应</T>
		 * 
		 */
		public static function sm_MailMsg_A(o:Object):void{
			if(o.hasOwnProperty("id")){
				UIManager.getInstance().maillWnd.onAccessoryResponse(o);
			}
		}
		
		/**
		 * <T>删除邮件回应</T>
		 * 
		 */
		public static function sm_MailMsg_D(o:Object):void{
			if(o.hasOwnProperty("id")){
				UIManager.getInstance().maillWnd.onDeleteMailResponse(o);
			}
		}
		
		public static function sm_MailMsg_Z(o:Object):void{
			UIManager.getInstance().maillReadWnd.flyItem();
		}
	}
}